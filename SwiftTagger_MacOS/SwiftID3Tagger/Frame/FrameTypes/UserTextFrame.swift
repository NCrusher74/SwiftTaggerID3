//
//  UserTextFrame.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/12/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

struct UserTextFrame: FrameProtocol {
    
    /// A short description of the frame content.
    public var descriptionString: String?
    /// the content of the frame
    public var contentString: String
    
    /**
     - parameter contentDescription: a terminated text string describing the frame content
     - parameter contentText: the full text of the comment or lyric frame.
     */
    public init(descriptionString: String?, contentString: String) {
        self.descriptionString = descriptionString
        self.contentString = contentString
    }
    
    var flags: Data
    var layout: KnownFrameLayoutIdentifier

//    func encodeContents(version: Version) throws -> Data {
//        
//    }

    init(decodingContents contents: Data.SubSequence,
         version: Version,
         layout: KnownFrameLayoutIdentifier,
         flags: Data) throws {
        var parsing = contents
        let encoding = UserTextFrame.extractEncoding(data: &parsing, version: version)
        let parsed = try UserTextFrame.extractDescriptionAndContent(from: &parsing, encoding: encoding)
        self.descriptionString = parsed.description
        self.contentString = parsed.content
    }
    
    
}
