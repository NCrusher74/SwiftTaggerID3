//
//  TagValidation.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/8/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation
import AVFoundation

struct TagValidator {
    
    var mp3File: Mp3File
    
    init(from mp3File: Mp3File) {
        self.mp3File = mp3File
    }
    
    // Check that mp3 has a valid file extension
    private var hasValidExtension: Bool {
        if self.mp3File.location.fileExtension.lowercased() == "mp3" {
            return true
        } else {
            return false
        }
    }
    
    // Check if MP3 is too small for a tag
    private func isValidSize(validatedMp3: Data) -> Bool {
        if validatedMp3.count < 5 {
            return false
        } else {
            return true
        }
    }
    
    // MARK: Validate file
    // confirm valid MP3 or throw error
    public func isValidMp3() throws -> Bool {
        if self.hasValidExtension {
            let validatedMp3 = try Data(contentsOf: self.mp3File.location)
            if self.isValidSize(validatedMp3: validatedMp3) {
                return true
            } else {
                throw Mp3File.Error.FileTooSmall
            }
        } else {
            throw Mp3File.Error.InvalidFileFormat
        }
    }
    
    /*
     The first part of the ID3v2 tag is the 10 byte tag header, laid out
     as follows:
     
     ID3v2/file identifier      "ID3" -- 3 bytes
     ID3v2 version              $04 00 -- 2 bytes
     ID3v2 flags                %abcd0000 -- 1 byte (Uint32)
     ID3v2 size             4 * %0xxxxxxx -- 4 bytes (Uint32)
     */
    
    // MARK: Validate Tag Data
    
    // check that first five bytes are "ID3<version><null>"
    private func hasValidVersionBytes(version: ID3Version) throws -> Bool {
        if try self.isValidMp3() {
            var ID3Bytes = [UInt8]("ID3".utf8)
            switch version {
                case .version22: ID3Bytes.append(contentsOf: [0x02, 0x00])
                case .version23: ID3Bytes.append(contentsOf: [0x03, 0x00])
                case .version24: ID3Bytes.append(contentsOf: [0x04, 0x00])
            }
            let mp3Data = try Data(contentsOf: self.mp3File.location)
            let versionBytes = [UInt8](mp3Data.subdata(in: 0..<5))
            if versionBytes == ID3Bytes {
                return true
            } else {
                throw Mp3File.Error.InvalidTagData
            }
        }; return false
    }
    
    private var headerBytesTotal: Int = 10

    // check that tag size does not exceed file size
    private func hasValidTagSize() throws -> Bool {
        let mp3Data = try Data(contentsOf: self.mp3File.location)
        let sizeBytes = mp3Data.subdata(in: 6..<10).uint32
        let synchSafe = SynchSafeInteger(integer: sizeBytes)
        let decodedTagSize = synchSafe.decode()
        if mp3Data.count < Int(decodedTagSize) + headerBytesTotal {
            throw Mp3File.Error.CorruptedFile
        } else {
            return true
        }
    }
    
    // confirm valid tag tag data
    public func hasValidTag(version: ID3Version) throws -> Bool {
        if try self.hasValidVersionBytes(version: version) && self.hasValidTagSize() {
            return true
        } else {
            throw Mp3File.Error.InvalidTagData
        }
    }
    
}
