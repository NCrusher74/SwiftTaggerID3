/*

 Data.Subsequence.swift
 SwiftTaggerID3

 Copyright ©2020 Nolaine Crusher. All rights reserved.

 */

import Foundation

extension Data.SubSequence {
    
    /// Removes and returns a null‐terminated string from the beginning of the subsequence (which only mutates the subsequence’s bounds, not the underlying `Data` instance).
    ///
    /// If there is no null‐termination, the string will be constructed from the entire subsequence.
    internal mutating func extractPrefixAsStringUntilNullTermination(_ encoding: StringEncoding) -> String? {
        let double: Bool
        switch encoding {
            case .utf8, .isoLatin1:
                double = false
            case .utf16BigEndian, .utf16WithBOM:
                double = true
        }
        var remainder = self
        search: while let null = remainder.firstIndex(of: 0) {
            remainder = self[null...].dropFirst()
            if double {
                if remainder.first == 0,
                    self.distance(from: startIndex, to: remainder.startIndex) % 2 != 0 {
                    // Found double‐byte null.
                    remainder = remainder.dropFirst()
                    break search
                } else {
                    // Single only, keep looking.
                    continue search
                }
            } else {
                // Found single‐byte null.
                break search
            }
        }
        
        var stringBytes: Data.SubSequence
        if remainder.startIndex == self.startIndex {
            // No null found.
            stringBytes = self
            self = self[self.endIndex...]
        } else {
            // Null found.
            stringBytes = self[..<remainder.startIndex]
            self = remainder
            stringBytes = stringBytes.dropLast()
            if double {
                stringBytes = stringBytes.dropLast()
            }
        }
        return String(data: Data(stringBytes), encoding: encoding.standardLibraryEncoding)
    }
    
}
