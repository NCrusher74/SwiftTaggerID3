//
//  Data.swift
//  SwiftTaggerID3
//
//  Created by Nolaine Crusher on 9/17/20.
//

import Foundation
extension Data {
    mutating func extractEncoding() throws -> String.Encoding {
        let encodingData = self.extractFirst(1)
        return try String.Encoding(byte: encodingData)
    }
    
    /// Interpret the most common "quasi-boolean" strings as boolean values
    /// - Parameter encoding: The `String.Encoding` type parsed out of the frame content previously
    /// - Returns: 1 or 0, if a value can be determined
    mutating func decodeBooleanString(_ encoding: String.Encoding) -> String {
        if let string = self.extractNullTerminatedString(encoding) {
            switch string.lowercased() {
                case "true", "t", "yes", "y", "1":
                    return "1"
                case "false", "f", "no", "n", "0":
                    return "0"
                default:
                    return "0"
            }
        } else {
            return ""
        }
    }
    
    mutating func decodeString(_ encoding: String.Encoding) -> String {
        if let string = self.extractNullTerminatedString(encoding) {
            return string
        } else {
            return ""
        }
    }
    
    mutating func extractAndDecodeCreditString(encoding: String.Encoding) throws -> [String: [String]] {
        var strings = [String]()
        while !self.isEmpty {
            if let next = self.extractNullTerminatedString(encoding) {
                strings.append(next)
            }
        }
        var pairsDictionary = [ String: [String] ]()
        let rolePersonPairs = strings.pairs()
        for pair in rolePersonPairs {
            let personArray = pair.1?.components(separatedBy: ",")
            pairsDictionary[pair.0] = personArray
        }
        return pairsDictionary
    }
    
    /// Extracts and decodes description and content strings for frame types that use them.
    /// - Parameters:
    ///   - frameData: The frame's data beginning at the description string
    ///   - encoding: The `String.Encoding` type parsed out of the frame content previously
    /// - Returns: The frame's description and content strings
    /// this is used for ID3 frames with a terminated description string followed by a content string
    mutating func extractDescriptionAndContent(_ encoding: String.Encoding) -> (description: String?, content: String) {
        let description = self.extractNullTerminatedString(encoding)
        
        let content = decodeString(encoding)
        
        return (description: description, content: content)
    }
}
