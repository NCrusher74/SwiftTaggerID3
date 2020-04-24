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
    
    var value: Int
    
    /**
     A frame with only an integer string as content, presented as an integer
     
     Usually the tag stores these values as an integer string.
     
     - parameter value: the content of the frame.
     */
    private init(layout: FrameLayoutIdentifier, value: Int) {
        self.value = value
        self.flags = IntegerFrame.defaultFlags
        self.layout = layout
        switch layout {
            case .known(KnownFrameLayoutIdentifier.bpm): self.frameKey = .bpm
            case .known(KnownFrameLayoutIdentifier.isrc): self.frameKey = .isrc
            case .known(KnownFrameLayoutIdentifier.length): self.frameKey = .length
            case .known(KnownFrameLayoutIdentifier.movementCount): self.frameKey = .movementCount
            case .known(KnownFrameLayoutIdentifier.movementNumber): self.frameKey = .movementNumber
            case .known(KnownFrameLayoutIdentifier.playlistDelay): self.frameKey = .playlistDelay
            default: self.frameKey = .userDefinedText(description: "")
        }
    }
    
    func encodeContents(version: Version) throws -> Data {
        return String(self.value).encoded(withNullTermination: false)
    }
    
    // MARK: Decode
    // decode incoming data and parse it into a frame
    var flags: Data
    var layout: FrameLayoutIdentifier
    var frameKey: FrameKey
    
    init(decodingContents contents: Data.SubSequence,
                  version: Version,
                  layout: FrameLayoutIdentifier,
                  flags: Data
    ) throws {
        self.flags = flags
        self.layout = layout
        switch layout {
            case .known(KnownFrameLayoutIdentifier.bpm): self.frameKey = .bpm
            case .known(KnownFrameLayoutIdentifier.isrc): self.frameKey = .isrc
            case .known(KnownFrameLayoutIdentifier.length): self.frameKey = .length
            case .known(KnownFrameLayoutIdentifier.movementCount): self.frameKey = .movementCount
            case .known(KnownFrameLayoutIdentifier.movementNumber): self.frameKey = .movementNumber
            case .known(KnownFrameLayoutIdentifier.playlistDelay): self.frameKey = .playlistDelay
            default: self.frameKey = .userDefinedText(description: "")
        }
        var parsing = contents
        let encoding = try IntegerFrame.extractEncoding(data: &parsing, version: version)
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
