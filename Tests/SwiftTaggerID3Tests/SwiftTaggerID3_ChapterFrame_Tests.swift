/*
 
 SwiftTaggerID3_ChapterFrame_Tests.swift
 SwiftTaggerID3
 
 Copyright ©2020 Nolaine Crusher. All rights reserved.
 
 */

import XCTest
import SwiftTaggerID3

// Actually tests for chapter frame and CTOC frame
class SwiftTaggerID3_ChapterFrame_Tests: XCTestCase {

    func testReadChapterizedFile() throws {
        let tag = try tagChapterized()
        
        XCTAssertEqual(tag[tableOfContents: "TOC"]?.topLevelFlag, true)
        XCTAssertEqual(tag[tableOfContents: "TOC"]?.orderedFlag, true)
        XCTAssertEqual(tag[tableOfContents: "TOC"]?.childElementIDs, ["ch0","ch1"])
        XCTAssertEqual(tag[tableOfContents: "TOC"]?.embeddedSubframesTag.title, "")
        
        XCTAssertEqual(tag[chapter: "ch0"]?.startTime, 0)
        XCTAssertEqual(tag[chapter: "ch0"]?.endTime, 2795)
        XCTAssertEqual(tag[chapter: "ch0"]?.embeddedSubframesTag.title, "Chapter 01")

        XCTAssertEqual(tag[chapter: "ch1"]?.startTime, 2795)
        XCTAssertEqual(tag[chapter: "ch1"]?.endTime, 5250)
        XCTAssertEqual(tag[chapter: "ch1"]?.embeddedSubframesTag.title, "Chapter 02")
    }

    @available(OSX 10.12, *)
    func testFrameRemoval() throws {
        var tag = try tagChapterized()
        
        tag.removeTOCFrame(withElementID: "TOC")
        tag.removeChapterFrame(withElementID: "ch0")
        tag.removeChapterFrame(withElementID: "ch1")
        
        let outputUrl = try localDirectory(fileName: "removaltest", fileExtension: "mp3")
        XCTAssertNoThrow(try mp3Chapterized().write(tagVersion: .v2_4,
                                               using: tag,
                                               writingTo: outputUrl))
    }

    @available(OSX 10.12, *)
    func testWritingTableOfContentsOnBlankFile() throws {
        var tag = try tagNoMeta()

        tag[tableOfContents: "ctoc"]?.topLevelFlag = false
        tag[tableOfContents: "ctoc"]?.orderedFlag = false
        tag[tableOfContents: "ctoc"]?.childElementIDs = ["ch1", "ch2","ch3"]
        tag[tableOfContents: "ctoc"]?.embeddedSubframesTag.title = "Table Of Contents"
        
        let outputUrl = try localDirectory(fileName: "ctoctest", fileExtension: "mp3")
        XCTAssertNoThrow(try mp3NoMeta().write(tagVersion: .v2_4,
                                               using: tag,
                                               writingTo: outputUrl))
        
        // MARK: Confirm accuracy
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten[tableOfContents: "ctoc"]?.topLevelFlag, false) // fails
        XCTAssertEqual(tagWritten[tableOfContents: "ctoc"]?.orderedFlag, false)
        XCTAssertEqual(tagWritten[tableOfContents: "ctoc"]?.childElementIDs, ["ch1","ch2","ch3"])
        XCTAssertEqual(tagWritten[tableOfContents: "ctoc"]?.embeddedSubframesTag.title, "Table Of Contents")
    }

    @available(OSX 10.12, *)
    func testWritingMultipleTableOfContentsOnBlankFile() throws {
        var tag = try tagNoMeta()
        
        tag[tableOfContents: "toc1"]?.topLevelFlag = true
        tag[tableOfContents: "toc1"]?.orderedFlag = true
        tag[tableOfContents: "toc1"]?.childElementIDs = ["toc2"]
        tag[tableOfContents: "toc1"]?.embeddedSubframesTag.title = "Table Of Contents (TOP)"
        
        tag[tableOfContents: "toc2"]?.topLevelFlag = false
        tag[tableOfContents: "toc2"]?.orderedFlag = true
        tag[tableOfContents: "toc2"]?.childElementIDs = ["ch1", "ch2", "ch3"]
        tag[tableOfContents: "toc2"]?.embeddedSubframesTag.title = "Table Of Contents (SECONDARY)"
        
        let outputUrl = try localDirectory(fileName: "ctoctest", fileExtension: "mp3")
        XCTAssertNoThrow(try mp3NoMeta().write(tagVersion: .v2_4,
                                               using: tag,
                                               writingTo: outputUrl))
        
        // MARK: Confirm accuracy
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten[tableOfContents: "toc1"]?.topLevelFlag, true)
        XCTAssertEqual(tagWritten[tableOfContents: "toc1"]?.orderedFlag, true)
        XCTAssertEqual(tagWritten[tableOfContents: "toc1"]?.childElementIDs, ["toc2"])
        XCTAssertEqual(tagWritten[tableOfContents: "toc1"]?.embeddedSubframesTag.title, "Table Of Contents (TOP)")

        XCTAssertEqual(tagWritten[tableOfContents: "toc2"]?.topLevelFlag, false)
        XCTAssertEqual(tagWritten[tableOfContents: "toc2"]?.orderedFlag, true)
        XCTAssertEqual(tagWritten[tableOfContents: "toc2"]?.childElementIDs, ["ch1", "ch2", "ch3"])
        XCTAssertEqual(tagWritten[tableOfContents: "toc2"]?.embeddedSubframesTag.title, "Table Of Contents (SECONDARY)")
    }

    @available(OSX 10.12, *)
    func testWritingTableOfContentsOnWrittenFile() throws {
        var tag = try tagv24()
        
        tag[tableOfContents: "ctoc"]?.topLevelFlag = false
        tag[tableOfContents: "ctoc"]?.orderedFlag = false
        tag[tableOfContents: "ctoc"]?.childElementIDs = ["ch1", "ch2","ch3"]
        tag[tableOfContents: "ctoc"]?.embeddedSubframesTag.title = "Table Of Contents"
        
        let outputUrl = try localDirectory(fileName: "ctoctest", fileExtension: "mp3")
        XCTAssertNoThrow(try mp3v24().write(tagVersion: .v2_4,
                                               using: tag,
                                               writingTo: outputUrl))
        
        // MARK: Confirm accuracy
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten[tableOfContents: "ctoc"]?.topLevelFlag, false) // fails
        XCTAssertEqual(tagWritten[tableOfContents: "ctoc"]?.orderedFlag, false)
        XCTAssertEqual(tagWritten[tableOfContents: "ctoc"]?.childElementIDs, ["ch1","ch2","ch3"])
        XCTAssertEqual(tagWritten[tableOfContents: "ctoc"]?.embeddedSubframesTag.title, "Table Of Contents")
    }
    
    @available(OSX 10.12, *)
    func testWritingMultipleTableOfContentsOnWrittenFile() throws {
        var tag = try tagv24()
        
        tag[tableOfContents: "toc1"]?.topLevelFlag = true
        tag[tableOfContents: "toc1"]?.orderedFlag = true
        tag[tableOfContents: "toc1"]?.childElementIDs = ["toc2"]
        tag[tableOfContents: "toc1"]?.embeddedSubframesTag.title = "Table Of Contents (TOP)"
        
        tag[tableOfContents: "toc2"]?.topLevelFlag = false
        tag[tableOfContents: "toc2"]?.orderedFlag = true
        tag[tableOfContents: "toc2"]?.childElementIDs = ["ch1", "ch2", "ch3"]
        tag[tableOfContents: "toc2"]?.embeddedSubframesTag.title = "Table Of Contents (SECONDARY)"
        
        let outputUrl = try localDirectory(fileName: "ctoctest", fileExtension: "mp3")
        XCTAssertNoThrow(try mp3v24().write(tagVersion: .v2_4,
                                               using: tag,
                                               writingTo: outputUrl))
        
        // MARK: Confirm accuracy
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten[tableOfContents: "toc1"]?.topLevelFlag, true)
        XCTAssertEqual(tagWritten[tableOfContents: "toc1"]?.orderedFlag, true)
        XCTAssertEqual(tagWritten[tableOfContents: "toc1"]?.childElementIDs, ["toc2"])
        XCTAssertEqual(tagWritten[tableOfContents: "toc1"]?.embeddedSubframesTag.title, "Table Of Contents (TOP)")
        
        XCTAssertEqual(tagWritten[tableOfContents: "toc2"]?.topLevelFlag, false)
        XCTAssertEqual(tagWritten[tableOfContents: "toc2"]?.orderedFlag, true)
        XCTAssertEqual(tagWritten[tableOfContents: "toc2"]?.childElementIDs, ["ch1", "ch2", "ch3"])
        XCTAssertEqual(tagWritten[tableOfContents: "toc2"]?.embeddedSubframesTag.title, "Table Of Contents (SECONDARY)")
    }

    @available(OSX 10.12, *)
    func testWritingChaptersOnBlankFilev24() throws {
        var tag = Tag()
        
        tag[chapter: "ch01"]?.startTime = 0
        tag[chapter: "ch01"]?.endTime = 1680
        tag[chapter: "ch01"]?.embeddedSubframesTag.title = "Chapter One"
        
        tag[chapter: "ch02"]?.startTime = 1680
        tag[chapter: "ch02"]?.endTime = 3360
        tag[chapter: "ch02"]?.embeddedSubframesTag.title = "Chapter Two"

        tag[chapter: "ch03"]?.startTime = 3360
        tag[chapter: "ch03"]?.endTime = 5040
        tag[chapter: "ch03"]?.embeddedSubframesTag.title = "Chapter Three"
        
        let outputUrl = try localDirectory(fileName: "chaptertest", fileExtension: "mp3")
        XCTAssertNoThrow(try mp3NoMeta().write(tagVersion: .v2_4,
                                               using: tag,
                                               writingTo: outputUrl))
        
        // MARK: Confirm accuracy
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten[chapter: "ch01"]?.startTime, 0)
        XCTAssertEqual(tagWritten[chapter: "ch01"]?.endTime, 1680)
        // XCTAssertEqual failed: ("0") is not equal to ("1680")
        XCTAssertEqual(tagWritten[chapter: "ch01"]?.embeddedSubframesTag.title, "Chapter One")
        // XCTAssertEqual failed: ("Optional("")") is not equal to ("Optional("Chapter One")")

        XCTAssertEqual(tagWritten[chapter: "ch02"]?.startTime, 1680)
        // XCTAssertEqual failed: ("0") is not equal to ("1680")
        XCTAssertEqual(tagWritten[chapter: "ch02"]?.endTime, 3360)
        // XCTAssertEqual failed: ("1680") is not equal to ("3360")
        XCTAssertEqual(tagWritten[chapter: "ch02"]?.embeddedSubframesTag.title, "Chapter Two")
        // XCTAssertEqual failed: ("Optional("")") is not equal to ("Optional("Chapter Two")")

        XCTAssertEqual(tagWritten[chapter: "ch03"]?.startTime, 3360)
        // XCTAssertEqual failed: ("0") is not equal to ("3360")
        XCTAssertEqual(tagWritten[chapter: "ch03"]?.endTime, 5040)
        // XCTAssertEqual failed: ("3360") is not equal to ("5040")
        XCTAssertEqual(tagWritten[chapter: "ch03"]?.embeddedSubframesTag.title, "Chapter Three")
        // XCTAssertEqual failed: ("Optional("")") is not equal to ("Optional("Chapter Three")")
    }
    
    


}
