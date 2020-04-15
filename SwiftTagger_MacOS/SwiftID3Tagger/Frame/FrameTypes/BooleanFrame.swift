//
//  BooleanFrame.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/12/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

/**
 A type representing an ID3 frame that holds a single integer
 */
public struct BooleanFrame: FrameProtocol {
    
    public let value: Bool
    
    /**
     A frame with a single-integer string, 1 or 0, presented as a boolean.
     - parameter value: the content of the frame.
     
     This frame is stored in the tag as a string. For the sake of user-friendliness, this is converted to a boolean value as long as the stored value is recognizable as a boolean-like word.
     */
    public init(value: Bool) {
        self.value = value
    }
    
    //    func encodeContents(version: Version) throws -> Data {
    //
    //    }
    
    internal var flags: Data
    internal var identifier: KnownFrameLayoutIdentifier
    
    internal init(decodingContents contents: Data.SubSequence,
                  version: Version,
                  frameIdentifier: KnownFrameLayoutIdentifier,
                  flags: Data) throws {
        var parsing = contents
        let encoding = StringFrame.extractEncoding(data: &parsing, version: version)
        let contentString = extractTerminatedString(
            data: &parsing, encoding: encoding)
        self.value = getBooleanFromString(boolString: contentString)
    }
    
    private func getBooleanFromString(boolString: String) -> Bool {
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
