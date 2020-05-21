/*

 Tag.swift
 SwiftTaggerID3

 Copyright ©2020 Nolaine Crusher. All rights reserved.

 */

import Foundation
import Cocoa

/// A type representing an ID3 tag contained in, or to be written to, an `Mp3File`
/// This wrapper houses methods and properties for parsing and constructing an ID3 tag
public struct Tag {
    
    /// The ID3 frames contained within the `Tag`
    var frames: [FrameKey: Frame]
    
    /// Instantiate an ID3 Tag from an Mp3File in order to parse frames data from the file
    /// - Parameter file: the mp3 file that is the source or destination for the ID3 tag
    /// - Throws: `InvalidVersionData` If there is not enough header data to parse a valid ID3 version from
    public init(readFrom file: Mp3File) throws {
        /// A type containing known data for an ID3 tag, used to calculate properties for the current `Tag`
        let properties = TagProperties()
        /// The data instance derived from an Mp3File
        let fileData: Data = file.data
        
        // get the file data as a subsequence. As the data is parsed when reading a tag, it will be extracted from the subsequence, leaving the remainder instact to continue parsing
        var remainder: Data.SubSequence = fileData[fileData.startIndex..<fileData.endIndex]
        
        // parse the data containing version information out of the tag header data
        // the first five bytes of a valid ID3 tag ae "ID3" plus the version number
        // this strips out the version bytes and passes along the rest
        let versionData = remainder.extractFirst(properties.versionDeclarationLength)
        guard versionData.count == 5 else {
            throw Mp3File.Error.InvalidVersionData
        }
        let version = try properties.version(data: versionData)
        
        // parse the flag byte from the tag header
        // this data is not generally used, and SwiftTagger does not support modifying it
        // we're just getting it out of the way
        _ = remainder.extractFirst(properties.tagFlagsLength)
        
        // parse tag size information from the tag header to create an upper bound for frames parsing
        // this strips out the size data and passes along the rest to be parsed
        let tagSizeData = remainder.extractFirst(properties.tagSizeDeclarationLength)
        let tagSize = try properties.size(data: tagSizeData, version: version)
        
        // at this point the remainder should be all the frames data, without the 10-byte tag header
        // set range of frames data using tag size as the upper bound
        let tagDataRange = remainder.startIndex ..< remainder.startIndex + tagSize
        remainder = remainder.subdata(in: tagDataRange)
        
        // parse frames from the remaining tag data
        var frames: [FrameKey : Frame] = [:]
        
        while !remainder.isEmpty {
            // extract the identifier data
            let identifierBytes = remainder.extractFirst(version.identifierLength)
            // if the first byte is 0x00, it's padding, not a frame
            guard identifierBytes.first != 0x00 else {
                break
            }
            // convert identifier data to string
            let identifier = try String(ascii: identifierBytes)
            // pass the frames data over to `Frame` to determine which frame type will handle it
            let frame = try Frame(identifier: identifier,
                                  data: &remainder,
                                  version: version)
            // get the frame key
            let frameKey = frame.frameKey
            // add frame to dictionary
            frames[frameKey] = frame
        }
        self.frames = frames
    }
    
    /// Construct a tag from the header data and the frames data
    /// - Parameter version: The `Version` of the ID3 tag being created
    /// - Throws: Caller will determine how to handle any errors
    /// - Returns: `data` containing the tag's header and contents
    func buildTag(version: Version) throws -> Data {
        var tagData = Data()
        tagData.append(try tagHeader(version: version))
        tagData.append(try framesData(version: version))
        return tagData
    }
    
    /// Constructs the 10-byte tag header consisting of 5 bytes of ID3 identifier data, 1 byte of flag data, and 4 bytes of size data.
    /// - Parameter version: The `Version` of the ID3 tag being created
    /// - Throws: Caller will determine how to handle any errors
    /// - Returns: The tag header as 10 bytes of `data`
    func tagHeader(version: Version) throws -> Data {
        var headerData = Data()
        let properties = TagProperties()
        // determine which version bytes to use
        switch version {
            case .v2_2:
                headerData.append(contentsOf: properties.v2_2Bytes)
            case .v2_3:
                headerData.append(contentsOf: properties.v2_3Bytes)
            case .v2_4:
                headerData.append(contentsOf: properties.v2_4Bytes)
        }
        // append the flag byte, which for our purposes will always be `0x00`
        headerData.append(contentsOf: properties.defaultFlag)
        // append the calculated size of the new tag's data
        headerData.append(contentsOf: (try properties.calculateNewTagSize(
            data: self.framesData(version: version))))
        return headerData
    }
    
    /// Pulls all the data from all the frames together into the tag's contents data
    /// - Parameter version: The `Version` of the ID3 tag being created
    /// - Throws: Caller will determine how to handle any errors
    /// - Returns: `data` containing all the frames of the tag
    func framesData(version: Version) throws -> Data {
        var framesData = Data()
        for frameKey in self.frames.keys {
            if let frame = self.frames[frameKey] {
                framesData.append(try frame.framesData(version: version))
            }
        }
        return framesData
    }
        
    init(subframes: [FrameKey: Frame]) {
        self.frames = subframes
    }
}
