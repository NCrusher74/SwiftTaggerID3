//
//  IntegerFrame.swift
//  SwiftTaggerID3
//
//  Created by Nolaine Crusher on 4/12/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

/**
 A type representing an ID3 frame that holds a single integer value, stored as an integer string
 */
struct IntegerFrame: FrameProtocol {
    
    var value: Int
    
    /**
     A frame with only an integer string as content, presented as an integer
     - parameter value: the content of the frame.
     */
    init(layout: FrameLayoutIdentifier, value: Int) {
        self.value = value
        self.flags = IntegerFrame.defaultFlags
        self.layout = layout
        switch layout { case .known(.bpm): self.frameKey = .bpm
            case .known(.isrc): self.frameKey = .isrc
            case .known(.length): self.frameKey = .length
            case .known(.movementCount): self.frameKey = .movementCount
            case .known(.movementNumber): self.frameKey = .movementNumber
            case .known(.playlistDelay): self.frameKey = .playlistDelay
            default: self.frameKey = .userDefinedText(description: "") }
    }
    
    // encode the contents of the frame to add to an ID3 tag
    func encodeContents(version: Version) throws -> Data {
        var frameData = Data()
        // append encooding byte
        frameData.append(StringEncoding.preferred.rawValue.encoding(
            endianness: .bigEndian))
        // encode and append integer string
        frameData.append(String(self.value).encoded(
            withNullTermination: false))
        return frameData
    }
    
    // MARK: Decode
    /// The frame flags property.
    ///
    /// Typically this is two bytes `[0x00, 0x00]`
    /// SwiftTagger does not support altering these flags.
    var flags: Data
    /// The layout property describes the unique structure of a given frame
    var layout: FrameLayoutIdentifier
    /** The frameKey property
     
     Provides a unique identifier to permits duplication of frame types that the ID3 spec allows to be duplicated within a tag. */
    var frameKey: FrameKey
    /** A boolean value indicating whether or not frames of a particular type are permitted to be duplicated in a valid ID3 tag */
    var allowMultipleFrames: Bool = false

    // MARK: Frame parsing
    /// Initialize a frame parsing operation
    /// - Parameters:
    ///   - contents: the slice of data containing the frame
    ///   - version: the ID3 version of the tag
    ///   - layout: the frame's FrameLayoutIdentifier
    ///   - flags: (current unsupported by SwiftTagger) [0x00, 0x00]
    init(decodingContents contents: Data.SubSequence,
                  version: Version,
                  layout: FrameLayoutIdentifier,
                  flags: Data
    ) throws {
        self.flags = flags
        self.layout = layout
        switch layout { case .known(.bpm): self.frameKey = .bpm
            case .known(.isrc): self.frameKey = .isrc
            case .known(.length): self.frameKey = .length
            case .known(.movementCount): self.frameKey = .movementCount
            case .known(.movementNumber): self.frameKey = .movementNumber
            case .known(.playlistDelay): self.frameKey = .playlistDelay
            default: self.frameKey = .userDefinedText(description: "") }
        var parsing = contents
        let encoding = try IntegerFrame.extractEncoding(data: &parsing, version: version)
        self.value = Int(
            parsing.extractPrefixAsStringUntilNullTermination(encoding) ?? "") ?? 0
    }
}

// MARK: Internal TAG Extension
/* get and set functions for `IntegerFrame` frame types. Each individual frame of this type will have its own get-set property that will call these functions using its `FrameKey` property and relevant data */
internal extension Tag {

    func integer(for frameKey: FrameKey) -> Int? {
        //check that the frame is an IntegerFrame
        if let frame = self.frames[frameKey],
            case .integerFrame(let integerFrame) = frame { // get the integer from the frame data
            return integerFrame.value } else { return nil }
    }
    
    mutating func set(_ layout: FrameLayoutIdentifier,
                      _ frameKey: FrameKey,
                      to value: Int) {
        let frame = IntegerFrame(
            layout: layout,
            value: value)
        self.frames[frameKey] = .integerFrame(frame)
    }
}

// MARK: Public Tag Extension
public extension Tag {
    /// - BeatsPerMinute getter-setter. ID3 Identifier: `TBP`/`TBPM`
    var bpm: Int {
        get { integer(for: .bpm) ?? 0 }
        set { set(.known(.bpm), .bpm, to: newValue) }
    }
    
    /// - IRSC getter-setter. ID3 Identifier: `TRC`/`TSRC`
    var isrc: Int {
        get { integer(for: .isrc) ?? 0 }
        set { set(.known(.isrc), .isrc, to: newValue) }
    }
    
    /// - Length getter-setter. ID3 Identifier: `TLE`/`TLEN`
    var length: Int {
        get { integer(for: .length) ?? 0 }
        set { set(.known(.length), .length, to: newValue) }
    }
    
    /// - TotalMovements getter-setter. This is a non-standard, iTunes compliant frame
    /// ID3 Identifier: `MVCN`. Valid only for tag versions 2.3/2.4
    var totalMovements: Int {
        get { integer(for: .movementCount) ?? 0 }
        set { set(.known(.movementCount), .movementCount, to: newValue) }
    }
    
    /// - MovementNumber getter-setter. This is a non-standard, iTunes compliant frame
    /// ID3 Identifier: `MVIN`. Valid only for tag versions 2.3/2.4
    var movementNumber: Int {
        get { integer(for: .movementNumber) ?? 0 }
        set { set(.known(.movementNumber), .movementNumber, to: newValue) }
    }
    
    /// - PlaylistDelay getter-setter. ID3 Identifier: `TDY`/`TDLY`
    var playlistDelay: Int {
        get { integer(for: .playlistDelay) ?? 0 }
        set { set(.known(.playlistDelay), .playlistDelay, to: newValue) }
    }
}
