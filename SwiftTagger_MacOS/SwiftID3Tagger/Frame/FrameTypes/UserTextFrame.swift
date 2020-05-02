//
//  UserTextFrame.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/12/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

/** a type representing an ID3 User Defined Text or User Defined Webpage frame, which consists of two strings: an optional, terminated `description` string, and a content string. A tag may have multiple frames of these types, but only one frame with the same `Description`. To preserve frame uniqueness while allowing multiple frames of these types, the `Description` field will be used as the `FrameKey` */
struct UserTextFrame: FrameProtocol {
   
    init(description: String, webpage: String) {
        self.init(layout: .known(.userDefinedWebpage),
                  descriptionString: description,
                  contentString: webpage)
    }

    init(description: String, content: String) {
        self.init(layout: .known(.userDefinedText),
                  descriptionString: description,
                  contentString: content)
    }

    // convenience initializer preset to "online extras" for comformance with MP4 module
    init(onlineExtras: String) {
        self.init(layout: .known(.userDefinedWebpage),
                  descriptionString: "Online Extras",
                  contentString: onlineExtras)
    }

    // convenience initializer, description pre-set to "Acknowledgments"
    init(acknowledgments: String) {
        self.init(layout: .known(.userDefinedText),
                  descriptionString: "Acknowledgments",
                  contentString: acknowledgments)
    }

    // convenience initializer, description pre-set to "Thanks"
    init(thanks: String) {
        self.init(layout: .known(.userDefinedText),
                  descriptionString: "Thanks",
                  contentString: thanks)
    }

    // convenience initializer, description pre-set to "Source Credit"
    init(sourceCredit: String) {
        self.init(layout: .known(.userDefinedText),
                  descriptionString: "Source Credit",
                  contentString: sourceCredit)
    }

    init(contentRating: ContentRatings) {
        self.init(layout: .known(.userDefinedText),
                  descriptionString: "Content Rating",
                  contentString: contentRating.rawValue)
    }

    init(contentAdvisory: ContentAdvisory) {
        self.init(layout: .known(.userDefinedText),
                  descriptionString: "Content Advisory",
                  contentString: contentAdvisory.rawValue)
    }

    init(keywords: String) {
        self.init(layout: .known(.userDefinedText),
                  descriptionString: "Keywords",
                  contentString: keywords)
    }

    init(episodeName: String) {
        self.init(layout: .known(.userDefinedText),
                  descriptionString: "Episode Name",
                  contentString: episodeName)
    }

    init(seriesName: String) {
        self.init(layout: .known(.userDefinedText),
                  descriptionString: "Series Name",
                  contentString: seriesName)
    }

    init(network: String) {
        self.init(layout: .known(.userDefinedText),
                  descriptionString: "Network",
                  contentString: network)
    }

    init(episodeNumber: Int) {
        self.init(layout: .known(.userDefinedText),
                  descriptionString: "Episode Number",
                  contentString: String(episodeNumber))
    }
    
    init(season: Int) {
        self.init(layout: .known(.userDefinedText),
                  descriptionString: "Season Number",
                  contentString: String(season))
    }
    


    /// A short description of the frame content.
    var descriptionString: String = ""
    /// the content of the frame
    var contentString: String
    
    /**
     - parameter contentDescription: a terminated text string describing the frame content
     - parameter contentText: the full text of the comment or lyric frame.
     */
    private init(layout: FrameLayoutIdentifier, descriptionString: String, contentString: String) {
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
    
    var flags: Data
    var layout: FrameLayoutIdentifier
    var frameKey: FrameKey
    var allowMultipleFrames: Bool = true

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

    // decode frame contents from an ID3 tag
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

// MARK: Tag Extension
public extension Tag {
    /// - UserDefinedText frame getter-setter. ID3 Identifier `TXX`/`TXXX`
    subscript(userDefinedText userTextDescription: String) -> String? {
        get {
            if let frame = self.frames[.userDefinedText(description: userTextDescription)],
                case .userTextFrame(let userTextFrame) = frame {
                return userTextFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let key = FrameKey.userDefinedText(description: userTextDescription)
            if let new = newValue {
                self.frames[key] = Frame.userTextFrame(.init(description: userTextDescription, content: new))
            } else {
                self.frames[key] = nil
            }
        }
    }
    
    /// - UserDefinedWebpage frame getter-setter. ID3 Identifier `WXX`/`WXXX`
    subscript(userDefinedUrl userDefinedUrlDescription: String) -> String? {
        get {
            if let frame = self.frames[.userDefinedWebpage(description: userDefinedUrlDescription)],
                case .userTextFrame(let userTextFrame) = frame {
                return userTextFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let key = FrameKey.userDefinedWebpage(description: userDefinedUrlDescription)
            if let new = newValue {
                self.frames[key] = Frame.userTextFrame(.init(description: userDefinedUrlDescription, content: new))
            } else {
                self.frames[key] = nil
            }
        }
    }

    /// - OnlineExtras getter-setter. This is a convenience for a custom `WXX`/`WXXX` frame with a description of `Online Extras`. Mainly present to create an MP3 counterpart to the MP4 online extras atom
    var onlineExtras: String? {
        get {
            if let frame = self.frames[.userDefinedWebpage(description: "Online Extras")],
                case .userTextFrame(let userTextFrame) = frame {
                return userTextFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let frame = UserTextFrame(description: "Online Extras", content: newValue ?? "")
            frames[.userDefinedWebpage(description: "Online Extras")] = .userTextFrame(frame)
        }
    }

    /// - Acknowledgment getter-setter. This is a convenience for a custom `TXX`/`TXXX` frame with a description of `Acknowledgment`
    var acknowledgment: String? {
        get {
            if let frame = self.frames[.userDefinedText(description: "Acknowledgment")],
                case .userTextFrame(let userTextFrame) = frame {
                return userTextFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let frame = UserTextFrame(description: "Acknowledgment", content: newValue ?? "")
            frames[.userDefinedText(description: "Acknowledgment")] = .userTextFrame(frame)
        }
    }
    
    /// - Thanks getter-setter. This is a convenience for a custom `TXX`/`TXXX` frame with a description of `Thanks`
    var thanks: String? {
        get {
            if let frame = self.frames[.userDefinedText(description: "Thanks")],
                case .userTextFrame(let userTextFrame) = frame {
                return userTextFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let frame = UserTextFrame(description: "Thanks", content: newValue ?? "")
            frames[.userDefinedText(description: "Thanks")] = .userTextFrame(frame)
        }
    }
    
    /// - SourceCredit getter-setter. This is a convenience for a custom `TXX`/`TXXX` frame with a description of `Source Credit`
    var sourceCredit: String? {
        get {
            if let frame = self.frames[.userDefinedText(description: "Source Credit")],
                case .userTextFrame(let userTextFrame) = frame {
                return userTextFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let frame = UserTextFrame(description: "Source Credit", content: newValue ?? "")
            frames[.userDefinedText(description: "Source Credit")] = .userTextFrame(frame)
        }
    }

    /// - SeriesName getter-setter. This is a convenience for a custom `TXX`/`TXXX` frame with a description of `Series NAme`
    var seriesName: String? {
        get {
            if let frame = self.frames[.userDefinedText(description: "Series Name")],
                case .userTextFrame(let userTextFrame) = frame {
                return userTextFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let frame = UserTextFrame(description: "Series Name", content: newValue ?? "")
            frames[.userDefinedText(description: "Series Name")] = .userTextFrame(frame)
        }
    }

    /// - Episode Name getter-setter. This is a convenience for a custom `TXX`/`TXXX` frame with a description of `Episode Name`
    var episodeName: String? {
        get {
            if let frame = self.frames[.userDefinedText(description: "Episode Name")],
                case .userTextFrame(let userTextFrame) = frame {
                return userTextFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let frame = UserTextFrame(description: "Episode Name", content: newValue ?? "")
            frames[.userDefinedText(description: "Episode Name")] = .userTextFrame(frame)
        }
    }

    /// - Network getter-setter. This is a convenience for a custom `TXX`/`TXXX` frame with a description of `Network`
    var network: String? {
        get {
            if let frame = self.frames[.userDefinedText(description: "Network")],
                case .userTextFrame(let userTextFrame) = frame {
                return userTextFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let frame = UserTextFrame(description: "Network", content: newValue ?? "")
            frames[.userDefinedText(description: "Network")] = .userTextFrame(frame)
        }
    }

    /// - EpisodeNumber getter-setter. This is a convenience for a custom `TXX`/`TXXX` frame with a description of `Episode Number`
    var episodeNumber: Int? {
        get {
            if let frame = self.frames[.userDefinedText(description: "Episode Number")],
                case .userTextFrame(let userTextFrame) = frame {
                return Int(userTextFrame.contentString)
            } else {
                return nil
            }
        }
        set {
            let frame = UserTextFrame(description: "Episode Number", content: String(newValue ?? 0))
            frames[.userDefinedText(description: "Episode Number")] = .userTextFrame(frame)
        }
    }

    /// - Season (number) getter-setter. This is a convenience for a custom `TXX`/`TXXX` frame with a description of `Episode Number`
    var season: Int? {
        get {
            if let frame = self.frames[.userDefinedText(description: "Season")],
                case .userTextFrame(let userTextFrame) = frame {
                return Int(userTextFrame.contentString)
            } else {
                return nil
            }
        }
        set {
            let frame = UserTextFrame(description: "Season", content: String(newValue ?? 0))
            frames[.userDefinedText(description: "Season")] = .userTextFrame(frame)
        }
    }

    /// - Keywords getter-setter. This is a convenience for a custom `TXX`/`TXXX` frame with a description of `Keywords`. Contents are separated by a semicolon when converting from a string.
    var keywords: [String]? {
        get {
            if let frame = self.frames[.userDefinedText(description: "Keywords")],
                case .userTextFrame(let userTextFrame) = frame {
                return userTextFrame.contentString.components(separatedBy: ";")
            } else {
                return nil
            }
        }
        set {
            let frame = UserTextFrame(description: "Keywords", content: newValue?.joined(separator: ";") ?? "")
            frames[.userDefinedText(description: "Keywords")] = .userTextFrame(frame)
        }
    }

    /// - Content Rating getter-setter. This is a convenience for a custom `TXX`/`TXXX` frame with a description of `Content Rating`
    var contentRating: String? {
        get {
            if let frame = self.frames[.userDefinedText(description: "Content Rating")],
                case .userTextFrame(let userTextFrame) = frame {
                return userTextFrame.contentString
            } else {
                return nil
            }
        }
    }
    
    mutating func setContentRating(contentRating: ContentRatings) throws {
        let key = FrameKey.userDefinedText(description: "Content Rating")
        self.frames[key] = Frame.userTextFrame(.init(contentRating: contentRating))
    }

    /// - Content Advisory getter-setter. This is a convenience for a custom `TXX`/`TXXX` frame with a description of `Content Advisory`
    var contentAdvisory: String? {
        get {
            if let frame = self.frames[.userDefinedText(description: "Content Advisory")],
                case .userTextFrame(let userTextFrame) = frame {
                return userTextFrame.contentString
            } else {
                return nil
            }
        }
    }
    
    mutating func setContentAdvisory(contentAdvisory: ContentAdvisory) throws {
        let key = FrameKey.userDefinedText(description: "Content Advisory")
        self.frames[key] = Frame.userTextFrame(.init(contentAdvisory: contentAdvisory))
    }

}
