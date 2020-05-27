/*
 
 SwiftTaggerID3_ChapterFrame_Tests.swift
 SwiftTaggerID3
 
 Copyright ©2020 Nolaine Crusher. All rights reserved.
 
 */

import XCTest
import SwiftTaggerID3

// Actually tests for chapter frame and CTOC frame
class SwiftTaggerID3_ChapterFrame_Tests: XCTestCase {

    // MARK: Read test
    func testReadChapterizedFile() throws {
        let tag = try TestFile.chapterized.tag()
        
        let chapters = tag?.tableOfContents.sortedChapters()
        XCTAssertEqual(chapters?.count, 2)
        XCTAssertEqual(chapters?[0].startTime, 0)
        XCTAssertEqual(chapters?[1].startTime, 2795)
        XCTAssertEqual(chapters?[0].chapter.subframes?.title, "Chapter 01")
        XCTAssertEqual(chapters?[1].chapter.subframes?.title, "Chapter 02")
    }

    // MARK: Frame removal test
    #warning("chapter removal broke with changes to chapter and toc handling")
    @available(OSX 10.12, *)
    func testFrameRemoval() throws {
        var tag = try TestFile.chapterized.tag()
        
        tag?.removeChapter(at: 0)
        tag?.removeChapter(at: 2795)
        tag?.removeTableOfContents()
        
        let outputUrl = try localDirectory(fileName: "removaltest", fileExtension: "mp3")
        XCTAssertNoThrow(try TestFile.chapterized.mp3File()?.write(
            tagVersion: .v2_4,
            using: tag ?? Tag(readFrom: Mp3File(location: TestFile.chapterized.url)),
            writingTo: outputUrl))
    }

    // MARK: Writing test
    @available(OSX 10.12, *)
    func testFrameWriting() throws {
        let tag = try TestFile.noMeta.tag()

        var chapters = tag?.tableOfContents.sortedChapters()
        chapters?[0].startTime = 0 // Fatal error: Index out of range: file 
        chapters?[1].startTime = 1680
        chapters?[2].startTime = 3360
        chapters?[0].chapter.subframes?.title = "Chapter 001"
        chapters?[1].chapter.subframes?.title = "Chapter 002"
        chapters?[2].chapter.subframes?.title = "Chapter 003"
        
        let outputUrl = try localDirectory(fileName: "newtoctest", fileExtension: "mp3")
        XCTAssertNoThrow(try TestFile.noMeta.mp3File()?.write(
            tagVersion: .v2_4,
            using: tag ?? Tag(readFrom: Mp3File(location: TestFile.noMeta.url)),
            writingTo: outputUrl))
        
        let writtenMp3 = try Mp3File(location: outputUrl)
        let writtenTag = try Tag(readFrom: writtenMp3)
        let writtenChapters = writtenTag.tableOfContents.sortedChapters()

        XCTAssertEqual(writtenChapters.count, 3)
        XCTAssertEqual(writtenChapters[0].startTime, 0)
        XCTAssertEqual(writtenChapters[1].startTime, 1680)
        XCTAssertEqual(writtenChapters[2].startTime, 3360)
        XCTAssertEqual(writtenChapters[0].chapter.subframes?.title, "Chapter 001")
        XCTAssertEqual(writtenChapters[1].chapter.subframes?.title, "Chapter 002")
        XCTAssertEqual(writtenChapters[2].chapter.subframes?.title, "Chapter 003")
    }
}
