/*

 StringEncoding.swift
 SwiftTaggerID3

 Copyright ©2020 Nolaine Crusher. All rights reserved.

 */

import Foundation
/*
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
 */

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
    
    init?(string: String) {
        if string.data(using: .isoLatin1) != nil {
            self = .isoLatin1
        } else if string.data(using: .utf16) != nil {
            self = .utf16
        } else if string.data(using: .utf16BigEndian) != nil {
            self = .utf16BigEndian
        } else if string.data(using: .utf8) != nil {
            self = .utf8
        } else {
            return nil
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
        switch self.terminationCount {
            case 1: return Data([0x00])
            case 2: return Data(repeating: 0x00, count: 2)
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
