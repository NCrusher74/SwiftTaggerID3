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
        \(self.frameKey): \(self.contentString)
        """
    }

    // // MARK: - Properties
    // Inherited from `FrameProtocol`
    var flags: Data
    var layout: FrameLayoutIdentifier
    var frameKey: FrameKey
    
    // unique properties for this frame type
    /// ISO-639-2 languge code
    var languageString: String?
    /// A short description of the frame content.
    var descriptionString: String?
    /// the content of the frame
    var contentString: String
    
    // // MARK: - Frame Parsing
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
    
    // // MARK: - Frame building
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

// // MARK: - Tag extension
// get and set functions for `LocalizedFrame` frame types, which retrieves or sets up to three strings, one of which may be a language code, and one of which is an optional description string. Each individual frame of this type will call these functions in a get-set property or function, where appropriate.
extension Tag {
    internal func get(for frameKey: FrameKey,
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
    
    internal func get(for frameKey: FrameKey, description: String?)
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
    
    public mutating func removeCommentFrame(withDescription: String) {
        self.frames[.comments(description: withDescription)] = nil
    }

    public mutating func removeLyricsFrame(withDescription: String) {
        self.frames[.unsynchronizedLyrics(description: withDescription)] = nil
    }

    /// Comments frame getter-setter. ID3 Identifier `COM`/`COMM`
    public subscript(
        comments language: ISO6392Codes,
        commentsDescription: String?) -> String? {
        get {
            get(for:
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
            get(for:
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
            get(for: .unsynchronizedLyrics(
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
            get(for: .userDefinedText(
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

    public mutating func removeUserTextFrame(withDescription: String) {
        self.frames[.userDefinedText(description: withDescription)] = nil
    }

    public mutating func removeUserUrlFrame(withDescription: String) {
        self.frames[.userDefinedWebpage(description: withDescription)] = nil
    }

    /// UserDefinedWebpage frame getter-setter. ID3 Identifier `WXX`/`WXXX`
    public subscript(userDefinedUrl userDefinedUrlDescription: String?) -> String? {
        get {
            get(for: .userDefinedWebpage(
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
}
