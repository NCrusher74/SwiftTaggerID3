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
            let validatedMp3 = self.mp3File.data
            if self.isValidSize(validatedMp3: validatedMp3) {
                return true
            } else {
                throw Mp3File.Error.FileTooSmall
            }
        } else {
            throw Mp3File.Error.InvalidFileFormat
        }
    }
        
    // MARK: Validate Tag Data
    
    // check that first five bytes are "ID3<version><null>"
    private func hasValidVersionBytes() throws -> Bool {
        if try self.isValidMp3() {
            let mp3Data = self.mp3File.data
            let properties = TagProperties(for: self.mp3File)
            let versionBytesFromMp3 = [UInt8](mp3Data.subdata(in: properties.versionBytesOffset..<properties.tagFlagsOffset))
            let versionBytes: [[UInt8]] = [
            [0x02, 0x00], [0x03, 0x00], [0x04, 0x00]
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
        let mp3Data = self.mp3File.data
        if mp3Data.count < Int(tagProperties.size) + tagProperties.tagHeaderLength {
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
