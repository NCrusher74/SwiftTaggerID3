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
    mutating func extractNullTerminatedString(_ encoding: String.Encoding) -> String? {
        var remainder = self
        search: while let null = remainder.firstIndex(of: 0) {
            remainder = self[null...].dropFirst()
            if encoding.terminationCount == 2 {
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
            if encoding.terminationCount == 2 {
                stringBytes = stringBytes.dropLast()
            }
        }
        return String(data: Data(stringBytes), encoding: encoding)
    }
    
//    mutating func extractAndDecodeFrameID(_ version: Version) throws -> (identifier: FrameIdentifier, idString: String) {
//        let idData = self.extractFirst(version.idLength)
//        // if the first byte is 0, it's padding, not identifier
//        guard idData.first != 0x00 else {
//            break
//        }
//        let idString = try String(ascii: idData)
//        return (FrameIdentifier(idString: idString), idString)
//    }
    
//    mutating func extractAndCalculateFrameSize(_ version: Version) -> Int {
//        let frameSizeData = self.extractFirst(version.sizeLength)
//        let frameSize: Int
//        switch version {
//            case .v2_2, .v2_3: frameSize = frameSizeData.uInt32BE.toInt
//            case .v2_4: frameSize = frameSizeData.uInt32BE.decodingSynchsafe().toInt
//        }
//        return frameSize
//    }
    
//    mutating func extractFlags(_ version: Version) -> Data {
//        switch version {
//            case .v2_2: return Data()
//            case .v2_3, .v2_4: return self.extractFirst(2)
//        }
//    }

    
    @available(OSX 10.12, *)
    mutating func extractAndParseToFrame(_ version: Version) throws -> Frame? {
        // extract the identifier data
//        let frameID = try self.extractAndDecodeFrameID(version)
        
        let idData = self.extractFirst(version.idLength)
        // if the first byte is 0, it's padding, not identifier
        guard idData.first != 0x00 else {
            return nil
        }
        let idString = try String(ascii: idData)
        let identifier = FrameIdentifier(idString: idString)
        
//        let identifier = frameID.identifier
//        let idString = frameID.idString
        let frameSizeData = self.extractFirst(version.sizeLength)
        let size: Int
        switch version {
            case .v2_2, .v2_3: size = frameSizeData.uInt32BE.toInt
            case .v2_4: size = frameSizeData.uInt32BE.decodingSynchsafe().toInt
        }
//        let size = self.extractAndCalculateFrameSize(version)

        var flags = Data()
        switch version {
            case .v2_2: flags = Data()
            case .v2_3, .v2_4: flags = self.extractFirst(2)
        }

//        let flags = self.extractFlags(version)
        let payload = self.extractFirst(size)
        return try identifier.parse(version: version,
                                    size: size,
                                    flags: flags,
                                    payload: payload,
                                    idString: idString)
    }
}
