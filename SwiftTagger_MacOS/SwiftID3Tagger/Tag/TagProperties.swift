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

/**
 A type that contains the general properties of an ID3 tag, such as version and size
 */
struct TagProperties {
    
    /// the ID3 version of the tag
    func extractVersionData(data: Data) -> Data {
        var fileData = data
        return fileData.extractFirst(versionDeclarationLength)
    }
    
    func version(versionData: Data) throws -> Version {
        if versionData == Data(v2_3Bytes) {
            return Version.v2_2
        } else if versionData == Data(v2_3Bytes) {
            return Version.v2_3
        } else if versionData == Data(v2_4Bytes) {
            return Version.v2_4
        } else {
            throw Mp3File.Error.InvalidTagData
        }
    }
    
    func extractFlagData(data: Data) -> Data {
        var flagData = data
        return flagData.extractFirst(tagFlagsLength)
    }
    
    func extractTagSizeData(data: Data) -> Data {
        var tagSizeData = data
        return tagSizeData.extractFirst(tagSizeDeclarationLength)
    }
    
    /// the size of the ID3 tag
    func size(tagSizeData: Data) -> UInt32 {
        let tagSizeNSData = tagSizeData as NSData
        let tagDataBytes = tagSizeNSData.bytes + tagSizeDeclarationOffset
        let tagSize = tagDataBytes.assumingMemoryBound(
            to: UInt32.self).pointee.bigEndian
        let decodedTagSize = tagSize.decodingSynchsafe()
        return decodedTagSize
    }
}

extension TagProperties {
    /*
     The first part of the ID3v2 tag is the 10 byte tag header, laid out
     as follows:
     
     ID3v2/file identifier      "ID3" -- 3 bytes
     ID3v2 version              $0x 00 -- 2 bytes
     ID3v2 flags                %abcd0000 -- 1 byte (Uint32)
     ID3v2 size             4 * %0xxxxxxx -- 4 bytes (Uint32)
     */
    
    /// the byte-count of the ID3 version declaration
    var versionDeclarationLength: Int {
        return 5
    }
    
    /// the byte-count of the tag's UInt32 flags
    var tagFlagsLength: Int {
        return 1
    }
    
    /// the byte-count of the tag's UInt32 size declaration
    var tagSizeDeclarationLength: Int {
        return 4
    }
    
    var tagHeaderLength: Int {
        return 10
    }
    
    /// the byte-offset of the tag's flag bytes
    var tagFlagsOffset: Data.Index {
        return versionDeclarationLength
    }
    
    /// the byte-offset of the tag's size declaration
    var tagSizeDeclarationOffset: Data.Index {
        return tagFlagsOffset + tagFlagsLength
    }
    
    /// the byte-count of the full tag header
    var frameDataOffset: Data.Index {
        return tagSizeDeclarationOffset + tagSizeDeclarationLength
    }
    
    /// the UInt8 byte array for version2.2
    /// used as a comparison to determine which version to return
    var v2_2Bytes: [UInt8] {
        return [0x49, 0x44, 0x33, 0x02, 0x00]
    }
    /// the UInt8 byte array for version2.3
    /// used as a comparison to determine which version to return
    var v2_3Bytes: [UInt8] {
        return [0x49, 0x44, 0x33, 0x03, 0x00]
    }
    /// the UInt8 byte array for version2.4
    /// used as a comparison to determine which version to return
    var v2_4Bytes: [UInt8] {
        return [0x49, 0x44, 0x33, 0x04, 0x00]
    }
    /// the [UInt8] byte array for all possible versions
    /// used as a comparison to determine which version to return
    var versionBytes: [[UInt8]] {
        return [v2_2Bytes, v2_3Bytes, v2_4Bytes]
    }
}
