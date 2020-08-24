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

    // MARK: - Properties
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
    
    // MARK: - Frame Parsing
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

        if let description = self.descriptionString {
            let entry = (self.frameKey, description, self.contentString)
            Tag.metadataWithDifferentiatingElement.removeAll(where: {$0.frameKey == frameKey})
            Tag.metadataWithDifferentiatingElement.append(entry)
        } else {
            let entry = (self.frameKey, "", self.contentString)
            Tag.metadataWithDifferentiatingElement.removeAll(where: {$0.frameKey == frameKey})
            Tag.metadataWithDifferentiatingElement.append(entry)
        }
    }
    
    // MARK: - Frame building
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

        if let description = self.descriptionString {
            let entry = (self.frameKey, description, self.contentString)
            Tag.metadataWithDifferentiatingElement.removeAll(where: {$0.frameKey == frameKey})
            Tag.metadataWithDifferentiatingElement.append(entry)
        } else {
            let entry = (self.frameKey, "", self.contentString)
            Tag.metadataWithDifferentiatingElement.removeAll(where: {$0.frameKey == frameKey})
            Tag.metadataWithDifferentiatingElement.append(entry)
        }
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

// MARK: - Tag extension
// get and set functions for `LocalizedFrame` frame types, which retrieves or sets up to three strings, one of which may be a language code, and one of which is an optional description string. Each individual frame of this type will call these functions in a get-set property or function, where appropriate.
extension Tag {
    private func get(for frameKey: FrameKey,
                      language: ISO6392Codes?,
                      description: String?) -> String? {
        if frameKey == .unsynchronizedLyrics(description: description ?? "") {
            if let frame = self.frames[.unsynchronizedLyrics(
                description: description ?? "")],
                case .localizedFrame(let localizedFrame) = frame {
                return localizedFrame.contentString
            } else {
                return nil
            }
        } else if frameKey == .comments(description: description ?? "") {
            if let frame = self.frames[.comments(
                description: description ?? "")],
                case .localizedFrame(let localizedFrame) = frame {
                return localizedFrame.contentString
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    private func get(for frameKey: FrameKey, description: String?)
        -> String? {
            // check that the frame is a UserDefinedWebpage frame or a UserText frame
            if frameKey == .userDefinedWebpage(description: description ?? "") {
                if let frame = self.frames[.userDefinedWebpage(
                    description: description ?? "")],
                    case .localizedFrame(let localizedFrame) = frame {
                    // return the content string of a specific frame by searching using the description string
                    return localizedFrame.contentString
                } else {
                    return nil
                }
            } else {
                if let frame = self.frames[.userDefinedText(
                    description: description ?? "")],
                    case .localizedFrame(let localizedFrame) = frame {
                    return localizedFrame.contentString
                } else {
                    return nil
                }
            }
    }
    
    private mutating func set(_ layout: FrameLayoutIdentifier,
                               _ frameKey: FrameKey,
                               in language: String?,
                               to description: String?,
                               with content: String?) {
        if let contentString = content {
            let frame = LocalizedFrame(layout,
                                       languageString: language,
                                       descriptionString: description,
                                       contentString: contentString)
            self.frames[frameKey] = .localizedFrame(frame)
        } else {
            self.frames[frameKey] = nil
        }
    }
    
    private mutating func set(_ layout: FrameLayoutIdentifier,
                               _ frameKey: FrameKey,
                               to description: String?,
                               with content: String?) {
        if let contentString = content {
            let frame = LocalizedFrame(
                layout, languageString: nil,
                descriptionString: description,
                contentString: contentString)
            self.frames[frameKey] = .localizedFrame(frame)
        } else {
            self.frames[frameKey] = nil
        }
    }
    
    private mutating func removeCommentFrame(withDescription: String) {
        self.frames[.comments(description: withDescription)] = nil
    }

    private mutating func removeLyricsFrame(withDescription: String) {
        self.frames[.unsynchronizedLyrics(description: withDescription)] = nil
    }

    /// Comments frame getter-setter. ID3 Identifier `COM`/`COMM`
    public subscript(_ commentDescription: String?, language: ISO6392Codes) -> String? {
        get {
            if let string = get(for: .comments(
                description: commentDescription ?? ""),
                                language: language,
                                description: commentDescription) {
                return string
            } else {
                return nil
            }
        }
        set {
            if let new = newValue {
                set(.known(.comments),
                    .comments(description: commentDescription ?? ""),
                    in: language.rawValue,
                    to: commentDescription,
                    with: new)
            } else {
                removeCommentFrame(withDescription: commentDescription ?? "")
            }
        }
    }
    
    /// (Unsynchronized) lyrics frame getter-setter. ID3 Identifier `ULT`/`USLT`
    public subscript(lyrics lyricsDescription: String?, language: ISO6392Codes) -> String? {
        get {
            if let string = get(for: .unsynchronizedLyrics(
                description: lyricsDescription ?? ""),
                                language: language,
                                description: lyricsDescription) {
                return string
            } else {
                return nil
            }
        }
        set {
            if let new = newValue {
                set(.known(.unsynchronizedLyrics), .unsynchronizedLyrics(description: lyricsDescription ?? ""), in: language.rawValue, to: lyricsDescription, with: new)
            } else {
                removeLyricsFrame(withDescription: lyricsDescription ?? "")
            }
        }
    }
    
    /// UserDefinedText frame getter-setter. ID3 Identifier `TXX`/`TXXX`
    public subscript(_ userTextDescription: String?) -> String? {
        get {
            if let string = get(for: .userDefinedText(
                description: userTextDescription ?? ""),
                                description: userTextDescription) {
                return string
            } else {
                return nil
            }
        }
        set {
            if let new = newValue {
                set(.known(.userDefinedText), .userDefinedText(
                    description: userTextDescription ?? ""),
                    to: userTextDescription,
                    with: new)
            } else {
                removeUserTextFrame(withDescription: userTextDescription ?? "")
            }
        }
    }

    private mutating func removeUserTextFrame(withDescription: String) {
        self.frames[.userDefinedText(description: withDescription)] = nil
    }

    private mutating func removeUserUrlFrame(withDescription: String) {
        self.frames[.userDefinedWebpage(description: withDescription)] = nil
    }

    /// UserDefinedWebpage frame getter-setter. ID3 Identifier `WXX`/`WXXX`
    public subscript(userDefinedUrl userDefinedUrlDescription: String?) -> String? {
        get {
            if let string = get(for: .userDefinedWebpage(
                description: userDefinedUrlDescription ?? ""),
                                description: userDefinedUrlDescription) {
                return string
            } else {
                return nil
            }
        }
        set {
            if let new = newValue {
                set(.known(.userDefinedWebpage), .userDefinedWebpage(
                    description: userDefinedUrlDescription ?? ""),
                    to: userDefinedUrlDescription,
                    with: new)
            } else {
                removeUserUrlFrame(withDescription: userDefinedUrlDescription ?? "")
            }
        }
    }
    
    public var contentRating: ContentRating? {
        get {
            if let stringValue = self["Content Rating"] {
                switch stringValue {
                    case "Clean": return ContentRating.clean
                    case "Explicit": return ContentRating.explicit
                    case "None": return ContentRating.none
                    default: return nil
                }
            } else {
                return nil
            }
        }
        set {
            if let new = newValue {
                self["Content Rating"] = new.rawValue
            } else {
                self["Content Rating"] = nil
            }
        }
    }
}
