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
        XCTAssertEqual(tag[tableOfContents: "TOC"]?.childElementIDs, ["ch0", "ch1"])
        XCTAssertEqual(tag[embeddedSubframes: "TOC"]?.title, "")
        
        XCTAssertEqual(tag[chapters: "ch0"]?.startTime, 0)
        XCTAssertEqual(tag[chapters: "ch0"]?.endTime, 2795)
        XCTAssertEqual(tag[embeddedSubframes: "ch0"]?.title, "Chapter 01")

        XCTAssertEqual(tag[chapters: "ch1"]?.startTime, 2795)
        XCTAssertEqual(tag[chapters: "ch1"]?.endTime, 5250)
        XCTAssertEqual(tag[embeddedSubframes: "ch1"]?.title, "Chapter 02")
    }
    
    @available(OSX 10.12, *)
    func testWritingTableOfContentsOnBlankFile() throws {
        var tag = try tagNoMeta()
        
        tag[tableOfContents: "ctoc"]?.topLevelFlag = true
        tag[tableOfContents: "ctoc"]?.orderedFlag = true
        tag[tableOfContents: "ctoc"]?.childElementIDs = ["ch01", "ch02", "ch03"]
        var tocSubframeTag = tag[embeddedSubframes: "ctoc"]
        tocSubframeTag?.title = "Table Of Contents"
        
        // need to tie this back into tag somehow
        let outputUrl = try localDirectory(fileName: "ctoctest", fileExtension: "mp3")
        XCTAssertNoThrow(try mp3NoMeta().write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))
        
        
    }
    
    
    
}
