//
//  Tag.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/10/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

struct Tag {
    
    var frames: [FrameKey : Frame]
    var mp3File: Mp3File
    
    // handles the parsing of an ID3 tag
    init(frames: [FrameKey: Frame]) throws {
        let file: Data = self.mp3File.data
        
        var remainder: Data.SubSequence = file[file.startIndex..<file.endIndex]
        
        let tagProperties = TagProperties(for: self.mp3File)
        let tagValidator = TagValidator(for: self.mp3File)
        
        // parse version from tag header
        var version: Version = .v2_4
        if try tagValidator.hasValidTag() != true {
            throw Mp3File.Error.InvalidTagData
        } else {
            // the first five bytes of a valid ID3 Tag are "ID3"+ the version number in UInt8
            let versionData = tagProperties.extractVersionData
            let version = try tagProperties.version(versionData: versionData)
            
            _ = tagProperties.extractFlagData
            let tagSizeData = tagProperties.extractTagSizeData
            let size = tagProperties.size(tagSizeData: tagSizeData)
        }
        
        var frames: [FrameKey: Frame]
        while !remainder.isEmpty {
            let identifierBytes = remainder.extractFirst(version.identifierLength)
            let identifier = String(ascii: identifierBytes)

            let frame = try Frame(
                identifier: identifier,
                data: &remainder,
                version: version)

            var additionalIdentifier: String = ""
            let specialCaseFrames = version.specialCaseFrameIdentifiers
            if specialCaseFrames.contains(identifier) {
                if identifier == "TLA" || identifier == "TLAN" {
                    additionalIdentifier =
                } else if identifier == "CHAP" || identifier == "CTOC" {
                    additionalIdentifier = // elementID
                } else {
                    additionalIdentifier = // description string
                }
            }
            let keyForIdentifier = FrameKey.getFrameKeyForIdentifier(identifier: identifier, additionalIdentifier: additionalIdentifier)

            
            frames[frameKey] = frame
        }
    }
}
