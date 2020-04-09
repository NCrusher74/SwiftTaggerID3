//
//  TagProperties.swift
//  SwiftTagger_MacOS
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

    internal var headerBytesCount: Int = 10

    // the first five bytes of a valid ID3 Tag are "ID3"+ the version number in UInt8
    internal var version22Bytes: [UInt8] = [0x49, 0x44, 0x33, 0x02, 0x00]
    internal var version23Bytes: [UInt8] = [0x49, 0x44, 0x33, 0x03, 0x00]
    internal var version24Bytes: [UInt8] = [0x49, 0x44, 0x33, 0x04, 0x00]

    internal func version() throws -> ID3Version {
        let mp3Data = try Data(contentsOf: self.mp3file.location)
        let versionBytesFromMp3 = [UInt8](mp3Data.subdata(in: 0..<5))
        if versionBytesFromMp3 == version22Bytes {
            return ID3Version.version22
        } else if versionBytesFromMp3 == version23Bytes {
            return ID3Version.version23
        } else if versionBytesFromMp3 == version24Bytes {
            return ID3Version.version24
        } else {
            throw Mp3File.Error.InvalidTagData
        }
    }

    internal func size() throws -> UInt32 {
        let tagBytesOffset = 6
        let mp3Data = try Data(contentsOf: self.mp3file.location) as NSData
        let tagDataBytes = mp3Data.bytes + tagBytesOffset
        let tagSize = tagDataBytes.assumingMemoryBound(
            to: UInt32.self).pointee.bigEndian
        let synchSafeInt = SynchSafeInteger(integer: tagSize)
        let decodedTagSize = synchSafeInt.decode()
        return decodedTagSize
    }

}
