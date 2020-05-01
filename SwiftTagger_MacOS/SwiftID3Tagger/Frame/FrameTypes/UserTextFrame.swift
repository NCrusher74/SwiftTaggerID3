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
   
    init(description: String, content: String) {
        self.init(layout: .known(.userDefinedText),
                  descriptionString: description,
                  contentString: content)
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

    init(description: String, webpage: String) {
        self.init(layout: .known(.userDefinedWebpage),
                  descriptionString: description,
                  contentString: webpage)
    }

    init(contentRatings: ContentRatings) {
        self.init(layout: .known(.userDefinedText),
                  descriptionString: "Content Rating",
                  contentString: contentRatings.ratings)
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
        let encodingByte = StringEncoding.preferred.rawValue.encoding(endianness: .bigEndian)
        let encodedDescriptionString = self.descriptionString.encoded(withNullTermination: true)
        let encodedContentsString = self.contentString.encoded(withNullTermination: false)
        return encodingByte + encodedDescriptionString + encodedContentsString

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
}
