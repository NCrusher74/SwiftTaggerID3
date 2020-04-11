//
//  TagProperties.swift
//  SwiftTagger_MacOS
//
//  Some of this code is adapted from ID3TagEditor
//  Created by Fabrizio Duroni on 27/02/2018.
//  2018 Fabrizio Duroni. https://github.com/chicio/ID3TagEditor
//
//  Created by Nolaine Crusher on 4/9/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

struct TagProperties {
    
    var mp3file: Mp3File
    
    init(for mp3File: Mp3File) {
        self.mp3file = mp3File
    }

    /// the ID3 version of the tag
    internal var version: Version {
        let mp3Data = self.mp3file.data
        // the first five bytes of a valid ID3 Tag are "ID3"+ the version number in UInt8
        let v2_2Bytes: [UInt8] = [0x02, 0x00]
        let v2_3Bytes: [UInt8] = [0x03, 0x00]
        let v2_4Bytes: [UInt8] = [0x04, 0x00]
        
        let versionBytesFromMp3 = [UInt8](mp3Data.subdata(in: versionBytesOffset..<tagFlagsOffset))
        if versionBytesFromMp3 == v2_2Bytes {
            return Version.v2_2
        } else if versionBytesFromMp3 == v2_3Bytes {
            return Version.v2_3
        } else if versionBytesFromMp3 == v2_4Bytes {
            return Version.v2_4
        } else {
            print(Mp3File.Error.InvalidTagData)
        }; return Version.v2_4
    }
    
    internal var size: UInt32 {
        let tagBytesOffset = 6
        let mp3Data = self.mp3file.data as NSData
        let tagDataBytes = mp3Data.bytes + tagBytesOffset
        let tagSize = tagDataBytes.assumingMemoryBound(
            to: UInt32.self).pointee.bigEndian
        let decodedTagSize = tagSize.decodingSynchsafe()
        return decodedTagSize
    }
    
//    internal func tagData() throws -> FrameData {
//        let validator = TagValidator(for: self.mp3file)
//        if try validator.hasValidTag() {
//            _ = size
//            _ = version
//        }
//        let frameParser = FrameParser(forFile: self.mp3file)
//        let data = try frameParser.parseFrames()
//        return data
//    }
    
}

extension TagProperties {
    /*
     The first part of the ID3v2 tag is the 10 byte tag header, laid out
     as follows:
     
     ID3v2/file identifier      "ID3" -- 3 bytes
     ID3v2 version              $04 00 -- 2 bytes
     ID3v2 flags                %abcd0000 -- 1 byte (Uint32)
     ID3v2 size             4 * %0xxxxxxx -- 4 bytes (Uint32)
     */
    
    /// the byte-count of the ID3 declaration
    internal var id3DeclarationLength: Int {
        return 3
    }
    
    /// the byte-count of the ID3 version declaration
    internal var versionDeclarationLength: Int {
        return 2
    }
    
    /// the byte-count of the tag's UInt32 flags
    internal var tagFlagsLength: Int {
        return 1
    }
    
    /// the byte-count of the tag's UInt32 size declaration
    internal var tagSizeDeclarationLength: Int {
        return 4
    }
    
    internal var tagHeaderLength: Int {
        return id3DeclarationLength + versionDeclarationLength + tagFlagsLength + tagSizeDeclarationLength
    }
    
    internal var versionBytesOffset: Int {
        return id3DeclarationLength
    }
    
    internal var tagFlagsOffset: Int {
        return id3DeclarationLength + versionDeclarationLength
    }
    
    internal var tagSizeDeclarationOffset: Int {
        return id3DeclarationLength + versionDeclarationLength + tagFlagsLength
    }
}
