//
//  LocalizedFrame.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/11/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

/**
 A type representing an ID3 frame that holds a three string fields: `Language` contains the 3-charcter string for the ISO-639-2 language code, `Description` contains a null-terminated string describing the frame content, and `Content`.
 
 This frame type will be used for both `Comment` and `UnsynchronizedLyrics` frames. A tag may have multiple frames of these types, but only one frame with the same `Description` and `Language`. To preserve frame uniqueness while allowing multiple frames of these types, the `Description` field will be used as the `FrameKey`
 */
struct LocalizedFrame: FrameProtocol {
    
    /// ISO-639-2 languge code
    private var languageString: ISO6392Codes
    /// A short description of the frame content.
    private var descriptionString: String = ""
    /// the content of the frame
    private var contentString: String
    
    /**
     - parameter languageString: the ISO-639-2 language code.
     - parameter descriptionString: a terminated text string describing the frame content
     - parameter contentString: the full text of the comment or lyric frame.
     */
    private init(layout: FrameLayoutIdentifier,
                languageString: ISO6392Codes,
                descriptionString: String,
                contentString: String) {
        self.languageString = languageString
        self.descriptionString = descriptionString
        self.contentString = contentString
        self.layout = layout
        self.flags = LocalizedFrame.defaultFlags()
    }

    internal var flags: Data
    internal var layout: FrameLayoutIdentifier
    
    internal func encodeContents(version: Version) throws -> Data {
        let encodedLanguageString = self.languageString.rawValue.encoded(withNullTermination: false)
        let encodedDescriptionString = self.descriptionString.encoded(withNullTermination: true)
        let encodedContentsString = self.contentString.encoded(withNullTermination: false)
        return encodedLanguageString + encodedDescriptionString + encodedContentsString
    }

    internal init(decodingContents contents: Data.SubSequence,
         version: Version,
         layout: FrameLayoutIdentifier,
         flags: Data) throws {
        self.flags = flags
        self.layout = layout
        var parsing = contents
        let encoding = LocalizedFrame.extractEncoding(data: &parsing, version: version)

        let languageCode = parsing.extractFirst(3).stringASCII ?? "und"
        if ISO6392Codes.allCases.contains(ISO6392Codes(rawValue: languageCode) ?? .und) {
            self.languageString = ISO6392Codes(rawValue: languageCode) ?? .und
        }

        let parsed = try LocalizedFrame.extractDescriptionAndContent(from: &parsing, encoding: encoding)
        self.descriptionString = parsed.description ?? ""
        self.contentString = parsed.content
    }
    

}
