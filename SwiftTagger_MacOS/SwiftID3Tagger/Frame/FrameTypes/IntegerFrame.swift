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
struct IntegerFrame: FrameProtocol {
    
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
        
    // MARK: Initializers
    init(bpm: Int) {
        self.init(layout: .known(.bpm), value: bpm)
    }

    init(isrc: Int) {
        self.init(layout: .known(.isrc), value: isrc)
    }
    
    init(length: Int) {
        self.init(layout: .known(.length), value: length)
    }
    
    init(movementNumber: Int) {
        self.init(layout: .known(.movementNumber), value: movementNumber)
    }
    
    init(totalMovements: Int) {
        self.init(layout: .known(.movementCount), value: totalMovements)
    }
    
    init(playlistDelay: Int) {
        self.init(layout: .known(.playlistDelay), value: playlistDelay)
    }
}

// MARK: Tag Extension

public extension Tag {
    /// - BeatsPerMinute getter-setter. ID3 Identifier: `TBP`/`TBPM`
    var bpm: Int? {
        get {
            if let frame = self.frames[.bpm],
                case .integerFrame(let integerFrame) = frame {
                return integerFrame.value
            } else {
                return nil
            }
        }
        set {
            let frame = IntegerFrame(bpm: newValue ?? 0)
            frames[.bpm] = .integerFrame(frame)
        }
    }
    
    /// - IRSC getter-setter. ID3 Identifier: `TRC`/`TSRC`
    var isrc: Int? {
        get {
            if let frame = self.frames[.isrc],
                case .integerFrame(let integerFrame) = frame {
                return integerFrame.value
            } else {
                return nil
            }
        }
        set {
            let frame = IntegerFrame(isrc: newValue ?? 0)
            frames[.isrc] = .integerFrame(frame)
        }
    }
    
    /// - Length getter-setter. ID3 Identifier: `TLE`/`TLEN`
    var length: Int? {
        get {
            if let frame = self.frames[.length],
                case .integerFrame(let integerFrame) = frame {
                return integerFrame.value
            } else {
                return nil
            }
        }
        set {
            let frame = IntegerFrame(length: newValue ?? 0)
            frames[.length] = .integerFrame(frame)
        }
    }
    
    /// - TotalMovements getter-setter. This is a non-standard, iTunes compliant frame
    /// ID3 Identifier: `MVCN`. Valid only for tag versions 2.3/2.4
    var totalMovements: Int? {
        get {
            if let frame = self.frames[.movementCount],
                case .integerFrame(let integerFrame) = frame {
                return integerFrame.value
            } else {
                return nil
            }
        }
        set {
            let frame = IntegerFrame(totalMovements: newValue ?? 0)
            frames[.movementCount] = .integerFrame(frame)
        }
    }
    
    /// - MovementNumber getter-setter. This is a non-standard, iTunes compliant frame
    /// ID3 Identifier: `MVIN`. Valid only for tag versions 2.3/2.4
    var movementNumber: Int? {
        get {
            if let frame = self.frames[.movementNumber],
                case .integerFrame(let integerFrame) = frame {
                return integerFrame.value
            } else {
                return nil
            }
        }
        set {
            let frame = IntegerFrame(movementNumber: newValue ?? 0)
            frames[.movementNumber] = .integerFrame(frame)
        }
    }
    
    /// - PlaylistDelay getter-setter. ID3 Identifier: `TDY`/`TDLY`
    var playlistDelay: Int? {
        get {
            if let frame = self.frames[.playlistDelay],
                case .integerFrame(let integerFrame) = frame {
                return integerFrame.value
            } else {
                return nil
            }
        }
        set {
            let frame = IntegerFrame(playlistDelay: newValue ?? 0)
            frames[.playlistDelay] = .integerFrame(frame)
        }
    }
}
