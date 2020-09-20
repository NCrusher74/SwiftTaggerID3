//
//  File.swift
//  
//
//  Created by Nolaine Crusher on 9/19/20.
//

import Foundation

import XCTest
import SwiftTaggerID3

// Tests for chapter frame and CTOC frame
class SwiftTaggerID3_Parsing_Tests: XCTestCase {
    
    func testPrint() throws {
        let data = try Data(contentsOf: sampleChapterUrl)
        let range = 00001579 ..< 00001630
        let subdata = data.subdata(in: range)
        print(subdata.hexadecimal())
    }
    
    func testTagReadingv2_4() throws {
        let mp3 = try Mp3File(location: sample24Url)
        let tag = try Tag(mp3File: mp3)
        
        print(tag.frames.count)
        for item in tag.frames {
            print(item)
        }
    }
    
    func testChapterReading() throws {
        let mp3 = try Mp3File(location: sampleChapterUrl)
        var tag = try Tag(mp3File: mp3)

        let knownTitles = ["Chapter 01", "Chapter 02"]
        let knownStarts = [0, 2795]

        var titles = [String]()
        for chapter in tag.chapterList {
            titles.append(chapter.title)
        }
        
        var starts = [Int]()
        for chapter in tag.chapterList {
            starts.append(chapter.startTime)
        }
        
        XCTAssertEqual(titles, knownTitles)
        XCTAssertEqual(starts, knownStarts)

        tag.removeAllChapters()
        
        XCTAssertTrue(tag.chapterList.isEmpty)

        tag.addChapter(startTime: 0, title: "ch01")
        tag.addChapter(startTime: 1500, title: "ch02")
        tag.addChapter(startTime: 3700, title: "ch03")
        
        let newTitles = ["ch01", "ch02", "ch03"]
        let newStarts = [0, 1500, 3700]

        var titlesNew = [String]()
        for chapter in tag.chapterList {
            titlesNew.append(chapter.title)
        }
        
        var startsNew = [Int]()
        for chapter in tag.chapterList {
            startsNew.append(chapter.startTime)
        }

        XCTAssertEqual(titlesNew, newTitles)
        XCTAssertEqual(startsNew, newStarts)
        
        tag.removeChapter(startTime: 1500)
        
        let finalTitles = ["ch01", "ch03"]
        let finalStarts = [0, 3700]
        
        var titlesFinal = [String]()
        for chapter in tag.chapterList {
            titlesFinal.append(chapter.title)
        }
        
        var startsFinal = [Int]()
        for chapter in tag.chapterList {
            startsFinal.append(chapter.startTime)
        }
        
        XCTAssertEqual(titlesFinal, finalTitles)
        XCTAssertEqual(startsFinal, finalStarts)
    }
}
