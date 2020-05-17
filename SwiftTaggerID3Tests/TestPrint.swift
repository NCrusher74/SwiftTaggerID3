//
//  TestPrint.swift
//  SwiftTaggerID3Tests
//
//  Created by Nolaine Crusher on 4/28/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import XCTest
import SwiftTaggerID3

class TestPrint: XCTestCase {
    
    
    func testPrint() throws {
        let path = "/Users/nolainecrusher/Desktop/test output/testV24Writing.mp3"
        let mp3Url = URL(fileURLWithPath: path)
//        let mp3Url = Bundle.writtenV24
        let mp3File = try Mp3File(location: mp3Url)
        let mp3Data = mp3File.data
        
        let rangeIn = 1302
        let rangeOut = 1350
        let range = rangeIn ..< rangeOut
        
        let data = mp3Data.subdata(in: range)
        print(data.hexadecimal())
    }

    func testDateTimeV24() throws {
        let mp3Url = Bundle.v23NoMeta
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.releaseDateTime = (year: 2015, month: 02, day: 03, hour: 11, minute: 11)
        tag.encodingDateTime = (year: 2016, month: 04, day: 05, hour: nil, minute: nil)
        tag.taggingDateTime = (year: 2017, month: 06, day: 07, hour: nil, minute: nil)
        tag.originalReleaseDateTime = (year: 2014, month: 08, day: 09, hour: nil, minute: nil)
        tag.recordingDateTime = (year: 2018, month: 10, day: 11, hour: nil, minute: nil)

        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/testV24Date.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))
        
        // MARK: Confirm accuracy
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.encodingDateTime?.year, 2016)
        XCTAssertEqual(tagWritten.encodingDateTime?.month, 04)
        XCTAssertEqual(tagWritten.encodingDateTime?.day, 05)
        XCTAssertEqual(tagWritten.originalReleaseDateTime?.year, 2014)
        XCTAssertEqual(tagWritten.originalReleaseDateTime?.month, 08)
        XCTAssertEqual(tagWritten.originalReleaseDateTime?.day, 09)
        XCTAssertEqual(tagWritten.recordingDateTime?.year, 2018)
        XCTAssertEqual(tagWritten.recordingDateTime?.month, 10)
        XCTAssertEqual(tagWritten.recordingDateTime?.day, 11)
        XCTAssertEqual(tagWritten.taggingDateTime?.year, 2017)
        XCTAssertEqual(tagWritten.taggingDateTime?.month, 06)
        XCTAssertEqual(tagWritten.taggingDateTime?.day, 07)
        XCTAssertEqual(tagWritten.releaseDateTime?.year, 2015)
        XCTAssertEqual(tagWritten.releaseDateTime?.month, 02)
        XCTAssertEqual(tagWritten.releaseDateTime?.day, 03)
        XCTAssertEqual(tagWritten.releaseDateTime?.hour, 11)
        XCTAssertEqual(tagWritten.releaseDateTime?.minute, 11)

    }
    
    func testDateTimeV23() throws {
        let mp3Url = Bundle.v23NoMeta
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.originalReleaseDateTime = (year: 2014, month: 08, day: 09, hour: nil, minute: nil)
        tag.recordingDateTime = (year: 2018, month: 10, day: 11, hour: nil, minute: nil)
        tag.date = (month: 02, day: 03)
        tag.time = (hour: 11, minute: 11)
        tag.year = 2015
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/testV23Date.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_3, using: tag, writingTo: outputUrl))
        
        // MARK: Confirm accuracy
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.originalReleaseDateTime?.year, 2014)
        XCTAssertEqual(tagWritten.originalReleaseDateTime?.month, 08)
        XCTAssertEqual(tagWritten.originalReleaseDateTime?.day, 09)
        XCTAssertEqual(tagWritten.recordingDateTime?.year, 2018)
        XCTAssertEqual(tagWritten.recordingDateTime?.month, 10)
        XCTAssertEqual(tagWritten.recordingDateTime?.day, 11)
        XCTAssertEqual(tagWritten.date?.month, 02)
        XCTAssertEqual(tagWritten.date?.day, 03)
        XCTAssertEqual(tagWritten.time?.hour, 11)
        XCTAssertEqual(tagWritten.time?.minute, 11)
        XCTAssertEqual(tagWritten.year, 2015)
        
    }

}

