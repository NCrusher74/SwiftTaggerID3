//
//  LocalizedFrame.swift
//  SwiftTaggerID3
//
//  Created by Nolaine Crusher on 4/11/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

/**
 A type representing an ID3 frame that holds a three string fields: `Language` contains the 3-charcter string for the ISO-639-2 language code, `Description` contains a null-terminated string describing the frame content, and `Content`.
 
 This frame type will be used for `UserDefinedText`, `UserDefinedWebpage`, `Comment` and `UnsynchronizedLyrics` frames. A tag may have multiple frames of these types, but only one frame with the same `Description` and/or `Language`.
 
 To preserve frame uniqueness while allowing multiple frames of these types, the `Description` field will be used as part of the `FrameKey`.
 
 `Comment` and `UnsynchronizedLyrics` frames are the only frames that allow the use of new-line characters. Therefore, they are ideally suited for long remarks and convenience getter-setter properties for the most common types have been added.
 */
struct LocalizedFrame: FrameProtocol {
    
    // MARK: Properties
    // Inherited from `FrameProtocol`
    var flags: Data
    var layout: FrameLayoutIdentifier
    var frameKey: FrameKey
    var allowMultipleFrames: Bool = false
    
    // unique properties for this frame type
    /// ISO-639-2 languge code
    var languageString: String? = "und"
    /// A short description of the frame content.
    var descriptionString: String? = ""
    /// the content of the frame
    var contentString: String
    
    init(decodingContents contents: Data.SubSequence,
         version: Version,
         layout: FrameLayoutIdentifier,
         flags: Data
    ) throws {
        self.flags = flags
        self.layout = layout
        
        var parsing = contents
        let encoding = try LocalizedFrame.extractEncoding(data: &parsing, version: version)
        
        if layout == .known(.comments) || layout == .known(.unsynchronizedLyrics) {
            /// parse out a language string only for these frame types
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
                case .known(.comments) : self.frameKey = .comments(
                    description: parsed.description ?? "")
                case .known(.unsynchronizedLyrics) : self.frameKey = .unsynchronizedLyrics(
                    description: parsed.description ?? "")
                default: self.frameKey = .comments(
                    description: parsed.description ?? "")
            }
        } else {
            let parsed = try LocalizedFrame.extractDescriptionAndContent(from: &parsing, encoding: encoding)
            self.descriptionString = parsed.description ?? ""
            self.contentString = parsed.content
            
            switch layout {
                case .known(.userDefinedText) : self.frameKey = .userDefinedText(
                    description: parsed.description ?? "")
                case .known(.userDefinedWebpage) : self.frameKey = .userDefinedWebpage(
                    description: parsed.description ?? "")
                default: self.frameKey = .userDefinedText(
                    description: parsed.description ?? "")
            }
        }
    }
    
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
            case .known(.userDefinedText): self.frameKey = .userDefinedText(description: descriptionString ?? "")
            case .known(.userDefinedWebpage) : self.frameKey = .userDefinedWebpage(description: descriptionString ?? "")
            default: self.frameKey = .userDefinedText(description: descriptionString ?? "")
        }
        self.flags = LocalizedFrame.defaultFlags
        
        self.languageString = languageString ?? "und"
        self.descriptionString = descriptionString ?? ""
        self.contentString = contentString
    }
    
    
    // encode the contents of the frame to add to an ID3 tag
    func encodeContents(version: Version) throws -> Data {
        var frameData = Data()
        // append encoding byte
        frameData.append(StringEncoding.preferred.rawValue.encoding(
            endianness: .bigEndian))
        if self.layout == .known(.comments) ||
            self.layout == .known(.unsynchronizedLyrics) {
            // encode and append language string
            frameData.append(self.languageString?.encoded(withNullTermination: false) ?? "und".encoded(withNullTermination: false))
        }
        // encode and append description string
        frameData.append(self.descriptionString?.encoded(withNullTermination: true) ?? "".encoded(withNullTermination: true))
        // encode and append contents string
        frameData.append(self.contentString.encoded(withNullTermination: false))
        return frameData
    }
    
}

internal extension Tag {
    // get and set functions for `LocalizedFrame` frame types, which retrieves or sets three strings, one of which is a language code, and one of which is optional. Each individual frame of this type will call these functions in a get-set property of function, where appropriate.
    func localizedGetter(for frameKey: FrameKey,
                         language: ISO6392Codes?,
                         description: String?) -> String? {
        if frameKey == .unsynchronizedLyrics(description: description ?? "") {
            if let frame = self.frames[.unsynchronizedLyrics(
                description: description ?? "")],
                case .localizedFrame(let localizedFrame) = frame {
                return localizedFrame.contentString
            }
        } else if frameKey == .comments(description: description ?? "") {
            if let frame = self.frames[.comments(
                description: description ?? "")],
                case .localizedFrame(let localizedFrame) = frame {
                return localizedFrame.contentString
            }
        }; return nil
    }
    
    func userTextGetter(for frameKey: FrameKey, description: String?)
        -> String? {
            // check that the frame is a UserDefinedWebpage frame or a UserText frame
            if frameKey == .userDefinedWebpage(description: description ?? "") {
                if let frame = self.frames[.userDefinedWebpage(
                    description: description ?? "")],
                    case .localizedFrame(let localizedFrame) = frame {
                    // return the content string of a specific frame by searching using the description string
                    return localizedFrame.contentString
                } else {
                    if let frame = self.frames[.userDefinedText(
                        description: description ?? "")],
                        case .localizedFrame(let localizedFrame) = frame {
                        return localizedFrame.contentString
                    }
                }
            }; return nil
    }
    
    mutating func set(_ layout: FrameLayoutIdentifier,
                      _ frameKey: FrameKey,
                      in language: String,
                      to description: String?,
                      with content: String) {
        let frame = LocalizedFrame(layout: layout,
                                   languageString: language,
                                   descriptionString: description,
                                   contentString: content)
        self.frames[frameKey] = .localizedFrame(frame)
    }
    
    mutating func set(_ layout: FrameLayoutIdentifier,
                      _ frameKey: FrameKey,
                      to description: String?,
                      with content: String) {
        let frame = LocalizedFrame(
            layout: layout, languageString: nil,
            descriptionString: description ?? "",
            contentString: content)
        self.frames[frameKey] = .localizedFrame(frame)
    }

    /// - Comments frame getter-setter. ID3 Identifier `COM`/`COMM`
    subscript(comments language: ISO6392Codes, commentsDescription: String) -> String {
        get {
            localizedGetter(for: .comments(
                description: commentsDescription),
                            language: language,
                            description: commentsDescription) ?? ""
        }
        set {
            set(.known(.comments), .comments(description: commentsDescription), in: language.rawValue, to: commentsDescription, with: newValue)
        }
    }
    
    /// - Description getter-setter. This is a convenience for a custom `COM`/`COMM` frame with a description of `Description`
    subscript(description language: ISO6392Codes) -> String {
        get {
            localizedGetter(for: .comments(
                description: "Description"),
                            language: language,
                            description: "Description") ?? ""
        }
        set {
            set(.known(.comments), .comments(description: "Description"), in: language.rawValue, to: "Description", with: newValue)
        }
    }
    
    /// - LongDescription getter-setter. This is a convenience for a custom `COM`/`COMM` frame with a description of `Long Description`
    subscript(longDescription language: ISO6392Codes) -> String {
        get {
            localizedGetter(for: .comments(
                description: "Long Description"),
                            language: language,
                            description: "Long Description") ?? ""
        }
        set {
            set(.known(.comments), .comments(description: "Long Description"), in: language.rawValue, to: "Long Description", with: newValue)
        }
    }
    
    /// - LinerNotes getter-setter. This is a convenience for a custom `COM`/`COMM` frame with a description of `Liner Notes`
    subscript(linerNotes language: ISO6392Codes) -> String {
        get {
            localizedGetter(for: .comments(
                description: "Liner Notes"),
                            language: language,
                            description: "Liner Notes") ?? ""
        }
        set {
            set(.known(.comments), .comments(description: "Liner Notes"), in: language.rawValue, to: "Liner Notes", with: newValue)
        }
    }
    
    /// - SongDescription getter-setter. This is a convenience for a custom `COM`/`COMM` frame with a description of `Song Description`
    subscript(songDescription language: ISO6392Codes) -> String {
        get {
            localizedGetter(for: .comments(
                description: "Song Description"),
                            language: language,
                            description: "Song Description") ?? ""
        }
        set {
            set(.known(.comments), .comments(description: "Song Description"), in: language.rawValue, to: "Song Description", with: newValue)
        }
    }
    
    /// - SeriesDescription getter-setter. This is a convenience for a custom `COM`/`COMM` frame with a description of `Series Description`
    subscript(seriesDescription language: ISO6392Codes) -> String {
        get {
            localizedGetter(for: .comments(
                description: "Series Description"),
                            language: language,
                            description: "Series Description") ?? ""
        }
        set {
            set(.known(.comments), .comments(description: "Series Description"), in: language.rawValue, to: "Series Description", with: newValue)
        }
    }
    
    /// - (Unsynchronized) lyrics frame getter-setter. ID3 Identifier `ULT`/`USLT`
    subscript(lyrics language: ISO6392Codes, lyricsDescription: String) -> String {
        get {
            localizedGetter(for: .unsynchronizedLyrics(
                description: lyricsDescription),
                            language: language,
                            description: lyricsDescription) ?? ""
        }
        set {
            set(.known(.unsynchronizedLyrics), .unsynchronizedLyrics(description: lyricsDescription), in: language.rawValue, to: lyricsDescription, with: newValue)
        }
    }
    
    /// - UserDefinedText frame getter-setter. ID3 Identifier `TXX`/`TXXX`
    subscript(userDefinedText userTextDescription: String) -> String {
        get {
            userTextGetter(for: .userDefinedText(description: userTextDescription), description: userTextDescription) ?? ""
        }
        set {
            set(.known(.userDefinedText), .userDefinedText(description: userTextDescription), to: userTextDescription, with: newValue)
        }
    }
    
    /// - UserDefinedWebpage frame getter-setter. ID3 Identifier `WXX`/`WXXX`
    subscript(userDefinedUrl userDefinedUrlDescription: String) -> String {
        get {
            userTextGetter(for: .userDefinedWebpage(description: userDefinedUrlDescription), description: userDefinedUrlDescription) ?? ""
        }
        set {
            set(.known(.userDefinedText), .userDefinedText(description: userDefinedUrlDescription), to: userDefinedUrlDescription, with: newValue)
        }
    }
    
    /// - OnlineExtras getter-setter. This is a convenience for a custom `WXX`/`WXXX` frame with a description of `Online Extras`. Mainly present to create an MP3 counterpart to the MP4 online extras atom
    var onlineExtras: String {
        get {
            userTextGetter(for: .userDefinedText(description: "Online Extras"), description: "Online Extras") ?? ""
        }
        set {
            set(.known(.userDefinedText), .userDefinedText(description: "Online Extras"), to: "Online Extras", with: newValue)
        }
    }
    
    /// - Acknowledgment getter-setter. This is a convenience for a custom `TXX`/`TXXX` frame with a description of `Acknowledgment`
    var acknowledgment: String {
        get {
            userTextGetter(for: .userDefinedText(description: "Acknowledgment"), description: "Acknowledgment") ?? ""
        }
        set {
            set(.known(.userDefinedText), .userDefinedText(description: "Acknowledgment"), to: "Acknowledgment", with: newValue)
        }
    }
    
    /// - Thanks getter-setter. This is a convenience for a custom `TXX`/`TXXX` frame with a description of `Thanks`
    var thanks: String {
        get {
            userTextGetter(for: .userDefinedText(description: "Thanks"), description: "Thanks") ?? ""
        }
        set {
            set(.known(.userDefinedText), .userDefinedText(description: "Thanks"), to: "Thanks", with: newValue)
        }
    }
    
    /// - SourceCredit getter-setter. This is a convenience for a custom `TXX`/`TXXX` frame with a description of `Source Credit`
    var sourceCredit: String {
        get {
            userTextGetter(for: .userDefinedText(description: "Source Credit"), description: "Source Credit") ?? ""
        }
        set {
            set(.known(.userDefinedText), .userDefinedText(description: "Source Credit"), to: "Source Credit", with: newValue)
        }
    }
    
    /// - SeriesName getter-setter. This is a convenience for a custom `TXX`/`TXXX` frame with a description of `Series Name`
    var seriesName: String {
        get {
            userTextGetter(for: .userDefinedText(description: "Series Name"), description: "Series Name") ?? ""
        }
        set {
            set(.known(.userDefinedText), .userDefinedText(description: "Series Name"), to: "Series Name", with: newValue)
        }
    }
    
    /// - Episode Name getter-setter. This is a convenience for a custom `TXX`/`TXXX` frame with a description of `Episode Name`
    var episodeName: String {
        get {
            userTextGetter(for: .userDefinedText(description: "Episode Name"), description: "Episode Name") ?? ""
        }
        set {
            set(.known(.userDefinedText), .userDefinedText(description: "Episode Name"), to: "Episode Name", with: newValue)
        }
    }
    
    /// - Network getter-setter. This is a convenience for a custom `TXX`/`TXXX` frame with a description of `Network`
    var network: String {
        get {
            userTextGetter(for: .userDefinedText(description: "Network"), description: "Network") ?? ""
        }
        set {
            set(.known(.userDefinedText), .userDefinedText(description: "Network"), to: "Network", with: newValue)
        }
    }
    
    /// - EpisodeNumber getter-setter. This is a convenience for a custom `TXX`/`TXXX` frame with a description of `Episode Number`
    var episodeNumber: Int {
        get {
            let intString = userTextGetter(for: .userDefinedText(description: "Episode Number"), description: "Episode Number") ?? ""
            return Int(intString) ?? 0
        }
        set {
            set(.known(.userDefinedText), .userDefinedText(description: "Episode Number"), to: "Episode Number", with: String(newValue))
        }
    }
    
    /// - Season (number) getter-setter. This is a convenience for a custom `TXX`/`TXXX` frame with a description of `Episode Number`
    var season: Int {
        get {
            let intString = userTextGetter(for: .userDefinedText(description: "Season"), description: "Season") ?? ""
            return Int(intString) ?? 0
        }
        set {
            set(.known(.userDefinedText), .userDefinedText(description: "Season"), to: "Season", with: String(newValue))
        }
    }
    
    /// - Keywords getter-setter. This is a convenience for a custom `TXX`/`TXXX` frame with a description of `Keywords`. Use semi-colon to separate keywords.
    var keywords: [String] {
        get {
            let keywordString = userTextGetter(for: .userDefinedText(description: "Keywords"), description: "Keywords")
            return keywordString?.components(separatedBy: ";") ?? []
        }
        set {
            set(.known(.userDefinedText), .userDefinedText(description: "Keywords"), to: "Keywords", with: newValue.joined(separator: ";"))
        }
    }
    
    /// - Content Rating getter-setter. This is a convenience for a custom `TXX`/`TXXX` frame with a description of `Content Advisory`
    var contentAdvisory: ContentAdvisory {
        get {
            let string = userTextGetter(for: .userDefinedText(description: "Content Advisory"), description: "Content Advisory") ?? "mpaa|Unrated|???"
            return ContentAdvisory(rawValue: string) ?? .usMovieUnrated
        }
        set {
            set(.known(.userDefinedText), .userDefinedText(description: "Content Advisory"), to: "Content Advisory", with: newValue.rawValue)
        }
    }
    
    /// - Content Advisory getter-setter. This is a convenience for a custom `TXX`/`TXXX` frame with a description of `Content Rating`
    var contentRating: ContentRating {
        get {
            let string = userTextGetter(for: .userDefinedText(description: "Content Rating"), description: "Content Rating") ?? ""
            return ContentRating(rawValue: string) ?? .none
        }
        set {
            set(.known(.userDefinedText), .userDefinedText(description: "Content Rating"), to: "Content Rating", with: newValue.rawValue)
        }
    }

}
