//
//  URLFrame.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/14/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation
/**
 A type representing an ID3 frame that holds a single string, such as Artist, Title, Album, etc
 */
internal struct URLFrame: FrameProtocol {
    
    var urlString: String
    
    /**
     A frame with only string content, presented as a single string without `(/n)`.
     - parameter contentString: the content of the frame.
     */
    init(urlString: String) {
        self.urlString = urlString
        // "Return from initializer without initializing all stored properties"
        // But we don't want self.flags, self.size, and self.identifier in this initializer
    }
    
    var flags: Data
    var identifier: FrameLayoutIdentifier

    //    func encodeContents(version: Version) throws -> Data {
    //
    //    }    

    internal init(decodingContents contents: Data.SubSequence,
                  version: Version,
                  frameIdentifier: FrameLayoutIdentifier,
                  flags: Data) throws {
        var parsing = contents
        let encoding = URLFrame.extractEncoding(data: &parsing, version: version)
        // 'self' used before all stored properties are initialized
        _ = extractTerminatedString(
            data: &parsing, version: version, encoding: encoding)
        // 'self' used before all stored properties are initialized
    }
    
}
