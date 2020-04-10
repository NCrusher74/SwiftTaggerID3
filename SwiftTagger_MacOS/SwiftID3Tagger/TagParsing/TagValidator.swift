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
    
    init(for mp3File: Mp3File) {
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
    internal func isValidMp3() throws -> Bool {
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
    private func hasValidVersionBytes() throws -> Bool {
        if try self.isValidMp3() {
            let mp3Data = try Data(contentsOf: self.mp3File.location)
            let versionBytesFromMp3 = [UInt8](mp3Data.subdata(in: 0..<5))
            let versionBytes: [[UInt8]] = [
            // the first five bytes of a valid ID3 Tag are "ID3"+ the version number in UInt8
            [0x49, 0x44, 0x33, 0x02, 0x00],
            [0x49, 0x44, 0x33, 0x03, 0x00],
            [0x49, 0x44, 0x33, 0x04, 0x00]
            ]
            if versionBytes.contains(versionBytesFromMp3) {
                return true
            } else {
                throw Mp3File.Error.InvalidTagData
            }
        }; return false
    }
    
    private var headerBytesTotal: Int = 10
    
    // check that tag size does not exceed file size
    private func hasValidTagSize() throws -> Bool {
        let tagProperties = TagProperties(for: self.mp3File)
        let mp3Data = try Data(contentsOf: self.mp3File.location)
        if mp3Data.count < Int(try tagProperties.size()) + tagProperties.tagHeaderSize {
            throw Mp3File.Error.CorruptedFile
        } else {
            return true
        }
    }
    
    // confirm valid tag tag data
    internal func hasValidTag() throws -> Bool {
        if try self.hasValidVersionBytes() && self.hasValidTagSize() {
            return true
        } else {
            throw Mp3File.Error.InvalidTagData
        }
    }
    
}
