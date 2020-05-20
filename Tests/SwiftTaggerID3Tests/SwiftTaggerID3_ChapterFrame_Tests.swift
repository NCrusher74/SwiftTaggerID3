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
        XCTAssertEqual(tag[tableOfContents: "TOC"]?.entryCount, 2)
        XCTAssertEqual(tag[tableOfContents: "TOC"]?.childElementIDs, ["ch0", "ch1"])
        // how to test for embedded subframes?
        
        XCTAssertEqual(tag[chapters: "ch0"]?.startTime, 0)
        XCTAssertEqual(tag[chapters: "ch0"]?.endTime, 2795)
        XCTAssertEqual(tag[chapters: "ch1"]?.startTime, 2795)
        XCTAssertEqual(tag[chapters: "ch1"]?.endTime, 5250)
        // how to test for subframes
    }
    
}
