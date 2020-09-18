//
//  File.swift
//  
//
//  Created by Nolaine Crusher on 9/17/20.
//

import Foundation
import AVFoundation
import Cocoa

struct Tag {
    /*
     The first part of the ID3v2 tag is the 10 byte tag header, laid out
     as follows:
     
     ID3v2/file identifier      "ID3" -- 3 bytes
     ID3v2 version              $0x 00 -- 2 bytes
     ID3v2 flags                %abcd0000 -- 1 byte (Uint32) (for our purposes, this is always `0x00`)
     ID3v2 size             4 * %0xxxxxxx -- 4 bytes (Synchsafe Uint32)
     */
    var frames: [String: Frame]
    var duration: Int?
    
    /// Instantiate a tag by parsing from MP3 file data
    init(mp3File: Mp3File) throws {
        // initialize the duration of the MP3 file for use in length and chapter frames
        let asset = AVAsset(url: mp3File.location)
        let seconds = asset.duration.seconds
        self.duration = Int(seconds * 1000)

        // get the file data as a subsequence. As the data is parsed when reading a tag, it will be extracted from the subsequence, leaving the remainder instact to continue parsing
        var remainder: Data.SubSequence = mp3File.data[
            mp3File.data.startIndex ..< mp3File.data.endIndex]
        
        // parse the data containing version information out of the tag header data
        // the first five bytes of a valid ID3 tag ae "ID3" plus the version number
        // this strips out the version bytes and passes along the rest
        let versionData = remainder.extractFirst(versionBytesLength)
        guard versionData.count == 5 else {
            throw Mp3FileError.InvalidVersionData
        }
        let version = try Version(data: versionData)
        
        // parse the flag byte from the tag header
        // this data is not generally used, and SwiftTagger does not support modifying it
        // we're just getting it out of the way
        _ = remainder.extractFirst(tagFlagsLength)

        // parse tag size information from the tag header to create an upper bound for frames parsing
        // this strips out the size data and passes along the rest to be parsed
        let tagSizeData = remainder.extractFirst(tagSizeLength)        
        let encodedSize = (tagSizeData as NSData)
            .bytes.assumingMemoryBound(to: UInt32.self).pointee.bigEndian
        let tagSize = encodedSize.decodingSynchsafe().toInt

        // at this point the remainder should be all the frames data, without the 10-byte tag header
        // set range of frames data using tag size as the upper bound
        let tagDataRange = remainder.startIndex ..< remainder.startIndex + tagSize
        remainder = remainder.subdata(in: tagDataRange)

        // parse frames from the remaining tag data
        var frames: [String : Frame] = [:]

        while !remainder.isEmpty {
            // pass the frames data over to `Data.Subsequence` exension for parsing
            if let frame = try remainder.extractAndParseToFrame(version: version) {
                // get the frame key
                let frameKey = try frame.frameKey(version: version)
                // add frame to dictionary
                frames[frameKey] = frame
            }
        }
        self.frames = frames
    }

    /// Instantiate a "pseudo-tag" for use with chapter and table-of-contents embedded frame sub-frames
    init(subframes: [String: Frame]) throws {
        self.frames = subframes
    }
    
    /// Instantiate an empty tag
    public init() {
        self.frames = [:]
    }
    
    // MARK: - Tag Building Calculations
    /// Calculates the size of a `Tag` instance being created, which is the count of all the data of a tag, minus the header data, converted to UInt32 and returned as data
    /// - Parameter data: the data of the `Tag` being created
    /// - Throws: Caller will determine how to handle any errors
    /// - Returns: a four-byte synchsafe integer as a data slice containing the `Tag` size
    func calculateNewTagSize(data: Data) throws -> Data {
        return data.count.uInt32.encodingSynchsafe().beData
    }

    // MARK: - Known Tag Properties
    /// The known length of version declaration data in a valid ID3 tag header
    let versionBytesLength: Int = 5
    /// The known byte-count of a valid ID3 tag's UInt32 flag
    let tagFlagsLength: Int = 1
    /// The default flag for an ID3 tag.
    ///
    /// SwiftTaggerID3 does not support alteration of this byte
    let defaultFlag: Data = {
        let defaultTagFlagByte: [UInt8] = [0x00]
        return Data(defaultTagFlagByte)
    }()
    /// The known byte-count of a valid ID3 tag's UInt32 size declaration
    let tagSizeLength: Int = 4
    /// The known byte-count of a valid ID3 tag header
    /// This value may be used to validate ID3 tag header data, or to locate the tag's frame data
    let tagHeaderLength: Int = 10
    /// The known byte-offset of a valid ID3 tag's flag bytes
    /// This value may be used to validate ID3 tag header data, or to locate the known tag flag data
    let tagFlagsOffset: Data.Index = 5
    /// The known byte-offset of a valid ID3 tag's size declaration
    /// This value may be used to validate ID3 tag header data, or to locate the known tag size declaration data
    let tagSizeOffset: Data.Index = 6
    /// The known byte-offset of an ID3 tag's data after a valid tag header
    /// This value may be used to validate ID3 tag header data, or to locate the tag's frame data
    let frameDataOffset: Data.Index = 10
    

}
