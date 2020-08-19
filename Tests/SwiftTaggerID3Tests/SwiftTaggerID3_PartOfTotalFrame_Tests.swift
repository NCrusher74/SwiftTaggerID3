/*

 SwiftTaggerID3_PartOfTotalFrame_Tests.swift
 SwiftTaggerID3

 Copyright ©2020 Nolaine Crusher. All rights reserved.

 */

import XCTest
import SwiftTaggerID3



class SwiftTaggerID3_PartOfTotalFrame_Tests: XCTestCase {
    
    @available(OSX 10.12, *)
    func testWithBothValuesWrittenOnBlankFile() throws {
        var tag = try TestFile.noMeta.tag()

        tag?.disc = 4
        tag?.totalDiscs = 5
        tag?.track = 6
        tag?.totalTracks = 7
        
        let outputUrlv22 = try tempDirectory().appendingPathComponent("testv22.mp3")
        XCTAssertNoThrow(try TestFile.noMeta.mp3File()?.write(
            tagVersion: .v2_2,
            using: tag ?? Tag(readFrom: Mp3File(location: TestFile.noMeta.url)),
            writingTo: outputUrlv22))
        let mp3UrlWrittenV22 = outputUrlv22
        let mp3FileWrittenV22 = try Mp3File(location: mp3UrlWrittenV22)
        let tagWrittenV22 = try Tag(readFrom: mp3FileWrittenV22)
        
        XCTAssertEqual(tagWrittenV22.disc, 4)
        XCTAssertEqual(tagWrittenV22.totalDiscs, 5)
        XCTAssertEqual(tagWrittenV22.track, 6)
        XCTAssertEqual(tagWrittenV22.totalTracks, 7)
        
        let outputUrlv23 = try tempDirectory().appendingPathComponent("testv23.mp3")
        XCTAssertNoThrow(try TestFile.noMeta.mp3File()?.write(
            tagVersion: .v2_3,
            using: tag ?? Tag(readFrom: Mp3File(location: TestFile.noMeta.url)),
            writingTo: outputUrlv23))
        let mp3UrlWrittenV23 = outputUrlv23
        let mp3FileWrittenV23 = try Mp3File(location: mp3UrlWrittenV23)
        let tagWrittenV23 = try Tag(readFrom: mp3FileWrittenV23)
        
        XCTAssertEqual(tagWrittenV23.disc, 4)
        XCTAssertEqual(tagWrittenV23.totalDiscs, 5)
        XCTAssertEqual(tagWrittenV23.track, 6)
        XCTAssertEqual(tagWrittenV23.totalTracks, 7)

        let outputUrlv24 = try tempDirectory().appendingPathComponent("testv24.mp3")
        XCTAssertNoThrow(try TestFile.noMeta.mp3File()?.write(tagVersion: .v2_4,
                                            using: tag ?? Tag(readFrom: Mp3File(location: TestFile.noMeta.url)),
                                            writingTo: outputUrlv24))
        let mp3UrlWrittenV24 = outputUrlv24
        let mp3FileWrittenV24 = try Mp3File(location: mp3UrlWrittenV24)
        let tagWrittenV24 = try Tag(readFrom: mp3FileWrittenV24)
        
        XCTAssertEqual(tagWrittenV24.disc, 4)
        XCTAssertEqual(tagWrittenV24.totalDiscs, 5)
        XCTAssertEqual(tagWrittenV24.track, 6)
        XCTAssertEqual(tagWrittenV24.totalTracks, 7)
    }

    @available(OSX 10.12, *)
    func testWithOneValueWrittenOnBlankFile() throws {
        var tag = try TestFile.noMeta.tag()
        
        tag?.disc = 4
        tag?.track = 6
        
     let outputUrlv22 = try tempDirectory().appendingPathComponent("testv22.mp3")
        XCTAssertNoThrow(try TestFile.noMeta.mp3File()?.write(tagVersion: .v2_2,
                                            using: tag ?? Tag(readFrom: Mp3File(location: TestFile.noMeta.url)),
                                            writingTo: outputUrlv22))
        let mp3UrlWrittenV22 = outputUrlv22
        let mp3FileWrittenV22 = try Mp3File(location: mp3UrlWrittenV22)
        let tagWrittenV22 = try Tag(readFrom: mp3FileWrittenV22)
        
        XCTAssertEqual(tagWrittenV22.disc, 4)
        XCTAssertNil(tagWrittenV22.totalDiscs)
        XCTAssertEqual(tagWrittenV22.track, 6)
        XCTAssertNil(tagWrittenV22.totalTracks)
        
     let outputUrlv23 = try tempDirectory().appendingPathComponent("testv23.mp3")
        XCTAssertNoThrow(try TestFile.noMeta.mp3File()?.write(tagVersion: .v2_3,
                                            using: tag ?? Tag(readFrom: Mp3File(location: TestFile.noMeta.url)),
                                            writingTo: outputUrlv23))
        let mp3UrlWrittenV23 = outputUrlv23
        let mp3FileWrittenV23 = try Mp3File(location: mp3UrlWrittenV23)
        let tagWrittenV23 = try Tag(readFrom: mp3FileWrittenV23)
        
        XCTAssertEqual(tagWrittenV23.disc, 4)
        XCTAssertNil(tagWrittenV23.totalDiscs)
        XCTAssertEqual(tagWrittenV23.track, 6)
        XCTAssertNil(tagWrittenV23.totalTracks)
        
     let outputUrlv24 = try tempDirectory().appendingPathComponent("testv24.mp3")
        XCTAssertNoThrow(try TestFile.noMeta.mp3File()?.write(tagVersion: .v2_4,
                                            using: tag ?? Tag(readFrom: Mp3File(location: TestFile.noMeta.url)),
                                            writingTo: outputUrlv24))
        let mp3UrlWrittenV24 = outputUrlv24
        let mp3FileWrittenV24 = try Mp3File(location: mp3UrlWrittenV24)
        let tagWrittenV24 = try Tag(readFrom: mp3FileWrittenV24)
        
        XCTAssertEqual(tagWrittenV24.disc, 4)
        XCTAssertNil(tagWrittenV24.totalDiscs)
        XCTAssertEqual(tagWrittenV24.track, 6)
        XCTAssertNil(tagWrittenV24.totalTracks)
    }
    
    @available(OSX 10.12, *)
    func testOverwriting() throws {
        var v22Tag = try TestFile.v22.tag()
        v22Tag?.disc = 4
        v22Tag?.totalDiscs = 5
        v22Tag?.track = 6
        v22Tag?.totalTracks = 7
        
        let outputUrlv22 = try tempDirectory().appendingPathComponent("testv22.mp3")
        XCTAssertNoThrow(try TestFile.v22.mp3File()?.write(tagVersion: .v2_2,
                                            using: v22Tag ?? Tag(readFrom: Mp3File(location: TestFile.v22.url)),
                                            writingTo: outputUrlv22))
        let mp3UrlWrittenV22 = outputUrlv22
        let mp3FileWrittenV22 = try Mp3File(location: mp3UrlWrittenV22)
        let tagWrittenV22 = try Tag(readFrom: mp3FileWrittenV22)
        
        XCTAssertEqual(tagWrittenV22.disc, 4)
        XCTAssertEqual(tagWrittenV22.totalDiscs, 5)
        XCTAssertEqual(tagWrittenV22.track, 6)
        XCTAssertEqual(tagWrittenV22.totalTracks, 7)
        
        var v23Tag = try TestFile.v23.tag()
        
        v23Tag?.disc = 4
        v23Tag?.totalDiscs = 5
        v23Tag?.track = 6
        v23Tag?.totalTracks = 7
        
        let outputUrlv23 = try tempDirectory().appendingPathComponent("testv23.mp3")
        XCTAssertNoThrow(try TestFile.v23.mp3File()?.write(tagVersion: .v2_3,
                                            using: v23Tag ?? Tag(readFrom: Mp3File(location: TestFile.v23.url)),
                                            writingTo: outputUrlv23))
        let mp3UrlWrittenV23 = outputUrlv23
        let mp3FileWrittenV23 = try Mp3File(location: mp3UrlWrittenV23)
        let tagWrittenV23 = try Tag(readFrom: mp3FileWrittenV23)
        
        XCTAssertEqual(tagWrittenV23.disc, 4)
        XCTAssertEqual(tagWrittenV23.totalDiscs, 5)
        XCTAssertEqual(tagWrittenV23.track, 6)
        XCTAssertEqual(tagWrittenV23.totalTracks, 7)
        
        var v24Tag = try TestFile.v24.tag()
        
        v24Tag?.disc = 4
        v24Tag?.totalDiscs = 5
        v24Tag?.track = 6
        v24Tag?.totalTracks = 7
        
        let outputUrlv24 = try tempDirectory().appendingPathComponent("testv24.mp3")
        XCTAssertNoThrow(try TestFile.v24.mp3File()?.write(tagVersion: .v2_4,
                                            using: v24Tag ?? Tag(readFrom: Mp3File(location: TestFile.v24.url)),
                                            writingTo: outputUrlv24))
        let mp3UrlWrittenV24 = outputUrlv24
        let mp3FileWrittenV24 = try Mp3File(location: mp3UrlWrittenV24)
        let tagWrittenV24 = try Tag(readFrom: mp3FileWrittenV24)
        
        XCTAssertEqual(tagWrittenV24.disc, 4)
        XCTAssertEqual(tagWrittenV24.totalDiscs, 5)
        XCTAssertEqual(tagWrittenV24.track, 6)
        XCTAssertEqual(tagWrittenV24.totalTracks, 7)
    }

    @available(OSX 10.12, *)
    func testOverwritingWithOnlyPart() throws {
        var v22Tag = try TestFile.v22.tag()
        v22Tag?.disc = 4
        v22Tag?.track = 6
        
        let outputUrlv22 = try tempDirectory().appendingPathComponent("testv22.mp3")
        XCTAssertNoThrow(try TestFile.v22.mp3File()?.write(tagVersion: .v2_2,
                                            using: v22Tag ?? Tag(readFrom: Mp3File(location: TestFile.v22.url)),
                                            writingTo: outputUrlv22))
        let mp3UrlWrittenV22 = outputUrlv22
        let mp3FileWrittenV22 = try Mp3File(location: mp3UrlWrittenV22)
        let tagWrittenV22 = try Tag(readFrom: mp3FileWrittenV22)
        
        XCTAssertEqual(tagWrittenV22.disc, 4)
        XCTAssertEqual(tagWrittenV22.totalDiscs, 4)
        XCTAssertEqual(tagWrittenV22.track, 6)
        XCTAssertEqual(tagWrittenV22.totalTracks, 2)
        
        var v23Tag = try TestFile.v23.tag()
        
        v23Tag?.disc = 4
        v23Tag?.track = 6
        
        let outputUrlv23 = try tempDirectory().appendingPathComponent("testv23.mp3")
        XCTAssertNoThrow(try TestFile.v23.mp3File()?.write(tagVersion: .v2_3,
                                            using: v23Tag ?? Tag(readFrom: Mp3File(location: TestFile.v23.url)),
                                            writingTo: outputUrlv23))
        let mp3UrlWrittenV23 = outputUrlv23
        let mp3FileWrittenV23 = try Mp3File(location: mp3UrlWrittenV23)
        let tagWrittenV23 = try Tag(readFrom: mp3FileWrittenV23)
        
        XCTAssertEqual(tagWrittenV23.disc, 4)
        XCTAssertEqual(tagWrittenV23.totalDiscs, 4)
        XCTAssertEqual(tagWrittenV23.track, 6)
        XCTAssertEqual(tagWrittenV23.totalTracks, 2)
        
        var v24Tag = try TestFile.v24.tag()
        
        v24Tag?.disc = 4
        v24Tag?.track = 6
        
        let outputUrlv24 = try tempDirectory().appendingPathComponent("testv24.mp3")
        XCTAssertNoThrow(try TestFile.v24.mp3File()?.write(tagVersion: .v2_4,
                                            using: v24Tag ?? Tag(readFrom: Mp3File(location: TestFile.v24.url)),
                                            writingTo: outputUrlv24))
        let mp3UrlWrittenV24 = outputUrlv24
        let mp3FileWrittenV24 = try Mp3File(location: mp3UrlWrittenV24)
        let tagWrittenV24 = try Tag(readFrom: mp3FileWrittenV24)
        
        XCTAssertEqual(tagWrittenV24.disc, 4)
        XCTAssertEqual(tagWrittenV24.totalDiscs, 4)
        XCTAssertEqual(tagWrittenV24.track, 6)
        XCTAssertEqual(tagWrittenV24.totalTracks, 2)
    }
}
