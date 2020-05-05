//
//  UserTextFrame.swift
//  SwiftTaggerID3
//
//  Created by Nolaine Crusher on 4/12/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

/** a type representing an ID3 User Defined Text or User Defined Webpage frame, which consists of two strings: an optional, terminated `description` string, and a content string. A tag may have multiple frames of these types, but only one frame with the same `Description`. To preserve frame uniqueness while allowing multiple frames of these types, the `Description` field will be used as the `FrameKey` */
struct UserTextFrame: FrameProtocol {

    /// A short description of the frame content.
    var descriptionString: String = ""
    /// the content of the frame
    var contentString: String
    
    /**
     - parameter contentDescription: a terminated text string describing the frame content
     - parameter contentText: the full text of the comment or lyric frame.
     */
   init(layout: FrameLayoutIdentifier, descriptionString: String, contentString: String) {
        self.descriptionString = descriptionString
        self.contentString = contentString
        self.flags = UserTextFrame.defaultFlags
        self.layout = layout
        
        switch layout {
            case .known(.userDefinedText) : self.frameKey = .userDefinedText(description: descriptionString)
            case .known(.userDefinedWebpage) : self.frameKey = .userDefinedWebpage(description: descriptionString)
            default: self.frameKey = .userDefinedText(description: descriptionString)
        }
    }
    
    // MARK: Properties
    var flags: Data
    var layout: FrameLayoutIdentifier
    var frameKey: FrameKey
    var allowMultipleFrames: Bool = false

    // encode contents to add to an ID3 tag
    func encodeContents(version: Version) throws -> Data {
        var frameData = Data()
        // append encoding byte
        frameData.append(StringEncoding.preferred.rawValue.encoding(
            endianness: .bigEndian))
        // encode and append Description String
        frameData.append(self.descriptionString.encoded(
            withNullTermination: true))
        // encoded and append contents string
        frameData.append(self.contentString.encoded(
            withNullTermination: false))
        return frameData
    }

    init(decodingContents contents: Data.SubSequence,
         version: Version,
         layout: FrameLayoutIdentifier,
         flags: Data
    ) throws {
        self.flags = flags
        self.layout = layout
        
        var parsing = contents
        let encoding = try UserTextFrame.extractEncoding(data: &parsing, version: version)
        let parsed = try UserTextFrame.extractDescriptionAndContent(from: &parsing, encoding: encoding)
        self.descriptionString = parsed.description ?? ""
        self.contentString = parsed.content

        switch layout {
            case .known(.userDefinedText) : self.frameKey = .userDefinedText(description: parsed.description ?? "")
            case .known(.userDefinedWebpage) : self.frameKey = .userDefinedWebpage(description: parsed.description ?? "")
            default: self.frameKey = .userDefinedText(description: parsed.description ?? "")
        }
    }
}

internal extension Tag {
    /* get and set functions for `UserTextFrame` frame types. Each individual frame of this type will call these functions in a get-set property of function, where appropriate.
     
     This type returns a tuple of two strings, one of which is optional. The get function is called by a subscript that searches through (potentially) multiple UserTextFrames to find one with a unique description */
    func userTextGetter(for frameKey: FrameKey, description: String?)
        -> String? {
            // check that the frame is a UserDefinedWebpage frame or a UserText frame
            if frameKey == .userDefinedWebpage(description: description ?? "") {
                if let frame = self.frames[.userDefinedWebpage(
                    description: description ?? "")],
                    case .userTextFrame(let userTextFrame) = frame {
                    // return the content string of a specific frame by searching using the description string
                    return userTextFrame.contentString
                } else {
                    if let frame = self.frames[.userDefinedText(
                        description: description ?? "")],
                        case .userTextFrame(let userTextFrame) = frame {
                        return userTextFrame.contentString
                    }
                }
            }; return nil
    }
    
    mutating func set(_ layout: FrameLayoutIdentifier,
                      _ frameKey: FrameKey,
                      to description: String?,
                      with content: String) {
        let frame = UserTextFrame(
            layout: layout,
            descriptionString: description ?? "",
            contentString: content)
        self.frames[frameKey] = .userTextFrame(frame)
    }
    

}

// MARK: Tag Extension
public extension Tag {
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

    /// - SeriesName getter-setter. This is a convenience for a custom `TXX`/`TXXX` frame with a description of `Series NAme`
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
