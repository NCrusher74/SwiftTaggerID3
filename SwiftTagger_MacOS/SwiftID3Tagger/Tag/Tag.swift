//
//  Tag.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/10/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

struct Tag {
    
    //    var frames: [FrameKey : Frame]
    var mp3File: Mp3File
    
    // handles the parsing of an ID3 tag
    init(mp3File: Mp3File) throws {
        self.mp3File = mp3File
    }
    
    func parseFramesFromTag() throws {
        let fileData: Data = self.mp3File.data
        
        var remainder: Data.SubSequence = fileData[fileData.startIndex..<fileData.endIndex]
        
        let tagProperties = TagProperties(for: self.mp3File)
        let tagValidator = TagValidator(for: self.mp3File)
        
        // parse version from tag header
        var version: Version = .v2_4
        if try tagValidator.hasValidTag() != true {
            throw Mp3File.Error.InvalidTagData
        } else {
            // the first five bytes of a valid ID3 Tag are "ID3"+ the version number in UInt8
            let versionData = tagProperties.extractVersionData(data: fileData)
            version = try tagProperties.version(data: versionData)
            
            // parse flags from tag header
            _ = tagProperties.extractFlagData(data: fileData)
            
            // parse size from tag header
            let tagSizeData = tagProperties.extractTagSizeData(data: fileData)
            _ = tagProperties.size(tagSizeData: tagSizeData)
        }
        
        while !remainder.isEmpty {
            let identifierBytes = remainder.extractFirst(version.identifierLength)
            let identifier = String(ascii: identifierBytes)
            
            _ = try Frame(
                identifier: identifier,
                data: &remainder,
                version: version)
        }
    }
}
