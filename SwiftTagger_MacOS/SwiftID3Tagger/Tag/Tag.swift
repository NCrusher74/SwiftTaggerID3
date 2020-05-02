//
//  Tag.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/10/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation
import Cocoa

/// A type representing an ID3 tag to be read from or written to a file
public struct Tag {
    
    var frames: [FrameKey : Frame]
    
    init(readFromEmbeddedSubframes subframes: [FrameKey:Frame]) {
        self.frames = subframes
    }
    
    /// handles the parsing of an ID3 tag
    init(readFrom file: Mp3File) throws {
        // a type containing tag-level properties and methods for querying tag-level information
        let properties = TagProperties()
        
        // the data derived from the input file
        let fileData: Data = file.data
        
        // the file data as a data subsequence
        var remainder: Data.SubSequence = fileData[fileData.startIndex..<fileData.endIndex]
        
        // initialized variables for tagSize and Version
        var tagSize: Data.Index = 0
        var version: Version = .v2_4
        
        // validate file is an mp3 file
        if file.location.pathExtension.lowercased() != "mp3" {
            throw Mp3File.Error.InvalidFileFormat
        } else {
            // parse version data from tag header
            // the first five bytes of a valid ID3 Tag are "ID3"+ the version number in UInt8
            let versionData = remainder.extractFirst(properties.versionDeclarationLength)
            version = try properties.version(data: versionData)
            // parse flags from tag header. This data is generally unused and use of this data is not supported by SwiftTagger
            _ = remainder.extractFirst(properties.tagFlagsLength)
            // parse size from tag header
            let tagSizeData = remainder.extractFirst(properties.tagSizeDeclarationLength)
            tagSize = try properties.size(data: tagSizeData)
        }
        
        // set range of tag data using tag size as the upper bound
        let tagDataRange = remainder.startIndex ..< remainder.startIndex + tagSize
        remainder = remainder.subdata(in: tagDataRange)
        
        // parse frames from remaining tag data
        var frames: [FrameKey : Frame] = [:]
        while !remainder.isEmpty  {
            // extract frame identifier data
            let identifierBytes = remainder.extractFirst(version.identifierLength)
            // check to be sure the data is a frame
            if identifierBytes.first == 0x00 { break } // Padding, not a frame.
            // convert data to string
            let identifier = try String(ascii: identifierBytes)
            // hand the data over to `Frame` to decide which frame handler it goes to
            let frame = try Frame(
                identifier: identifier,
                data: &remainder,
                version: version)
            
            // used parsed frame data to get frame key
            let frameKey = frame.frameKey
            // add frame and framekey to frames dictionary
            frames[frameKey] = frame
        }
        self.frames = frames
    }
    
    func buildTagHeader(version: Version) throws -> Data {
        var headerData = Data()
        switch version {
            case .v2_2:
                headerData.append(contentsOf: TagProperties().v2_2Bytes)
            case .v2_3:
                headerData.append(contentsOf: TagProperties().v2_3Bytes)
            case .v2_4:
                headerData.append(contentsOf: TagProperties().v2_4Bytes)
        }
        headerData.append(contentsOf: TagProperties().defaultFlag)
        headerData.append(contentsOf: (try TagProperties().calculateNewTagSize(data: self.framesData(version: version))))
        return headerData
    }
    
    func framesData(version: Version) throws -> Data {
        var framesData = Data()
        for frame in self.frames.values {
            framesData.append(try frame.getFramesData(version: version))
        }
        return framesData
    }
    
    func buildTag(version: Version) throws -> Data {
        var tagData = Data()
        tagData.append(try buildTagHeader(version: version))
        tagData.append(try self.framesData(version: version))
        return tagData
    }
}
