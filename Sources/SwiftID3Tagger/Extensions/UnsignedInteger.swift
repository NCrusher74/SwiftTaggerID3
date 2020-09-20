/*

 UnsignedInteger.swift
 SwiftTaggerID3

 Copyright ©2020 Nolaine Crusher. All rights reserved.

 */

import Foundation
import SwiftConvenienceExtensions

extension UnsignedInteger {
    func encodingSynchsafe() -> Self {
        let byteMask: Self = 0b0111_1111
        var encoded: Self = 0
        for offset in 0 ..< MemoryLayout<Self>.size {
            // Pull out seven bits at a time.
            let relevantBits = self & (byteMask << (offset * 7))
            // Shift them to make gaps.
            let shifted = relevantBits << offset * 1
            encoded |= shifted
        }
        return encoded
    }
    func decodingSynchsafe() -> Self {
        let byteMask: Self = 0b0111_1111
        var decoded: Self = 0
        for offset in 0 ..< MemoryLayout<Self>.size {
            // Pull out each byte without the leading bit.
            let relevantBits = self & (byteMask << (offset * 8))
            // Shift them to close the gaps.
            let shifted = relevantBits >> offset * 1
            decoded |= shifted
        }
        return decoded
    }
}
