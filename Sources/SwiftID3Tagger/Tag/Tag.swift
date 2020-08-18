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
    
    static var metadataWithDifferentiatingElement = [(frameKey: FrameKey, differentiatingElement: String, value: Any)]()
    
    @available(OSX 10.12, *)
    public func listMetadata() -> [(frameKey: FrameKey, value: Any)] {
        var metadata = [(FrameKey, value: Any)]()
        var frameKeys = [FrameKey]()

        for frame in self.frames {
            let frameKey = frame.key
            frameKeys.append(frameKey)
        }

        for frameKey in frameKeys {
            let frameKey = frameKey
            var value: Any? = nil
            if frameKey == .album {
                if let frameValue = self.album {
                    value = frameValue
                }
            } else if frameKey == .albumSort {
                if let frameValue = self.albumSort {
                    value = frameValue
                }
            } else if frameKey == .albumArtist {
                if let frameValue = self.albumArtist {
                    value = frameValue
                }
            } else if frameKey == .albumArtistSort {
                if let frameValue = self.albumArtistSort {
                    value = frameValue
                }
            } else if frameKey == .arranger {
                if let frameValue = self.arranger {
                    value = frameValue
                }
                if let frameValue = self.remixer {
                    value = frameValue
                }
                if let frameValue = self.interpretedBy {
                    value = frameValue
                }
            } else if frameKey == .artist {
                if let frameValue = self.artist {
                    value = frameValue
                }
                if let frameValue = self.author {
                    value = frameValue
                }
            } else if frameKey == .artistSort {
                if let frameValue = self.artistSort {
                    value = frameValue
                }
                if let frameValue = self.authorSort {
                    value = frameValue
                }
            } else if frameKey == .artistWebpage {
                if let frameValue = self.artistWebpage {
                    value = frameValue
                }
            } else if frameKey == .audioFileWebpage {
                if let frameValue = self.audioFileWebpage {
                    value = frameValue
                }
            } else if frameKey == .audioSourceWebpage {
                if let frameValue = self.audioSourceWebpage {
                    value = frameValue
                }
            } else if frameKey == .bpm {
                if let frameValue = self.bpm {
                    value = frameValue
                }
            } else if frameKey == .compilation {
                if let frameValue = self.compilation {
                    value = frameValue
                }
            } else if frameKey == .composer {
                if let frameValue = self.composer {
                    value = frameValue
                }
                if let frameValue = self.narrator {
                    value = frameValue
                }
            } else if frameKey == .composerSort {
                if let frameValue = self.composerSort {
                    value = frameValue
                }
                if let frameValue = self.narratorSort {
                    value = frameValue
                }
            } else if frameKey == .conductor {
                if let frameValue = self.conductor {
                    value = frameValue
                }
            } else if frameKey == .contentGroup {
                if let frameValue = self.contentGroup {
                    value = frameValue
                }
                if let frameValue = self.work {
                    value = frameValue
                }
                if let frameValue = self.series {
                    value = frameValue
                }
            } else if frameKey == .copyright {
                if let frameValue = self.copyright {
                    value = frameValue
                }
            } else if frameKey == .copyrightWebpage {
                if let frameValue = self.copyrightWebpage {
                    value = frameValue
                }
            } else if frameKey == .date {
                if let frameValue = self.date {
                    value = frameValue
                }
            } else if frameKey == .discNumber {
                if let frameValue = self.discNumber {
                    value = frameValue
                }
            } else if frameKey == .encodingTime {
                if let frameValue = self.encodingDateTime {
                    value = frameValue
                }
            } else if frameKey == .encodedBy {
                if let frameValue = self.encodedBy {
                    value = frameValue
                }
            } else if frameKey == .encodingSettings {
                if let frameValue = self.encodingSettings {
                    value = frameValue
                }
            } else if frameKey == .fileType {
                if let frameValue = self.fileType {
                    value = frameValue
                }
            } else if frameKey == .fileOwner {
                if let frameValue = self.fileOwner {
                    value = frameValue
                }
            } else if frameKey == .genre {
                if let frameValue = self.genre {
                    value = frameValue
                }
            } else if frameKey == .grouping {
                if let frameValue = self.grouping {
                    value = frameValue
                }
            } else if frameKey == .initialKey {
                if let frameValue = self.initialKey {
                    value = frameValue
                }
            } else if frameKey == .involvedPeopleList {
                if let frameValue = self.involvedPeopleList {
                    value = frameValue
                }
            } else if frameKey == .isrc {
                if let frameValue = self.isrc {
                    value = frameValue
                }
            } else if frameKey == .languages {
                if let frameValue = self.languages {
                    value = frameValue
                }
            } else if frameKey == .length {
                if let frameValue = self.length {
                    value = frameValue
                }
            } else if frameKey == .lyricist {
                if let frameValue = self.lyricist {
                    value = frameValue
                }
            } else if frameKey == .mediaType {
                if let frameValue = self.mediaType {
                    value = frameValue
                }
            } else if frameKey == .mood {
                if let frameValue = self.mood {
                    value = frameValue
                }
            } else if frameKey == .movementCount {
                if let frameValue = self.totalMovements {
                    value = frameValue
                }
            } else if frameKey == .movementName {
                if let frameValue = self.movementName {
                    value = frameValue
                }
            } else if frameKey == .movementNumber {
                if let frameValue = self.movementNumber {
                    value = frameValue
                }
            } else if frameKey == .musicianCreditsList {
                if let frameValue = self.musicianCreditsList {
                    value = frameValue
                }
            } else if frameKey == .originalAlbum {
                if let frameValue = self.originalAlbum {
                    value = frameValue
                }
            } else if frameKey == .originalArtist {
                if let frameValue = self.originalArtist {
                    value = frameValue
                }
            } else if frameKey == .originalFilename {
                if let frameValue = self.originalFilename {
                    value = frameValue
                }
            } else if frameKey == .originalLyricist {
                if let frameValue = self.originalLyricist {
                    value = frameValue
                }
            } else if frameKey == .originalReleaseTime {
                if let frameValue = self.originalReleaseTime {
                    value = frameValue
                }
            } else if frameKey == .paymentWebpage {
                if let frameValue = self.paymentWebpage {
                    value = frameValue
                }
            } else if frameKey == .playlistDelay {
                if let frameValue = self.playlistDelay {
                    value = frameValue
                }
            } else if frameKey == .podcastCategory {
                if let frameValue = self.podcastCategory {
                    value = frameValue
                }
            } else if frameKey == .podcastDescription {
                if let frameValue = self.podcastDescription {
                    value = frameValue
                }
            } else if frameKey == .podcastID {
                if let frameValue = self.podcastID {
                    value = frameValue
                }
            } else if frameKey == .podcastKeywords {
                if let frameValue = self.podcastKeywords {
                    value = frameValue
                }
            } else if frameKey == .podcastFeedLink {
                if let frameValue = self.podcastFeedLink {
                    value = frameValue
                }
            } else if frameKey == .producedNotice {
                if let frameValue = self.producedNotice {
                    value = frameValue
                }
            } else if frameKey == .publisher {
                if let frameValue = self.publisher {
                    value = frameValue
                }
                if let frameValue = self.studio {
                    value = frameValue
                }
                if let frameValue = self.label {
                    value = frameValue
                }
                if let frameValue = self.recordCompany {
                    value = frameValue
                }
            } else if frameKey == .publisherWebpage {
                if let frameValue = self.publisherWebpage {
                    value = frameValue
                }
            } else if frameKey == .radioStation {
                if let frameValue = self.radioStation {
                    value = frameValue
                }
            } else if frameKey == .radioStationOwner {
                if let frameValue = self.radioStationOwner {
                    value = frameValue
                }
            } else if frameKey == .radioStationWebpage {
                if let frameValue = self.radioStationWebpage {
                    value = frameValue
                }
            } else if frameKey == .recordingDate {
                if let frameValue = self.recordingDateTime {
                    value = frameValue
                }
            } else if frameKey == .releaseTime {
                if let frameValue = self.releaseDateTime {
                    value = frameValue
                }
            } else if frameKey == .setSubtitle {
                if let frameValue = self.setSubtitle {
                    value = frameValue
                }
            } else if frameKey == .subtitle {
                if let frameValue = self.subtitle {
                    value = frameValue
                }
            } else if frameKey == .taggingTime {
                if let frameValue = self.taggingDateTime {
                    value = frameValue
                }
            } else if frameKey == .time {
                if let frameValue = self.time {
                    value = frameValue
                }
            } else if frameKey == .title {
                if let frameValue = self.title {
                    value = frameValue
                }
            } else if frameKey == .titleSort {
                if let frameValue = self.titleSort {
                    value = frameValue
                }
            } else if frameKey == .trackNumber {
                if let frameValue = self.trackNumber {
                    value = frameValue
                }
            } else if frameKey == .year {
                if let frameValue = self.year {
                    value = frameValue
                }
            } else {
                continue
            }
            if let value = value {
                metadata.append((frameKey, value))
            }
        }
        
        for item in Tag.metadataWithDifferentiatingElement {
            metadata.append((item.frameKey, item.value))
        }
        return metadata
    }
    
    public mutating func removeAllMetadata() throws {
        self.frames = [:]
        Tag.metadataWithDifferentiatingElement = []
    }
}

