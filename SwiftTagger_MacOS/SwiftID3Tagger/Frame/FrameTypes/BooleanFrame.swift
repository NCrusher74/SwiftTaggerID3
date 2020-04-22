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
public struct BooleanFrame: FrameProtocol {
    
    public init(value: Bool) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.compilation), value: value)
    }
    
    var value: Bool
    
    /**
     A frame with a single-integer string, 1 or 0, presented as a boolean.
     - parameter value: the content of the frame.
     
     This frame is stored in the tag as a string. For the sake of user-friendliness, this is converted to a boolean value as long as the stored value is recognizable as a boolean-like word.
     */
    private init(layout: FrameLayoutIdentifier, value: Bool) {
        self.value = value
        self.flags = BooleanFrame.defaultFlags
        self.layout = layout
    }
    
    func encodeContents(version: Version) throws -> Data {
        let contents = self.value
        if contents == true {
            return "1".encoded(withNullTermination: false)
        } else {
            return "0".encoded(withNullTermination: false)
        }
    }
    
    var flags: Data
    var layout: FrameLayoutIdentifier
    
    init(decodingContents contents: Data.SubSequence,
         version: Version,
         layout: FrameLayoutIdentifier,
         flags: Data
    ) throws {
        self.flags = flags
        self.layout = layout
        var parsing = contents
        let encoding = BooleanFrame.extractEncoding(data: &parsing, version: version)
        let contentString = parsing.extractPrefixAsStringUntilNullTermination(encoding) ?? ""
        self.value = BooleanFrame.getBooleanFromString(boolString: contentString)
    }
    
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
    
    func frameKey(version: Version) -> FrameKey? {
        if self.layout == .known(KnownFrameLayoutIdentifier.compilation) {
            return .compilation
        } else {
            return nil
        }
    }
}
