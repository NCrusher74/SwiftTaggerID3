//
//  TagValidation.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/8/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

/**
 A type containing methods and properties to validate the content of the mp3 file and tag
 */
struct TagValidator {
    
    var mp3File: Mp3File
    
    ///  - parameter mp3File: the mp3 file containing the tag.
    init(for mp3File: Mp3File) {
        self.mp3File = mp3File
    }
    
    private var mp3Data: Data {
        return self.mp3File.data
    }
    
    private var tagProperties: TagProperties {
        return TagProperties(for: mp3File)
    }
    
    // MARK: Validate file
    // Check that mp3 has a valid file extension
    var hasValidExtension: Bool {
        if self.mp3File.location.fileExtension.lowercased() == "mp3" {
            return true
        }; return false
    }
    
    // Check if MP3 is too small for a tag
    var isValidSize: Bool {
        if mp3Data.count < 5 {
            return false
        }; return true
    }
    
    // confirm valid MP3 or throw error
    func isValidMp3() throws -> Bool {
        if self.hasValidExtension {
            if self.isValidSize {
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
    func hasValidVersionData() throws -> Bool {
        if try self.isValidMp3() {
            
            let versionData = tagProperties.extractVersionData(data: self.mp3Data)
//            let versionUInt8 = [versionData.uint8]

            let knownVersionData = tagProperties.versionData
            if knownVersionData.contains(versionData) {
                return true
            } else {
                throw Mp3File.Error.InvalidTagData
            }
        }; return false
    }
    
    // check that tag size does not exceed file size
    func hasValidTagSize() throws -> Bool {
        let byteOffset = tagProperties.tagSizeDeclarationOffset
        let endOfRelevantBytes = byteOffset + tagProperties.tagSizeDeclarationLength
        let tagSizeDataRange = byteOffset ..< endOfRelevantBytes
        let tagSizeData = mp3Data.subdata(in: tagSizeDataRange)

        let sizeInt = Int(tagProperties.size(tagSizeData: tagSizeData))
        let headerSize = tagProperties.tagHeaderLength
        let tagSize =  sizeInt + headerSize

        if mp3Data.count < tagSize {
            throw Mp3File.Error.CorruptedFile
        }; return true
    }
    
    // confirm valid tag tag data
    func hasValidTag() throws -> Bool {
        if try self.hasValidVersionData() && self.hasValidTagSize() {
            return true
        } else {
            throw Mp3File.Error.InvalidTagData
        }
    }
    
}
