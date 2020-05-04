//
//  BooleanFrame.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/12/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

/**
 A type representing an ID3 frame that holds a single integer stored as an integer string, 1 for true and 0 for false.
 */
struct BooleanFrame: FrameProtocol {
    
    init(value: Bool) {
        self.init(layout: .known(.compilation), value: value)
    }
    
    var value: Bool
    
    /**
     A frame with a single-integer string, 1 or 0, presented as a boolean.
     - parameter value: the content of the frame.
     
     This frame is stored in the tag as an integer string. For the sake of user-friendliness, this is converted to a boolean value as long as the stored value is recognizable as a boolean-like word.
     */
    private init(layout: FrameLayoutIdentifier, value: Bool) {
        self.value = value
        self.flags = BooleanFrame.defaultFlags
        self.layout = layout
        self.frameKey = .compilation
    }
    
    // encode the contents of the frame for writing
    func encodeContents(version: Version) throws -> Data {
        var frameData = Data()
        // append encoding byte
        frameData.append(StringEncoding.preferred.rawValue.encoding(endianness: .bigEndian))

        // convert boolean to 1 or 0, encoded and append
        let contents = self.value
        if contents == true {
            frameData.append("1".encoded(withNullTermination: false))
        } else {
            frameData.append("0".encoded(withNullTermination: false))
        }
        return frameData
    }
    
    var flags: Data
    var layout: FrameLayoutIdentifier
    var frameKey: FrameKey
    var allowMultipleFrames: Bool = false
    
    // decode the contents of a frame from an ID3 tag
    init(decodingContents contents: Data.SubSequence,
         version: Version,
         layout: FrameLayoutIdentifier,
         flags: Data
    ) throws {
        self.flags = flags
        self.layout = layout
        self.frameKey = .compilation

        var parsing = contents
        let encoding = try BooleanFrame.extractEncoding(data: &parsing, version: version)
        let contentString = parsing.extractPrefixAsStringUntilNullTermination(encoding) ?? ""
        self.value = BooleanFrame.getBooleanFromString(boolString: contentString)
    }
    
    // interpret some of the most common boolean-type strings
    private static func getBooleanFromString(boolString: String) -> Bool {
        switch boolString.lowercased() {
            case "true", "t", "yes", "y", "1":
                return true
            case "false", "f", "no", "n", "0":
                return false
            default:
                return false
        }
    }
}

public extension Tag {
    /// - Compilation flag getter-setter. This is a non-standard, iTunes compliant frame
    /// ID3 Identifier: `TCP`/`TCMP`.
    var compilation: Bool? {
        get {
            if let frame = self.frames[.compilation],
                case .booleanFrame(let booleanFrame) = frame {
                return booleanFrame.value
            } else {
                return nil
            }
        }
        set {
            let frame = BooleanFrame(value: newValue ?? false)
            frames[.compilation] = .booleanFrame(frame)
        }
    }
}
