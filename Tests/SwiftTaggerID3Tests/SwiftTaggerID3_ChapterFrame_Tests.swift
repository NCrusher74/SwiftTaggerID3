/*

 SwiftTaggerID3_ChapterFrame_Tests.swift
 SwiftTaggerID3

 Copyright ©2020 Nolaine Crusher. All rights reserved.

 */

import XCTest
@testable import SwiftTaggerID3

// Tests for chapter frame and CTOC frame

class SwiftTaggerID3_ChapterFrame_Tests: XCTestCase {

    func testGetChapterList() throws {
        let tag = tagChaptered
        if let firstChapter = tag.chapterList.first {
            XCTAssertEqual(firstChapter.startTime, 0)
            XCTAssertEqual(firstChapter.title, "Chapter 01")
        }
        if let lastChapter = tag.chapterList.last {
            XCTAssertEqual(lastChapter.startTime, 2795)
            XCTAssertEqual(lastChapter.title, "Chapter 02")
        }
    }
    
    func testSetChapterListV24() throws {
        let chapterList = [
            (startTime: 0, title: "Chapter One"),
            (startTime: 1500, title: "Chapter Two"),
            (startTime: 3000, title: "Chapter Three")
        ]
        var tag = tagNoMeta
        
        var chapters = [Chapter]()
        for chapter in chapterList {
            let chap = Chapter(startTime: chapter.startTime, title: chapter.title)
            chapters.append(chap)
        }
        
        tag.chapterList = chapters
        let outputUrl = tempOutputDirectory
//        let outputUrl = try localOutputDirectory("chapterTest")
        XCTAssertNoThrow(try mp3NoMeta.write(tag: &tag,
                                             version: .v2_4,
                                             outputLocation: outputUrl))
        
        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try Tag(mp3File: outputMp3)
        
        let chapter1 = output.chapterList[0]
        let chapter2 = output.chapterList[1]
        let chapter3 = output.chapterList[2]
        
        XCTAssertEqual(chapter1.startTime, 0)
        XCTAssertEqual(chapter2.startTime, 1500)
        XCTAssertEqual(chapter3.startTime, 3000)
        XCTAssertEqual(chapter1.title, "Chapter One")
        XCTAssertEqual(chapter2.title, "Chapter Two")
        XCTAssertEqual(chapter3.title, "Chapter Three")
    }

    func testSetChapterListV23() throws {
        let chapterList = [
            (startTime: 0, title: "Chapter One"),
            (startTime: 1500, title: "Chapter Two"),
            (startTime: 3000, title: "Chapter Three")
        ]
        var tag = tagNoMeta
        var chapters = [Chapter]()
        for chapter in chapterList {
            let chap = Chapter(startTime: chapter.startTime, title: chapter.title)
            chapters.append(chap)
        }
        
        tag.chapterList = chapters
        let outputUrl = tempOutputDirectory
//        let outputUrl = try localOutputDirectory("chapterTest")
        XCTAssertNoThrow(try mp3NoMeta.write(tag: &tag,
                                             version: .v2_3,
                                             outputLocation: outputUrl))
        
        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try Tag(mp3File: outputMp3)
        
        let chapter1 = output.chapterList[0]
        let chapter2 = output.chapterList[1]
        let chapter3 = output.chapterList[2]
        
        XCTAssertEqual(chapter1.startTime, 0)
        XCTAssertEqual(chapter2.startTime, 1500)
        XCTAssertEqual(chapter3.startTime, 3000)
        XCTAssertEqual(chapter1.title, "Chapter One")
        XCTAssertEqual(chapter2.title, "Chapter Two")
        XCTAssertEqual(chapter3.title, "Chapter Three")
    }

    func testAddChapterToUnchapteredFileV24() throws {
        var tag = tagNoMeta
        tag.addChapter(startTime: 0, title: "Chapter 01")
        tag.addChapter(startTime: 3000, title: "Chapter 02")
        
        let outputUrl = tempOutputDirectory
//        let outputUrl = try localOutputDirectory("chapterTest")
        XCTAssertNoThrow(try mp3NoMeta.write(tag: &tag,
                                                version: .v2_4,
                                                outputLocation: outputUrl))
        
        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try Tag(mp3File: outputMp3)
        
        let chapter1 = output.chapterList[0]
        let chapter2 = output.chapterList[1]
        XCTAssertEqual(chapter1.startTime, 0)
        XCTAssertEqual(chapter2.startTime, 3000)
        XCTAssertEqual(chapter1.title, "Chapter 01")
        XCTAssertEqual(chapter2.title, "Chapter 02")
    }

    func testAddChapterToUnchapteredFileV23() throws {
        var tag = tagNoMeta
        tag.addChapter(startTime: 0, title: "Chapter 01")
        tag.addChapter(startTime: 3000, title: "Chapter 02")
        
        let outputUrl = tempOutputDirectory
//        let outputUrl = try localOutputDirectory("chapterTest")
        XCTAssertNoThrow(try mp3NoMeta.write(tag: &tag,
                                             version: .v2_3,
                                             outputLocation: outputUrl))
        
        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try Tag(mp3File: outputMp3)
        
        let chapter1 = output.chapterList[0]
        let chapter2 = output.chapterList[1]
        XCTAssertEqual(chapter1.startTime, 0)
        XCTAssertEqual(chapter2.startTime, 3000)
        XCTAssertEqual(chapter1.title, "Chapter 01")
        XCTAssertEqual(chapter2.title, "Chapter 02")
    }

    func testAddChapterToChapteredFile24() throws {
        var tag = tagChaptered
        tag.addChapter(startTime: 1000, title: "Chapter 1.5")
        tag.addChapter(startTime: 4000, title: "Chapter 2.5")
        let outputUrl = tempOutputDirectory
//        let outputUrl = try localOutputDirectory("chapterTest")
        XCTAssertNoThrow(try mp3Chaptered.write(tag: &tag,
                                                 version: .v2_4,
                                                 outputLocation: outputUrl))
        
        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try Tag(mp3File: outputMp3)
        let chapter1 = output.chapterList[0]
        let chapter2 = output.chapterList[1]
        let chapter3 = output.chapterList[2]
        let chapter4 = output.chapterList[3]
        XCTAssertEqual(chapter1.startTime, 0)
        XCTAssertEqual(chapter2.startTime, 1000)
        XCTAssertEqual(chapter3.startTime, 2795)
        XCTAssertEqual(chapter4.startTime, 4000)
        XCTAssertEqual(chapter1.title, "Chapter 01")
        XCTAssertEqual(chapter2.title, "Chapter 1.5")
        XCTAssertEqual(chapter3.title, "Chapter 02")
        XCTAssertEqual(chapter4.title, "Chapter 2.5")
    }

    func testRemoveAllChapters() throws {
        var tag = tagChaptered
        tag.removeAllChapters()
        
        let outputUrl = tempOutputDirectory
//        let outputUrl = try localOutputDirectory("chapterTest")
        XCTAssertNoThrow(try mp3Chaptered.write(tag: &tag,
                                             version: .v2_4,
                                             outputLocation: outputUrl))
        
        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try Tag(mp3File: outputMp3)
        
        XCTAssertNil(output.frames[.tableOfContents])
        XCTAssertNil(output.frames[.chapter(startTime: 0)])
        XCTAssertNil(output.frames[.chapter(startTime: 2795)])
    }

    func testRemoveSingleChapter() throws {
        var tag = tagChaptered
        tag.removeChapter(startTime: 2795)
        
        let outputUrl = tempOutputDirectory
//        let outputUrl = try localOutputDirectory("chapterTest")
        XCTAssertNoThrow(try mp3Chaptered.write(tag: &tag,
                                                version: .v2_4,
                                                outputLocation: outputUrl))
        
        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try Tag(mp3File: outputMp3)
        
        XCTAssertEqual(output.chapterList.count, 1)
        let chapter1 = output.chapterList[0]
        XCTAssertEqual(chapter1.startTime, 0)
        XCTAssertEqual(chapter1.title, "Chapter 01")
        XCTAssertNil(output.chapterList.first(where: {$0.startTime == 2795}))
    }
    
    func testAddChapterToFileWithMetadata() throws {
        var tag = tagV24
        tag.addChapter(startTime: 0, title: "Chapter 01")
        tag.addChapter(startTime: 1500, title: "Chapter 02")
        tag.addChapter(startTime: 3000, title: "Chapter 03")
        
        let outputUrl = tempOutputDirectory
//        let outputUrl = try localOutputDirectory("chapterTest")
        XCTAssertNoThrow(try mp3V24.write(tag: &tag,
                                             version: .v2_4,
                                             outputLocation: outputUrl))
        
        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try Tag(mp3File: outputMp3)
        
        let chapter1 = output.chapterList[0]
        let chapter2 = output.chapterList[1]
        let chapter3 = output.chapterList[2]
        XCTAssertEqual(chapter1.startTime, 0)
        XCTAssertEqual(chapter2.startTime, 1500)
        XCTAssertEqual(chapter3.startTime, 3000)
        XCTAssertEqual(chapter1.title, "Chapter 01")
        XCTAssertEqual(chapter2.title, "Chapter 02")
        XCTAssertEqual(chapter3.title, "Chapter 03")
    }

}
