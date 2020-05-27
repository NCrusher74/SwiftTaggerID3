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
        
        XCTAssertEqual(tag?.tableOfContents.chapters.count, 2)
        let ch0 = tag?.tableOfContents.sortedChapters()[0]
        let ch1 = tag?.tableOfContents.sortedChapters()[1]
        XCTAssertEqual(ch0?.startTime, 0)
        XCTAssertEqual(ch1?.startTime, 2795)
        let chapter0 = ch0?.chapter
        let chapter1 = ch1?.chapter
        XCTAssertEqual(chapter0?.subframes?.title, "Chapter 01")
        XCTAssertEqual(chapter1?.subframes?.title, "Chapter 02")
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
    func testFrameWriting() throws {
        var tag = try TestFile.noMeta.tag()
        
        tag?.tableOfContents.chapters[0] = // what?
        tag?.tableOfContents.chapters[1680] =
        tag?.tableOfContents.chapters[3360] =
    }
}
