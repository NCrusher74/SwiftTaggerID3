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
        
        XCTAssertEqual(tag[chapter: 0]?.endTime, 2795)
        XCTAssertEqual(tag[chapter: 0]?.elementID, "ch0")
        XCTAssertEqual(tag[chapter: 0]?.embeddedSubframesTag.title, "Chapter 01")

        XCTAssertEqual(tag[chapter: 2795]?.endTime, 5250)
        XCTAssertEqual(tag[chapter: 2795]?.elementID, "ch1")
        XCTAssertEqual(tag[chapter: 2795]?.embeddedSubframesTag.title, "Chapter 02")
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
        
        XCTAssertEqual(tagWritten[tableOfContents: "ctoc"]?.topLevelFlag, false)
        XCTAssertEqual(tagWritten[tableOfContents: "ctoc"]?.orderedFlag, false)
        XCTAssertEqual(tagWritten[tableOfContents: "ctoc"]?.childElementIDs, ["ch1","ch2","ch3"])
        XCTAssertEqual(tagWritten[tableOfContents: "ctoc"]?.embeddedSubframesTag.title, "Table Of Contents")
        XCTAssertNil(tagWritten[tableOfContents: "TOC"])
    }
    
    @available(OSX 10.12, *)
    func testWritingTableOfContentsOnWrittenFile() throws {
        var tag = try tagNoMeta()
        
        tag[tableOfContents: "TOC"] = nil
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
        
        print(tagWritten[tableOfContents: "TOC"])
        print(tagWritten[tableOfContents: "ctoc"])
        XCTAssertEqual(tagWritten[tableOfContents: "ctoc"]?.topLevelFlag, false)
        XCTAssertEqual(tagWritten[tableOfContents: "ctoc"]?.orderedFlag, false)
        XCTAssertEqual(tagWritten[tableOfContents: "ctoc"]?.childElementIDs, ["ch1","ch2","ch3"])
        XCTAssertEqual(tagWritten[tableOfContents: "ctoc"]?.embeddedSubframesTag.title, "Table Of Contents")
        XCTAssertNil(tagWritten[tableOfContents: "TOC"])
    }

}
