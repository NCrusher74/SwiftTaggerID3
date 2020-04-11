//
//  TagValidation.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/8/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation
import AVFoundation

/**
 A type containing methods and properties to validate the content of the mp3 file and tag
 */
internal struct TagValidator {
    
    internal var mp3File: Mp3File

    ///  - parameter mp3File: the mp3 file containing the tag.
    internal init(for mp3File: Mp3File) {
        self.mp3File = mp3File
    }
    
    // MARK: Validate file
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
            let versionBytes = properties.versionBytes
            if versionBytes.contains(versionBytesFromMp3) {
                return true
            } else {
                throw Mp3File.Error.InvalidTagData
            }
        }; return false
    }
    
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
