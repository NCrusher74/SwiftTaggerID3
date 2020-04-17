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
    public var languageString: String
    /// A short description of the frame content.
    public var descriptionString: String = ""
    /// the content of the frame
    public var contentString: String
    
    /**
     - parameter languageString: the ISO-639-2 language code.
     - parameter descriptionString: a terminated text string describing the frame content
     - parameter contentString: the full text of the comment or lyric frame.
     */
    public init(layout: FrameLayoutIdentifier,
                languageString: String,
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
    
    func encodeContents(version: Version) throws -> Data {
        let encodedLanguageString = self.languageString.encoded(withNullTermination: false)
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
        let languages = IsoLanguages.allLanguages.filter({ $0.iso6392T == languageCode })
        self.languageString = String(languages.first?.isoName ?? "undefined")

        let parsed = try LocalizedFrame.extractDescriptionAndContent(from: &parsing, encoding: encoding)
        self.descriptionString = parsed.description ?? ""
        self.contentString = parsed.content
    }
    

}
