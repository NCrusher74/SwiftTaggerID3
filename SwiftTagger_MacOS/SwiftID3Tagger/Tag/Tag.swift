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
        var tagSize: Data.Index = 0
        var version: Version = .v2_4
        // validate file
        if file.location.fileExtension.lowercased() != "mp3" {
            throw Mp3File.Error.InvalidFileFormat
        } else {
            // parse version from tag header
            // the first five bytes of a valid ID3 Tag are "ID3"+ the version number in UInt8
            let versionData = remainder.extractFirst(properties.versionDeclarationLength)
            version = try properties.version(data: versionData)
            // parse flags from tag header
            _ = remainder.extractFirst(properties.tagFlagsLength)
            // parse size from tag header
            let tagSizeData = remainder.extractFirst(properties.tagSizeDeclarationLength)
            tagSize = try properties.size(data: tagSizeData)
            print(tagSize)
        }

        let tagDataRange = remainder.startIndex ..< remainder.startIndex + tagSize
        remainder = remainder.subdata(in: tagDataRange)

        var frames: [FrameKey : Frame] = [:]
        while !remainder.isEmpty  {
            print(remainder.count)
            let identifierBytes = remainder.extractFirst(version.identifierLength)
            if identifierBytes.first == 0x00 { break } // Padding, not a frame.
            let identifier = try String(ascii: identifierBytes)
            print(identifier)
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
