/*

 SwiftTaggerMp3_PartOfTotalFrame_Tests.swift
 SwiftTaggerID3

 Copyright ©2020 Nolaine Crusher. All rights reserved.

 */

import XCTest
import SwiftTaggerID3

@available(OSX 10.12, *)
class SwiftTaggerMp3_PartOfTotalFrame_Tests: XCTestCase {
    
    // PartOfTotalFrame tests
    func testWithBothValuesWrittenOnBlankFile() throws {
        var blankTag = try tagNoMeta()

        // Test when both values are valid - v22
        blankTag.discNumber?.disc = 4
        blankTag.discNumber?.totalDiscs = 5
        blankTag.trackNumber?.track = 6
        blankTag.trackNumber?.totalTracks = 7
        
        // test V22
        let outputUrlv22 = try tempDirectory().appendingPathComponent("testV22PartOfTotal.mp3")
        XCTAssertNoThrow(try mp3NoMeta().write(tagVersion: .v2_2,
                                            using: blankTag,
                                            writingTo: outputUrlv22))
        let mp3UrlWrittenV22 = outputUrlv22
        let mp3FileWrittenV22 = try Mp3File(location: mp3UrlWrittenV22)
        let tagWrittenV22 = try Tag(readFrom: mp3FileWrittenV22)
        
        XCTAssertEqual(tagWrittenV22.discNumber?.disc, 4)
        XCTAssertEqual(tagWrittenV22.discNumber?.totalDiscs, 5)
        XCTAssertEqual(tagWrittenV22.trackNumber?.track, 6)
        XCTAssertEqual(tagWrittenV22.trackNumber?.totalTracks, 7)
        
        // test V23
        let outputUrlv23 = try tempDirectory().appendingPathComponent("testV23PartOfTotal.mp3")
        XCTAssertNoThrow(try mp3NoMeta().write(tagVersion: .v2_3,
                                            using: blankTag,
                                            writingTo: outputUrlv23))
        let mp3UrlWrittenV23 = outputUrlv23
        let mp3FileWrittenV23 = try Mp3File(location: mp3UrlWrittenV23)
        let tagWrittenV23 = try Tag(readFrom: mp3FileWrittenV23)
        
        XCTAssertEqual(tagWrittenV23.discNumber?.disc, 4)
        XCTAssertEqual(tagWrittenV23.discNumber?.totalDiscs, 5)
        XCTAssertEqual(tagWrittenV23.trackNumber?.track, 6)
        XCTAssertEqual(tagWrittenV23.trackNumber?.totalTracks, 7)

        // test V24
        let outputUrlv24 = try tempDirectory().appendingPathComponent("testV24PartOfTotal.mp3")
        XCTAssertNoThrow(try mp3NoMeta().write(tagVersion: .v2_4,
                                            using: blankTag,
                                            writingTo: outputUrlv24))
        let mp3UrlWrittenV24 = outputUrlv24
        let mp3FileWrittenV24 = try Mp3File(location: mp3UrlWrittenV24)
        let tagWrittenV24 = try Tag(readFrom: mp3FileWrittenV24)
        
        XCTAssertEqual(tagWrittenV24.discNumber?.disc, 4)
        XCTAssertEqual(tagWrittenV24.discNumber?.totalDiscs, 5)
        XCTAssertEqual(tagWrittenV24.trackNumber?.track, 6)
        XCTAssertEqual(tagWrittenV24.trackNumber?.totalTracks, 7)
    }

    #warning("CAUSES OUT OF BOUNDS ERROR FOR SECOND VALUE")
    /*

     // PartOfTotalFrame tests
    func testWithOneValueWrittenOnBlankFile() throws {
        let mp3Blank = try Bundle.mp3NoMeta()
        var blankTag = try Tag(readFrom: mp3Blank)
        
        // Test when both values are valid - v22
        blankTag.discNumber?.disc = 4
        blankTag.trackNumber?.track = 6
        
        // test V22
     let outputUrlv22 = try tempDirectory().appendingPathComponent("testV22PartOfTotal.mp3")
        XCTAssertNoThrow(try mp3Blank.write(tagVersion: .v2_2,
                                            using: blankTag,
                                            writingTo: outputUrlV22))
        let mp3UrlWrittenV22 = outputUrlV22
        let mp3FileWrittenV22 = try Mp3File(location: mp3UrlWrittenV22)
        let tagWrittenV22 = try Tag(readFrom: mp3FileWrittenV22)
        
        XCTAssertEqual(tagWrittenV22.discNumber?.disc, 4)
        XCTAssertNil(tagWrittenV22.discNumber?.totalDiscs)
        XCTAssertEqual(tagWrittenV22.trackNumber?.track, 6)
        XCTAssertNil(tagWrittenV22.trackNumber?.totalTracks)
        
        // test V23
     let outputUrlv23 = try tempDirectory().appendingPathComponent("testV23PartOfTotal.mp3")
        XCTAssertNoThrow(try mp3Blank.write(tagVersion: .v2_3,
                                            using: blankTag,
                                            writingTo: outputUrlV23))
        let mp3UrlWrittenV23 = outputUrlV23
        let mp3FileWrittenV23 = try Mp3File(location: mp3UrlWrittenV23)
        let tagWrittenV23 = try Tag(readFrom: mp3FileWrittenV23)
        
        XCTAssertEqual(tagWrittenV23.discNumber?.disc, 4)
        XCTAssertNil(tagWrittenV23.discNumber?.totalDiscs)
        XCTAssertEqual(tagWrittenV23.trackNumber?.track, 6)
        XCTAssertNil(tagWrittenV23.trackNumber?.totalTracks)
        
        // test V23
     let outputUrlv24 = try tempDirectory().appendingPathComponent("testV24PartOfTotal.mp3")
        XCTAssertNoThrow(try mp3Blank.write(tagVersion: .v2_4,
                                            using: blankTag,
                                            writingTo: outputUrlV24))
        let mp3UrlWrittenV24 = outputUrlV24
        let mp3FileWrittenV24 = try Mp3File(location: mp3UrlWrittenV24)
        let tagWrittenV24 = try Tag(readFrom: mp3FileWrittenV24)
        
        XCTAssertEqual(tagWrittenV24.discNumber?.disc, 4)
        XCTAssertNil(tagWrittenV24.discNumber?.totalDiscs)
        XCTAssertEqual(tagWrittenV24.trackNumber?.track, 6)
        XCTAssertNil(tagWrittenV24.trackNumber?.totalTracks)
    }*/
    
    func testOverwriting() throws {
        var v22Tag = try tagv22()
        // Test when both values are valid - v22
        v22Tag.discNumber?.disc = 4
        v22Tag.discNumber?.totalDiscs = 5
        v22Tag.trackNumber?.track = 6
        v22Tag.trackNumber?.totalTracks = 7
        
        // test V22
        let outputUrlv22 = try tempDirectory().appendingPathComponent("testV22PartOfTotal.mp3")
        XCTAssertNoThrow(try mp3v22().write(tagVersion: .v2_2,
                                            using: v22Tag,
                                            writingTo: outputUrlv22))
        let mp3UrlWrittenV22 = outputUrlv22
        let mp3FileWrittenV22 = try Mp3File(location: mp3UrlWrittenV22)
        let tagWrittenV22 = try Tag(readFrom: mp3FileWrittenV22)
        
        XCTAssertEqual(tagWrittenV22.discNumber?.disc, 4)
        XCTAssertEqual(tagWrittenV22.discNumber?.totalDiscs, 5)
        XCTAssertEqual(tagWrittenV22.trackNumber?.track, 6)
        XCTAssertEqual(tagWrittenV22.trackNumber?.totalTracks, 7)
        
        // test V23
        var v23Tag = try tagv23()
        
        // Test when both values are valid - v22
        v23Tag.discNumber?.disc = 4
        v23Tag.discNumber?.totalDiscs = 5
        v23Tag.trackNumber?.track = 6
        v23Tag.trackNumber?.totalTracks = 7
        
        let outputUrlv23 = try tempDirectory().appendingPathComponent("testV23PartOfTotal.mp3")
        XCTAssertNoThrow(try mp3v23().write(tagVersion: .v2_3,
                                            using: v23Tag,
                                            writingTo: outputUrlv23))
        let mp3UrlWrittenV23 = outputUrlv23
        let mp3FileWrittenV23 = try Mp3File(location: mp3UrlWrittenV23)
        let tagWrittenV23 = try Tag(readFrom: mp3FileWrittenV23)
        
        XCTAssertEqual(tagWrittenV23.discNumber?.disc, 4)
        XCTAssertEqual(tagWrittenV23.discNumber?.totalDiscs, 5)
        XCTAssertEqual(tagWrittenV23.trackNumber?.track, 6)
        XCTAssertEqual(tagWrittenV23.trackNumber?.totalTracks, 7)
        
        // test V24
        var v24Tag = try tagv24()
        
        // Test when both values are valid - v22
        v24Tag.discNumber?.disc = 4
        v24Tag.discNumber?.totalDiscs = 5
        v24Tag.trackNumber?.track = 6
        v24Tag.trackNumber?.totalTracks = 7
        
        let outputUrlv24 = try tempDirectory().appendingPathComponent("testV24PartOfTotal.mp3")
        XCTAssertNoThrow(try mp3v24().write(tagVersion: .v2_4,
                                            using: v24Tag,
                                            writingTo: outputUrlv24))
        let mp3UrlWrittenV24 = outputUrlv24
        let mp3FileWrittenV24 = try Mp3File(location: mp3UrlWrittenV24)
        let tagWrittenV24 = try Tag(readFrom: mp3FileWrittenV24)
        
        XCTAssertEqual(tagWrittenV24.discNumber?.disc, 4)
        XCTAssertEqual(tagWrittenV24.discNumber?.totalDiscs, 5)
        XCTAssertEqual(tagWrittenV24.trackNumber?.track, 6)
        XCTAssertEqual(tagWrittenV24.trackNumber?.totalTracks, 7)
    }

    
}
