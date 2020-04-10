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
    
    func exists(in version: Version) -> Bool {
        switch self {
            case .utf16WithBOM, .isoLatin1:
                return true
            case .utf8, .utf16BigEndian:
                switch version {
                    case .v2_2, .v2_3:
                        return false
                    case .v2_4:
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
        }
    }
    
    //    func detect(frame: Data, version: Version) -> String.Encoding {
    //        let encodingBytePosition = id3FrameConfiguration.encodingPositionFor(version: version)
    //        let encoding = id3StringEncodingConverter.convert(
    //            id3Encoding: ID3StringEncoding(rawValue: frame[encodingBytePosition]),
    //            version: version
    //        )
    //        return encoding
    //    }
    
//    func detect(mp3File: Mp3File, frame: Data, version: Version) -> String.Encoding {
//        let frameProperties = FrameProperties(
//            mp3File: mp3File, version: version)
//        
//    }
    
    func convert(version: Version) -> String.Encoding {
        let validId3Encoding = self
        if validId3Encoding.exists(in: version) {
            return validId3Encoding.standardLibraryEncoding
        }
        return .isoLatin1
    }
}
