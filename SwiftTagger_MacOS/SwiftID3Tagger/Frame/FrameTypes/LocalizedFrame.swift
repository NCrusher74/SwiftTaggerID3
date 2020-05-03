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
struct LocalizedFrame: FrameProtocol {
    
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
    init(layout: FrameLayoutIdentifier,
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
    var allowMultipleFrames: Bool = true
    
    // encode the contents of the frame to add to an ID3 tag
    func encodeContents(version: Version) throws -> Data {
        var frameData = Data()
        // append encoding byte
        frameData.append(StringEncoding.preferred.rawValue.encoding(
            endianness: .bigEndian))
        // encode and append language string
        frameData.append(self.languageString?.encoded(withNullTermination: false) ?? "und".encoded(withNullTermination: false))
        // encode and append description string
        frameData.append(self.descriptionString?.encoded(withNullTermination: true) ?? "".encoded(withNullTermination: true))
        // encode and append contents string
        frameData.append(self.contentString.encoded(withNullTermination: false))
        return frameData
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
        if ISO6392Codes.allCases.contains(where: { $0.rawValue == languageCode }) {
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

// MARK: Tag Extension
public extension Tag {
    /// - Comments frame getter-setter. ID3 Identifier `COM`/`COMM`
    subscript(comments language: ISO6392Codes, commentsDescription: String) -> String {
        get {
            localizedGetter(for: .comments(
                description: commentsDescription),
                            in: language,
                            with: commentsDescription) ?? ""
        }
        set {
            set(.known(.comments), .comments(description: commentsDescription), language: language.rawValue, description: commentsDescription, content: newValue)
        }
    }
    
    /// - Description getter-setter. This is a convenience for a custom `COM`/`COMM` frame with a description of `Description`
    subscript(description language: ISO6392Codes) -> String {
        get {
            localizedGetter(for: .comments(
                description: "Description"),
                            in: language,
                            with: "Description") ?? ""
        }
        set {
            set(.known(.comments), .comments(description: "Description"), language: language.rawValue, description: "Description", content: newValue)
        }
    }
    
    /// - LongDescription getter-setter. This is a convenience for a custom `COM`/`COMM` frame with a description of `Long Description`
    subscript(longDescription language: ISO6392Codes) -> String {
        get {
            localizedGetter(for: .comments(
                description: "Long Description"),
                            in: language,
                            with: "Long Description") ?? ""
        }
        set {
            set(.known(.comments), .comments(description: "Long Description"), language: language.rawValue, description: "Long Description", content: newValue)
        }
    }
    
    /// - LinerNotes getter-setter. This is a convenience for a custom `COM`/`COMM` frame with a description of `Liner Notes`
    subscript(linerNotes language: ISO6392Codes) -> String {
        get {
            localizedGetter(for: .comments(
                description: "Liner Notes"),
                            in: language,
                            with: "Liner Notes") ?? ""
        }
        set {
            set(.known(.comments), .comments(description: "Liner Notes"), language: language.rawValue, description: "Liner Notes", content: newValue)
        }
    }
    
    /// - SongDescription getter-setter. This is a convenience for a custom `COM`/`COMM` frame with a description of `Song Description`
    subscript(songDescription language: ISO6392Codes) -> String {
        get {
            localizedGetter(for: .comments(
                description: "Song Description"),
                            in: language,
                            with: "Song Description") ?? ""
        }
        set {
            set(.known(.comments), .comments(description: "Song Description"), language: language.rawValue, description: "Song Description", content: newValue)
        }
    }
    
    /// - SeriesDescription getter-setter. This is a convenience for a custom `COM`/`COMM` frame with a description of `Series Description`
    subscript(seriesDescription language: ISO6392Codes) -> String {
        get {
            localizedGetter(for: .comments(
                description: "Series Description"),
                            in: language,
                            with: "Series Description") ?? ""
        }
        set {
            set(.known(.comments), .comments(description: "Series Description"), language: language.rawValue, description: "Series Description", content: newValue)
        }
    }
    
    /// - (Unsynchronized) lyrics frame getter-setter. ID3 Identifier `ULT`/`USLT`
    subscript(lyrics language: ISO6392Codes, lyricsDescription: String) -> String {
        get {
            localizedGetter(for: .unsynchronizedLyrics(
                description: lyricsDescription),
                            in: language,
                            with: lyricsDescription) ?? ""
        }
        set {
            set(.known(.unsynchronizedLyrics), .unsynchronizedLyrics(description: lyricsDescription), language: language.rawValue, description: lyricsDescription, content: newValue)
        }
    }
}
