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
 
 This frame type will be used for both `Comment` and `UnsynchronizedLyrics` frames. A tag may have multiple frames of these types, but only one frame with the same `Description` and `Language`. To preserve frame uniqueness while allowing multiple frames of these types, the `Description` field will be used as the `FrameKey`.
 
 These frames are the only frames that allow the use of new-line characters. Therefore, they are ideally suited for long remarks and convenience initializers for the most common types have been added.
 */
public struct LocalizedFrame: FrameProtocol {
    
    // public initializers
    /// general lyrics frame initializer
    public init(language: String?, description: String?, lyrics: String) {
        self.init(layout: .known(.unsynchronizedLyrics),
                  languageString: language ?? "und",
                  descriptionString: description ?? "",
                  contentString: lyrics)
    }

    /// general comments frame initializer
    public init(language: String?, description: String?, comments: String) {
        self.init(layout: .known(.comments),
                  languageString: language ?? "und",
                  descriptionString: description ?? "",
                  contentString: comments)
    }

    /// convenience initializer for comments frame intended to hold a description of the audio file contents
    public init(language: String?, contentDescription: String) {
        self.init(layout: .known(.comments),
                  languageString: language ?? "und",
                  descriptionString: "Description",
                  contentString: contentDescription)
    }

    /// convenience initializer for comments frame intended to hold the liner notes of the audio file contents
    public init(language: String?, linerNotes: String) {
        self.init(layout: .known(.comments),
                  languageString: language ?? "und",
                  descriptionString: "Liner Notes",
                  contentString: linerNotes)
    }

    /// convenience initializer for comments frame intended to hold a short description of the audio file contents
    public init(language: String?, shortDescription: String) {
        self.init(layout: .known(.comments),
                  languageString: language ?? "und",
                  descriptionString: "Short Description",
                  contentString: shortDescription)
    }

    /// convenience initializer for comments frame intended to hold a longer or extended description of the audio file contents
    public init(language: String?, longDescription: String) {
        self.init(layout: .known(.comments),
                  languageString: language ?? "und",
                  descriptionString: "Long Description",
                  contentString: longDescription)
    }

    /// convenience initializer for comments frame intended to hold a description of a specific song
    public init(language: String?, songDescription: String) {
        self.init(layout: .known(.comments),
                  languageString: language ?? "und",
                  descriptionString: "Song Description",
                  contentString: songDescription)
    }

    /// convenience initializer for comments frame intended to hold a description of a series or collection that the audio file is a part of (such as for audiobooks)
    public init(language: String?, seriesDescription: String) {
        self.init(layout: .known(.comments),
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
        self.layout = layout
        switch layout {
            case .known(.comments) : self.frameKey = .comments(description: descriptionString ?? "")
            case .known(.unsynchronizedLyrics) : self.frameKey = .unsynchronizedLyrics(description: descriptionString ?? "")
            default: self.frameKey = .userDefinedText(description: descriptionString ?? "")
        }
        self.flags = LocalizedFrame.defaultFlags

        self.languageString = languageString ?? "und"
        self.descriptionString = descriptionString ?? ""
        self.contentString = contentString
    }

    var flags: Data
    var layout: FrameLayoutIdentifier
    var frameKey: FrameKey
    
    // encode the contents of the frame to add to an ID3 tag
    func encodeContents(version: Version) throws -> Data {
        let encodingByte = StringEncoding.preferred.rawValue.encoding(endianness: .bigEndian)
        let encodedLanguageString = self.languageString?.encoded(withNullTermination: false) ?? "und".encoded(withNullTermination: false)
        let encodedDescriptionString = self.descriptionString?.encoded(withNullTermination: true) ?? "".encoded(withNullTermination: true)
        let encodedContentsString = self.contentString.encoded(withNullTermination: false)
        return encodingByte + encodedLanguageString + encodedDescriptionString + encodedContentsString
    }

    // decode the contents of the frame from an ID3 tag
    init(decodingContents contents: Data.SubSequence,
         version: Version,
         layout: FrameLayoutIdentifier,
         flags: Data
    ) throws {
        self.flags = flags
        self.layout = layout

        var parsing = contents
        let encoding = try LocalizedFrame.extractEncoding(data: &parsing, version: version)

        let languageCode = try String(ascii: parsing.extractFirst(3))
        if ISO6392Codes.allCases.contains(where: { $0.iso6392TCode == languageCode }) {
            self.languageString = languageCode
        } else {
            self.languageString = "und"
        }

        let parsed = try LocalizedFrame.extractDescriptionAndContent(from: &parsing, encoding: encoding)
        self.descriptionString = parsed.description ?? ""
        self.contentString = parsed.content

        switch layout {
            case .known(.comments) : self.frameKey = .comments(description: parsed.description ?? "")
            case .known(.unsynchronizedLyrics) : self.frameKey = .unsynchronizedLyrics(description: parsed.description ?? "")
            default: self.frameKey = .comments(description: parsed.description ?? "")
        }
    }
}
