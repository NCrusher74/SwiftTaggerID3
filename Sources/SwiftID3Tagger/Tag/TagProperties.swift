/*

 TagProperties.swift
 SwiftTaggerID3

 Copyright ©2020 Nolaine Crusher. All rights reserved.

 */

import Foundation

/** Houses variables and methods for using known ID3 Tag information to derive necessary data from a specific `Tag` instance */
struct TagProperties {
    
    /** Compares bytes in the known range of the version bytes for an ID3 header to known values in order to calculate the ID3 version of a `Tag` instance */
    /** - Parameter data: The slice of data from `Tag` instance that should contain ID3 version information, to be compared to known values */
    /// - Throws: `InvalidVersionData` if the bytes do not match known values
    /// - Returns: `Version` the ID3 version for the `Tag`
    func version(data: Data) throws -> Version {
        if data == Data(v2_2Bytes) {
            return Version.v2_2
        } else if data == Data(v2_3Bytes) {
            return Version.v2_3
        } else if data == Data(v2_4Bytes) {
            return Version.v2_4
        } else {
            throw Mp3File.Error.InvalidVersionData
        }
    }
    
    /** Reads the size bytes from a `Tag` header. This value may be used to valid ID3 tag data, or to provide an upper bound for parsing the frame data contained in the tag*/
    /** - Parameter data: The slice of data from `Tag` instance that should contain tag size information, used to derive a declared size */
    /// - Throws: `InvalidTagSize` If the tag is not large enough to hold at least one valid frame.
    /// - Returns: the tag size as a synch-safed integer
    func size(data: Data, version: Version) throws -> Int {
        let tagSize = (data as NSData).bytes.assumingMemoryBound(to: UInt32.self).pointee.bigEndian
        let decodedTagSize = tagSize.decodingSynchsafe()
        switch version {
            case .v2_2:
                guard Int(decodedTagSize) > 6 else {
                    throw Mp3File.Error.InvalidTagSize
            }
            case .v2_3, .v2_4:
                guard Int(decodedTagSize) > 10 else {
                    throw Mp3File.Error.InvalidTagSize
            }
        }
        return Int(decodedTagSize)
    }
    
    /// Calculated the size of a `Tag` instance being created, which is the count of all the data of a tag, minus the header data, converted to UInt32 and returned as data
    /// - Parameter data: the data of the `Tag` being created
    /// - Throws: Caller will determine how to handle any errors
    /// - Returns: a four-byte synchsafe integer as a data slice containing the `Tag` size
    func calculateNewTagSize(data: Data) throws -> Data {
        return data.count.truncatedUInt32.encodingSynchsafe().bigEndianData
    }
}

extension TagProperties {
    /*
     The first part of the ID3v2 tag is the 10 byte tag header, laid out
     as follows:
     
     ID3v2/file identifier      "ID3" -- 3 bytes
     ID3v2 version              $0x 00 -- 2 bytes
     ID3v2 flags                %abcd0000 -- 1 byte (Uint32) (for our purposes, this is always `0x00`)
     ID3v2 size             4 * %0xxxxxxx -- 4 bytes (Synchsafe Uint32)
     */
    
    // MARK: Tag Properties
    /// The known length of version declaration data in a valid ID3 tag header
    var versionDeclarationLength: Int {
        return 5
    }
    
    /// the UInt8 byte array for version2.2 ("ID320")
    ///
    /// Used as a comparison to determine which version to return
    var v2_2Bytes: [UInt8] {
        return [0x49, 0x44, 0x33, 0x02, 0x00]
    }
    /// the UInt8 byte array for version2.2 ("ID330")
    ///
    /// Used as a comparison to determine which version to return
    var v2_3Bytes: [UInt8] {
        return [0x49, 0x44, 0x33, 0x03, 0x00]
    }
    /// the UInt8 byte array for version2.2 ("ID340")
    ///
    /// Used as a comparison to determine which version to return
    var v2_4Bytes: [UInt8] {
        return [0x49, 0x44, 0x33, 0x04, 0x00]
    }

    /// The known byte-count of a valid ID3 tag's UInt32 flag
    var tagFlagsLength: Int {
        return 1
    }

    /// The default flag for an ID3 tag.
    ///
    /// SwiftTaggerID3 does not support alteration of this byte
    var defaultFlag: Data {
        let defaultTagFlagByte: [UInt8] = [0x00]
        return Data(defaultTagFlagByte)
    }
    
    /// The known byte-count of a valid ID3 tag's UInt32 size declaration
    var tagSizeDeclarationLength: Int {
        return 4
    }
    
    /// The known byte-count of a valid ID3 tag header
    /// This value may be used to validate ID3 tag header data, or to locate the tag's frame data
    var tagHeaderLength: Int {
        return 10
    }
    
    /// The known byte-offset of a valid ID3 tag's flag bytes
    /// This value may be used to validate ID3 tag header data, or to locate the known tag flag data
    var tagFlagsOffset: Data.Index {
        return versionDeclarationLength
    }
    
    /// The known byte-offset of a valid ID3 tag's size declaration
    /// This value may be used to validate ID3 tag header data, or to locate the known tag size declaration data
    var tagSizeDeclarationOffset: Data.Index {
        return tagFlagsOffset + tagFlagsLength
    }
    
    /// The known byte-offset of an ID3 tag's data after a valid tag header
    /// This value may be used to validate ID3 tag header data, or to locate the tag's frame data
    var frameDataOffset: Data.Index {
        return tagHeaderLength
    }
}
