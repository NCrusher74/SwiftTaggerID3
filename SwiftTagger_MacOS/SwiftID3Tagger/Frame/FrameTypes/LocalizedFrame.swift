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
    
    // general lyrics frame initializer
    init(language: ISO6392Codes?, description: String?, lyrics: String) {
        self.init(layout: .known(.unsynchronizedLyrics),
                  languageString: language?.rawValue,
                  descriptionString: description ?? "",
                  contentString: lyrics)
    }

    // general comments frame initializer
    init(language: ISO6392Codes?, description: String?, comments: String) {
        self.init(layout: .known(.comments),
                  languageString: language?.rawValue,
                  descriptionString: description ?? "",
                  contentString: comments)
    }

    // convenience initializer for comments frame intended to hold a description of the audio file contents
    init(language: ISO6392Codes?, contentDescription: String) {
        self.init(layout: .known(.comments),
                  languageString: language?.rawValue,
                  descriptionString: "Description",
                  contentString: contentDescription)
    }

    // convenience initializer for comments frame intended to hold the liner notes of the audio file contents
    init(language: ISO6392Codes?, linerNotes: String) {
        self.init(layout: .known(.comments),
                  languageString: language?.rawValue,
                  descriptionString: "Liner Notes",
                  contentString: linerNotes)
    }

    // convenience initializer for comments frame intended to hold a short description of the audio file contents
    init(language: ISO6392Codes?, shortDescription: String) {
        self.init(layout: .known(.comments),
                  languageString: language?.rawValue,
                  descriptionString: "Short Description",
                  contentString: shortDescription)
    }

    // convenience initializer for comments frame intended to hold a longer or extended description of the audio file contents
    init(language: ISO6392Codes?, longDescription: String) {
        self.init(layout: .known(.comments),
                  languageString: language?.rawValue,
                  descriptionString: "Long Description",
                  contentString: longDescription)
    }

    // convenience initializer for comments frame intended to hold a description of a specific song
    init(language: ISO6392Codes?, songDescription: String) {
        self.init(layout: .known(.comments),
                  languageString: language?.rawValue,
                  descriptionString: "Song Description",
                  contentString: songDescription)
    }

    // convenience initializer for comments frame intended to hold a description of a series or collection that the audio file is a part of (such as for audiobooks)
    init(language: ISO6392Codes?, seriesDescription: String) {
        self.init(layout: .known(.comments),
                  languageString: language?.rawValue,
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
    var allowMultipleFrames: Bool = true
    
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
    subscript(comments language: ISO6392Codes, commentsDescription: String) -> String? {
        get {
            if let frame = self.frames[.comments(description: commentsDescription)],
                case .localizedFrame(let localizedFrame) = frame {
                return localizedFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let key = FrameKey.comments(description: commentsDescription)
            if let new = newValue {
                self.frames[key] = Frame.localizedFrame(.init(language: language, description: commentsDescription, comments: new))
            } else {
                self.frames[key] = nil
            }
        }
    }
    
    /// - Description getter-setter. This is a convenience for a custom `COM`/`COMM` frame with a description of `Description`
    subscript(description language: ISO6392Codes) -> String? {
        get {
            if let frame = self.frames[.comments(description: "Description")],
                case .localizedFrame(let localizedFrame) = frame {
                return localizedFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let key = FrameKey.comments(description: "Description")
            if let new = newValue {
                self.frames[key] = Frame.localizedFrame(.init(language: language, description: "Description", comments: new))
            } else {
                self.frames[key] = nil
            }
        }
    }
    
    /// - ShortDescription getter-setter. This is a convenience for a custom `COM`/`COMM` frame with a description of `Short Description`
    subscript(shortDescription language: ISO6392Codes) -> String? {
        get {
            if let frame = self.frames[.comments(description: "Short Description")],
                case .localizedFrame(let localizedFrame) = frame {
                return localizedFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let key = FrameKey.comments(description: "Short Description")
            if let new = newValue {
                self.frames[key] = Frame.localizedFrame(.init(language: language, description: "Short Description", comments: new))
            } else {
                self.frames[key] = nil
            }
        }
    }
    
    /// - LongDescription getter-setter. This is a convenience for a custom `COM`/`COMM` frame with a description of `Long Description`
    subscript(longDescription language: ISO6392Codes) -> String? {
        get {
            if let frame = self.frames[.comments(description: "Long Description")],
                case .localizedFrame(let localizedFrame) = frame {
                return localizedFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let key = FrameKey.comments(description: "Long Description")
            if let new = newValue {
                self.frames[key] = Frame.localizedFrame(.init(language: language, description: "Long Description", comments: new))
            } else {
                self.frames[key] = nil
            }
        }
    }
    
    /// - LinerNotes getter-setter. This is a convenience for a custom `COM`/`COMM` frame with a description of `Liner Notes`
    subscript(linerNotes language: ISO6392Codes) -> String? {
        get {
            if let frame = self.frames[.comments(description: "Liner Notes")],
                case .localizedFrame(let localizedFrame) = frame {
                return localizedFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let key = FrameKey.comments(description: "Liner Notes")
            if let new = newValue {
                self.frames[key] = Frame.localizedFrame(.init(language: language, description: "Liner Notes", comments: new))
            } else {
                self.frames[key] = nil
            }
        }
    }
    
    /// - SongDescription getter-setter. This is a convenience for a custom `COM`/`COMM` frame with a description of `Song Description`
    subscript(songDescription language: ISO6392Codes) -> String? {
        get {
            if let frame = self.frames[.comments(description: "Song Description")],
                case .localizedFrame(let localizedFrame) = frame {
                return localizedFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let key = FrameKey.comments(description: "Song Description")
            if let new = newValue {
                self.frames[key] = Frame.localizedFrame(.init(language: language, description: "Song Description", comments: new))
            } else {
                self.frames[key] = nil
            }
        }
    }
    
    /// - SeriesDescription getter-setter. This is a convenience for a custom `COM`/`COMM` frame with a description of `Series Description`
    subscript(seriesDescription language: ISO6392Codes) -> String? {
        get {
            if let frame = self.frames[.comments(description: "Series Description")],
                case .localizedFrame(let localizedFrame) = frame {
                return localizedFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let key = FrameKey.comments(description: "Series Description")
            if let new = newValue {
                self.frames[key] = Frame.localizedFrame(.init(language: language, description: "Series Description", comments: new))
            } else {
                self.frames[key] = nil
            }
        }
    }
    
    /// - (Unsynchronized) lyrics frame getter-setter. ID3 Identifier `ULT`/`USLT`
    subscript(lyrics language: ISO6392Codes, lyricsDescription: String) -> String? {
        get {
            if let frame = self.frames[.unsynchronizedLyrics(description: lyricsDescription)],
                case .localizedFrame(let localizedFrame) = frame {
                return localizedFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let key = FrameKey.unsynchronizedLyrics(description: lyricsDescription)
            if let new = newValue {
                self.frames[key] = Frame.localizedFrame(.init(language: language, description: lyricsDescription, lyrics: new))
            } else {
                self.frames[key] = nil
            }
        }
    }
}
