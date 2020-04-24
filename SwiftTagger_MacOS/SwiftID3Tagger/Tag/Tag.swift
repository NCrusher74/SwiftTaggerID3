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
        let properties = TagProperties()
        let fileData: Data = file.data
        var remainder: Data.SubSequence = fileData[fileData.startIndex..<fileData.endIndex]
        
        var version: Version = .v2_4
        // validate file
        if file.location.fileExtension.lowercased() != "mp3" {
            throw Mp3File.Error.InvalidFileFormat
        } else {
            // parse version from tag header
            // the first five bytes of a valid ID3 Tag are "ID3"+ the version number in UInt8
            let versionData = remainder.extractFirst(properties.versionDeclarationLength)
            version = try properties.version(data: versionData)
//            print(version) - checks .v2_3
            // parse flags from tag header
            _ = remainder.extractFirst(properties.tagFlagsLength)
//            print(flags.hexadecimal()) 0 - checks
            // parse size from tag header
            let tagSizeData = remainder.extractFirst(properties.tagSizeDeclarationLength)
//            print(tagSizeData.hexadecimal()) - 0 0 1e 3b / 0 0 30 59 -- I don't know
            _ = try properties.size(data: tagSizeData, version: version)
//            print(tagSize) - 7739 (according to Yate should be 3909? -- how do we go from (0 0 30 59) to 7739?
        }
        
        var frames: [FrameKey : Frame] = [:]
        while !remainder.isEmpty {
            let identifierBytes = remainder.extractFirst(version.identifierLength)
//            print(identifierBytes.hexadecimal()) - 54 49 54 32 / TIT2, exactly right
            let identifier = try String(ascii: identifierBytes)
//            print(identifier) - TIT2, exactly right
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
