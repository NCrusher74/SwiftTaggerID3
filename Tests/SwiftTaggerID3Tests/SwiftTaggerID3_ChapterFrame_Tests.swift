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
        
        XCTAssertEqual(tag?[tableOfContents: true, "TOC"]?.orderedFlag, true)
        XCTAssertEqual(tag?[tableOfContents: true, "TOC"]?.childElementIDs, ["ch0","ch1"])
        XCTAssertEqual(tag?[tableOfContents: true, "TOC"]?.embeddedSubframesTag.title, "")
        
        XCTAssertEqual(tag?[chapter: 0]?.startTime, 0)
        XCTAssertEqual(tag?[chapter: 0]?.endTime, 2795)
        XCTAssertEqual(tag?[chapter: 0]?.embeddedSubframesTag.title, "Chapter 01")

        XCTAssertEqual(tag?[chapter: 2795]?.startTime, 2795)
        XCTAssertEqual(tag?[chapter: 2795]?.endTime, 5250)
        XCTAssertEqual(tag?[chapter: 2795]?.embeddedSubframesTag.title, "Chapter 02")
    }

    // MARK: Frame removal test
    @available(OSX 10.12, *)
    func testFrameRemoval() throws {
        var tag = try TestFile.chapterized.tag()
        
        tag?.removeTOCFrame(isTopLevel: true, withElementID: "TOC")
        tag?.removeChapterFrame(atStartTime: 0)
        tag?.removeChapterFrame(atStartTime: 2795)
        
        let outputUrl = try localDirectory(fileName: "removaltest", fileExtension: "mp3")
        XCTAssertNoThrow(try TestFile.chapterized.mp3File()?.write(
            tagVersion: .v2_4,
            using: tag ?? Tag(readFrom: Mp3File(location: TestFile.chapterized.url)),
            writingTo: outputUrl))
    }

    // MARK: Test version failure
    @available(OSX 10.12, *)
    func testVersionFailureV22() throws {
        var tag = try TestFile.v22.tag()
        
        tag?[chapter: 0]?.startTime = 0
        tag?[chapter: 0]?.endTime = 1680
        tag?[chapter: 0]?.embeddedSubframesTag.title = "Chapter One"
        
        tag?[chapter: 1680]?.startTime = 1680
        tag?[chapter: 1680]?.endTime = 3360
        tag?[chapter: 1680]?.embeddedSubframesTag.title = "Chapter Two"
        
        tag?[chapter: 3360]?.startTime = 3360
        tag?[chapter: 3360]?.endTime = 5040
        tag?[chapter: 3360]?.embeddedSubframesTag.title = "Chapter Three"
        
        let outputUrl = try localDirectory(fileName: "chaptertest", fileExtension: "mp3")
        XCTAssertThrowsError(try TestFile.v22.mp3File()?.write(
            tagVersion: .v2_2,
            using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v22.url)),
            writingTo: outputUrl))
    }

    @available(OSX 10.12, *)
    func testTOCVersionFailurev22() throws {
        var tag = try TestFile.v22.tag()
        
        tag?[tableOfContents: false, "ctoc"]?.topLevelFlag = false
        tag?[tableOfContents: false, "ctoc"]?.orderedFlag = false
        tag?[tableOfContents: false, "ctoc"]?.childElementIDs = ["ch1", "ch2","ch3"]
        tag?[tableOfContents: false, "ctoc"]?.embeddedSubframesTag.title = "Table Of Contents"
        
        let outputUrl = try localDirectory(fileName: "ctoctest", fileExtension: "mp3")
        XCTAssertThrowsError(try TestFile.v22.mp3File()?.write(
            tagVersion: .v2_2,
            using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v22.url)),
            writingTo: outputUrl))
    }
    
    // MARK: Write TOC on blank file
    @available(OSX 10.12, *)
    func testWritingTableOfContentsOnBlankFile() throws {
        var tag = try TestFile.noMeta.tag()

        tag?[tableOfContents: false, "ctoc"]?.topLevelFlag = false
        tag?[tableOfContents: false, "ctoc"]?.orderedFlag = false
        tag?[tableOfContents: false, "ctoc"]?.childElementIDs = ["ch1", "ch2","ch3"]
        tag?[tableOfContents: false, "ctoc"]?.embeddedSubframesTag.title = "Table Of Contents"
        
        let outputUrl = try localDirectory(fileName: "ctoctest", fileExtension: "mp3")
        XCTAssertNoThrow(try TestFile.noMeta.mp3File()?.write(
            tagVersion: .v2_4,
            using: tag ?? Tag(readFrom: Mp3File(location: TestFile.noMeta.url)),
            writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten[tableOfContents: false, "ctoc"]?.topLevelFlag, false)
        XCTAssertEqual(tagWritten[tableOfContents: false, "ctoc"]?.orderedFlag, false)
        XCTAssertEqual(tagWritten[tableOfContents: false, "ctoc"]?.childElementIDs, ["ch1","ch2","ch3"])
        XCTAssertEqual(tagWritten[tableOfContents: false, "ctoc"]?.embeddedSubframesTag.title, "Table Of Contents")
    }

    // MARK: Write multiple tocs
    @available(OSX 10.12, *)
    func testWritingMultipleTableOfContentsOnBlankFile() throws {
        var tag = try TestFile.noMeta.tag()
        
        tag?[tableOfContents: true, "toc1"]?.topLevelFlag = true
        tag?[tableOfContents: true, "toc1"]?.orderedFlag = true
        tag?[tableOfContents: true, "toc1"]?.childElementIDs = ["toc2"]
        tag?[tableOfContents: true, "toc1"]?.embeddedSubframesTag.title = "Table Of Contents (TOP)"
        
        tag?[tableOfContents: false, "toc2"]?.topLevelFlag = false
        tag?[tableOfContents: false, "toc2"]?.orderedFlag = true
        tag?[tableOfContents: false, "toc2"]?.childElementIDs = ["ch1", "ch2", "ch3"]
        tag?[tableOfContents: false, "toc2"]?.embeddedSubframesTag.title = "Table Of Contents (SECONDARY)"
        
        let outputUrl = try localDirectory(fileName: "ctoctest", fileExtension: "mp3")
        XCTAssertNoThrow(try TestFile.noMeta.mp3File()?.write(tagVersion: .v2_4,
                                               using: tag ?? Tag(readFrom: Mp3File(location: TestFile.noMeta.url)),
                                               writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten[tableOfContents: true, "toc1"]?.topLevelFlag, true)
        XCTAssertEqual(tagWritten[tableOfContents: true, "toc1"]?.orderedFlag, true)
        XCTAssertEqual(tagWritten[tableOfContents: true, "toc1"]?.childElementIDs, ["toc2"])
        XCTAssertEqual(tagWritten[tableOfContents: true, "toc1"]?.embeddedSubframesTag.title, "Table Of Contents (TOP)")

        XCTAssertEqual(tagWritten[tableOfContents: false, "toc2"]?.topLevelFlag, false)
        XCTAssertEqual(tagWritten[tableOfContents: false, "toc2"]?.orderedFlag, true)
        XCTAssertEqual(tagWritten[tableOfContents: false, "toc2"]?.childElementIDs, ["ch1", "ch2", "ch3"])
        XCTAssertEqual(tagWritten[tableOfContents: false, "toc2"]?.embeddedSubframesTag.title, "Table Of Contents (SECONDARY)")
    }

    // MARK: Write TOC on populated file
    @available(OSX 10.12, *)
    func testWritingTableOfContentsOnWrittenFile() throws {
        var tag = try TestFile.v24.tag()
        
        tag?[tableOfContents: false, "ctoc"]?.topLevelFlag = false
        tag?[tableOfContents: false, "ctoc"]?.orderedFlag = false
        tag?[tableOfContents: false, "ctoc"]?.childElementIDs = ["ch1", "ch2","ch3"]
        tag?[tableOfContents: false, "ctoc"]?.embeddedSubframesTag.title = "Table Of Contents"
        
        let outputUrl = try localDirectory(fileName: "ctoctest", fileExtension: "mp3")
        XCTAssertNoThrow(try TestFile.v24.mp3File()?.write(tagVersion: .v2_4,
                                               using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v24.url)),
                                               writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten[tableOfContents: false, "ctoc"]?.topLevelFlag, false)
        XCTAssertEqual(tagWritten[tableOfContents: false, "ctoc"]?.orderedFlag, false)
        XCTAssertEqual(tagWritten[tableOfContents: false, "ctoc"]?.childElementIDs, ["ch1","ch2","ch3"])
        XCTAssertEqual(tagWritten[tableOfContents: false, "ctoc"]?.embeddedSubframesTag.title, "Table Of Contents")
    }
    
    @available(OSX 10.12, *)
    func testWritingMultipleTableOfContentsOnWrittenFile() throws {
        var tag = try TestFile.v24.tag()
        
        tag?[tableOfContents: true, "toc1"]?.topLevelFlag = true
        tag?[tableOfContents: true, "toc1"]?.orderedFlag = true
        tag?[tableOfContents: true, "toc1"]?.childElementIDs = ["toc2"]
        tag?[tableOfContents: true, "toc1"]?.embeddedSubframesTag.title = "Table Of Contents (TOP)"
        
        tag?[tableOfContents: false, "toc2"]?.topLevelFlag = false
        tag?[tableOfContents: false, "toc2"]?.orderedFlag = true
        tag?[tableOfContents: false, "toc2"]?.childElementIDs = ["ch1", "ch2", "ch3"]
        tag?[tableOfContents: false, "toc2"]?.embeddedSubframesTag.title = "Table Of Contents (SECONDARY)"
        
        let outputUrl = try localDirectory(fileName: "ctoctest", fileExtension: "mp3")
        XCTAssertNoThrow(try TestFile.v24.mp3File()?.write(tagVersion: .v2_4,
                                               using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v24.url)),
                                               writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten[tableOfContents: true, "toc1"]?.topLevelFlag, true)
        XCTAssertEqual(tagWritten[tableOfContents: true, "toc1"]?.orderedFlag, true)
        XCTAssertEqual(tagWritten[tableOfContents: true, "toc1"]?.childElementIDs, ["toc2"])
        XCTAssertEqual(tagWritten[tableOfContents: true, "toc1"]?.embeddedSubframesTag.title, "Table Of Contents (TOP)")
        
        XCTAssertEqual(tagWritten[tableOfContents: false, "toc2"]?.topLevelFlag, false)
        XCTAssertEqual(tagWritten[tableOfContents: false, "toc2"]?.orderedFlag, true)
        XCTAssertEqual(tagWritten[tableOfContents: false, "toc2"]?.childElementIDs, ["ch1", "ch2", "ch3"])
        XCTAssertEqual(tagWritten[tableOfContents: false, "toc2"]?.embeddedSubframesTag.title, "Table Of Contents (SECONDARY)")
    }

    // MARK: Writing chapters tests
    @available(OSX 10.12, *)
    func testWritingChaptersOnBlankFilev24() throws {
        var tag = Tag()
        
        tag[chapter: 0]?.startTime = 0
        tag[chapter: 0]?.endTime = 1680
        tag[chapter: 0]?.embeddedSubframesTag.title = "Chapter One"
        
        tag[chapter: 1680]?.startTime = 1680
        tag[chapter: 1680]?.endTime = 3360
        tag[chapter: 1680]?.embeddedSubframesTag.title = "Chapter Two"

        tag[chapter: 3360]?.startTime = 3360
        tag[chapter: 3360]?.endTime = 5040
        tag[chapter: 3360]?.embeddedSubframesTag.title = "Chapter Three"
        
        let outputUrl = try localDirectory(fileName: "chaptertest", fileExtension: "mp3")
        XCTAssertNoThrow(try TestFile.noMeta.mp3File()?.write(
            tagVersion: .v2_4, using: tag,
            writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten[chapter: 0]?.startTime, 0)
        XCTAssertEqual(tagWritten[chapter: 0]?.endTime, 1680)
        XCTAssertEqual(tagWritten[chapter: 0]?.embeddedSubframesTag.title, "Chapter One")

        XCTAssertEqual(tagWritten[chapter: 1680]?.startTime, 1680)

        XCTAssertEqual(tagWritten[chapter: 1680]?.endTime, 3360)
        XCTAssertEqual(tagWritten[chapter: 1680]?.embeddedSubframesTag.title, "Chapter Two")

        XCTAssertEqual(tagWritten[chapter: 3360]?.startTime, 3360)
        XCTAssertEqual(tagWritten[chapter: 3360]?.endTime, 5040)
        XCTAssertEqual(tagWritten[chapter: 3360]?.embeddedSubframesTag.title, "Chapter Three")
    }

    @available(OSX 10.12, *)
    func testChaptersOnWrittenFilev24() throws {
        var tag = try TestFile.v24.tag()
        
        tag?[chapter: 0]?.startTime = 0
        tag?[chapter: 0]?.endTime = 1680
        tag?[chapter: 0]?.embeddedSubframesTag.title = "Chapter One"
        
        tag?[chapter: 1680]?.startTime = 1680
        tag?[chapter: 1680]?.endTime = 3360
        tag?[chapter: 1680]?.embeddedSubframesTag.title = "Chapter Two"
        
        tag?[chapter: 3360]?.startTime = 3360
        tag?[chapter: 3360]?.endTime = 5040
        tag?[chapter: 3360]?.embeddedSubframesTag.title = "Chapter Three"
        
        let outputUrl = try localDirectory(fileName: "chaptertest", fileExtension: "mp3")
        XCTAssertNoThrow(try TestFile.v24.mp3File()?.write(
            tagVersion: .v2_4,
            using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v24.url)),
            writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten[chapter: 0]?.startTime, 0)
        XCTAssertEqual(tagWritten[chapter: 0]?.endTime, 1680)
        XCTAssertEqual(tagWritten[chapter: 0]?.embeddedSubframesTag.title, "Chapter One")
        
        XCTAssertEqual(tagWritten[chapter: 1680]?.startTime, 1680)
        XCTAssertEqual(tagWritten[chapter: 1680]?.endTime, 3360)
        XCTAssertEqual(tagWritten[chapter: 1680]?.embeddedSubframesTag.title, "Chapter Two")
        
        XCTAssertEqual(tagWritten[chapter: 3360]?.startTime, 3360)
        XCTAssertEqual(tagWritten[chapter: 3360]?.endTime, 5040)
        XCTAssertEqual(tagWritten[chapter: 3360]?.embeddedSubframesTag.title, "Chapter Three")
    }
    
    @available(OSX 10.12, *)
    func testChaptersOnWrittenFilev23() throws {
        var tag = try TestFile.v23.tag()
        
        tag?[chapter: 0]?.startTime = 0
        tag?[chapter: 0]?.endTime = 1680
        tag?[chapter: 0]?.embeddedSubframesTag.title = "Chapter One"
        
        tag?[chapter: 1680]?.startTime = 1680
        tag?[chapter: 1680]?.endTime = 3360
        tag?[chapter: 1680]?.embeddedSubframesTag.title = "Chapter Two"
        
        tag?[chapter: 3360]?.startTime = 3360
        tag?[chapter: 3360]?.endTime = 5040
        tag?[chapter: 3360]?.embeddedSubframesTag.title = "Chapter Three"
        
        let outputUrl = try localDirectory(fileName: "chaptertest", fileExtension: "mp3")
        XCTAssertNoThrow(try TestFile.v23.mp3File()?.write(
            tagVersion: .v2_3,
            using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v23.url)),
            writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten[chapter: 0]?.startTime, 0)
        XCTAssertEqual(tagWritten[chapter: 0]?.endTime, 1680)
        XCTAssertEqual(tagWritten[chapter: 0]?.embeddedSubframesTag.title, "Chapter One")
        
        XCTAssertEqual(tagWritten[chapter: 1680]?.startTime, 1680)
        XCTAssertEqual(tagWritten[chapter: 1680]?.endTime, 3360)
        XCTAssertEqual(tagWritten[chapter: 1680]?.embeddedSubframesTag.title, "Chapter Two")
        
        XCTAssertEqual(tagWritten[chapter: 3360]?.startTime, 3360)
        XCTAssertEqual(tagWritten[chapter: 3360]?.endTime, 5040)
        XCTAssertEqual(tagWritten[chapter: 3360]?.embeddedSubframesTag.title, "Chapter Three")
    }

    // MARK: Chapters + TOC
    @available(OSX 10.12, *)
    func testChaptersWithTOCv24() throws {
        var tag = try TestFile.v24.tag()
        
        tag?[tableOfContents: true, "ctoc"]?.topLevelFlag = true
        tag?[tableOfContents: true, "ctoc"]?.orderedFlag = true
        tag?[tableOfContents: true, "ctoc"]?.childElementIDs = ["ch01", "ch02","ch03"]
        tag?[tableOfContents: true, "ctoc"]?.embeddedSubframesTag.title = "Table Of Contents"

        tag?[chapter: 0]?.startTime = 0
        tag?[chapter: 0]?.endTime = 1680
        tag?[chapter: 0]?.embeddedSubframesTag.title = "Chapter One"
        
        tag?[chapter: 1680]?.startTime = 1680
        tag?[chapter: 1680]?.endTime = 3360
        tag?[chapter: 1680]?.embeddedSubframesTag.title = "Chapter Two"
        
        tag?[chapter: 3360]?.startTime = 3360
        tag?[chapter: 3360]?.endTime = 5040
        tag?[chapter: 3360]?.embeddedSubframesTag.title = "Chapter Three"
        
        let outputUrl = try localDirectory(fileName: "chapterplustoctest", fileExtension: "mp3")
        XCTAssertNoThrow(try TestFile.v24.mp3File()?.write(
            tagVersion: .v2_4,
            using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v24.url)),
            writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten[tableOfContents: true, "ctoc"]?.topLevelFlag, true)
        XCTAssertEqual(tagWritten[tableOfContents: true, "ctoc"]?.orderedFlag, true)
        XCTAssertEqual(tagWritten[tableOfContents: true, "ctoc"]?.childElementIDs, ["ch01","ch02","ch03"])
        XCTAssertEqual(tagWritten[tableOfContents: true, "ctoc"]?.embeddedSubframesTag.title, "Table Of Contents")

        XCTAssertEqual(tagWritten[chapter: 0]?.startTime, 0)
        XCTAssertEqual(tagWritten[chapter: 0]?.endTime, 1680)
        XCTAssertEqual(tagWritten[chapter: 0]?.embeddedSubframesTag.title, "Chapter One")
        
        XCTAssertEqual(tagWritten[chapter: 1680]?.startTime, 1680)
        
        XCTAssertEqual(tagWritten[chapter: 1680]?.endTime, 3360)
        XCTAssertEqual(tagWritten[chapter: 1680]?.embeddedSubframesTag.title, "Chapter Two")
        
        XCTAssertEqual(tagWritten[chapter: 3360]?.startTime, 3360)
        XCTAssertEqual(tagWritten[chapter: 3360]?.endTime, 5040)
        XCTAssertEqual(tagWritten[chapter: 3360]?.embeddedSubframesTag.title, "Chapter Three")
    }

    @available(OSX 10.12, *)
    func testChaptersWithTOCv23() throws {
        var tag = try TestFile.v23.tag()
        
        tag?[tableOfContents: true, "ctoc"]?.topLevelFlag = true
        tag?[tableOfContents: true, "ctoc"]?.orderedFlag = true
        tag?[tableOfContents: true, "ctoc"]?.childElementIDs = ["ch01", "ch02","ch03"]
        tag?[tableOfContents: true, "ctoc"]?.embeddedSubframesTag.title = "Table Of Contents"
        
        tag?[chapter: 0]?.startTime = 0
        tag?[chapter: 0]?.endTime = 1680
        tag?[chapter: 0]?.embeddedSubframesTag.title = "Chapter One"
        
        tag?[chapter: 1680]?.startTime = 1680
        tag?[chapter: 1680]?.endTime = 3360
        tag?[chapter: 1680]?.embeddedSubframesTag.title = "Chapter Two"
        
        tag?[chapter: 3360]?.startTime = 3360
        tag?[chapter: 3360]?.endTime = 5040
        tag?[chapter: 3360]?.embeddedSubframesTag.title = "Chapter Three"
        
        let outputUrl = try localDirectory(fileName: "chapterplustoctest", fileExtension: "mp3")
        XCTAssertNoThrow(try TestFile.v23.mp3File()?.write(
            tagVersion: .v2_3,
            using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v23.url)),
            writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten[tableOfContents: true, "ctoc"]?.topLevelFlag, true)
        XCTAssertEqual(tagWritten[tableOfContents: true, "ctoc"]?.orderedFlag, true)
        XCTAssertEqual(tagWritten[tableOfContents: true, "ctoc"]?.childElementIDs, ["ch01","ch02","ch03"])
        XCTAssertEqual(tagWritten[tableOfContents: true, "ctoc"]?.embeddedSubframesTag.title, "Table Of Contents")
        
        XCTAssertEqual(tagWritten[chapter: 0]?.startTime, 0)
        XCTAssertEqual(tagWritten[chapter: 0]?.endTime, 1680)
        XCTAssertEqual(tagWritten[chapter: 0]?.embeddedSubframesTag.title, "Chapter One")
        
        XCTAssertEqual(tagWritten[chapter: 1680]?.startTime, 1680)
        
        XCTAssertEqual(tagWritten[chapter: 1680]?.endTime, 3360)
        XCTAssertEqual(tagWritten[chapter: 1680]?.embeddedSubframesTag.title, "Chapter Two")
        
        XCTAssertEqual(tagWritten[chapter: 3360]?.startTime, 3360)
        XCTAssertEqual(tagWritten[chapter: 3360]?.endTime, 5040)
        XCTAssertEqual(tagWritten[chapter: 3360]?.embeddedSubframesTag.title, "Chapter Three")
    }
    
    // MARK: Overwriting
    @available(OSX 10.12, *)
    func testOverwritingChaptersWithTOCv23() throws {
        var tag = try TestFile.chapterized.tag()
        
        tag?[tableOfContents: true, "ctoc"]?.topLevelFlag = true
        tag?[tableOfContents: true, "ctoc"]?.orderedFlag = true
        tag?[tableOfContents: true, "ctoc"]?.childElementIDs = ["ch01", "ch02","ch03"]
        tag?[tableOfContents: true, "ctoc"]?.embeddedSubframesTag.title = "Table Of Contents"
        
        tag?[chapter: 0]?.startTime = 0
        tag?[chapter: 0]?.endTime = 1680
        tag?[chapter: 0]?.embeddedSubframesTag.title = "Chapter One"
        
        tag?[chapter: 1680]?.startTime = 1680
        tag?[chapter: 1680]?.endTime = 3360
        tag?[chapter: 1680]?.embeddedSubframesTag.title = "Chapter Two"
        
        tag?[chapter: 3360]?.startTime = 3360
        tag?[chapter: 3360]?.endTime = 5040
        tag?[chapter: 3360]?.embeddedSubframesTag.title = "Chapter Three"
        
        let outputUrl = try localDirectory(fileName: "chapterplustoctest", fileExtension: "mp3")
        XCTAssertNoThrow(try TestFile.chapterized.mp3File()?.write(
            tagVersion: .v2_4,
            using: tag ?? Tag(readFrom: Mp3File(location: TestFile.chapterized.url)),
            writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten[tableOfContents: true, "ctoc"]?.topLevelFlag, true) // fails
        XCTAssertEqual(tagWritten[tableOfContents: true, "ctoc"]?.orderedFlag, true)
        XCTAssertEqual(tagWritten[tableOfContents: true, "ctoc"]?.childElementIDs, ["ch01","ch02","ch03"])
        XCTAssertEqual(tagWritten[tableOfContents: true, "ctoc"]?.embeddedSubframesTag.title, "Table Of Contents")
        
        XCTAssertEqual(tagWritten[chapter: 0]?.startTime, 0)
        XCTAssertEqual(tagWritten[chapter: 0]?.endTime, 1680)
        XCTAssertEqual(tagWritten[chapter: 0]?.embeddedSubframesTag.title, "Chapter One")
        
        XCTAssertEqual(tagWritten[chapter: 1680]?.startTime, 1680)
        
        XCTAssertEqual(tagWritten[chapter: 1680]?.endTime, 3360)
        XCTAssertEqual(tagWritten[chapter: 1680]?.embeddedSubframesTag.title, "Chapter Two")
        
        XCTAssertEqual(tagWritten[chapter: 3360]?.startTime, 3360)
        XCTAssertEqual(tagWritten[chapter: 3360]?.endTime, 5040)
        XCTAssertEqual(tagWritten[chapter: 3360]?.embeddedSubframesTag.title, "Chapter Three")
    }
    
    #warning("TO DO: need to figure out how to produce a list of chapter/toc frames that doesn't depend on knowing the start time or element ID")
}
