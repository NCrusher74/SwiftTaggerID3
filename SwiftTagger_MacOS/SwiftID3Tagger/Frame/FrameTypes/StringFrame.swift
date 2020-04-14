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
        // "Return from initializer without initializing all stored properties"
        // But we don't want self.flags, self.size, and self.identifier in this initializer
    }
 
    func encodeContents(version: Version) throws -> Data {
        
    }
        
    #warning("this is the 'read' part")
    var flags: Data
    var size: Int
    var identifier: FrameLayoutIdentifier
        
    internal init(decodingContents contents: Data.SubSequence,
                  version: Version,
                  frameIdentifier: FrameLayoutIdentifier,
                  flags: Data) throws {
        var parsing = contents
        let encoding = extractEncoding(data: &parsing, version: version)
        // 'self' used before all stored properties are initialized
        _ = extractTerminatedString(
            data: &parsing, version: version, encoding: encoding)
        // 'self' used before all stored properties are initialized
    }
    
}
