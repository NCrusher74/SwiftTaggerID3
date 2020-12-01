/*

 SwiftTaggerID3_PartOfTotalFrame_Tests.swift
 SwiftTaggerID3

 Copyright ©2020 Nolaine Crusher. All rights reserved.

 */

import XCTest
@testable import SwiftTaggerID3

@available(OSX 11.0, iOS 10.0, *)
class SwiftTaggerID3_PartOfTotalFrame_Tests: XCTestCase {
    
    func testWithBothValuesWrittenOnBlankFile() throws {
        var tag = tagNoMeta

        tag.discNumber.index = 4
        tag.discNumber.total = 5
        tag.trackNumber.index = 6
        tag.trackNumber.total = 7

//        let outputUrlV22 = try localOutputDirectory("pottestv22")
        let outputUrlV22 = tempOutputDirectory
        XCTAssertNoThrow(try mp3NoMeta.write(tag: &tag,
                                             version: .v2_2,
                                             outputLocation: outputUrlV22))
        let outputMp3V22 = try Mp3File(location: outputUrlV22)
        let outputV22 = try Tag(mp3File: outputMp3V22)
        
        XCTAssertEqual(outputV22.discNumber.index, 4)
        XCTAssertEqual(outputV22.discNumber.total, 5)
        XCTAssertEqual(outputV22.trackNumber.index, 6)
        XCTAssertEqual(outputV22.trackNumber.total, 7)
        
//        let outputUrlV23 = try localOutputDirectory("pottestv23")
        let outputUrlV23 = tempOutputDirectory
        XCTAssertNoThrow(try mp3NoMeta.write(tag: &tag,
                                             version: .v2_3,
                                             outputLocation: outputUrlV23))
        let outputMp3V23 = try Mp3File(location: outputUrlV23)
        let outputV23 = try Tag(mp3File: outputMp3V23)
        
        XCTAssertEqual(outputV23.discNumber.index, 4)
        XCTAssertEqual(outputV23.discNumber.total, 5)
        XCTAssertEqual(outputV23.trackNumber.index, 6)
        XCTAssertEqual(outputV23.trackNumber.total, 7)

//        let outputUrlV24 = try localOutputDirectory("pottestv24")
        let outputUrlV24 = tempOutputDirectory
        XCTAssertNoThrow(try mp3NoMeta.write(tag: &tag,
                                             version: .v2_4,
                                             outputLocation: outputUrlV24))
        let outputMp3V24 = try Mp3File(location: outputUrlV24)
        let outputV24 = try Tag(mp3File: outputMp3V24)
        
        XCTAssertEqual(outputV24.discNumber.index, 4)
        XCTAssertEqual(outputV24.discNumber.total, 5)
        XCTAssertEqual(outputV24.trackNumber.index, 6)
        XCTAssertEqual(outputV24.trackNumber.total, 7)
    }

    func testWithOneValueWrittenOnBlankFile() throws {
        var tag = tagNoMeta
        
        tag.discNumber.index = 4
        tag.trackNumber.index = 6
        
        let outputUrlV22 = tempOutputDirectory
        XCTAssertNoThrow(try mp3NoMeta.write(tag: &tag,
                                             version: .v2_2,
                                             outputLocation: outputUrlV22))
        let outputMp3V22 = try Mp3File(location: outputUrlV22)
        let outputV22 = try Tag(mp3File: outputMp3V22)
        
        XCTAssertEqual(outputV22.discNumber.index, 4)
        XCTAssertNil(outputV22.discNumber.total)
        XCTAssertEqual(outputV22.trackNumber.index, 6)
        XCTAssertNil(outputV22.trackNumber.total)
        
        let outputUrlV23 = tempOutputDirectory
        XCTAssertNoThrow(try mp3NoMeta.write(tag: &tag,
                                             version: .v2_3,
                                             outputLocation: outputUrlV23))
        let outputMp3V23 = try Mp3File(location: outputUrlV23)
        let outputV23 = try Tag(mp3File: outputMp3V23)
        
        XCTAssertEqual(outputV23.discNumber.index, 4)
        XCTAssertNil(outputV23.discNumber.total)
        XCTAssertEqual(outputV23.trackNumber.index, 6)
        XCTAssertNil(outputV23.trackNumber.total)
        
        let outputUrlV24 = tempOutputDirectory
        XCTAssertNoThrow(try mp3NoMeta.write(tag: &tag,
                                             version: .v2_4,
                                             outputLocation: outputUrlV24))
        let outputMp3V24 = try Mp3File(location: outputUrlV24)
        let outputV24 = try Tag(mp3File: outputMp3V24)
        
        XCTAssertEqual(outputV24.discNumber.index, 4)
        XCTAssertNil(outputV24.discNumber.total)
        XCTAssertEqual(outputV24.trackNumber.index, 6)
        XCTAssertNil(outputV24.trackNumber.total)
    }
    
    func testOverwriting() throws {
        var v22Tag = tagV22
        v22Tag.discNumber.index = 4
        v22Tag.discNumber.total = 5
        v22Tag.trackNumber.index = 6
        v22Tag.trackNumber.total = 7
        
        let outputUrlV22 = tempOutputDirectory
        XCTAssertNoThrow(try mp3NoMeta.write(tag: &v22Tag,
                                             version: .v2_2,
                                             outputLocation: outputUrlV22))
        let outputmp3V22 = try Mp3File(location: outputUrlV22)
        let output = try Tag(mp3File: outputmp3V22)
        
        XCTAssertEqual(output.discNumber.index, 4)
        XCTAssertEqual(output.discNumber.total, 5)
        XCTAssertEqual(output.trackNumber.index, 6)
        XCTAssertEqual(output.trackNumber.total, 7)
        
        var v23Tag = tagV23
        
        v23Tag.discNumber.index = 4
        v23Tag.discNumber.total = 5
        v23Tag.trackNumber.index = 6
        v23Tag.trackNumber.total = 7
        
        let outputUrlV23 = tempOutputDirectory
        XCTAssertNoThrow(try mp3NoMeta.write(tag: &v23Tag,
                                             version: .v2_3,
                                             outputLocation: outputUrlV23))
        let outputmp3V23 = try Mp3File(location: outputUrlV23)
        let outputV23 = try Tag(mp3File: outputmp3V23)
        
        XCTAssertEqual(outputV23.discNumber.index, 4)
        XCTAssertEqual(outputV23.discNumber.total, 5)
        XCTAssertEqual(outputV23.trackNumber.index, 6)
        XCTAssertEqual(outputV23.trackNumber.total, 7)
        
        var v24Tag = tagV24
        
        v24Tag.discNumber.index = 4
        v24Tag.discNumber.total = 5
        v24Tag.trackNumber.index = 6
        v24Tag.trackNumber.total = 7
        
        let outputUrlV24 = tempOutputDirectory
        XCTAssertNoThrow(try mp3NoMeta.write(tag: &v24Tag,
                                             version: .v2_4,
                                             outputLocation: outputUrlV24))
        let outputmp3V24 = try Mp3File(location: outputUrlV24)
        let outputV24 = try Tag(mp3File: outputmp3V24)
        
        XCTAssertEqual(outputV24.discNumber.index, 4)
        XCTAssertEqual(outputV24.discNumber.total, 5)
        XCTAssertEqual(outputV24.trackNumber.index, 6)
        XCTAssertEqual(outputV24.trackNumber.total, 7)
    }

    func testOverwritingWithOnlyPart() throws {
        var v22Tag = tagV22
        v22Tag.discNumber.index = 4
        v22Tag.trackNumber.index = 6
        
        let outputUrlV22 = tempOutputDirectory
        XCTAssertNoThrow(try mp3NoMeta.write(tag: &v22Tag,
                                             version: .v2_2,
                                             outputLocation: outputUrlV22))
        let outputmp3V22 = try Mp3File(location: outputUrlV22)
        let output = try Tag(mp3File: outputmp3V22)
        
        XCTAssertEqual(output.discNumber.index, 4)
        XCTAssertEqual(output.discNumber.total, 4)
        XCTAssertEqual(output.trackNumber.index, 6)
        XCTAssertEqual(output.trackNumber.total, 2)
        
        var v23Tag = tagV23
        
        v23Tag.discNumber.index = 4
        v23Tag.trackNumber.index = 6
        
        let outputUrlV23 = tempOutputDirectory
        XCTAssertNoThrow(try mp3NoMeta.write(tag: &v23Tag,
                                             version: .v2_3,
                                             outputLocation: outputUrlV23))
        let outputmp3V23 = try Mp3File(location: outputUrlV23)
        let outputV23 = try Tag(mp3File: outputmp3V23)
        
        XCTAssertEqual(outputV23.discNumber.index, 4)
        XCTAssertEqual(outputV23.discNumber.total, 4)
        XCTAssertEqual(outputV23.trackNumber.index, 6)
        XCTAssertEqual(outputV23.trackNumber.total, 2)
        
        var v24Tag = tagV24
        
        v24Tag.discNumber.index = 4
        v24Tag.trackNumber.index = 6
        
        let outputUrlV24 = tempOutputDirectory
        XCTAssertNoThrow(try mp3NoMeta.write(tag: &v24Tag,
                                             version: .v2_4,
                                             outputLocation: outputUrlV24))
        let outputmp3V24 = try Mp3File(location: outputUrlV24)
        let outputV24 = try Tag(mp3File: outputmp3V24)
        
        XCTAssertEqual(outputV24.discNumber.index, 4)
        XCTAssertEqual(outputV24.discNumber.total, 4)
        XCTAssertEqual(outputV24.trackNumber.index, 6)
        XCTAssertEqual(outputV24.trackNumber.total, 2)
    }
    
    func testSetToNil() throws {
        var tag = tagV24
        tag.discNumber.index = 0
        tag.discNumber.total = nil
        tag.trackNumber.index = 0
        tag.trackNumber.total = nil
        XCTAssertEqual(tag.discNumber.index, 0)
        XCTAssertEqual(tag.trackNumber.index, 0)
        XCTAssertNil(tag.discNumber.total)
        XCTAssertNil(tag.trackNumber.total)
        XCTAssertNil(tag.frames.first(where: {$0.value.identifier == .discNumber}))
        XCTAssertNil(tag.frames.first(where: {$0.value.identifier == .trackNumber}))
        
        let outputUrl = tempOutputDirectory
//        let outputUrl = try localOutputDirectory("pottest")
        XCTAssertNoThrow(try mp3NoMeta.write(tag: &tag,
                                             version: .v2_4,
                                             outputLocation: outputUrl))
        let output = try Tag(mp3File: try Mp3File(location: outputUrl))
        XCTAssertEqual(output.discNumber.index, 0)
        XCTAssertEqual(output.trackNumber.index,0)
        XCTAssertNil(output.discNumber.total)
        XCTAssertNil(output.trackNumber.total)
        XCTAssertNil(tag.frames.first(where: {$0.value.identifier == .discNumber}))
        XCTAssertNil(tag.frames.first(where: {$0.value.identifier == .trackNumber}))
    }
}
