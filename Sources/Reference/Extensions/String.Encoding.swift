/*

 StringEncoding.swift
 SwiftTaggerID3

 Copyright ©2020 Nolaine Crusher. All rights reserved.

 */

import Foundation

extension String.Encoding {
    init(byte: Data?) throws {
        if byte == nil {
            self = .ascii
        } else {
            let uInt8 = byte?.uInt8BE
            switch uInt8 {
                case 0x00: self = .isoLatin1
                case 0x01: self = .utf16
                case 0x02: self = .utf16BigEndian
                case 0x03: self = .utf8
                default: throw Mp3FileError.InvalidStringEncodingByte
            }
        }
    }
    
    var encodingByte: Data {
        switch self {
            case .isoLatin1: return 0.uInt8.beData
            case .utf16: return 1.uInt8.beData
            case .utf16BigEndian: return 2.uInt8.beData
            case .utf8: return 3.uInt8.beData
            default: return Data()
        }
    }
    
    var nullTerminator: Data {
        switch self {
            case .ascii, .utf8, .isoLatin1: return Data([0x00])
            case .utf16, .utf16BigEndian: return Data(repeating: 0x00, count: 2)
            default: fatalError("Null terminator not set for string type")
        }
    }
    
    var terminationCount: Int {
        switch self {
            case .ascii, .utf8, .isoLatin1: return 1
            case .utf16, .utf16BigEndian: return 2
            default: fatalError("Null terminator not set for string type")
        }
    }
}
