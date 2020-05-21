/*

 Data.swift
 SwiftTaggerID3

 Copyright ©2020 Nolaine Crusher. All rights reserved.

 */

import Foundation

extension Data {
    
    /// works for a single byte, not an array
    var uint8: UInt8 {
        get {
            var number: UInt8 = 0
            self.copyBytes(to:&number, count: MemoryLayout<UInt8>.size)
            return number
        }
    }
    
    func addingNullTerminationToASCIIEncodedString() -> Data {
        let null = Data(repeating: 0x00, count: StringEncoding.utf8.sizeOfTermination)
        return null
    }

}
