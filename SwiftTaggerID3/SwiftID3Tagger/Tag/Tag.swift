//
//  Tag.swift
//  SwiftTaggerID3
//
//  Created by Nolaine Crusher on 4/10/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation
import Cocoa

/// A type representing an ID3 tag contained in, or to be written to, an `Mp3File`
///
/// This wrapper houses methods and properties for parsing and constructing an ID3 tag
public struct Tag {
    
    /// The ID3 frames contained within the `Tag`
    var frames: [FrameKey : Frame]
    
    /** An internal intializer used by certain frame types.
     
        `TableOfContentsFrame` and `ChapterFrame` types may contain optional embedded subframes, such as a `TitleFrame` or `ImageFrame`.
     
        This initializer allows those subframes to be handled as a `Tag` instance so that they may be parsed and constructed using the same methods and properties as top-level frames.
     */
    init(readFromEmbeddedSubframes subframes: [FrameKey:Frame]) {
        self.frames = subframes
    }
    
    /** Initializes an ID3 tag, derives required data from the tag header, and instantiates the parsing of the frames within the tag. */
    /// - Parameter file: The `Mp3File` containing the tag data.
    /// - Throws: `InvalidFileFormat` if the `Mp3File` does not have a valid Mp3 file extension.
    init(readFrom file: Mp3File) throws {
        // a type containing tag-level properties and methods for querying tag-level information
        let properties = TagProperties()
        
        // the data derived from the Mp3File
        let fileData: Data = file.data
        
        // the file data as a data subsequence
        var remainder: Data.SubSequence = fileData[fileData.startIndex..<fileData.endIndex]
        
        // pre-initialized variables for tagSize and Version
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
            // parse flag from tag header. This data is generally unused and use of this data is not supported by SwiftTagger. We're just getting it out of the way here.
            _ = remainder.extractFirst(properties.tagFlagsLength)
            // parse tag size information from tag header to create an upper bound for frames parsing
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
            // convert identifier data to string
            let identifier = try String(ascii: identifierBytes)
            // hand the data over to `Frame` to decide which frame handler it should go to
            let frame = try Frame(
                identifier: identifier,
                data: &remainder,
                version: version)
            
            // used parsed frame data to get the frame key
            let frameKey = frame.frameKey
            // add frame and framekey to frames dictionary
            frames[frameKey] = frame
        }
        self.frames = frames
    }
    
    /// Constructs the 10-byte tag header consisting of 5 bytes of ID3 identifier data, 1 byte of flag data, and 4 bytes of size data.
    /// - Parameter version: The `Version` of the ID3 tag being created
    /// - Throws: Caller will determine how to handle any errors
    /// - Returns: The tag header as 10 bytes of `data`
    func buildTagHeader(version: Version) throws -> Data {
        var headerData = Data()
        // determine which version bytes to use
        switch version {
            case .v2_2:
                headerData.append(contentsOf: TagProperties().v2_2Bytes)
            case .v2_3:
                headerData.append(contentsOf: TagProperties().v2_3Bytes)
            case .v2_4:
                headerData.append(contentsOf: TagProperties().v2_4Bytes)
        }
        // append the flag byte, which for our purposes will always be `0x00`
        headerData.append(contentsOf: TagProperties().defaultFlag)
        // append the calculated size of the new tag's data
        headerData.append(contentsOf: (try TagProperties().calculateNewTagSize(data: self.framesData(version: version))))
        return headerData
    }
    
    /// Pulls all the data from all the frames together into the tag's contents data
    /// - Parameter version: The `Version` of the ID3 tag being created
    /// - Throws: Caller will determine how to handle any errors
    /// - Returns: `data` containing all the frames of the tag
    func framesData(version: Version) throws -> Data {
        var framesData = Data()
        for frame in self.frames.values {
            framesData.append(try frame.getFramesData(version: version))
        }
        return framesData
    }
    
    /// Construct a tag from the header data and the frames data
    /// - Parameter version: The `Version` of the ID3 tag being created
    /// - Throws: Caller will determine how to handle any errors
    /// - Returns: `data` containing the tag's header and contents
    func buildTag(version: Version) throws -> Data {
        var tagData = Data()
        tagData.append(try buildTagHeader(version: version))
        tagData.append(try self.framesData(version: version))
        return tagData
    }
}
