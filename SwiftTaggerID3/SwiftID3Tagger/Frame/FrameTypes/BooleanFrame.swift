//
//  BooleanFrame.swift
//  SwiftTaggerID3
//
//  Created by Nolaine Crusher on 4/12/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

/**
 A type representing an ID3 frame that holds a single integer stored as an integer string, 1 or 0. SwiftTaggerID3 handles this value as a boolean.
 */
struct BooleanFrame: FrameProtocol {
    
    // MARK: Properties
    var flags: Data
    var layout: FrameLayoutIdentifier
    var frameKey: FrameKey
    var allowMultipleFrames: Bool = false


    /// The frame's contents as a boolean value
    var value: Bool
    
    init(decodingContents contents: Data.SubSequence,
         version: Version,
         layout: FrameLayoutIdentifier,
         flags: Data
    ) throws {
        // initialize flags property
        self.flags = flags
        // initialize layout property
        self.layout = layout
        // initialize frame key property based on the layout
        self.frameKey = .compilation
        
        // parse contents
        var parsing = contents
        // extract and decode encoding byte
        let encoding = try BooleanFrame.extractEncoding(data: &parsing, version: version)
        // extract and decode contents
        let contentString = parsing.extractPrefixAsStringUntilNullTermination(encoding) ?? ""
        // initialize the frame's value property by converting the string content to a boolean
        self.value = BooleanFrame.getBooleanFromString(boolString: contentString)
    }
    
    /// Interpret the most common "quasi-boolean" strings as boolean values
    /// - Parameter boolString: The string parsed from the frame's contents
    /// - Returns: a boolean value, if one can be determined
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
    
    // MARK: Frame creation
    /**
     Intialize frame with a single-integer string, 1 or 0, presented as a boolean.
     
     This frame is stored in the tag as an integer string.
     For the sake of user-friendliness, this is converted to a boolean value as long as the stored string is recognizable as a "quasi-boolean" word or value.
     - parameter layout: The frame's layout
     - parameter value: the content of the frame.
     */
    init(layout: FrameLayoutIdentifier, value: Bool) {
        self.value = value
        self.flags = BooleanFrame.defaultFlags
        self.layout = layout
        self.frameKey = .compilation
    }
    
    /// Encodes the contents of the frame, without any header data
    /// - Parameter version: The version of the ID3 tag
    /// - Throws: Caller will determine how to handle any errors
    /// - Returns: The frame's contents as `data`
    func encodeContents(version: Version) throws -> Data {
        // initialize an empty Data array
        var frameData = Data()
        // append encoding byte
        frameData.append(StringEncoding.preferred.rawValue.encoding(endianness: .bigEndian))
        
        // convert boolean to integer string of "1" or "0", encode, and append
        let contents = self.value
        if contents == true {
            frameData.append("1".encoded(withNullTermination: false))
        } else {
            frameData.append("0".encoded(withNullTermination: false))
        }
        return frameData
    }
}

public extension Tag {
    /// Compilation flag getter-setter. This is a non-standard, iTunes compliant frame
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
            let frame = BooleanFrame(layout: .known(.compilation),
                                     value: newValue ?? false)
            frames[.compilation] = .booleanFrame(frame)
        }
    }
}
