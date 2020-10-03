/*

 SwiftTaggerID3_PartOfTotalFrame_Tests.swift
 SwiftTaggerID3

 Copyright ©2020 Nolaine Crusher. All rights reserved.

 */

import XCTest
@testable import SwiftTaggerID3

@available(OSX 10.12, *)
class SwiftTaggerID3_PartOfTotalFrame_Tests: XCTestCase {
    
    @available(OSX 10.12, *)
    func testWithBothValuesWrittenOnBlankFile() throws {
        var tag = tagNoMeta

        tag.discNumber.disc = 4
        tag.discNumber.totalDiscs = 5
        tag.trackNumber.track = 6
        tag.trackNumber.totalTracks = 7

//        let outputUrlV22 = try localOutputDirectory("pottestv22")
        let outputUrlV22 = tempOutputDirectory
        XCTAssertNoThrow(try mp3NoMeta.write(tag: &tag,
                                             version: .v2_2,
                                             outputLocation: outputUrlV22))
        let outputMp3V22 = try Mp3File(location: outputUrlV22)
        let outputV22 = try Tag(mp3File: outputMp3V22)
        
        XCTAssertEqual(outputV22.discNumber.disc, 4)
        XCTAssertEqual(outputV22.discNumber.totalDiscs, 5)
        XCTAssertEqual(outputV22.trackNumber.track, 6)
        XCTAssertEqual(outputV22.trackNumber.totalTracks, 7)
        
//        let outputUrlV23 = try localOutputDirectory("pottestv23")
        let outputUrlV23 = tempOutputDirectory
        XCTAssertNoThrow(try mp3NoMeta.write(tag: &tag,
                                             version: .v2_3,
                                             outputLocation: outputUrlV23))
        let outputMp3V23 = try Mp3File(location: outputUrlV23)
        let outputV23 = try Tag(mp3File: outputMp3V23)
        
        XCTAssertEqual(outputV23.discNumber.disc, 4)
        XCTAssertEqual(outputV23.discNumber.totalDiscs, 5)
        XCTAssertEqual(outputV23.trackNumber.track, 6)
        XCTAssertEqual(outputV23.trackNumber.totalTracks, 7)

//        let outputUrlV24 = try localOutputDirectory("pottestv24")
        let outputUrlV24 = tempOutputDirectory
        XCTAssertNoThrow(try mp3NoMeta.write(tag: &tag,
                                             version: .v2_4,
                                             outputLocation: outputUrlV24))
        let outputMp3V24 = try Mp3File(location: outputUrlV24)
        let outputV24 = try Tag(mp3File: outputMp3V24)
        
        XCTAssertEqual(outputV24.discNumber.disc, 4)
        XCTAssertEqual(outputV24.discNumber.totalDiscs, 5)
        XCTAssertEqual(outputV24.trackNumber.track, 6)
        XCTAssertEqual(outputV24.trackNumber.totalTracks, 7)
    }

    @available(OSX 10.12, *)
    func testWithOneValueWrittenOnBlankFile() throws {
        var tag = tagNoMeta
        
        tag.discNumber.disc = 4
        tag.trackNumber.track = 6
        
        let outputUrlV22 = tempOutputDirectory
        XCTAssertNoThrow(try mp3NoMeta.write(tag: &tag,
                                             version: .v2_2,
                                             outputLocation: outputUrlV22))
        let outputMp3V22 = try Mp3File(location: outputUrlV22)
        let outputV22 = try Tag(mp3File: outputMp3V22)
        
        XCTAssertEqual(outputV22.discNumber.disc, 4)
        XCTAssertNil(outputV22.discNumber.totalDiscs)
        XCTAssertEqual(outputV22.trackNumber.track, 6)
        XCTAssertNil(outputV22.trackNumber.totalTracks)
        
        let outputUrlV23 = tempOutputDirectory
        XCTAssertNoThrow(try mp3NoMeta.write(tag: &tag,
                                             version: .v2_3,
                                             outputLocation: outputUrlV23))
        let outputMp3V23 = try Mp3File(location: outputUrlV23)
        let outputV23 = try Tag(mp3File: outputMp3V23)
        
        XCTAssertEqual(outputV23.discNumber.disc, 4)
        XCTAssertNil(outputV23.discNumber.totalDiscs)
        XCTAssertEqual(outputV23.trackNumber.track, 6)
        XCTAssertNil(outputV23.trackNumber.totalTracks)
        
        let outputUrlV24 = tempOutputDirectory
        XCTAssertNoThrow(try mp3NoMeta.write(tag: &tag,
                                             version: .v2_4,
                                             outputLocation: outputUrlV24))
        let outputMp3V24 = try Mp3File(location: outputUrlV24)
        let outputV24 = try Tag(mp3File: outputMp3V24)
        
        XCTAssertEqual(outputV24.discNumber.disc, 4)
        XCTAssertNil(outputV24.discNumber.totalDiscs)
        XCTAssertEqual(outputV24.trackNumber.track, 6)
        XCTAssertNil(outputV24.trackNumber.totalTracks)
    }
    
    @available(OSX 10.12, *)
    func testOverwriting() throws {
        var v22Tag = tagV22
        v22Tag.discNumber.disc = 4
        v22Tag.discNumber.totalDiscs = 5
        v22Tag.trackNumber.track = 6
        v22Tag.trackNumber.totalTracks = 7
        
        let outputUrlV22 = tempOutputDirectory
        XCTAssertNoThrow(try mp3NoMeta.write(tag: &v22Tag,
                                             version: .v2_2,
                                             outputLocation: outputUrlV22))
        let outputmp3V22 = try Mp3File(location: outputUrlV22)
        let output = try Tag(mp3File: outputmp3V22)
        
        XCTAssertEqual(output.discNumber.disc, 4)
        XCTAssertEqual(output.discNumber.totalDiscs, 5)
        XCTAssertEqual(output.trackNumber.track, 6)
        XCTAssertEqual(output.trackNumber.totalTracks, 7)
        
        var v23Tag = tagV23
        
        v23Tag.discNumber.disc = 4
        v23Tag.discNumber.totalDiscs = 5
        v23Tag.trackNumber.track = 6
        v23Tag.trackNumber.totalTracks = 7
        
        let outputUrlV23 = tempOutputDirectory
        XCTAssertNoThrow(try mp3NoMeta.write(tag: &v23Tag,
                                             version: .v2_3,
                                             outputLocation: outputUrlV23))
        let outputmp3V23 = try Mp3File(location: outputUrlV23)
        let outputV23 = try Tag(mp3File: outputmp3V23)
        
        XCTAssertEqual(outputV23.discNumber.disc, 4)
        XCTAssertEqual(outputV23.discNumber.totalDiscs, 5)
        XCTAssertEqual(outputV23.trackNumber.track, 6)
        XCTAssertEqual(outputV23.trackNumber.totalTracks, 7)
        
        var v24Tag = tagV24
        
        v24Tag.discNumber.disc = 4
        v24Tag.discNumber.totalDiscs = 5
        v24Tag.trackNumber.track = 6
        v24Tag.trackNumber.totalTracks = 7
        
        let outputUrlV24 = tempOutputDirectory
        XCTAssertNoThrow(try mp3NoMeta.write(tag: &v24Tag,
                                             version: .v2_4,
                                             outputLocation: outputUrlV24))
        let outputmp3V24 = try Mp3File(location: outputUrlV24)
        let outputV24 = try Tag(mp3File: outputmp3V24)
        
        XCTAssertEqual(outputV24.discNumber.disc, 4)
        XCTAssertEqual(outputV24.discNumber.totalDiscs, 5)
        XCTAssertEqual(outputV24.trackNumber.track, 6)
        XCTAssertEqual(outputV24.trackNumber.totalTracks, 7)
    }

    @available(OSX 10.12, *)
    func testOverwritingWithOnlyPart() throws {
        var v22Tag = tagV22
        v22Tag.discNumber.disc = 4
        v22Tag.trackNumber.track = 6
        
        let outputUrlV22 = tempOutputDirectory
        XCTAssertNoThrow(try mp3NoMeta.write(tag: &v22Tag,
                                             version: .v2_2,
                                             outputLocation: outputUrlV22))
        let outputmp3V22 = try Mp3File(location: outputUrlV22)
        let output = try Tag(mp3File: outputmp3V22)
        
        XCTAssertEqual(output.discNumber.disc, 4)
        XCTAssertEqual(output.discNumber.totalDiscs, 4)
        XCTAssertEqual(output.trackNumber.track, 6)
        XCTAssertEqual(output.trackNumber.totalTracks, 2)
        
        var v23Tag = tagV23
        
        v23Tag.discNumber.disc = 4
        v23Tag.trackNumber.track = 6
        
        let outputUrlV23 = tempOutputDirectory
        XCTAssertNoThrow(try mp3NoMeta.write(tag: &v23Tag,
                                             version: .v2_3,
                                             outputLocation: outputUrlV23))
        let outputmp3V23 = try Mp3File(location: outputUrlV23)
        let outputV23 = try Tag(mp3File: outputmp3V23)
        
        XCTAssertEqual(outputV23.discNumber.disc, 4)
        XCTAssertEqual(outputV23.discNumber.totalDiscs, 4)
        XCTAssertEqual(outputV23.trackNumber.track, 6)
        XCTAssertEqual(outputV23.trackNumber.totalTracks, 2)
        
        var v24Tag = tagV24
        
        v24Tag.discNumber.disc = 4
        v24Tag.trackNumber.track = 6
        
        let outputUrlV24 = tempOutputDirectory
        XCTAssertNoThrow(try mp3NoMeta.write(tag: &v24Tag,
                                             version: .v2_4,
                                             outputLocation: outputUrlV24))
        let outputmp3V24 = try Mp3File(location: outputUrlV24)
        let outputV24 = try Tag(mp3File: outputmp3V24)
        
        XCTAssertEqual(outputV24.discNumber.disc, 4)
        XCTAssertEqual(outputV24.discNumber.totalDiscs, 4)
        XCTAssertEqual(outputV24.trackNumber.track, 6)
        XCTAssertEqual(outputV24.trackNumber.totalTracks, 2)
    }
    
    func testSetToNil() throws {
        var tag = tagV24
        tag.discNumber.disc = 0
        tag.discNumber.totalDiscs = nil
        tag.trackNumber.track = 0
        tag.trackNumber.totalTracks = nil
        XCTAssertEqual(tag.discNumber.disc, 0)
        XCTAssertEqual(tag.trackNumber.track, 0)
        XCTAssertNil(tag.discNumber.totalDiscs)
        XCTAssertNil(tag.trackNumber.totalTracks)
        XCTAssertNil(tag.frames.first(where: {$0.value.identifier == .discNumber}))
        XCTAssertNil(tag.frames.first(where: {$0.value.identifier == .trackNumber}))
        
        let outputUrl = tempOutputDirectory
//        let outputUrl = try localOutputDirectory("pottest")
        XCTAssertNoThrow(try mp3NoMeta.write(tag: &tag,
                                             version: .v2_4,
                                             outputLocation: outputUrl))
        let output = try Tag(mp3File: try Mp3File(location: outputUrl))
        XCTAssertEqual(output.discNumber.disc, 0)
        XCTAssertEqual(output.trackNumber.track,0)
        XCTAssertNil(output.discNumber.totalDiscs)
        XCTAssertNil(output.trackNumber.totalTracks)
        XCTAssertNil(tag.frames.first(where: {$0.value.identifier == .discNumber}))
        XCTAssertNil(tag.frames.first(where: {$0.value.identifier == .trackNumber}))
    }
}
