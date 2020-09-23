//
//  File.swift
//  
//
//  Created by Nolaine Crusher on 9/18/20.
//

/*
 v2.2:
 User defined text information frame
 
 This frame is intended for one-string text information concerning the
 audiofile in a similar way to the other "T"-frames. The frame body
 consists of a description of the string, represented as a terminated
 string, followed by the actual string. There may be more than one
 "TXXX" frame in each tag, but only one with the same description.
 
 <Header for 'User defined text information frame', ID: (TXX or )"TXXX">
 Text encoding     $xx
 Description       <text string according to encoding> $00 (00)
 Value             <text string according to encoding>

 User defined URL link frame
 
 This frame is intended for URL [URL] links concerning the audio file
 in a similar way to the other "W"-frames. The frame body consists
 of a description of the string, represented as a terminated string,
 followed by the actual URL. The URL is always encoded with ISO-8859-1
 [ISO-8859-1]. There may be more than one "WXXX" frame in each tag,
 but only one with the same description.
 
 <Header for 'User defined URL link frame', ID: "WXXX">
 Text encoding     $xx
 Description       <text string according to encoding> $00 (00)
 URL               <text string>

 Comments
 
 This frame is intended for any kind of full text information that
 does not fit in any other frame. It consists of a frame header
 followed by encoding, language and content descriptors and is ended
 with the actual comment as a text string. Newline characters are
 allowed in the comment text string. There may be more than one
 comment frame in each tag, but only one with the same language and
 content descriptor.
 
 <Header for 'Comment', ID: "COMM">
 Text encoding          $xx
 Language               $xx xx xx
 Short content descrip. <text string according to encoding> $00 (00)
 The actual text        <full text string according to encoding>

 Unsynchronised lyrics/text transcription
 
 This frame contains the lyrics of the song or a text transcription of
 other vocal activities. The head includes an encoding descriptor and
 a content descriptor. The body consists of the actual text. The
 'Content descriptor' is a terminated string. If no descriptor is
 entered, 'Content descriptor' is $00 (00) only. Newline characters
 are allowed in the text. There may be more than one 'Unsynchronised
 lyrics/text transcription' frame in each tag, but only one with the
 same language and content descriptor.
 
 <Header for 'Unsynchronised lyrics/text transcription', ID: "USLT">
 Text encoding        $xx
 Language             $xx xx xx
 Content descriptor   <text string according to encoding> $00 (00)
 Lyrics/text          <full text string according to encoding>
 */

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
        if identifier == .comments ||
            identifier == .unsynchronizedLyrics {
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
    
    override var frameKey: String {
        return self.identifier.frameKey(self.description)
    }
    
    /*
     Text encoding     $xx
     Description       <textstring> $00 (00)
     URL               <textstring>

     Text encoding          $xx
     Language               $xx xx xx
     Short content descrip. <text string according to encoding> $00 (00)
     The actual text        <full text string according to encoding>
     */

    override var contentData: Data {
        var data = Data()
        let encoding = String.Encoding.isoLatin1
        data.append(encoding.encodingByte)
        if self.identifier == .comments || self.identifier == .unsynchronizedLyrics {
            // encode and append language string

            if let language = self.language {
                let languageString = language.rawValue
                data.append(languageString.encodedASCII)
            } else {
                data.append("und".encodedASCII)
            }

            if let description = self.description {
                data.append(description.encodeNullTerminatedString(encoding))
            } else {
                data.append(encoding.nullTerminator)
            }
            data.append(self.stringValue.encodedISOLatin1)
        }
        return data
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
        self.language = language
        self.description = description
        self.stringValue = stringValue
        
        var size = 1 // +1 for encoding byte
        let encoding = String.Encoding.isoLatin1
        if let languageString = language?.rawValue {
            size += languageString.encodedASCII.count
        }
        if let description = description {
            size += description.encodeNullTerminatedString(encoding).count
        } else {
            
        }
        size += stringValue.encodedISOLatin1.count
        let flags = version.defaultFlags
        super.init(identifier: identifier,
                   version: version,
                   size: size,
                   flags: flags)
    }
}

// MARK: - Tag extension
// get and set functions for `LocalizedFrame` frame types, which retrieves or sets up to three strings, one of which may be a language code, and one of which is an optional description string. Each individual frame of this type will call these functions in a get-set property or function, where appropriate.
extension Tag {
    /// `comments` frame getter-setter. ID3 Identifier `COM`/`COMM`
    public subscript(comment description: String?, language: ISO6392Code) -> String? {
        get {
            if let string = get(localizedFrame: .comments,
                                language: language,
                                description: description) {
                return string
            } else {
                return nil
            }
        }
        set {
            if let new = newValue {
                set(localizedFrame: .comments,
                    language: language,
                    description: description,
                    stringValue: new)
            } else {
                removeCommentFrame(description: description ?? "")
            }
        }
    }
    
    /// `unsynchronizedLyrics` frame getter-setter. ID3 Identifier `ULT`/`USLT`
    public subscript(lyrics description: String?, language: ISO6392Code) -> String? {
        get {
            if let string = get(localizedFrame: .unsynchronizedLyrics,
                                language: language,
                                description: description) {
                return string
            } else {
                return nil
            }
        }
        set {
            if let new = newValue {
                set(localizedFrame: .unsynchronizedLyrics,
                    language: language,
                    description: description,
                    stringValue: new)
            } else {
                removeCommentFrame(description: description ?? "")
            }
        }
    }
    
    /// `userDefinedText` frame getter-setter. ID3 Identifier `TXX`/`TXXX`
    public subscript(_ description: String?) -> String? {
        get {
            if let string = get(userDefinedFrame: .userDefinedText,
                                description: description) {
                return string
            } else {
                return nil
            }
        }
        set {
            if let new = newValue {
                set(userDefinedFrame: .userDefinedText,
                    description: description,
                    stringValue: new)
            } else {
                removeUserTextFrame(description: description ?? "")
            }
        }
    }
    
    /// `userDefinedWebpage` frame getter-setter. ID3 Identifier `WXX`/`WXXX`
    public subscript(userDefinedUrl description: String?) -> String? {
        get {
            if let string = get(userDefinedFrame: .userDefinedWebpage,
                                description: description) {
                return string
            } else {
                return nil
            }
        }
        set {
            if let new = newValue {
                set(userDefinedFrame: .userDefinedWebpage,
                    description: description,
                    stringValue: new)
            } else {
                removeUserUrlFrame(description: description ?? "")
            }
        }
    }
    
    // MARK: - Private and Internal
    private func get(localizedFrame identifier: FrameIdentifier,
                     language: ISO6392Code?,
                     description: String?) -> String? {
        let frameKey = identifier.frameKey(description)
        if frameKey == FrameIdentifier.unsynchronizedLyrics.frameKey(description) {
            if let frame = self.frames[frameKey] as? LocalizedFrame {
                return frame.stringValue
            } else {
                return nil
            }
        } else if frameKey == FrameIdentifier.comments.frameKey(description) {
            if let frame = self.frames[frameKey] as? LocalizedFrame {
                return frame.stringValue
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    private func get(userDefinedFrame identifier: FrameIdentifier,
                     description: String?) -> String? {
        let frameKey = identifier.frameKey(description)
        // check that the frame is a UserDefinedWebpage frame or a UserText frame
        if frameKey == FrameIdentifier.userDefinedWebpage.frameKey(description) {
            if let frame = self.frames[frameKey] as? LocalizedFrame {
                // return the content string of a specific frame by searching using the description string
                return frame.stringValue
            } else {
                return nil
            }
        } else if frameKey == FrameIdentifier.userDefinedText.frameKey(description) {
            if let frame = self.frames[frameKey] as? LocalizedFrame {
                return frame.stringValue
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    private mutating func set(localizedFrame identifier: FrameIdentifier,
                              language: ISO6392Code?,
                              description: String?,
                              stringValue: String?) {
        let frameKey = identifier.frameKey(description)
        if let stringValue = stringValue {
            let frame = LocalizedFrame(identifier,
                                       version: self.version,
                                       language: language,
                                       description: description,
                                       stringValue: stringValue)
            self.frames[frameKey] = frame
        } else {
            self.frames[frameKey] = nil
        }
    }
    
    private mutating func set(userDefinedFrame identifier: FrameIdentifier,
                              description: String?,
                              stringValue: String?) {
        let frameKey = identifier.frameKey(description)
        if let stringValue = stringValue {
            let frame = LocalizedFrame(identifier,
                                       version: self.version,
                                       language: nil,
                                       description: description,
                                       stringValue: stringValue)
            self.frames[frameKey] = frame
        } else {
            self.frames[frameKey] = nil
        }
    }
    
    private mutating func removeCommentFrame(description: String) {
        let frameKey = FrameIdentifier.comments.frameKey(description)
        self.frames[frameKey] = nil
    }
    
    private mutating func removeLyricsFrame(description: String) {
        let frameKey = FrameIdentifier.unsynchronizedLyrics.frameKey(description)
        self.frames[frameKey] = nil
    }
    
    private mutating func removeUserTextFrame(description: String) {
        let frameKey = FrameIdentifier.userDefinedText.frameKey(description)
        self.frames[frameKey] = nil
    }
    
    private mutating func removeUserUrlFrame(description: String) {
        let frameKey = FrameIdentifier.userDefinedWebpage.frameKey(description)
        self.frames[frameKey] = nil
    }
}
