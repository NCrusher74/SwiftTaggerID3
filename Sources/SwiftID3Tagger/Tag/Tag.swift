/*
 
 Tag.swift
 SwiftTaggerID3
 
 Copyright ©2020 Nolaine Crusher. All rights reserved.
 
 */

import Foundation
import AVFoundation
import Cocoa

/// A type representing an ID3 tag contained in, or to be written to, an `Mp3File`
/// This wrapper houses methods and properties for parsing and constructing an ID3 tag


public struct Tag: CustomStringConvertible {
    public var description: String {
        return "\(frames.values.description)"
    }
    
    /// The ID3 frames contained within the `Tag`
    var frames: [FrameKey: Frame]
    var mp3Duration: Int?
    
    /// Instantiate an ID3 Tag from an Mp3File in order to parse frames data from the file
    /// - Parameter file: the mp3 file that is the source or destination for the ID3 tag
    /// - Throws: `InvalidVersionData` If there is not enough header data to parse a valid ID3 version from
    @available(OSX 10.12, *)
    public init(readFrom file: Mp3File) throws {
        // A type containing known data for an ID3 tag, used to calculate properties for the current `Tag`
        let properties = TagProperties()
        // The data instance derived from an Mp3File
        let fileData = file.data
        
        // initialize the duration of the MP3 file for use in length and chapter frames
        let asset = AVAsset(url: file.location)
        let seconds = asset.duration.seconds
        self.mp3Duration = Int(seconds * 1000)
        
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
    
    // initializer for embedded subframes of Chapter and TOC frames
    init(subframes: [FrameKey: Frame]) {
        self.frames = subframes
    }
    
    // initializer for starting with a completely empty tag instead of importing from file
    public init() {
        self.frames = [:]
    }
    
    public static var listMetadata = [(frameKey: FrameKey, value: Any)]()
    
//    public func listMetadata() throws -> [(frameKey: FrameKey, value: Any)] {
//        var metadata = [(FrameKey, Any)]()
//        var frameKeys = [FrameKey]()
//        var localizedFrames = [Frame]()
//
//        for frame in self.frames {
//            let frameKey = frame.key
//            frameKeys.append(frameKey)
//        }
//
//        for frameKey in frameKeys {
//            if frameKey == .album {
//                if let value = self.album {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .albumSort {
//                if let value = self.albumSort {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .albumArtist {
//                if let value = self.albumArtist {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .albumArtistSort {
//                if let value = self.albumArtistSort {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .arranger {
//                if let value = self.arranger {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//                if let value = self.remixer {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//                if let value = self.interpretedBy {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .artist {
//                if let value = self.artist {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//                if let value = self.author {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .artistSort {
//                if let value = self.artistSort {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//                if let value = self.authorSort {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .artistWebpage {
//                if let value = self.artistWebpage {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .audioFileWebpage {
//                if let value = self.audioFileWebpage {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .audioSourceWebpage {
//                if let value = self.audioSourceWebpage {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .bpm {
//                if let value = self.bpm {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .compilation {
//                if let value = self.compilation {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .composer {
//                if let value = self.composer {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//                if let value = self.narrator {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .composerSort {
//                if let value = self.composerSort {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//                if let value = self.narratorSort {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .conductor {
//                if let value = self.conductor {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .contentGroup {
//                if let value = self.contentGroup {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//                if let value = self.work {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//                if let value = self.series {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .copyright {
//                if let value = self.copyright {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .copyrightWebpage {
//                if let value = self.copyrightWebpage {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .date {
//                if let value = self.date {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .discNumber {
//                if let value = self.discNumber {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .encodingTime {
//                if let value = self.encodingDateTime {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .encodedBy {
//                if let value = self.encodedBy {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .encodingSettings {
//                if let value = self.encodingSettings {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .fileType {
//                if let value = self.fileType {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .fileOwner {
//                if let value = self.fileOwner {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .genre {
//                if let value = self.genre {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .grouping {
//                if let value = self.grouping {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .initialKey {
//                if let value = self.initialKey {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .involvedPeopleList {
//                if let value = self.involvedPeopleList {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .isrc {
//                if let value = self.isrc {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .languages {
//                if let value = self.languages {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .length {
//                if let value = self.length {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .lyricist {
//                if let value = self.lyricist {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .mediaType {
//                if let value = self.mediaType {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .mood {
//                if let value = self.mood {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .movementCount {
//                if let value = self.totalMovements {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .movementName {
//                if let value = self.movementName {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .movementNumber {
//                if let value = self.movementNumber {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .musicianCreditsList {
//                if let value = self.musicianCreditsList {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .originalAlbum {
//                if let value = self.originalAlbum {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .originalArtist {
//                if let value = self.originalArtist {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .originalFilename {
//                if let value = self.originalFilename {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .originalLyricist {
//                if let value = self.originalLyricist {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .originalReleaseTime {
//                if let value = self.originalReleaseTime {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .paymentWebpage {
//                if let value = self.paymentWebpage {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .playlistDelay {
//                if let value = self.playlistDelay {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .podcastCategory {
//                if let value = self.podcastCategory {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .podcastDescription {
//                if let value = self.podcastDescription {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .podcastID {
//                if let value = self.podcastID {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .podcastKeywords {
//                if let value = self.podcastKeywords {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .podcastFeedLink {
//                if let value = self.podcastFeedLink {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .producedNotice {
//                if let value = self.producedNotice {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .publisher {
//                if let value = self.publisher {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//                if let value = self.studio {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//                if let value = self.label {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//                if let value = self.recordCompany {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .publisherWebpage {
//                if let value = self.publisherWebpage {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .radioStation {
//                if let value = self.radioStation {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .radioStationOwner {
//                if let value = self.radioStationOwner {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .radioStationWebpage {
//                if let value = self.radioStationWebpage {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .recordingDate {
//                if let value = self.recordingDateTime {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .releaseTime {
//                if let value = self.releaseDateTime {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .setSubtitle {
//                if let value = self.setSubtitle {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .subtitle {
//                if let value = self.subtitle {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .taggingTime {
//                if let value = self.taggingDateTime {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .time {
//                if let value = self.time {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .title {
//                if let value = self.title {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .titleSort {
//                if let value = self.titleSort {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .trackNumber {
//                if let value = self.trackNumber {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else if frameKey == .year {
//                if let value = self.year {
//                    let entry = (frameKey, value)
//                    metadata.append(entry)
//                }
//            } else {
//                continue
//            }
//        }
//
//        return metadata
//    }
}

