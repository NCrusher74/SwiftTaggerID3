/*

 StringEncoding.swift
 SwiftTaggerID3

 Copyright ©2020 Nolaine Crusher. All rights reserved.

 */

import Foundation

enum StringEncoding: UInt8 {
    case isoLatin1 = 0x00
    case utf16WithBOM = 0x01
    case utf16BigEndian = 0x02
    case utf8 = 0x03
    
    var standardLibraryEncoding: String.Encoding {
        switch self {
            case .isoLatin1:
                return .isoLatin1
            case .utf16WithBOM:
                return .utf16
            case .utf8:
                return .utf8
            case .utf16BigEndian:
                return .utf16BigEndian
        }
    }
}

extension StringEncoding {
    var sizeOfTermination: Int {
        switch self {
            case .isoLatin1, .utf8:
                return 1
            case .utf16WithBOM, .utf16BigEndian:
                return 2
        }
    }
    
    // Because every string can be losslessly encoded this way,
    // and because it is supported by all ID3 versions.
    static let preferred = isoLatin1
}
