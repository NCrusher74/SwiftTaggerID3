//
//  StringFrame.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/11/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

/**
 A type representing an ID3 frame that holds a single string, such as Artist, Title, Album, etc
 */
public struct StringFrame: FrameProtocol {
    
    public var contentString: String
    
    /**
     A frame with only string content, presented as a single string without`(/n)` newline characters.
     - parameter contentString: the content of the frame.
     */
    public init(contentString: String) {
        self.contentString = contentString
    }
    
    //    func encodeContents(version: Version) throws -> Data {
    //
    //    }
    
    // MARK: Decode
    // decode incoming data and parse it into a frame
    internal var flags: Data
    internal var layout: KnownFrameLayoutIdentifier
    
    internal init(decodingContents contents: Data.SubSequence,
                  version: Version,
                  layout: KnownFrameLayoutIdentifier,
                  flags: Data) throws {
        var parsing = contents
        let encoding = StringFrame.extractEncoding(data: &parsing, version: version)
        self.contentString = StringFrame.extractTerminatedString(
            data: &parsing, encoding: encoding)
    }
    
}
