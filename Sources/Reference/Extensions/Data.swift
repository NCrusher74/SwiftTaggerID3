//
//  File.swift
//  
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
    /// - Parameter boolString: The string parsed from the frame's contents
    /// - Returns: 1 or 0, if a value can be determined
    mutating func extractAndDecodeStringFromBoolean() throws -> String {
        let encoding = try self.extractEncoding()
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
    
    mutating func extractAndDecodeString() throws -> String {
        let encoding = try self.extractEncoding()
        if let string = self.extractNullTerminatedString(encoding) {
            return string
        } else {
            return ""
        }
    }
}
