//
//  StringEncoding.swift
//  SwiftTagger_MacOS
//
//  This code is adapted from ID3TagEditor
//  Created by Fabrizio Duroni on 27/02/2018.
//  2018 Fabrizio Duroni. https://github.com/chicio/ID3TagEditor
//
//  Created by Nolaine Crusher on 4/9/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

enum StringEncoding: UInt8 {
    case isoLatin1 = 0x00
    case utf16WithBOM = 0x01
    case utf16BigEndian = 0x02
    case utf8 = 0x03
    case ascii = 0x04
    
    func exists(in version: ID3Version) -> Bool {
        switch self {
            case .utf16WithBOM, .isoLatin1, .ascii:
                return true
            case .utf8, .utf16BigEndian:
                switch version {
                    case .version22, .version23:
                        return false
                    case .version24:
                        return true
            }
        }
    }
    
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
            case .ascii:
                return .ascii
        }
    }
    
    //    func detect(frame: Data, version: ID3Version) -> String.Encoding {
    //        let encodingBytePosition = id3FrameConfiguration.encodingPositionFor(version: version)
    //        let encoding = id3StringEncodingConverter.convert(
    //            id3Encoding: ID3StringEncoding(rawValue: frame[encodingBytePosition]),
    //            version: version
    //        )
    //        return encoding
    //    }
    
    
    func convert(version: ID3Version) -> String.Encoding {
        let validId3Encoding = self
        if validId3Encoding.exists(in: version) {
            return validId3Encoding.standardLibraryEncoding
        }
        return .isoLatin1
    }
}
