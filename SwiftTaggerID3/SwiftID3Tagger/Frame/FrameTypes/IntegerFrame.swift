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
    
    // MARK: Properties
    // inherited from FrameProtocol
    var flags: Data
    var layout: FrameLayoutIdentifier
    var frameKey: FrameKey
    var allowMultipleFrames: Bool = false
    
    // frame's unique property
    var value: Int
    
    // MARK: Frame parsing
    init(decodingContents contents: Data.SubSequence,
         version: Version,
         layout: FrameLayoutIdentifier,
         flags: Data
    ) throws {
        self.flags = flags
        self.layout = layout
        switch layout {
            case .known(.bpm):
                self.frameKey = .bpm
            case .known(.isrc):
                self.frameKey = .isrc
            case .known(.length):
                self.frameKey = .length
            case .known(.movementCount):
                self.frameKey = .movementCount
            case .known(.movementNumber):
                self.frameKey = .movementNumber
            case .known(.playlistDelay):
                self.frameKey = .playlistDelay
            case .known(.compilation):
                self.frameKey = .compilation
            default: self.frameKey = .userDefinedText(
                description: "\(layout.id3Identifier(version: version) ?? "")")
        }
        var parsing = contents
        // extract and interpret the encoding byte
        let encoding = try IntegerFrame.extractEncoding(data: &parsing, version: version)
        // hand the frame content as a boolean value of 1 or 0
        if self.frameKey == .compilation {
            let contentString = parsing.extractPrefixAsStringUntilNullTermination(encoding) ?? ""
            // initialize the frame's value property by converting the string content to an integer
            self.value = IntegerFrame.getBooleanIntFromString(boolString: contentString)
        } else {
            self.value = Int(
                parsing.extractPrefixAsStringUntilNullTermination(encoding) ?? "") ?? 0
        }
    }
    
    /// Interpret the most common "quasi-boolean" strings as boolean values
    /// - Parameter boolString: The string parsed from the frame's contents
    /// - Returns: 1 or 0, if a value can be determined
    private static func getBooleanIntFromString(boolString: String) -> Int {
        switch boolString.lowercased() {
            case "true", "t", "yes", "y", "1":
                return 1
            case "false", "f", "no", "n", "0":
                return 0
            default:
                return 0
        }
    }
    
    /**
     Initialize a frame-building instance for a frame with only an integer string as content, presented as an integer
     - parameter value: the content of the frame.
     - parameter layout: the frame layout identifier, used to determine the `frameKey`
     */
    init(layout: FrameLayoutIdentifier, value: Int) {
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
            case .known(.compilation): self.frameKey = .compilation
            default: self.frameKey = .userDefinedText(description: "")
        }
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
    
}

// MARK: Internal TagG Extension
/* get and set functions for `IntegerFrame` frame types. Each individual frame of this type will have its own get-set property that will call these functions using its `FrameKey` property and relevant data */
extension Tag {
    
    /// get the integer value from the frame
    /// - Parameter frameKey: the frame's unique identifier
    /// - Returns: an integer representation of the integer string within the frame
    internal func integer(for frameKey: FrameKey) -> Int? {
        //check that the frame is an IntegerFrame
        if let frame = self.frames[frameKey],
            case .integerFrame(let integerFrame) = frame {
            // get the integer from the frame data
            return integerFrame.value } else { return nil }
    }
    
    /// Add a frame to the `Tag` instance
    /// - Parameters:
    ///   - layout: the frame's layout identifier
    ///   - frameKey: the frame's unique identifier
    ///   - value: the integer value of the frame
    internal mutating func set(_ layout: FrameLayoutIdentifier,
                               _ frameKey: FrameKey,
                               to value: Int) {
        // call the frame-building initializer
        let frame = IntegerFrame(
            layout: layout,
            value: value)
        self.frames[frameKey] = .integerFrame(frame)
    }
    
    /// BeatsPerMinute getter-setter. ID3 Identifier: `TBP`/`TBPM`
    public var bpm: Int {
        get { integer(for: .bpm) ?? 0 }
        set { set(.known(.bpm), .bpm, to: newValue) }
    }
    
    /// IRSC getter-setter. ID3 Identifier: `TRC`/`TSRC`
    public var isrc: Int {
        get { integer(for: .isrc) ?? 0 }
        set { set(.known(.isrc), .isrc, to: newValue) }
    }
    
    /// Length getter-setter. ID3 Identifier: `TLE`/`TLEN`
    public var length: Int {
        get { integer(for: .length) ?? 0 }
        set { set(.known(.length), .length, to: newValue) }
    }
    
    /// TotalMovements getter-setter. This is a non-standard, iTunes non-standard frame
    /// ID3 Identifier: `MVCN`. Valid only for tag versions 2.3/2.4
    public var totalMovements: Int {
        get { integer(for: .movementCount) ?? 0 }
        set { set(.known(.movementCount), .movementCount, to: newValue) }
    }
    
    /// MovementNumber getter-setter. This is a non-standard, iTunes non-standard frame
    /// ID3 Identifier: `MVIN`. Valid only for tag versions 2.3/2.4
    public var movementNumber: Int {
        get { integer(for: .movementNumber) ?? 0 }
        set { set(.known(.movementNumber), .movementNumber, to: newValue) }
    }
    
    /// PlaylistDelay getter-setter. ID3 Identifier: `TDY`/`TDLY`
    public var playlistDelay: Int {
        get { integer(for: .playlistDelay) ?? 0 }
        set { set(.known(.playlistDelay), .playlistDelay, to: newValue) }
    }
    
    /// Compilation (flag) getter-setter. ID3 identifier: `TCP`/`TCMP`. iTunes non-standard frame
    public var compilation: Bool {
        get {
            let intValue = integer(for: .compilation) ?? 0
            if intValue == 1 {
                return true
            } else {
                return false
            }
        }
        set {
            if newValue == true {
                set(.known(.compilation), .compilation, to: 1)
            } else {
                set(.known(.compilation), .compilation, to: 0)
            }
        }
    }
}
