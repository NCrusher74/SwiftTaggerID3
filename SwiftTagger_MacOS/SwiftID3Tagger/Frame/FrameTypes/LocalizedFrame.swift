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
public struct LocalizedFrame: FrameProtocol {
    
    // public initializers
    public init(language: String?, description: String?, lyrics: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.unsynchronizedLyrics),
                  languageString: language ?? "und",
                  descriptionString: description ?? "",
                  contentString: lyrics)
    }

    public init(language: String?, description: String?, comments: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.comments),
                  languageString: language ?? "und",
                  descriptionString: description ?? "",
                  contentString: comments)
    }

    public init(language: String?, contentDescription: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.comments),
                  languageString: language ?? "und",
                  descriptionString: "Description",
                  contentString: contentDescription)
    }

    public init(language: String?, linerNotes: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.comments),
                  languageString: language ?? "und",
                  descriptionString: "Liner Notes",
                  contentString: linerNotes)
    }

    public init(language: String?, shortDescription: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.comments),
                  languageString: language ?? "und",
                  descriptionString: "Short Description",
                  contentString: shortDescription)
    }

    public init(language: String?, longDescription: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.comments),
                  languageString: language ?? "und",
                  descriptionString: "Long Description",
                  contentString: longDescription)
    }

    public init(language: String?, songDescription: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.comments),
                  languageString: language ?? "und",
                  descriptionString: "Song Description",
                  contentString: songDescription)
    }

    public init(language: String?, seriesDescription: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.comments),
                  languageString: language ?? "und",
                  descriptionString: "Series Description",
                  contentString: seriesDescription)
    }

    /// ISO-639-2 languge code
    var languageString: String? = "und"
    /// A short description of the frame content.
    var descriptionString: String? = ""
    /// the content of the frame
    var contentString: String
    
    /**
     - parameter languageString: the ISO-639-2 language code. default is `undetermined`
     - parameter descriptionString: a terminated text string describing the frame content
     - parameter contentString: the full text of the comment or lyric frame.
     */
    private init(layout: FrameLayoutIdentifier,
                languageString: String?,
                descriptionString: String?,
                contentString: String) {
        self.languageString = languageString ?? "und"
        self.descriptionString = descriptionString ?? ""
        self.contentString = contentString
        self.layout = layout
//        self.flags = LocalizedFrame.defaultFlags()
    }

//    var flags: Data
    var layout: FrameLayoutIdentifier
    
    func encodeContents(version: Version) throws -> Data {
        let encodedLanguageString = self.languageString?.encoded(withNullTermination: false) ?? "und".encoded(withNullTermination: false)
        let encodedDescriptionString = self.descriptionString?.encoded(withNullTermination: true) ?? "".encoded(withNullTermination: true)
        let encodedContentsString = self.contentString.encoded(withNullTermination: false)
        return encodedLanguageString + encodedDescriptionString + encodedContentsString
    }

    init(decodingContents contents: Data.SubSequence,
         version: Version,
         layout: FrameLayoutIdentifier
//         flags: Data
    ) throws {
//        self.flags = flags
        self.layout = layout
        var parsing = contents
        let encoding = LocalizedFrame.extractEncoding(data: &parsing, version: version)

        self.languageString = parsing.extractFirst(3).stringASCII ?? "und"

        let parsed = try LocalizedFrame.extractDescriptionAndContent(from: &parsing, encoding: encoding)
        self.descriptionString = parsed.description ?? ""
        self.contentString = parsed.content
    }
    

}
