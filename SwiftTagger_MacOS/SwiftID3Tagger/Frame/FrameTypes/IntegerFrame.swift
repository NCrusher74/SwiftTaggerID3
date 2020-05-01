//
//  IntegerFrame.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/12/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

/**
 A type representing an ID3 frame that holds a single integer value, stored as an integer string
 */
public struct IntegerFrame: FrameProtocol {
    
    var value: Int
    
    /**
     A frame with only an integer string as content, presented as an integer
     - parameter value: the content of the frame.
     */
    private init(layout: FrameLayoutIdentifier, value: Int) {
        self.value = value
        self.flags = IntegerFrame.defaultFlags
        self.layout = layout
        switch layout {
            case .known(.bpm): self.frameKey = .bpm
            case .known(.isrc): self.frameKey = .isrc
            case .known(.length): self.frameKey = .length
            case .known(.movementCount): self.frameKey = .movementCount
            case .known(.movementNumber): self.frameKey = .movementNumber
            case .known(.playlistDelay): self.frameKey = .playlistDelay
            default: self.frameKey = .userDefinedText(description: "")
        }
    }
    
    // encode the contents of the frame to add to an ID3 tag
    func encodeContents(version: Version) throws -> Data {
        let encodingByte = StringEncoding.preferred.rawValue.encoding(endianness: .bigEndian)
        return encodingByte + String(self.value).encoded(withNullTermination: false)
    }
    
    // MARK: Decode
    // decode incoming data and parse it into a frame
    var flags: Data
    var layout: FrameLayoutIdentifier
    var frameKey: FrameKey
    var allowMultipleFrames: Bool = false
    
    init(decodingContents contents: Data.SubSequence,
                  version: Version,
                  layout: FrameLayoutIdentifier,
                  flags: Data
    ) throws {
        self.flags = flags
        self.layout = layout
        switch layout {
            case .known(.bpm): self.frameKey = .bpm
            case .known(.isrc): self.frameKey = .isrc
            case .known(.length): self.frameKey = .length
            case .known(.movementCount): self.frameKey = .movementCount
            case .known(.movementNumber): self.frameKey = .movementNumber
            case .known(.playlistDelay): self.frameKey = .playlistDelay
            default: self.frameKey = .userDefinedText(description: "")
        }
        var parsing = contents
        let encoding = try IntegerFrame.extractEncoding(data: &parsing, version: version)
        self.value = Int(
            parsing.extractPrefixAsStringUntilNullTermination(encoding) ?? "") ?? 0
    }
        
    // MARK: Public initializers
    public init(bpm: Int) {
        self.init(layout: .known(.bpm), value: bpm)
    }

    public init(isrc: Int) {
        self.init(layout: .known(.isrc), value: isrc)
    }
    
    public init(length: Int) {
        self.init(layout: .known(.length), value: length)
    }
    
    public init(movementNumber: Int) {
        self.init(layout: .known(.movementNumber), value: movementNumber)
    }
    
    public init(totalMovements: Int) {
        self.init(layout: .known(.movementCount), value: totalMovements)
    }
    
    public init(playlistDelay: Int) {
        self.init(layout: .known(.playlistDelay), value: playlistDelay)
    }
}
