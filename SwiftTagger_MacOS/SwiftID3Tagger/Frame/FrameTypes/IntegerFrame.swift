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
    
    private let value: Int
    
    /**
     A frame with only an integer string as content, presented as an integer
     
     Usually the tag stores these values as an integer string.
     
     - parameter value: the content of the frame.
     */
    private init(layout: FrameLayoutIdentifier, value: Int) {
        self.value = value
        self.flags = IntegerFrame.defaultFlags()
        self.layout = layout
    }
    
    internal func encodeContents(version: Version) throws -> Data {
        return String(self.value).encoded(withNullTermination: false)
    }
    
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
        self.value = Int(parsing.extractPrefixAsStringUntilNullTermination(encoding) ?? "") ?? 0
    }
    
    // MARK: Public initializers
    public init(bpm: Int) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.bpm), value: bpm)
    }

    public init(isrc: Int) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.isrc), value: isrc)
    }
    
    public init(length: Int) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.length), value: length)
    }
    
    public init(movementNumber: Int) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.movementNumber), value: movementNumber)
    }
    
    public init(totalMovements: Int) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.movementCount), value: totalMovements)
    }
    
    public init(playlistDelay: Int) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.playlistDelay), value: playlistDelay)
    }
}
