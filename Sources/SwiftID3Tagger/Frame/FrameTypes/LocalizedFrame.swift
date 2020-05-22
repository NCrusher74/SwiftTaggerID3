/*

 LocalizedFrame.swift
 SwiftTaggerID3

 Copyright ©2020 Nolaine Crusher. All rights reserved.

 */

import Foundation

/**
 A type representing an ID3 frame that holds a three string fields: `Language` contains the 3-charcter string for the ISO-639-2 language code, `Description` contains a null-terminated string describing the frame content, and `Content`.
 
 This frame type will be used for `UserDefinedText`, `UserDefinedWebpage`, `Comment` and `UnsynchronizedLyrics` frames. A tag may have multiple frames of these types, but only one frame with the same `Description` and/or `Language`.
 
 To preserve frame uniqueness while allowing multiple frames of these types, the `Description` field will be used as part of the `FrameKey`.
 
 `Comment` and `UnsynchronizedLyrics` frames are the only frames that allow the use of new-line characters. Therefore, they are ideally suited for long remarks and convenience getter-setter properties for the most common types have been added.
 */
struct LocalizedFrame: FrameProtocol, CustomStringConvertible {
    public var description: String {
        return """
        frameKey: .\(self.frameKey)
        \(String(describing: self.descriptionString)): \(self.contentString)
        """
    }

    // MARK: Properties
    // Inherited from `FrameProtocol`
    var flags: Data
    var layout: FrameLayoutIdentifier
    var frameKey: FrameKey
    var allowMultipleFrames: Bool = true
    
    // unique properties for this frame type
    /// ISO-639-2 languge code
    var languageString: String?
    /// A short description of the frame content.
    var descriptionString: String?
    /// the content of the frame
    var contentString: String
    
    // MARK: Frame Parsing
    init(decodingContents contents: Data.SubSequence,
         version: Version,
         layout: FrameLayoutIdentifier,
         flags: Data
    ) throws {
        self.flags = flags
        self.layout = layout
        
        var parsing = contents
        let encoding = try LocalizedFrame.extractEncoding(data: &parsing, version: version)
        
        if layout == .known(.comments) ||
            layout == .known(.unsynchronizedLyrics) {
            /// parse out a language string only for these frame types
            
            let codeString = try String(ascii: parsing.extractFirst(3))
            if let languageCode = ISO6392Codes(rawValue: codeString) {
                self.languageString = languageCode.rawValue
            } else {
                self.languageString = "und"
            }
        }
        let parsed = try LocalizedFrame.extractDescriptionAndContent(from: &parsing, encoding: encoding)
        self.descriptionString = parsed.description ?? ""
        self.contentString = parsed.content
        self.frameKey = layout.frameKey(additionalIdentifier: self.descriptionString)
    }
    
    // MARK: Frame building
    /**
     - parameter languageString: the ISO-639-2 language code. default is `undetermined`
     - parameter descriptionString: a terminated text string describing the frame content
     - parameter contentString: the full text of the comment or lyric frame.
     */
    init(_ layout: FrameLayoutIdentifier,
         languageString: String?,
         descriptionString: String?,
         contentString: String) {
        self.layout = layout
        self.frameKey = layout.frameKey(additionalIdentifier: descriptionString)
        
        self.flags = LocalizedFrame.defaultFlags
        self.languageString = languageString
        self.descriptionString = descriptionString
        self.contentString = contentString
    }
    
    
    // encode the contents of the frame to add to an ID3 tag
    func encodeContents(version: Version) throws -> Data {
        var frameData = Data()
        // append encoding byte
        frameData.append(StringEncoding.preferred.rawValue)
        
        if self.layout == .known(.comments) ||
            self.layout == .known(.unsynchronizedLyrics) {
            // encode and append language string
            frameData.append(self.languageString?.encodedASCII(withNullTermination: false) ?? "und".encodedASCII(withNullTermination: false))
        }
        // encode and append description string
        if let encodedDescription = self.descriptionString?.encoded(withNullTermination: true) {
            frameData.append(encodedDescription)
        }
        // encode and append contents string
        frameData.append(self.contentString.encoded(withNullTermination: false))
        return frameData
    }
}

// MARK: Tag extension
// get and set functions for `LocalizedFrame` frame types, which retrieves or sets up to three strings, one of which may be a language code, and one of which is an optional description string. Each individual frame of this type will call these functions in a get-set property or function, where appropriate.
extension Tag {
    internal func localizedGetter(for frameKey: FrameKey,
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
    
    internal func userTextGetter(for frameKey: FrameKey, description: String?)
        -> String? {
            // check that the frame is a UserDefinedWebpage frame or a UserText frame
            if frameKey == .userDefinedWebpage(description: description ?? "") {
                if let frame = self.frames[.userDefinedWebpage(
                    description: description ?? "")],
                    case .localizedFrame(let localizedFrame) = frame {
                    // return the content string of a specific frame by searching using the description string
                    return localizedFrame.contentString
                }
            } else {
                if let frame = self.frames[.userDefinedText(
                    description: description ?? "")],
                    case .localizedFrame(let localizedFrame) = frame {
                    return localizedFrame.contentString
                }
            }; return nil
    }
    
    internal mutating func set(_ layout: FrameLayoutIdentifier,
                               _ frameKey: FrameKey,
                               in language: String?,
                               to description: String?,
                               with content: String) {
        let frame = LocalizedFrame(layout,
                                   languageString: language,
                                   descriptionString: description,
                                   contentString: content)
        self.frames[frameKey] = .localizedFrame(frame)
    }
    
    internal mutating func set(_ layout: FrameLayoutIdentifier,
                               _ frameKey: FrameKey,
                               to description: String?,
                               with content: String) {
        let frame = LocalizedFrame(
            layout, languageString: nil,
            descriptionString: description,
            contentString: content)
        self.frames[frameKey] = .localizedFrame(frame)
    }
    
    public mutating func removeComment(withDescription: String?) {
        set(.known(.comments),
            .comments(description: withDescription ?? ""),
            in: nil,
            to: nil,
            with: "")
    }

    public mutating func removeLyrics(withDescription: String?) {
        set(.known(.unsynchronizedLyrics),
            .unsynchronizedLyrics(description: withDescription ?? ""),
            in: nil,
            to: nil,
            with: "")
    }

    /// Comments frame getter-setter. ID3 Identifier `COM`/`COMM`
    public subscript(
        comments language: ISO6392Codes,
        commentsDescription: String?) -> String? {
        get {
            localizedGetter(for:
                .comments(description: commentsDescription ?? ""),
                            language: language,
                            description: commentsDescription) ?? ""
        }
        set {
            set(.known(.comments),
                .comments(description: commentsDescription ?? ""),
                in: language.rawValue,
                to: commentsDescription,
                with: newValue ?? "")
        }
    }
    
    /// Description getter-setter. This is a convenience for a custom `COM`/`COMM` frame with a description with a description that can be selected from a list of custom presets
    public subscript(customComment language: ISO6392Codes,
        description: CommentDescriptionPresets?) -> String? {
        get {
            localizedGetter(for:
                .comments(description: description?.rawValue ?? ""),
                            language: language,
                            description: description?.rawValue)
        }
        set {
            set(.known(.comments),
                .comments(description: description?.rawValue ?? ""),
                in: language.rawValue,
                to: description?.rawValue,
                with: newValue ?? "")
        }
    }
    
    /// (Unsynchronized) lyrics frame getter-setter. ID3 Identifier `ULT`/`USLT`
    public subscript(lyrics language: ISO6392Codes, lyricsDescription: String?) -> String? {
        get {
            localizedGetter(for: .unsynchronizedLyrics(
                description: lyricsDescription ?? ""),
                            language: language,
                            description: lyricsDescription)
        }
        set {
            set(.known(.unsynchronizedLyrics), .unsynchronizedLyrics(description: lyricsDescription ?? ""), in: language.rawValue, to: lyricsDescription, with: newValue ?? "")
        }
    }
    
    /// UserDefinedText frame getter-setter. ID3 Identifier `TXX`/`TXXX`
    public subscript(userDefinedText userTextDescription: String?) -> String? {
        get {
            userTextGetter(for: .userDefinedText(
                description: userTextDescription ?? ""),
                           description: userTextDescription)
        }
        set {
            set(.known(.userDefinedText), .userDefinedText(
                description: userTextDescription ?? ""),
                to: userTextDescription,
                with: newValue ?? "")
        }
    }

    public mutating func removeUserText(withDescription: String?) {
        set(.known(.userDefinedText),
            .userDefinedText(description: withDescription ?? ""),
            to: nil,
            with: "")
    }

    public mutating func removeUserWebpage(withDescription: String?) {
        set(.known(.userDefinedWebpage),
            .userDefinedWebpage(description: withDescription ?? ""),
            to: nil,
            with: "")
    }

    /// UserDefinedWebpage frame getter-setter. ID3 Identifier `WXX`/`WXXX`
    public subscript(userDefinedUrl userDefinedUrlDescription: String?) -> String? {
        get {
            userTextGetter(for: .userDefinedWebpage(
                description: userDefinedUrlDescription ?? ""),
                           description: userDefinedUrlDescription)
        }
        set {
            set(.known(.userDefinedWebpage), .userDefinedWebpage(
                description: userDefinedUrlDescription ?? ""),
                to: userDefinedUrlDescription,
                with: newValue ?? "")
        }
    }
    
    /// OnlineExtras getter-setter. This is a convenience for a custom `WXX`/`WXXX` frame with a description of `Online Extras`. Mainly present to create an MP3 counterpart to the MP4 online extras atom
    public var onlineExtras: String? {
        get {
            userTextGetter(
                for: .userDefinedWebpage(description: "Online Extras"),
                description: "Online Extras")
        }
        set {
            set(.known(.userDefinedWebpage), .userDefinedWebpage(
                description: "Online Extras"),
                to: "Online Extras",
                with: newValue ?? "")
        }
    }
    
    /// Acknowledgment getter-setter. This is a convenience for a custom `TXX`/`TXXX` frame with a description of `Acknowledgment`
    public var acknowledgment: String? {
        get {
            userTextGetter(
                for: .userDefinedText(description: "Acknowledgment"),
                description: "Acknowledgment")
        }
        set {
            set(.known(.userDefinedText), .userDefinedText(
                description: "Acknowledgment"),
                to: "Acknowledgment",
                with: newValue ?? "")
        }
    }
    
    /// Thanks getter-setter. This is a convenience for a custom `TXX`/`TXXX` frame with a description of `Thanks`
    public var thanks: String? {
        get {
            userTextGetter(for: .userDefinedText(description: "Thanks"), description: "Thanks")
        }
        set {
            set(.known(.userDefinedText), .userDefinedText(
                description: "Thanks"),
                to: "Thanks",
                with: newValue ?? "")
        }
    }
    
    /// SourceCredit getter-setter. This is a convenience for a custom `TXX`/`TXXX` frame with a description of `Source Credit`
    public var sourceCredit: String? {
        get {
            userTextGetter(for: .userDefinedText(description: "Source Credit"),
                           description: "Source Credit")
        }
        set {
            set(.known(.userDefinedText), .userDefinedText(
                description: "Source Credit"),
                to: "Source Credit",
                with: newValue ?? "")
        }
    }
    
    /// SeriesName getter-setter. This is a convenience for a custom `TXX`/`TXXX` frame with a description of `Series Name`
    public var seriesName: String? {
        get {
            userTextGetter(for: .userDefinedText(description: "Series Name"), description: "Series Name")
        }
        set {
            set(.known(.userDefinedText), .userDefinedText(
                description: "Series Name"),
                to: "Series Name",
                with: newValue ?? "")
        }
    }
    
    /// Episode Name getter-setter. This is a convenience for a custom `TXX`/`TXXX` frame with a description of `Episode Name`
    public var episodeName: String? {
        get {
            userTextGetter(for: .userDefinedText(description: "Episode Name"), description: "Episode Name")
        }
        set {
            set(.known(.userDefinedText), .userDefinedText(
                description: "Episode Name"),
                to: "Episode Name",
                with: newValue ?? "")
        }
    }
    
    /// Network getter-setter. This is a convenience for a custom `TXX`/`TXXX` frame with a description of `Network`
    public var network: String? {
        get {
            userTextGetter(for: .userDefinedText(description: "Network"), description: "Network")
        }
        set {
            set(.known(.userDefinedText), .userDefinedText(
                description: "Network"),
                to: "Network",
                with: newValue ?? "")
        }
    }
    
    /// EpisodeNumber getter-setter. This is a convenience for a custom `TXX`/`TXXX` frame with a description of `Episode Number`
    public var episodeNumber: Int? {
        get {
            guard let intString = userTextGetter(for: .userDefinedText(description: "Episode Number"), description: "Episode Number") else { return nil }
            return Int(intString)
        }
        set {
            set(.known(.userDefinedText), .userDefinedText(
                description: "Episode Number"),
                to: "Episode Number",
                with: String(newValue ?? 0))
        }
    }
    
    /// Season (number) getter-setter. This is a convenience for a custom `TXX`/`TXXX` frame with a description of `Episode Number`
    public var season: Int? {
        get {
            guard let intString = userTextGetter(for: .userDefinedText(description: "Season"), description: "Season") else { return nil }
            return Int(intString)
        }
        set {
            set(.known(.userDefinedText), .userDefinedText(description: "Season"), to: "Season", with: String(newValue ?? 0))
        }
    }
    
    /// Keywords getter-setter. This is a convenience for a custom `TXX`/`TXXX` frame with a description of `Keywords`. Use semi-colon to separate keywords.
    public var keywords: [String]? {
        get {
            let keywordString = userTextGetter(for: .userDefinedText(description: "Keywords"), description: "Keywords")
            return keywordString?.components(separatedBy: ";")
        }
        set {
            set(.known(.userDefinedText), .userDefinedText(description: "Keywords"), to: "Keywords", with: newValue?.joined(separator: ";") ?? "")
        }
    }
    
    /// Content Rating getter-setter. This is a convenience for a custom `TXX`/`TXXX` frame with a description of `Content Advisory`
    public var contentAdvisory: ContentAdvisory? {
        get {
            guard let string = userTextGetter(for: .userDefinedText(description: "Content Advisory"), description: "Content Advisory") else { return nil }
            return ContentAdvisory(rawValue: string) ?? .usMovieUnrated
        }
        set {
            set(.known(.userDefinedText), .userDefinedText(description: "Content Advisory"), to: "Content Advisory", with: newValue?.rawValue ?? "")
        }
    }
    
    /// Content Advisory getter-setter. This is a convenience for a custom `TXX`/`TXXX` frame with a description of `Content Rating`
    public var contentRating: ContentRating? {
        get {
            guard let string = userTextGetter(for: .userDefinedText(description: "Content Rating"), description: "Content Rating") else { return nil }
            return ContentRating(rawValue: string)
        }
        set {
            set(.known(.userDefinedText), .userDefinedText(description: "Content Rating"), to: "Content Rating", with: newValue?.rawValue ?? "")
        }
    }
    
}
