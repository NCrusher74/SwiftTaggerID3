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
public struct URLFrame: FrameProtocol {
    
    public var urlString: String
    
    /**
     A frame with only string content, presented as a single string without `(/n)`.
     - parameter contentString: the content of the frame.
     */
    public init(urlString: String) {
        self.urlString = urlString
        // "Return from initializer without initializing all stored properties"
        // But we don't want self.flags, self.size, and self.identifier in this initializer
    }
    
    // MARK: Decode
    // decode incoming data and parse it into a frame
    internal var flags: Data
    internal var layout: KnownFrameLayoutIdentifier
    
    internal init(decodingContents contents: Data.SubSequence,
                  version: Version,
                  layout: KnownFrameLayoutIdentifier,
                  flags: Data) throws {
        self.urlString = contents.stringASCII ?? ""
    }
}
