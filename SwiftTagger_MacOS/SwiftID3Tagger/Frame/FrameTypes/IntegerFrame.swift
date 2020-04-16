//
//  IntegerFrame.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/12/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

/**
 A type representing an ID3 frame that holds a single integer value
 */
public struct IntegerFrame: FrameProtocol {
    
    public let value: Int
    
    /**
     A frame with only an integer string as content, presented as an integer
     - parameter value: the content of the frame.
     */
    public init(value: Int) {
        self.value = value
    }
    //    func encodeContents(version: Version) throws -> Data {
    //
    //    }
    
    // MARK: Decode
    // decode incoming data and parse it into a frame
    internal var flags: Data
    internal var layout: FrameLayoutIdentifier
    
    internal init(decodingContents contents: Data.SubSequence,
                  version: Version,
                  layout: FrameLayoutIdentifier,
                  flags: Data) throws {
        self.flags = flags
        self.layout = layout
        var parsing = contents
        let encoding = IntegerFrame.extractEncoding(data: &parsing, version: version)
        self.value = Int(IntegerFrame.extractTerminatedString(
            data: &parsing, encoding: encoding)) ?? 0
    }
    
}
