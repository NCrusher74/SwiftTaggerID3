///*
//
// SwiftTaggerID3_ChapterFrame_Tests.swift
// SwiftTaggerID3
//
// Copyright ©2020 Nolaine Crusher. All rights reserved.
//
// */
//
//import XCTest
//import SwiftTaggerID3
//@testable import SwiftTaggerID3

//// Tests for chapter frame and CTOC frame
//class SwiftTaggerID3_ChapterFrame_Tests: XCTestCase {
//
//    // // MARK: - Read test
//    @available(OSX 10.12, *)
//    func testReadChapterizedFile() throws {
//        let tag = try TestFile.chapterized.tag()
//
//        XCTAssertEqual(tag?.chapterList.count,2)
//        XCTAssertEqual(tag?.chapterList[0].startTime, 0)
//        XCTAssertEqual(tag?.chapterList[0].title, "Chapter 01")
//        XCTAssertEqual(tag?.chapterList[1].startTime, 2795)
//        XCTAssertEqual(tag?.chapterList[1].title, "Chapter 02")
//    }
//
//    @available(OSX 10.12, *)
//    func testAddChapterToChapteredFile() throws {
//        var tag = try TestFile.chapterized.tag()
//        tag?.addChapter(at: 3800, title: "Chapter 03")
//        
//        let outputUrl = try localDirectory(fileName: "STID3_chaptertest", fileExtension: "mp3")
//        //        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
//        XCTAssertNoThrow(try TestFile.chapterized.mp3File()?.write(
//            tagVersion: .v2_4,
//            using: tag ?? Tag(readFrom: Mp3File(location: TestFile.chapterized.url)),
//            writingTo: outputUrl))
//        
//        let outputFile = try Mp3File(location: outputUrl)
//        let output = try Tag(readFrom: outputFile)
//        
//        XCTAssertEqual(output.chapterList.count,3)
//        XCTAssertEqual(output.chapterList[0].startTime, 0)
//        XCTAssertEqual(output.chapterList[0].title, "Chapter 01")
//        XCTAssertEqual(output.chapterList[1].startTime, 2795)
//        XCTAssertEqual(output.chapterList[1].title, "Chapter 02")
//        XCTAssertEqual(output.chapterList[2].startTime, 3800)
//        XCTAssertEqual(output.chapterList[2].title, "Chapter 03")
//    }
//    
//    // // MARK: - Frame removal test
//    @available(OSX 10.12, *)
//    func testFrameRemoval() throws {
//        var tag = try TestFile.chapterized.tag()
//
//        tag?.removeAllChapters()
//        
//        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
//
//        XCTAssertNoThrow(try TestFile.chapterized.mp3File()?.write(
//            tagVersion: .v2_4,
//            using: tag ?? Tag(readFrom: Mp3File(location: TestFile.chapterized.url)),
//            writingTo: outputUrl))
//        
//        let writtenFile = try Mp3File(location: outputUrl)
//        let writtenTag = try Tag(readFrom: writtenFile)
//        
//        XCTAssertTrue(writtenTag.chapterList.isEmpty)
//    }
//
//    // // MARK: - Writing test
//    @available(OSX 10.12, *)
//    func testFrameWriting() throws {
//        var tag = try TestFile.noMeta.tag()
//        
//        tag?.addChapter(at: 0, title: "Chapter 001")
//        tag?.addChapter(at: 1680, title: "Chapter 002")
//        tag?.addChapter(at: 3360, title: "Chapter 003")
//        
//        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
//        XCTAssertNoThrow(try TestFile.noMeta.mp3File()?.write(
//            tagVersion: .v2_4,
//            using: tag ?? Tag(readFrom: Mp3File(location: TestFile.noMeta.url)),
//            writingTo: outputUrl))
//        
//        let writtenFile = try Mp3File(location: outputUrl)
//        let writtenTag = try Tag(readFrom: writtenFile)
//
//        XCTAssertEqual(writtenTag.chapterList[0].startTime, 0)
//        XCTAssertEqual(writtenTag.chapterList[0].title, "Chapter 001")
//        XCTAssertEqual(writtenTag.chapterList[1].startTime, 1680)
//        XCTAssertEqual(writtenTag.chapterList[1].title, "Chapter 002")
//        XCTAssertEqual(writtenTag.chapterList[2].startTime, 3360)
//        XCTAssertEqual(writtenTag.chapterList[2].title, "Chapter 003")
//    }
//
//    // // MARK: - Overwriting test
//    @available(OSX 10.12, *)
//    func testOverwriting() throws {
//        var tag = try TestFile.chapterized.tag()
//        
//        tag?.addChapter(at: 0, title: "Chapter 001")
//        tag?.addChapter(at: 1680, title: "Chapter 002")
//        tag?.addChapter(at: 3360, title: "Chapter 003")
//        
//        let outputUrl = try localDirectory(fileName: "STID3_chaptertest", fileExtension: "mp3")
//        //        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
//        XCTAssertNoThrow(try TestFile.chapterized.mp3File()?.write(
//            tagVersion: .v2_4,
//            using: tag ?? Tag(readFrom: Mp3File(location: TestFile.chapterized.url)),
//            writingTo: outputUrl))
//        
//        let writtenFile = try Mp3File(location: outputUrl)
//        let writtenTag = try Tag(readFrom: writtenFile)
//        
//        XCTAssertEqual(writtenTag.chapterList[0].startTime, 0)
//        XCTAssertEqual(writtenTag.chapterList[0].title, "Chapter 001")
//        XCTAssertEqual(writtenTag.chapterList[1].startTime, 1680)
//        XCTAssertEqual(writtenTag.chapterList[1].title, "Chapter 002")
//        XCTAssertEqual(writtenTag.chapterList[2].startTime, 2795)
//        XCTAssertEqual(writtenTag.chapterList[2].title, "Chapter 02")
//        XCTAssertEqual(writtenTag.chapterList[3].startTime, 3360)
//        XCTAssertEqual(writtenTag.chapterList[3].title, "Chapter 003")
//    }
//    
//    @available(OSX 10.12, *)
//    func testOverwritingWithRenaming() throws {
//        var tag = try TestFile.chapterized.tag()
//        
//        tag?.addChapter(at: 0, title: "Chapter 001")
//        tag?.addChapter(at: 1680, title: "Chapter 002")
//        tag?.addChapter(at: 2795, title: "Chapter 003")
//        tag?.addChapter(at: 3360, title: "Chapter 004")
//        
//        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
//        XCTAssertNoThrow(try TestFile.chapterized.mp3File()?.write(
//            tagVersion: .v2_4,
//            using: tag ?? Tag(readFrom: Mp3File(location: TestFile.chapterized.url)),
//            writingTo: outputUrl))
//        
//        let writtenFile = try Mp3File(location: outputUrl)
//        let writtenTag = try Tag(readFrom: writtenFile)
//        
//        XCTAssertEqual(writtenTag.chapterList[0].startTime, 0)
//        XCTAssertEqual(writtenTag.chapterList[0].title, "Chapter 001")
//        XCTAssertEqual(writtenTag.chapterList[1].startTime, 1680)
//        XCTAssertEqual(writtenTag.chapterList[1].title, "Chapter 002")
//        XCTAssertEqual(writtenTag.chapterList[2].startTime, 2795)
//        XCTAssertEqual(writtenTag.chapterList[2].title, "Chapter 003")
//        XCTAssertEqual(writtenTag.chapterList[3].startTime, 3360)
//        XCTAssertEqual(writtenTag.chapterList[3].title, "Chapter 004")
//    }
//
//    @available(OSX 10.12, *)
//    func testVersionFailure() throws {
//        var tag = try TestFile.noMeta.tag()
//        
//        tag?.addChapter(at: 0, title: "Chapter 001")
//        tag?.addChapter(at: 1680, title: "Chapter 002")
//        tag?.addChapter(at: 3360, title: "Chapter 003")
//        
//        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
//        XCTAssertThrowsError(try TestFile.noMeta.mp3File()?.write(
//            tagVersion: .v2_2,
//            using: tag ?? Tag(readFrom: Mp3File(location: TestFile.noMeta.url)),
//            writingTo: outputUrl))
//    }
//}
