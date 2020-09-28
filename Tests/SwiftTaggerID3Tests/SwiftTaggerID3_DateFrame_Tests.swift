/*

 SwiftTaggerID3_DateFrame_Tests.swift
 SwiftTaggerID3

 Copyright ©2020 Nolaine Crusher. All rights reserved.

 */

import XCTest
@testable import SwiftTaggerID3

class SwiftTaggerID3_DateFrame_Tests: XCTestCase {
    
    func testReleaseDateV24() throws {
        var tag = tagV24
        XCTAssertEqual(tag.releaseDateTime, v24ReleaseDate)
        tag.releaseDateTime = newDate
//        let outputUrl = try localDirectory(fileName: "datetestv24", fileExtension: "mp3")
        let outputUrl = tempOutputDirectory
        XCTAssertNoThrow(try mp3V24.write(tag: tag, version: .v2_4, outputLocation: outputUrl))
        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try outputMp3.tag()
        XCTAssertEqual(output.releaseDateTime, newDate)
        XCTAssertNil(output.frames[FrameKey.date])
        XCTAssertNil(output.frames[FrameKey.time])
        XCTAssertNil(output.frames[FrameKey.year])
    }

    func testReleaseDateV23() throws {
        var tag = tagV23
        XCTAssertNotNil(tag.releaseDateTime)
        if let date = tag.releaseDateTime {
            let components = calendar.dateComponents(in: timeZone, from: date)
            let year = components.year
            let month = components.month
            let day = components.day
            let hour = components.hour
            let minute = components.minute
            
            let dateFrameDate = calendar.date(from: DateComponents(calendar: calendar, timeZone: timeZone, month: month, day: day))
            let timeFrameDate = calendar.date(from: DateComponents(calendar: calendar, timeZone: timeZone, hour: hour, minute: minute))
            let yearFrameDate = calendar.date(from: DateComponents(calendar: calendar, timeZone: timeZone, year: year))
            
            XCTAssertEqual(dateFrameDate, v23Date)
            XCTAssertEqual(timeFrameDate, v23Time)
            XCTAssertEqual(yearFrameDate, v23Year)
        }
        XCTAssertNil(tag.frames[FrameKey.releaseTime])
        tag.releaseDateTime = newDate

//        let outputUrl = try localDirectory(fileName: "datetestv23", fileExtension: "mp3")
        let outputUrl = tempOutputDirectory
        XCTAssertNoThrow(try mp3V23.write(tag: tag, version: .v2_3, outputLocation: outputUrl))
        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try outputMp3.tag()
        XCTAssertEqual(output.releaseDateTime, newDate)
        XCTAssertNil(output.frames[FrameKey.releaseTime])
        XCTAssertNotNil(output.frames[FrameKey.date])
        XCTAssertNotNil(output.frames[FrameKey.time])
        XCTAssertNotNil(output.frames[FrameKey.year])
    }

    func testReleaseDateV22() throws {
        var tag = tagV22
        XCTAssertNotNil(tag.releaseDateTime)
        if let date = tag.releaseDateTime {
            let components = calendar.dateComponents(in: timeZone, from: date)
            let year = components.year
            let month = components.month
            let day = components.day
            let hour = components.hour
            let minute = components.minute
            
            let dateFrameDate = calendar.date(from: DateComponents(calendar: calendar, timeZone: timeZone, month: month, day: day))
            let timeFrameDate = calendar.date(from: DateComponents(calendar: calendar, timeZone: timeZone, hour: hour, minute: minute))
            let yearFrameDate = calendar.date(from: DateComponents(calendar: calendar, timeZone: timeZone, year: year))
            
            XCTAssertEqual(dateFrameDate, v22Date)
            XCTAssertEqual(timeFrameDate, v22Time)
            XCTAssertEqual(yearFrameDate, v22Year)
        }
        XCTAssertNil(tag.frames[FrameKey.releaseTime])
        tag.releaseDateTime = newDate
        
//        let outputUrl = try localDirectory(fileName: "datetestv22", fileExtension: "mp3")
        let outputUrl = tempOutputDirectory
        XCTAssertNoThrow(try mp3V22.write(tag: tag, version: .v2_2, outputLocation: outputUrl))
        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try outputMp3.tag()
        XCTAssertEqual(output.releaseDateTime, newDate)
        XCTAssertNil(output.frames[FrameKey.releaseTime])
        XCTAssertNotNil(output.frames[FrameKey.date])
        XCTAssertNotNil(output.frames[FrameKey.time])
        XCTAssertNotNil(output.frames[FrameKey.year])
    }
    
    func testRecordingDateV24() throws {
        var tag = tagV24
        XCTAssertEqual(tag.recordingDateTime, v24RecordingDate)
        tag.recordingDateTime = newDate
//        let outputUrl = try localOutputDirectory("recordingDateV24")
        let outputUrl = tempOutputDirectory
        XCTAssertNoThrow(try mp3V24.write(tag: tag, version: .v2_4, outputLocation: outputUrl))
        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try outputMp3.tag()
        XCTAssertEqual(output.recordingDateTime, newDate)
    }
    
    func testRecordingDateV23() throws {
        var tag = tagV23
        XCTAssertEqual(tag.recordingDateTime, v24RecordingDate)
        tag.recordingDateTime = newDate
//        let outputUrl = try localOutputDirectory("recordingDateV23")
        let outputUrl = tempOutputDirectory
        XCTAssertNoThrow(try mp3V23.write(tag: tag, version: .v2_3, outputLocation: outputUrl))
        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try outputMp3.tag()
        XCTAssertEqual(output.recordingDateTime, newDate)
    }

    func testRecordingDateV22() throws {
        var tag = tagV22
        XCTAssertEqual(tag.recordingDateTime, v24RecordingDate)
        tag.recordingDateTime = newDate
//        let outputUrl = try localOutputDirectory("recordingDateV22")
        let outputUrl = tempOutputDirectory
        XCTAssertNoThrow(try mp3V22.write(tag: tag, version: .v2_2, outputLocation: outputUrl))
        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try outputMp3.tag()
        XCTAssertEqual(output.recordingDateTime, newDate)
    }
    
    func testEncodingDateV24() throws {
        var tag = tagV24
        XCTAssertEqual(tag.encodingDateTime, v24EncodingDate)
        tag.encodingDateTime = newDate
//        let outputUrl = try localOutputDirectory("encodingDateV24")
        let outputUrl = tempOutputDirectory
        XCTAssertNoThrow(try mp3V24.write(tag: tag, version: .v2_4, outputLocation: outputUrl))
        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try outputMp3.tag()
        XCTAssertEqual(output.encodingDateTime, newDate)
    }
    
    func testEncodingDateV23() throws {
        var tag = tagV23
        XCTAssertNil(tag.encodingDateTime)
        tag.encodingDateTime = newDate
//        let outputUrl = try localOutputDirectory("encodingDateV23")
        let outputUrl = tempOutputDirectory
        XCTAssertNoThrow(try mp3V23.write(tag: tag, version: .v2_3, outputLocation: outputUrl))
        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try outputMp3.tag()
        XCTAssertNotNil(output.encodingDateTime)
        XCTAssertEqual(output.encodingDateTime, newDate)
    }
    
    func testEncodingDateV22() throws {
        var tag = tagV22
        XCTAssertNil(tag.encodingDateTime)
        tag.encodingDateTime = newDate
//        let outputUrl = try localOutputDirectory("encodingDateV22")
        let outputUrl = tempOutputDirectory
        XCTAssertNoThrow(try mp3V22.write(tag: tag, version: .v2_2, outputLocation: outputUrl))
        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try outputMp3.tag()
        XCTAssertNotNil(output.encodingDateTime)
        XCTAssertEqual(output.encodingDateTime, newDate)
    }
    
    func testTaggingDateV24() throws {
        var tag = tagV24
        XCTAssertEqual(tag.taggingDateTime, v24TaggingDate)
        tag.taggingDateTime = newDate
//        let outputUrl = try localOutputDirectory("taggingDateV24")
        let outputUrl = tempOutputDirectory
        XCTAssertNoThrow(try mp3V24.write(tag: tag, version: .v2_4, outputLocation: outputUrl))
        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try outputMp3.tag()
        XCTAssertEqual(output.taggingDateTime, newDate)
    }
    
    func testTaggingDateV23() throws {
        var tag = tagV23
        XCTAssertNil(tag.taggingDateTime)
        tag.taggingDateTime = newDate
//        let outputUrl = try localOutputDirectory("taggingDateV23")
        let outputUrl = tempOutputDirectory
        XCTAssertNoThrow(try mp3V23.write(tag: tag, version: .v2_3, outputLocation: outputUrl))
        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try outputMp3.tag()
        XCTAssertNotNil(output.taggingDateTime)
        XCTAssertEqual(output.taggingDateTime, newDate)
    }
    
    func testTaggingDateV22() throws {
        var tag = tagV22
        XCTAssertNil(tag.taggingDateTime)
        tag.taggingDateTime = newDate
//        let outputUrl = try localOutputDirectory("taggingDateV22")
        let outputUrl = tempOutputDirectory
        XCTAssertNoThrow(try mp3V22.write(tag: tag, version: .v2_2, outputLocation: outputUrl))
        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try outputMp3.tag()
        XCTAssertNotNil(output.taggingDateTime)
        XCTAssertEqual(output.taggingDateTime, newDate)
    }

    func testOriginalReleaseDateV24() throws {
        var tag = tagV24
        XCTAssertEqual(tag.originalRelease, v24OriginalReleaseDate)
        tag.originalRelease = newDate
//        let outputUrl = try localOutputDirectory("originalReleaseDateV24")
        let outputUrl = tempOutputDirectory
        XCTAssertNoThrow(try mp3V24.write(tag: tag, version: .v2_4, outputLocation: outputUrl))
        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try outputMp3.tag()
        XCTAssertEqual(output.originalRelease, newDate)
    }
    
    func testOriginalReleaseDateV23() throws {
        var tag = tagV23
        XCTAssertEqual(tag.originalRelease, v23OriginalReleaseYear)
        tag.originalRelease = newDate
//        let outputUrl = try localOutputDirectory("originalReleaseDateV23")
        let outputUrl = tempOutputDirectory
        XCTAssertNoThrow(try mp3V23.write(tag: tag, version: .v2_3, outputLocation: outputUrl))
        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try outputMp3.tag()
        XCTAssertNotNil(output.originalRelease)
        XCTAssertEqual(output.originalRelease, newDateYearOnly)
    }
    
    func testOriginalReleaseDateV22() throws {
        var tag = tagV22
        XCTAssertEqual(tag.originalRelease, v23OriginalReleaseYear)
        tag.originalRelease = newDate
//        let outputUrl = try localOutputDirectory("originalReleaseDateV22")
        let outputUrl = tempOutputDirectory
        XCTAssertNoThrow(try mp3V22.write(tag: tag, version: .v2_2, outputLocation: outputUrl))
        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try outputMp3.tag()
        XCTAssertNotNil(output.originalRelease)
        XCTAssertEqual(output.originalRelease, newDateYearOnly)
    }
}
