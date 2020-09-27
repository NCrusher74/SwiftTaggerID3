/*

 SwiftTaggerID3_ChapterFrame_Tests.swift
 SwiftTaggerID3

 Copyright ©2020 Nolaine Crusher. All rights reserved.

 */

import XCTest
@testable import SwiftTaggerID3

// Tests for chapter frame and CTOC frame
class SwiftTaggerID3_ChapterFrame_Tests: XCTestCase {

    func testGetChapterList() throws {
        let tag = tagChaptered
        if let firstChapter = tag.chapterList.first {
            XCTAssertEqual(firstChapter.startTime, 0)
            XCTAssertEqual(firstChapter.title, "Chapter 01")
        }
        if let lastChapter = tag.chapterList.last {
            XCTAssertEqual(lastChapter.startTime, 2795)
            XCTAssertEqual(lastChapter.title, "Chapter 02")
        }
    }
}
/*
// // MARK: - Read test
@available(OSX 10.12, *)
func testReadChapterizedFile() throws {
    let tag = tagChaptered
    
    XCTAssertEqual(tag.chapterList.count,2)
    XCTAssertEqual(tag.chapterList[0].startTime, 0)
    XCTAssertEqual(tag.chapterList[0].title, "Chapter 01")
    XCTAssertEqual(tag.chapterList[1].startTime, 2795)
    XCTAssertEqual(tag.chapterList[1].title, "Chapter 02")
}

@available(OSX 10.12, *)
func testAddChapterToChapteredFile() throws {
    var tag = tagChaptered
    tag.addChapter(startTime: 3800, title: "Chapter 03")
    
    let outputUrl = tempOutputDirectory
    XCTAssertNoThrow(try mp3Chaptered.write(tag: tag, version: .v2_4, outputLocation: outputUrl))
    
    let outputFile = try Mp3File(location: outputUrl)
    let output = try Tag(mp3File: outputFile)
    
    XCTAssertEqual(output.chapterList.count,3)
    XCTAssertEqual(output.chapterList[0].startTime, 0)
    XCTAssertEqual(output.chapterList[0].title, "Chapter 01")
    XCTAssertEqual(output.chapterList[1].startTime, 2795)
    XCTAssertEqual(output.chapterList[1].title, "Chapter 02")
    XCTAssertEqual(output.chapterList[2].startTime, 3800)
    XCTAssertEqual(output.chapterList[2].title, "Chapter 03")
}

// // MARK: - Frame removal test
@available(OSX 10.12, *)
func testFrameRemoval() throws {
    var tag = tagChaptered
    tag.removeAllChapters()
    let outputUrl = tempOutputDirectory
    XCTAssertNoThrow(try mp3Chaptered.write(tag: tag, version: .v2_4, outputLocation: outputUrl))
    let outputMp3 = try Mp3File(location: outputUrl)
    let output = try Tag(mp3File: outputMp3)
    
    XCTAssertTrue(output.chapterList.isEmpty)
}

// // MARK: - Writing test
@available(OSX 10.12, *)
func testFrameWriting() throws {
    var tag = tagNoMeta
    
    tag.addChapter(startTime: 0, title: "Chapter 001")
    tag.addChapter(startTime: 1680, title: "Chapter 002")
    tag.addChapter(startTime: 3360, title: "Chapter 003")
    
    let outputUrl = tempOutputDirectory
    XCTAssertNoThrow(try mp3NoMeta.write(tag: tag, version: .v2_4, outputLocation: outputUrl))
    
    let outputMp3 = try Mp3File(location: outputUrl)
    let output = try Tag(mp3File: outputMp3)
    
    XCTAssertEqual(output.chapterList[0].startTime, 0)
    XCTAssertEqual(output.chapterList[0].title, "Chapter 001")
    XCTAssertEqual(output.chapterList[1].startTime, 1680)
    XCTAssertEqual(output.chapterList[1].title, "Chapter 002")
    XCTAssertEqual(output.chapterList[2].startTime, 3360)
    XCTAssertEqual(output.chapterList[2].title, "Chapter 003")
}

// // MARK: - Overwriting test
@available(OSX 10.12, *)
func testOverwriting() throws {
    var tag = tagChaptered
    
    tag.addChapter(startTime: 0, title: "Chapter 001")
    tag.addChapter(startTime: 1680, title: "Chapter 002")
    tag.addChapter(startTime: 3360, title: "Chapter 003")
    
    let outputUrl = tempOutputDirectory
    //        let outputUrl = try tempOutputDirectory
    XCTAssertNoThrow(try mp3Chaptered.write(tag: tag, version: .v2_4, outputLocation: outputUrl))
    
    let outputMp3 = try Mp3File(location: outputUrl)
    let output = try Tag(mp3File: outputMp3)
    
    XCTAssertEqual(output.chapterList[0].startTime, 0)
    XCTAssertEqual(output.chapterList[0].title, "Chapter 001")
    XCTAssertEqual(output.chapterList[1].startTime, 1680)
    XCTAssertEqual(output.chapterList[1].title, "Chapter 002")
    XCTAssertEqual(output.chapterList[2].startTime, 2795)
    XCTAssertEqual(output.chapterList[2].title, "Chapter 02")
    XCTAssertEqual(output.chapterList[3].startTime, 3360)
    XCTAssertEqual(output.chapterList[3].title, "Chapter 003")
}

@available(OSX 10.12, *)
func testOverwritingWithRenaming() throws {
    var tag = tagChaptered
    
    tag.addChapter(startTime: 0, title: "Chapter 001")
    tag.addChapter(startTime: 1680, title: "Chapter 002")
    tag.addChapter(startTime: 2795, title: "Chapter 003")
    tag.addChapter(startTime: 3360, title: "Chapter 004")
    
    let outputUrl = tempOutputDirectory
    XCTAssertNoThrow(try mp3Chaptered.write(tag: tag, version: .v2_4, outputLocation: outputUrl))
    
    let outputMp3 = try Mp3File(location: outputUrl)
    let output = try Tag(mp3File: outputMp3)
    
    XCTAssertEqual(output.chapterList[0].startTime, 0)
    XCTAssertEqual(output.chapterList[0].title, "Chapter 001")
    XCTAssertEqual(output.chapterList[1].startTime, 1680)
    XCTAssertEqual(output.chapterList[1].title, "Chapter 002")
    XCTAssertEqual(output.chapterList[2].startTime, 2795)
    XCTAssertEqual(output.chapterList[2].title, "Chapter 003")
    XCTAssertEqual(output.chapterList[3].startTime, 3360)
    XCTAssertEqual(output.chapterList[3].title, "Chapter 004")
}

@available(OSX 10.12, *)
func testVersionFailure() throws {
    var tag = tagNoMeta
    
    tag.addChapter(startTime: 0, title: "Chapter 001")
    tag.addChapter(startTime: 1680, title: "Chapter 002")
    tag.addChapter(startTime: 3360, title: "Chapter 003")
    
    let outputUrl = tempOutputDirectory
    XCTAssertThrowsError(try mp3NoMeta.write(tag: tag, version: .v2_4, outputLocation: outputUrl))
}
*/
