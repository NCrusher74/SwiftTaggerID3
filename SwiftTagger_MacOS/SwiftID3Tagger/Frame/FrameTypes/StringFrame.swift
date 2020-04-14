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
internal struct StringFrame: FrameProtocol {
    
    #warning("this is the 'write' part")
    var contentString: String
    
    /**
     A frame with only string content, presented as a single string without `(/n)`.     
     - parameter contentString: the content of the frame.
     */
    init(contentString: String) {
        self.contentString = contentString
    }
 
    
    
    
    #warning("this is the 'read' part")
    var flags: Data
    var size: Int
    var identifier: FrameLayoutIdentifier
    
    //    func encodeContents(version: Version) throws -> Data {
    //
    //    }
    
    internal init(decodingContents contents: Data.SubSequence,
                  version: Version,
                  frameIdentifier: FrameLayoutIdentifier,
                  flags: Data) throws {
        extractStringContent(content: contents, version: version)
    }
    
    private func extractStringContent(
        content: Data.SubSequence, version: Version) {
        var parsing = content[...]
        let encoding = extractEncoding(
            data: &parsing, version: version)
        _ = extractTerminatedString(
            data: &parsing, version: version, encoding: encoding)
    }
}
