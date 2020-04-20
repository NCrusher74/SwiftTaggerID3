//
//  UserTextFrame.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/12/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

struct UserTextFrame: FrameProtocol {
   
    // public initializers
    public init(description: String, content: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.userDefinedText),
                  descriptionString: description,
                  contentString: content)
    }

    public init(acknowledgmentsContent: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.userDefinedText),
                  descriptionString: "Acknowledgments",
                  contentString: acknowledgmentsContent)
    }

    public init(thanksContent: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.userDefinedText),
                  descriptionString: "Thanks",
                  contentString: thanksContent)
    }

    public init(sourceCreditContent: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.userDefinedText),
                  descriptionString: "Source Credit",
                  contentString: sourceCreditContent)
    }

    public init(description: String, webpage: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.userDefinedWebpage),
                  descriptionString: description,
                  contentString: webpage)
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
        self.flags = UserTextFrame.defaultFlags()
        self.layout = layout
    }
    
    internal var flags: Data
    internal var layout: FrameLayoutIdentifier

    internal func encodeContents(version: Version) throws -> Data {
        let encodedDescriptionString = self.descriptionString.encoded(withNullTermination: true)
        let encodedContentsString = self.contentString.encoded(withNullTermination: false)
        return encodedDescriptionString + encodedContentsString

    }

    internal init(decodingContents contents: Data.SubSequence,
         version: Version,
         layout: FrameLayoutIdentifier,
         flags: Data) throws {
        var parsing = contents
        let encoding = UserTextFrame.extractEncoding(data: &parsing, version: version)
        self.flags = flags
        self.layout = layout
        let parsed = try UserTextFrame.extractDescriptionAndContent(from: &parsing, encoding: encoding)
        self.descriptionString = parsed.description ?? ""
        self.contentString = parsed.content
    }
    
    
}
