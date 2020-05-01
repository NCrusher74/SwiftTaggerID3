//
//  TagProperties.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/23/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

/** a type containing properties and methods for relating to an ID3 Tag */
struct TagProperties {

    /// determines tag version by comparing version data to known version datat
    func version(data: Data) throws -> Version {
        if data == Data(v2_2Bytes) {
            return Version.v2_2
        } else if data == Data(v2_3Bytes) {
            return Version.v2_3
        } else if data == Data(v2_4Bytes) {
            return Version.v2_4
        } else {
            throw Mp3File.Error.InvalidTagData
        }
    }
    
    /// determines the size of the ID3 tag by parsing and decoding the size data
    func size(data: Data) throws -> Int {
        let tagSize = (data as NSData).bytes.assumingMemoryBound(to: UInt32.self).pointee.bigEndian
        let decodedTagSize = tagSize.decodingSynchsafe()
        return Int(decodedTagSize)
    }
    
    func calculateNewSize(data: Data) throws -> Data {
        return data.count.truncatedUInt32.bigEndianData
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
    
    // MARK: Tag Properties
    /// the byte-count of the ID3 version declaration
    var versionDeclarationLength: Int {
        return 5
    }
    
    /// the UInt8 byte array for version2.2 ("ID320")
    /// used as a comparison to determine which version to return
    var v2_2Bytes: [UInt8] {
        return [0x49, 0x44, 0x33, 0x02, 0x00]
    }
    /// the UInt8 byte array for version2.3 ("ID330")
    /// used as a comparison to determine which version to return
    var v2_3Bytes: [UInt8] {
        return [0x49, 0x44, 0x33, 0x03, 0x00]
    }
    /// the UInt8 byte array for version2.4 ("ID340")
    /// used as a comparison to determine which version to return
    var v2_4Bytes: [UInt8] {
        return [0x49, 0x44, 0x33, 0x04, 0x00]
    }
    /// the [UInt8] byte array for all possible versions
    /// used as a comparison to determine which version to return
    var versionBytes: [[UInt8]] {
        return [v2_2Bytes, v2_3Bytes, v2_4Bytes]
    }
    
    var versionData: [Data] {
        let v22Data = Data(v2_2Bytes)
        let v23Data = Data(v2_3Bytes)
        let v24Data = Data(v2_4Bytes)
        
        return [v22Data, v23Data, v24Data]
    }

    /// the byte-count of the tag's UInt32 flags
    var tagFlagsLength: Int {
        return 1
    }

    var defaultFlag: Data {
        let defaultTagFlagByte: [UInt8] = [0x00]
        return Data(defaultTagFlagByte)
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
    
}
