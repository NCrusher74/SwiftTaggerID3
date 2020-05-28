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

        XCTAssertEqual(tag?.getChapters().count, 2)
        XCTAssertEqual(tag?.getChapters()[0], "Chapter 01")
        XCTAssertEqual(tag?.getChapters()[2795], "Chapter 02")
    }

    // MARK: Frame removal test
    @available(OSX 10.12, *)
    func testFrameRemoval() throws {
        var tag = try TestFile.chapterized.tag()

        tag?.removeAllChapters()
        tag?.removeTableOfContents()
        
        let outputUrl = try localDirectory(fileName: "removaltest", fileExtension: "mp3")

        XCTAssertNoThrow(try TestFile.chapterized.mp3File()?.write(
            tagVersion: .v2_4,
            using: tag ?? Tag(readFrom: Mp3File(location: TestFile.chapterized.url)),
            writingTo: outputUrl))
        
        let writtenFile = try Mp3File(location: outputUrl)
        let writtenTag = try Tag(readFrom: writtenFile)
        
        XCTAssertEqual(writtenTag.getChapters(),[:])
    }

    // MARK: Writing test
    @available(OSX 10.12, *)
    func testFrameWriting() throws {
        var tag = try TestFile.noMeta.tag()
        
        tag?.addChapter(at: 0, title: "Chapter 001")
        tag?.addChapter(at: 1680, title: "Chapter 002")
        tag?.addChapter(at: 3360, title: "Chapter 003")
        
        let outputUrl = try localDirectory(fileName: "newtoctest", fileExtension: "mp3")
        XCTAssertNoThrow(try TestFile.noMeta.mp3File()?.write(
            tagVersion: .v2_4,
            using: tag ?? Tag(readFrom: Mp3File(location: TestFile.noMeta.url)),
            writingTo: outputUrl))
        
        let writtenFile = try Mp3File(location: outputUrl)
        let writtenTag = try Tag(readFrom: writtenFile)

        XCTAssertEqual(writtenTag.getChapters(), [
            0 : "Chapter 001",
            1680: "Chapter 002",
            3360: "Chapter 003"
        ])
    }
}
