//
//  File.swift
//
//
//  Created by Nolaine Crusher on 9/19/20.
//

import Foundation

import XCTest
@testable import SwiftTaggerID3

// Tests for chapter frame and CTOC frame
class SwiftTaggerID3_Misc_Tests: XCTestCase {

    let testString = "Trên Tình Bạn Dưới Tình Yêu"
    
    func testV24() throws {
        var tag = tagNoMeta
        
        tag.album = testString
        tag.albumArtist = testString
        tag.albumSort = testString
        tag.albumArtistSort = testString
        tag.arranger = testString
        tag.artist = testString
        tag.artistSort = testString
        tag.composer = testString
        tag.composerSort = testString
        tag.conductor = testString
        tag.contentGroup = testString
        tag.encodedBy = testString
        tag.encodingSettings = testString
        tag.fileOwner = testString
        tag.grouping = testString
        tag.lyricist = testString
        tag.mood = testString
        tag.movement = testString
        tag.originalAlbum = testString
        tag.originalArtist = testString
        tag.originalFilename = testString
        tag.originalLyricist = testString
        tag.podcastID = testString
        tag.podcastFeed = testString
        tag.podcastCategory = testString
        tag.podcastDescription = testString
        tag.podcastKeywords = [testString]
        tag.publisher = testString
        tag.radioStation = testString
        tag.radioStationOwner = testString
        tag.subtitle = testString
        tag.setSubtitle = testString
        tag.title = testString
        tag.titleSort = testString
        
        //        let outputUrl = tempOutputDirectory
        let outputUrl = localOutputDirectory
        XCTAssertNoThrow(try mp3NoMeta.write(tag: &tag,
                                             version: .v2_4,
                                             outputLocation: outputUrl))
        
        
        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try Tag(mp3File: outputMp3)
        
        XCTAssertEqual(output.album, testString)
        XCTAssertEqual(output.albumArtist, testString)
        XCTAssertEqual(output.albumArtistSort, testString)
        XCTAssertEqual(output.albumSort, testString)
        XCTAssertEqual(output.arranger, testString)
        XCTAssertEqual(output.artist, testString)
        XCTAssertEqual(output.artistSort, testString)
        XCTAssertEqual(output.composer, testString)
        XCTAssertEqual(output.composerSort, testString)
        XCTAssertEqual(output.conductor, testString)
        XCTAssertEqual(output.contentGroup, testString)
        XCTAssertEqual(output.encodedBy, testString)
        XCTAssertEqual(output.encodingSettings, testString)
        XCTAssertEqual(output.fileOwner, testString)
        XCTAssertEqual(output.grouping, testString)
        XCTAssertEqual(output.lyricist, testString)
        XCTAssertEqual(output.mood, testString)
        XCTAssertEqual(output.movement, testString)
        XCTAssertEqual(output.originalAlbum, testString)
        XCTAssertEqual(output.originalArtist, testString)
        XCTAssertEqual(output.originalFilename, testString)
        XCTAssertEqual(output.originalLyricist, testString)
        XCTAssertEqual(output.podcastCategory, testString)
        XCTAssertEqual(output.podcastDescription, testString)
        XCTAssertEqual(output.podcastFeed, testString)
        XCTAssertEqual(output.podcastID, testString)
        XCTAssertEqual(output.podcastKeywords, [testString])
        XCTAssertEqual(output.publisher, testString)
        XCTAssertEqual(output.radioStation, testString)
        XCTAssertEqual(output.radioStationOwner, testString)
        XCTAssertEqual(output.setSubtitle, testString)
        XCTAssertEqual(output.subtitle, testString)
        XCTAssertEqual(output.title, testString)
        XCTAssertEqual(output.titleSort, testString)
        XCTAssertEqual(output.work, testString)
    }
    
    func testLocalizedFrame() throws {
        var tag = tagNoMeta

        tag[comment: testString, .eng] = testString
        tag[lyrics: testString, .eng] = testString
        tag[testString] = testString

        //        let outputUrl = tempOutputDirectory
        let outputUrl = localOutputDirectory
        XCTAssertNoThrow(try mp3NoMeta.write(tag: &tag,
                                             version: .v2_4,
                                             outputLocation: outputUrl))
        
        
        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try Tag(mp3File: outputMp3)

        XCTAssertEqual(output[comment: testString, .eng], testString)
        XCTAssertEqual(output[lyrics: testString, .eng], testString)
        XCTAssertEqual(output[testString], testString)
    }
    
    func testV23Writing() throws {
        var tag = tagNoMeta
        
        tag.album = testString
        tag.albumArtist = testString
        tag.albumSort = testString
        tag.albumArtistSort = testString
        tag.arranger = testString
        tag.artist = testString
        tag.artistSort = testString
        tag.composer = testString
        tag.composerSort = testString
        tag.conductor = testString
        tag.contentGroup = testString
        tag.encodedBy = testString
        tag.encodingSettings = testString
        tag.fileOwner = testString
        tag.grouping = testString
        tag.lyricist = testString
        tag.movement = testString
        tag.originalAlbum = testString
        tag.originalArtist = testString
        tag.originalFilename = testString
        tag.originalLyricist = testString
        tag.podcastID = testString
        tag.podcastCategory = testString
        tag.podcastFeed = testString
        tag.podcastDescription = testString
        tag.podcastKeywords = [testString, testString]
        tag.publisher = testString
        tag.radioStation = testString
        tag.radioStationOwner = testString
        tag.subtitle = testString
        tag.title = testString
        tag.titleSort = testString
                
        //let outputUrl = tempOutputDirectory
        let outputUrl = localOutputDirectory
        XCTAssertNoThrow(try mp3NoMeta.write(tag: &tag, version: .v2_3, outputLocation: outputUrl))
        
        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try Tag(mp3File: outputMp3)
        
        XCTAssertEqual(output.album, testString)
        XCTAssertEqual(output.albumArtist, testString)
        XCTAssertEqual(output.albumArtistSort, testString)
        XCTAssertEqual(output.albumSort, testString)
        XCTAssertEqual(output.arranger, testString)
        XCTAssertEqual(output.artist, testString)
        XCTAssertEqual(output.artistSort, testString)
        XCTAssertEqual(output.composer, testString)
        XCTAssertEqual(output.composerSort, testString)
        XCTAssertEqual(output.conductor, testString)
        XCTAssertEqual(output.contentGroup, testString)
        XCTAssertEqual(output.encodedBy, testString)
        XCTAssertEqual(output.encodingSettings, testString)
        XCTAssertEqual(output.fileOwner, testString)
        XCTAssertEqual(output.grouping, testString)
        XCTAssertEqual(output.lyricist, testString)
        XCTAssertEqual(output.movement, testString)
        XCTAssertEqual(output.originalAlbum, testString)
        XCTAssertEqual(output.originalArtist, testString)
        XCTAssertEqual(output.originalFilename, testString)
        XCTAssertEqual(output.originalLyricist, testString)
        XCTAssertEqual(output.podcastCategory, testString)
        XCTAssertEqual(output.podcastDescription, testString)
        XCTAssertEqual(output.podcastFeed, testString)
        XCTAssertEqual(output.podcastID, testString)
        XCTAssertEqual(output.podcastKeywords, [testString, testString])
        XCTAssertEqual(output.publisher, testString)
        XCTAssertEqual(output.radioStation, testString)
        XCTAssertEqual(output.radioStationOwner, testString)
        XCTAssertEqual(output.subtitle, testString)
        XCTAssertEqual(output.title, testString)
        XCTAssertEqual(output.titleSort, testString)
        XCTAssertEqual(output.work, testString)
    }
    
    // Test writing, and accuracy of written data, version 2.2
    func testV22Writing() throws {
        var tag = tagNoMeta
        
        tag.album = testString
        tag.albumArtist = testString
        tag.albumSort = testString
        tag.albumArtistSort = testString
        tag.arranger = testString
        tag.artist = testString
        tag.artistSort = testString
        tag.composer = testString
        tag.composerSort = testString
        tag.conductor = testString
        tag.contentGroup = testString
        tag.encodedBy = testString
        tag.encodingSettings = testString
        tag.lyricist = testString
        tag.originalAlbum = testString
        tag.originalArtist = testString
        tag.originalFilename = testString
        tag.originalLyricist = testString
        tag.publisher = testString
        tag.radioStation = testString
        tag.radioStationOwner = testString
        tag.subtitle = testString
        tag.title = testString
        tag.titleSort = testString
        
        //let outputUrl = tempOutputDirectory
        let outputUrl = localOutputDirectory
        XCTAssertNoThrow(try mp3NoMeta.write(tag: &tag, version: .v2_2, outputLocation: outputUrl))
        
        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try Tag(mp3File: outputMp3)
        
        XCTAssertEqual(output.album, testString)
        XCTAssertEqual(output.albumArtist, testString)
        XCTAssertEqual(output.albumArtistSort, testString)
        XCTAssertEqual(output.albumSort, testString)
        XCTAssertEqual(output.arranger, testString)
        XCTAssertEqual(output.artist, testString)
        XCTAssertEqual(output.artistSort, testString)
        XCTAssertEqual(output.composer, testString)
        XCTAssertEqual(output.composerSort, testString)
        XCTAssertEqual(output.conductor, testString)
        XCTAssertEqual(output.contentGroup, testString)
        XCTAssertEqual(output.encodedBy, testString)
        XCTAssertEqual(output.encodingSettings, testString)
        XCTAssertEqual(output.lyricist, testString)
        XCTAssertEqual(output.originalAlbum, testString)
        XCTAssertEqual(output.originalArtist, testString)
        XCTAssertEqual(output.originalFilename, testString)
        XCTAssertEqual(output.originalLyricist, testString)
        XCTAssertEqual(output.publisher, testString)
        XCTAssertEqual(output.radioStation, testString)
        XCTAssertEqual(output.radioStationOwner, testString)
        XCTAssertEqual(output.subtitle, testString)
        XCTAssertEqual(output.title, testString)
        XCTAssertEqual(output.titleSort, testString)
        XCTAssertEqual(output.work, testString)
    }

    func testSamples() throws {
        let sample1Path = "/Users/nolainecrusher/Downloads/NEW FOLDER/Magic System - 1er Gaou.mp3"
        let sample2Path = "/Users/nolainecrusher/Downloads/NEW FOLDER/Travis Scott - SICKO MODE.mp3"
        
        let sample1Url = URL(fileURLWithPath: sample1Path)
        let sample2Url = URL(fileURLWithPath: sample2Path)
        
        let sample1File = try Mp3File(location: sample1Url)
        let sample2File = try Mp3File(location: sample2Url)
        
        let samplePic = URL(fileURLWithPath: "/Users/nolainecrusher/Downloads/audiobook/testfiles/covers/SampleCoverPurple.jpg")
        var tag = try sample1File.tag()
        try tag.set(attachedPicture: .frontCover, imageLocation: samplePic, description: "Description")
        try sample1File.write(tag: &tag, version: .v2_4, outputLocation: URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/TestOutput/sample1.mp3"))
    }
}
