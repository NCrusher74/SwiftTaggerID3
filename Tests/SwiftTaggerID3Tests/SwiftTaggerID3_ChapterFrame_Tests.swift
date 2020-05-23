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
        let tag = try TestFile.chapterized.tag()
        
        XCTAssertEqual(tag?[tableOfContents: "TOC"]?.topLevelFlag, true)
        XCTAssertEqual(tag?[tableOfContents: "TOC"]?.orderedFlag, true)
        XCTAssertEqual(tag?[tableOfContents: "TOC"]?.childElementIDs, ["ch0","ch1"])
        XCTAssertEqual(tag?[tableOfContents: "TOC"]?.embeddedSubframesTag.title, "")
        
        XCTAssertEqual(tag?[chapter: "ch0"]?.startTime, 0)
        XCTAssertEqual(tag?[chapter: "ch0"]?.endTime, 2795)
        XCTAssertEqual(tag?[chapter: "ch0"]?.embeddedSubframesTag.title, "Chapter 01")

        XCTAssertEqual(tag?[chapter: "ch1"]?.startTime, 2795)
        XCTAssertEqual(tag?[chapter: "ch1"]?.endTime, 5250)
        XCTAssertEqual(tag?[chapter: "ch1"]?.embeddedSubframesTag.title, "Chapter 02")
    }

    @available(OSX 10.12, *)
    func testFrameRemoval() throws {
        var tag = try TestFile.chapterized.tag()
        
        tag?.removeTOCFrame(withElementID: "TOC")
        tag?.removeChapterFrame(withElementID: "ch0")
        tag?.removeChapterFrame(withElementID: "ch1")
        
        let outputUrl = try localDirectory(fileName: "removaltest", fileExtension: "mp3")
        XCTAssertNoThrow(try TestFile.chapterized.mp3File()?.write(
            tagVersion: .v2_4,
            using: tag ?? Tag(readFrom: Mp3File(location: TestFile.chapterized.url)),
            writingTo: outputUrl))
    }

    @available(OSX 10.12, *)
    func testWritingTableOfContentsOnBlankFile() throws {
        var tag = try TestFile.noMeta.tag()

        tag?[tableOfContents: "ctoc"]?.topLevelFlag = false
        tag?[tableOfContents: "ctoc"]?.orderedFlag = false
        tag?[tableOfContents: "ctoc"]?.childElementIDs = ["ch1", "ch2","ch3"]
        tag?[tableOfContents: "ctoc"]?.embeddedSubframesTag.title = "Table Of Contents"
        
        let outputUrl = try localDirectory(fileName: "ctoctest", fileExtension: "mp3")
        XCTAssertNoThrow(try TestFile.noMeta.mp3File()?.write(
            tagVersion: .v2_4,
            using: tag ?? Tag(readFrom: Mp3File(location: TestFile.noMeta.url)),
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
        var tag = try TestFile.noMeta.tag()
        
        tag?[tableOfContents: "toc1"]?.topLevelFlag = true
        tag?[tableOfContents: "toc1"]?.orderedFlag = true
        tag?[tableOfContents: "toc1"]?.childElementIDs = ["toc2"]
        tag?[tableOfContents: "toc1"]?.embeddedSubframesTag.title = "Table Of Contents (TOP)"
        
        tag?[tableOfContents: "toc2"]?.topLevelFlag = false
        tag?[tableOfContents: "toc2"]?.orderedFlag = true
        tag?[tableOfContents: "toc2"]?.childElementIDs = ["ch1", "ch2", "ch3"]
        tag?[tableOfContents: "toc2"]?.embeddedSubframesTag.title = "Table Of Contents (SECONDARY)"
        
        let outputUrl = try localDirectory(fileName: "ctoctest", fileExtension: "mp3")
        XCTAssertNoThrow(try TestFile.noMeta.mp3File()?.write(tagVersion: .v2_4,
                                               using: tag ?? Tag(readFrom: Mp3File(location: TestFile.noMeta.url)),
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
        var tag = try TestFile.v24.tag()
        
        tag?[tableOfContents: "ctoc"]?.topLevelFlag = false
        tag?[tableOfContents: "ctoc"]?.orderedFlag = false
        tag?[tableOfContents: "ctoc"]?.childElementIDs = ["ch1", "ch2","ch3"]
        tag?[tableOfContents: "ctoc"]?.embeddedSubframesTag.title = "Table Of Contents"
        
        let outputUrl = try localDirectory(fileName: "ctoctest", fileExtension: "mp3")
        XCTAssertNoThrow(try TestFile.v24.mp3File()?.write(tagVersion: .v2_4,
                                               using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v24.url)),
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
        var tag = try TestFile.v24.tag()
        
        tag?[tableOfContents: "toc1"]?.topLevelFlag = true
        tag?[tableOfContents: "toc1"]?.orderedFlag = true
        tag?[tableOfContents: "toc1"]?.childElementIDs = ["toc2"]
        tag?[tableOfContents: "toc1"]?.embeddedSubframesTag.title = "Table Of Contents (TOP)"
        
        tag?[tableOfContents: "toc2"]?.topLevelFlag = false
        tag?[tableOfContents: "toc2"]?.orderedFlag = true
        tag?[tableOfContents: "toc2"]?.childElementIDs = ["ch1", "ch2", "ch3"]
        tag?[tableOfContents: "toc2"]?.embeddedSubframesTag.title = "Table Of Contents (SECONDARY)"
        
        let outputUrl = try localDirectory(fileName: "ctoctest", fileExtension: "mp3")
        XCTAssertNoThrow(try TestFile.v24.mp3File()?.write(tagVersion: .v2_4,
                                               using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v24.url)),
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
        XCTAssertNoThrow(try TestFile.noMeta.mp3File()?.write(
            tagVersion: .v2_4, using: tag,
            writingTo: outputUrl))
        
        // MARK: Confirm accuracy
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten[chapter: "ch01"]?.startTime, 0)
        XCTAssertEqual(tagWritten[chapter: "ch01"]?.endTime, 1680)
        XCTAssertEqual(tagWritten[chapter: "ch01"]?.embeddedSubframesTag.title, "Chapter One")

        XCTAssertEqual(tagWritten[chapter: "ch02"]?.startTime, 1680)

        XCTAssertEqual(tagWritten[chapter: "ch02"]?.endTime, 3360)
        XCTAssertEqual(tagWritten[chapter: "ch02"]?.embeddedSubframesTag.title, "Chapter Two")

        XCTAssertEqual(tagWritten[chapter: "ch03"]?.startTime, 3360)
        XCTAssertEqual(tagWritten[chapter: "ch03"]?.endTime, 5040)
        XCTAssertEqual(tagWritten[chapter: "ch03"]?.embeddedSubframesTag.title, "Chapter Three")
    }

    @available(OSX 10.12, *)
    func testOverwritingChaptersv24() throws {
        var tag = try TestFile.v24.tag()
        
        tag?[chapter: "ch01"]?.startTime = 0
        tag?[chapter: "ch01"]?.endTime = 1680
        tag?[chapter: "ch01"]?.embeddedSubframesTag.title = "Chapter One"
        
        tag?[chapter: "ch02"]?.startTime = 1680
        tag?[chapter: "ch02"]?.endTime = 3360
        tag?[chapter: "ch02"]?.embeddedSubframesTag.title = "Chapter Two"
        
        tag?[chapter: "ch03"]?.startTime = 3360
        tag?[chapter: "ch03"]?.endTime = 5040
        tag?[chapter: "ch03"]?.embeddedSubframesTag.title = "Chapter Three"
        
        let outputUrl = try localDirectory(fileName: "chaptertest", fileExtension: "mp3")
        XCTAssertNoThrow(try TestFile.v24.mp3File()?.write(
            tagVersion: .v2_4,
            using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v24.url)),
            writingTo: outputUrl))
        
        // MARK: Confirm accuracy
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten[chapter: "ch01"]?.startTime, 0)
        XCTAssertEqual(tagWritten[chapter: "ch01"]?.endTime, 1680)
        XCTAssertEqual(tagWritten[chapter: "ch01"]?.embeddedSubframesTag.title, "Chapter One")
        
        XCTAssertEqual(tagWritten[chapter: "ch02"]?.startTime, 1680)
        
        XCTAssertEqual(tagWritten[chapter: "ch02"]?.endTime, 3360)
        XCTAssertEqual(tagWritten[chapter: "ch02"]?.embeddedSubframesTag.title, "Chapter Two")
        
        XCTAssertEqual(tagWritten[chapter: "ch03"]?.startTime, 3360)
        XCTAssertEqual(tagWritten[chapter: "ch03"]?.endTime, 5040)
        XCTAssertEqual(tagWritten[chapter: "ch03"]?.embeddedSubframesTag.title, "Chapter Three")
    }
    
    @available(OSX 10.12, *)
    func testOverwritingChaptersv23() throws {
        var tag = try TestFile.v23.tag()
        
        tag?[chapter: "ch01"]?.startTime = 0
        tag?[chapter: "ch01"]?.endTime = 1680
        tag?[chapter: "ch01"]?.embeddedSubframesTag.title = "Chapter One"
        
        tag?[chapter: "ch02"]?.startTime = 1680
        tag?[chapter: "ch02"]?.endTime = 3360
        tag?[chapter: "ch02"]?.embeddedSubframesTag.title = "Chapter Two"
        
        tag?[chapter: "ch03"]?.startTime = 3360
        tag?[chapter: "ch03"]?.endTime = 5040
        tag?[chapter: "ch03"]?.embeddedSubframesTag.title = "Chapter Three"
        
        let outputUrl = try localDirectory(fileName: "chaptertest", fileExtension: "mp3")
        XCTAssertNoThrow(try TestFile.v23.mp3File()?.write(
            tagVersion: .v2_3,
            using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v23.url)),
            writingTo: outputUrl))
        
        // MARK: Confirm accuracy
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten[chapter: "ch01"]?.startTime, 0)
        XCTAssertEqual(tagWritten[chapter: "ch01"]?.endTime, 1680)
        XCTAssertEqual(tagWritten[chapter: "ch01"]?.embeddedSubframesTag.title, "Chapter One")
        
        XCTAssertEqual(tagWritten[chapter: "ch02"]?.startTime, 1680)
        
        XCTAssertEqual(tagWritten[chapter: "ch02"]?.endTime, 3360)
        XCTAssertEqual(tagWritten[chapter: "ch02"]?.embeddedSubframesTag.title, "Chapter Two")
        
        XCTAssertEqual(tagWritten[chapter: "ch03"]?.startTime, 3360)
        XCTAssertEqual(tagWritten[chapter: "ch03"]?.endTime, 5040)
        XCTAssertEqual(tagWritten[chapter: "ch03"]?.embeddedSubframesTag.title, "Chapter Three")
    }

    @available(OSX 10.12, *)
    func testVersionFailureV22() throws {
        var tag = try TestFile.v22.tag()
        
        tag?[chapter: "ch01"]?.startTime = 0
        tag?[chapter: "ch01"]?.endTime = 1680
        tag?[chapter: "ch01"]?.embeddedSubframesTag.title = "Chapter One"
        
        tag?[chapter: "ch02"]?.startTime = 1680
        tag?[chapter: "ch02"]?.endTime = 3360
        tag?[chapter: "ch02"]?.embeddedSubframesTag.title = "Chapter Two"
        
        tag?[chapter: "ch03"]?.startTime = 3360
        tag?[chapter: "ch03"]?.endTime = 5040
        tag?[chapter: "ch03"]?.embeddedSubframesTag.title = "Chapter Three"
        
        let outputUrl = try localDirectory(fileName: "chaptertest", fileExtension: "mp3")
        XCTAssertThrowsError(try TestFile.v22.mp3File()?.write(
            tagVersion: .v2_2,
            using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v22.url)),
            writingTo: outputUrl))
        }

    @available(OSX 10.12, *)
    func testChaptersWithTOCv24() throws {
        var tag = try TestFile.v24.tag()
        
        tag?[tableOfContents: "ctoc"]?.topLevelFlag = true
        tag?[tableOfContents: "ctoc"]?.orderedFlag = true
        tag?[tableOfContents: "ctoc"]?.childElementIDs = ["ch01", "ch02","ch03"]
        tag?[tableOfContents: "ctoc"]?.embeddedSubframesTag.title = "Table Of Contents"

        tag?[chapter: "ch01"]?.startTime = 0
        tag?[chapter: "ch01"]?.endTime = 1680
        tag?[chapter: "ch01"]?.embeddedSubframesTag.title = "Chapter One"
        
        tag?[chapter: "ch02"]?.startTime = 1680
        tag?[chapter: "ch02"]?.endTime = 3360
        tag?[chapter: "ch02"]?.embeddedSubframesTag.title = "Chapter Two"
        
        tag?[chapter: "ch03"]?.startTime = 3360
        tag?[chapter: "ch03"]?.endTime = 5040
        tag?[chapter: "ch03"]?.embeddedSubframesTag.title = "Chapter Three"
        
        let outputUrl = try localDirectory(fileName: "chapterplustoctest", fileExtension: "mp3")
        XCTAssertNoThrow(try TestFile.v24.mp3File()?.write(
            tagVersion: .v2_4,
            using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v24.url)),
            writingTo: outputUrl))
        
        // MARK: Confirm accuracy
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten[tableOfContents: "ctoc"]?.topLevelFlag, true) // fails
        XCTAssertEqual(tagWritten[tableOfContents: "ctoc"]?.orderedFlag, true)
        XCTAssertEqual(tagWritten[tableOfContents: "ctoc"]?.childElementIDs, ["ch01","ch02","ch03"])
        XCTAssertEqual(tagWritten[tableOfContents: "ctoc"]?.embeddedSubframesTag.title, "Table Of Contents")

        XCTAssertEqual(tagWritten[chapter: "ch01"]?.startTime, 0)
        XCTAssertEqual(tagWritten[chapter: "ch01"]?.endTime, 1680)
        XCTAssertEqual(tagWritten[chapter: "ch01"]?.embeddedSubframesTag.title, "Chapter One")
        
        XCTAssertEqual(tagWritten[chapter: "ch02"]?.startTime, 1680)
        
        XCTAssertEqual(tagWritten[chapter: "ch02"]?.endTime, 3360)
        XCTAssertEqual(tagWritten[chapter: "ch02"]?.embeddedSubframesTag.title, "Chapter Two")
        
        XCTAssertEqual(tagWritten[chapter: "ch03"]?.startTime, 3360)
        XCTAssertEqual(tagWritten[chapter: "ch03"]?.endTime, 5040)
        XCTAssertEqual(tagWritten[chapter: "ch03"]?.embeddedSubframesTag.title, "Chapter Three")
    }

    @available(OSX 10.12, *)
    func testChaptersWithTOCv23() throws {
        var tag = try TestFile.v23.tag()
        
        tag?[tableOfContents: "ctoc"]?.topLevelFlag = true
        tag?[tableOfContents: "ctoc"]?.orderedFlag = true
        tag?[tableOfContents: "ctoc"]?.childElementIDs = ["ch01", "ch02","ch03"]
        tag?[tableOfContents: "ctoc"]?.embeddedSubframesTag.title = "Table Of Contents"
        
        tag?[chapter: "ch01"]?.startTime = 0
        tag?[chapter: "ch01"]?.endTime = 1680
        tag?[chapter: "ch01"]?.embeddedSubframesTag.title = "Chapter One"
        
        tag?[chapter: "ch02"]?.startTime = 1680
        tag?[chapter: "ch02"]?.endTime = 3360
        tag?[chapter: "ch02"]?.embeddedSubframesTag.title = "Chapter Two"
        
        tag?[chapter: "ch03"]?.startTime = 3360
        tag?[chapter: "ch03"]?.endTime = 5040
        tag?[chapter: "ch03"]?.embeddedSubframesTag.title = "Chapter Three"
        
        let outputUrl = try localDirectory(fileName: "chapterplustoctest", fileExtension: "mp3")
        XCTAssertNoThrow(try TestFile.v23.mp3File()?.write(
            tagVersion: .v2_3,
            using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v23.url)),
            writingTo: outputUrl))
        
        // MARK: Confirm accuracy
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten[tableOfContents: "ctoc"]?.topLevelFlag, true) // fails
        XCTAssertEqual(tagWritten[tableOfContents: "ctoc"]?.orderedFlag, true)
        XCTAssertEqual(tagWritten[tableOfContents: "ctoc"]?.childElementIDs, ["ch01","ch02","ch03"])
        XCTAssertEqual(tagWritten[tableOfContents: "ctoc"]?.embeddedSubframesTag.title, "Table Of Contents")
        
        XCTAssertEqual(tagWritten[chapter: "ch01"]?.startTime, 0)
        XCTAssertEqual(tagWritten[chapter: "ch01"]?.endTime, 1680)
        XCTAssertEqual(tagWritten[chapter: "ch01"]?.embeddedSubframesTag.title, "Chapter One")
        
        XCTAssertEqual(tagWritten[chapter: "ch02"]?.startTime, 1680)
        
        XCTAssertEqual(tagWritten[chapter: "ch02"]?.endTime, 3360)
        XCTAssertEqual(tagWritten[chapter: "ch02"]?.embeddedSubframesTag.title, "Chapter Two")
        
        XCTAssertEqual(tagWritten[chapter: "ch03"]?.startTime, 3360)
        XCTAssertEqual(tagWritten[chapter: "ch03"]?.endTime, 5040)
        XCTAssertEqual(tagWritten[chapter: "ch03"]?.embeddedSubframesTag.title, "Chapter Three")
    }
    
    @available(OSX 10.12, *)
    func testOverwritingChaptersWithTOCv23() throws {
        var tag = try TestFile.chapterized.tag()
        
        tag?[tableOfContents: "ctoc"]?.topLevelFlag = true
        tag?[tableOfContents: "ctoc"]?.orderedFlag = true
        tag?[tableOfContents: "ctoc"]?.childElementIDs = ["ch01", "ch02","ch03"]
        tag?[tableOfContents: "ctoc"]?.embeddedSubframesTag.title = "Table Of Contents"
        
        tag?[chapter: "ch01"]?.startTime = 0
        tag?[chapter: "ch01"]?.endTime = 1680
        tag?[chapter: "ch01"]?.embeddedSubframesTag.title = "Chapter One"
        
        tag?[chapter: "ch02"]?.startTime = 1680
        tag?[chapter: "ch02"]?.endTime = 3360
        tag?[chapter: "ch02"]?.embeddedSubframesTag.title = "Chapter Two"
        
        tag?[chapter: "ch03"]?.startTime = 3360
        tag?[chapter: "ch03"]?.endTime = 5040
        tag?[chapter: "ch03"]?.embeddedSubframesTag.title = "Chapter Three"
        
        let outputUrl = try localDirectory(fileName: "chapterplustoctest", fileExtension: "mp3")
        XCTAssertNoThrow(try TestFile.chapterized.mp3File()?.write(
            tagVersion: .v2_4,
            using: tag ?? Tag(readFrom: Mp3File(location: TestFile.chapterized.url)),
            writingTo: outputUrl))
        
        // MARK: Confirm accuracy
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten[tableOfContents: "ctoc"]?.topLevelFlag, true) // fails
        XCTAssertEqual(tagWritten[tableOfContents: "ctoc"]?.orderedFlag, true)
        XCTAssertEqual(tagWritten[tableOfContents: "ctoc"]?.childElementIDs, ["ch01","ch02","ch03"])
        XCTAssertEqual(tagWritten[tableOfContents: "ctoc"]?.embeddedSubframesTag.title, "Table Of Contents")
        
        XCTAssertEqual(tagWritten[chapter: "ch01"]?.startTime, 0)
        XCTAssertEqual(tagWritten[chapter: "ch01"]?.endTime, 1680)
        XCTAssertEqual(tagWritten[chapter: "ch01"]?.embeddedSubframesTag.title, "Chapter One")
        
        XCTAssertEqual(tagWritten[chapter: "ch02"]?.startTime, 1680)
        
        XCTAssertEqual(tagWritten[chapter: "ch02"]?.endTime, 3360)
        XCTAssertEqual(tagWritten[chapter: "ch02"]?.embeddedSubframesTag.title, "Chapter Two")
        
        XCTAssertEqual(tagWritten[chapter: "ch03"]?.startTime, 3360)
        XCTAssertEqual(tagWritten[chapter: "ch03"]?.endTime, 5040)
        XCTAssertEqual(tagWritten[chapter: "ch03"]?.embeddedSubframesTag.title, "Chapter Three")
    }


}
