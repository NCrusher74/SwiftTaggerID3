//
//  Tag.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/10/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

struct Tag {
    
    public var frames: [FrameKey : Frame]

    // handles the parsing of an ID3 tag
    init(readFrom file: Mp3File) throws {
        let fileData: Data = file.data
        var frames: [FrameKey : Frame] = [:]
        
        var remainder: Data.SubSequence = fileData[fileData.startIndex..<fileData.endIndex]
        
        let tagProperties = TagProperties(for: file)
        let tagValidator = TagValidator(for: file)
        
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
            _ = try tagProperties.size(data: tagSizeData, version: version)
        }
        
        while !remainder.isEmpty {
            let identifierBytes = remainder.extractFirst(version.identifierLength)
            let identifier = identifierBytes.stringUTF8 ?? "TXXX"
            // bytes are not ASCII (86 35 a0 0)
            let frame = try Frame(
                identifier: identifier,
                data: &remainder,
                version: version)
            
            let frameKey = frame.frameKey
            frames = [frameKey : frame]
        }
        self.frames = frames
    }
    
    
    
    
    
}
