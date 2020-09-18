//
//  File.swift
//  
//
//  Created by Nolaine Crusher on 9/18/20.
//

import Foundation
import SwiftLanguageAndLocaleCodes
/// A type representing an ID3 frame that holds a three string fields: `Language` contains the 3-charcter string for the ISO-639-2 language code, `Description` contains a null-terminated string describing the frame content, and `Content`.
///
/// This frame type will be used for `UserDefinedText`, `UserDefinedWebpage`, `Comment` and `UnsynchronizedLyrics` frames. A tag may have multiple frames of these types, but only one frame with the same `Description` and/or `Language`.
///
/// To preserve frame uniqueness while allowing multiple frames of these types, the `Description` field will be used as part of the `FrameKey`.///
///
/// `Comment` and `UnsynchronizedLyrics` frames are the only frames that allow the use of new-line characters. Therefore, they are ideally suited for long remarks and convenience getter-setter properties for the most common types have been added.
class LocalizedFrame: Frame {
    /// ISO-639-2 languge code
    var language: ISO6392Code?
    /// A short description of the frame content.
    var description: String?
    /// the content of the frame
    var stringValue: String
    
    // MARK: - Frame Parsing
    init(identifier: FrameIdentifier,
         version: Version,
         size: Int,
         flags: Data,
         payload: Data) throws {
        var data = payload
                
        let encoding = try data.extractEncoding()
        
        if identifier == .known(.comments) ||
            identifier == .known(.unsynchronizedLyrics) {
            /// parse out a language string only for these frame types
            let codeString = try String(ascii: data.extractFirst(3))
            if let languageCode = ISO6392Code(rawValue: codeString) {
                self.language = languageCode
            } else {
                self.language = .und
            }
        }
        
        let parsed = data.extractDescriptionAndContent(encoding: encoding)
        self.description = parsed.description
        self.stringValue = parsed.content
        super.init(identifier: identifier,
                   version: version,
                   size: size,
                   flags: flags)
    }
    
    // MARK: - Frame building
    /// - parameter languageString: the ISO-639-2 language code. default is `undetermined`
    /// - parameter descriptionString: a terminated text string describing the frame content
    /// - parameter contentString: the full text of the comment or lyric frame.
    init(_ identifier: FrameIdentifier,
         version: Version,
         language: ISO6392Code?,
         description: String?,
         stringValue: String) {
        let flags = version.defaultFlags
        self.language = language
        self.description = description
        self.stringValue = stringValue
        
        var payload = Data()
        let encoding = String.Encoding.isoLatin1
        payload.append(encoding.encodingByte)
        if let languageString = language?.rawValue {
            payload.append(languageString.encodedASCII)
        }
        if let description = description {
            payload.append(description.encodeNullTerminatedString(encoding))
        }
        payload.append(stringValue.encodedISOLatin1)
        let size = payload.count
        super.init(identifier: identifier,
                   version: version,
                   size: size,
                   flags: flags)
    }
    
    override func frameKey(version: Version) throws -> String {
        return try self.identifier.frameKey(additionalID: self.description)
    }
    
    override var contentData: Data {
        var data = Data()
        let encoding = String.Encoding.isoLatin1
        data.append(encoding.encodingByte)
        if self.identifier == .known(.comments) || self.identifier == .known(.unsynchronizedLyrics) {
            // encode and append language string
            if let language = self.language {
                let languageString = language.rawValue
                data.append(languageString.encodedASCII)
            } else {
                data.append("und".encodedASCII)
            }
            if let description = self.description {
                data.append(description.encodeNullTerminatedString(encoding))
            }
            data.append(self.stringValue.encodedISOLatin1)
        }
        return data
    }
}
