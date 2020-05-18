//
//  SwiftTaggerMp3_DateFrame_Tests.swift
//  SwiftTaggerID3Tests
//
//  Created by Nolaine Crusher on 5/18/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

#warning("NEEDS FIXING: When writing to a file with a tag in an existing version that is incompatible, version-restricted frames will error out even if the outgoing version is correct")
import XCTest
import SwiftTaggerID3

class SwiftTaggerMp3_DateFrame_Tests: XCTestCase {

    // MARK: TENC, Expected, Blank, Components
    func testTENCExpectedInputComponentsBlankFileV24() throws {
        let mp3Url = Bundle.v23NoMeta
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)

        tag.encodingDateTime?.year = 2002
        tag.encodingDateTime?.month = 11
        tag.encodingDateTime?.day = 7
        tag.encodingDateTime?.hour = 9
        tag.encodingDateTime?.minute = 23
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/FrameTENCtest1.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)

        XCTAssertEqual(tagWritten.encodingDateTime?.year, 2002)
        XCTAssertEqual(tagWritten.encodingDateTime?.month, 11)
        XCTAssertEqual(tagWritten.encodingDateTime?.day, 7)
        XCTAssertEqual(tagWritten.encodingDateTime?.hour, 9)
        XCTAssertEqual(tagWritten.encodingDateTime?.minute, 23)
    }
    
    // MARK: TENC, Expected, Blank, Tuple
    func testTENCExpectedInputTupleBlankFileV24() throws {
        let mp3Url = Bundle.v23NoMeta
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.encodingDateTime = (year: 2002, month: 11, day: 7, hour: 9, minute: 23)
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/FrameTENCtest2.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.encodingDateTime?.year, 2002)
        XCTAssertEqual(tagWritten.encodingDateTime?.month, 11)
        XCTAssertEqual(tagWritten.encodingDateTime?.day, 7)
        XCTAssertEqual(tagWritten.encodingDateTime?.hour, 9)
        XCTAssertEqual(tagWritten.encodingDateTime?.minute, 23)
    }

    // MARK: TENC, Expected, Overwrite, Components
    func testTENCExpectedInputComponentsOverwriteFileV24() throws {
        let mp3Url = Bundle.writtenV24
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.encodingDateTime?.year = 2002
        tag.encodingDateTime?.month = 11
        tag.encodingDateTime?.day = 7
        tag.encodingDateTime?.hour = 9
        tag.encodingDateTime?.minute = 23
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/FrameTENCtest3.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.encodingDateTime?.year, 2002)
        XCTAssertEqual(tagWritten.encodingDateTime?.month, 11)
        XCTAssertEqual(tagWritten.encodingDateTime?.day, 7)
        XCTAssertEqual(tagWritten.encodingDateTime?.hour, 9)
        XCTAssertEqual(tagWritten.encodingDateTime?.minute, 23)
    }
    
    // MARK: TENC, Expected, Overwrite, Tuple
    func testTENCExpectedInputTupleOverwriteFileV24() throws {
        let mp3Url = Bundle.writtenV24
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.encodingDateTime = (year: 2002, month: 11, day: 7, hour: 9, minute: 23)
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/FrameTENCtest4.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.encodingDateTime?.year, 2002)
        XCTAssertEqual(tagWritten.encodingDateTime?.month, 11)
        XCTAssertEqual(tagWritten.encodingDateTime?.day, 7)
        XCTAssertEqual(tagWritten.encodingDateTime?.hour, 9)
        XCTAssertEqual(tagWritten.encodingDateTime?.minute, 23)
    }

    // MARK: TENC, Unexpected, Blank, Components
    func testTENCUnxpectedInputComponentsBlankFileV24() throws {
        let mp3Url = Bundle.v23NoMeta
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.encodingDateTime?.year = 2002
        tag.encodingDateTime?.month = 55
        tag.encodingDateTime?.day = 119
        tag.encodingDateTime?.hour = nil
        tag.encodingDateTime?.minute = 6784
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/FrameTENCtest5.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.encodingDateTime?.year, 2006)
        XCTAssertEqual(tagWritten.encodingDateTime?.month, 10)
        XCTAssertEqual(tagWritten.encodingDateTime?.day, 31)
        XCTAssertEqual(tagWritten.encodingDateTime?.hour, 17)
        XCTAssertEqual(tagWritten.encodingDateTime?.minute, 4)
    }
    
    // MARK: TENC, Unexpected, Blank, Tuple
    func testTENCUnexpectedInputTupleBlankFileV24() throws {
        let mp3Url = Bundle.v23NoMeta
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.encodingDateTime = (year: 2002, month: 55, day: 119, hour: nil, minute: 6784)
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/FrameTENCtest6.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.encodingDateTime?.year, 2006)
        XCTAssertEqual(tagWritten.encodingDateTime?.month, 10)
        XCTAssertEqual(tagWritten.encodingDateTime?.day, 31)
        XCTAssertEqual(tagWritten.encodingDateTime?.hour, 17)
        XCTAssertEqual(tagWritten.encodingDateTime?.minute, 4)
    }
    
    // MARK: TENC, Unexpected, Overwrite, Components
    func testTENCUnexpectedInputComponentsOverwriteFileV24() throws {
        let mp3Url = Bundle.writtenV24
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.encodingDateTime?.year = 2002
        tag.encodingDateTime?.month = 55
        tag.encodingDateTime?.day = 119
        tag.encodingDateTime?.hour = nil
        tag.encodingDateTime?.minute = 6784
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/FrameTENCtest7.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.encodingDateTime?.year, 2006)
        XCTAssertEqual(tagWritten.encodingDateTime?.month, 10)
        XCTAssertEqual(tagWritten.encodingDateTime?.day, 31)
        XCTAssertEqual(tagWritten.encodingDateTime?.hour, 17)
        XCTAssertEqual(tagWritten.encodingDateTime?.minute, 4)
    }
    
    // MARK: TENC, Unexpected, Overwrite, Tuple
    func testTENCUnexpectedInputTupleOverwriteFileV24() throws {
        let mp3Url = Bundle.writtenV24
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.encodingDateTime = (year: 2002, month: 55, day: 119, hour: nil, minute: 6784)
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/FrameTENCtest8.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.encodingDateTime?.year, 2006)
        XCTAssertEqual(tagWritten.encodingDateTime?.month, 10)
        XCTAssertEqual(tagWritten.encodingDateTime?.day, 31)
        XCTAssertEqual(tagWritten.encodingDateTime?.hour, 17)
        XCTAssertEqual(tagWritten.encodingDateTime?.minute, 4)
    }

    // MARK: TDTG, Expected, Blank, Components
    func testTDTGExpectedInputComponentsBlankFileV24() throws {
        let mp3Url = Bundle.v23NoMeta
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.taggingDateTime?.year = 2002
        tag.taggingDateTime?.month = 11
        tag.taggingDateTime?.day = 7
        tag.taggingDateTime?.hour = 9
        tag.taggingDateTime?.minute = 23
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/FrameTDTGtest1.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.taggingDateTime?.year, 2002)
        XCTAssertEqual(tagWritten.taggingDateTime?.month, 11)
        XCTAssertEqual(tagWritten.taggingDateTime?.day, 7)
        XCTAssertEqual(tagWritten.taggingDateTime?.hour, 9)
        XCTAssertEqual(tagWritten.taggingDateTime?.minute, 23)
    }
    
    // MARK: TDTG, Expected, Blank, Tuple
    func testTDTGExpectedInputTupleBlankFileV24() throws {
        let mp3Url = Bundle.v23NoMeta
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.taggingDateTime = (year: 2002, month: 11, day: 7, hour: 9, minute: 23)
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/FrameTDTGtest2.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.taggingDateTime?.year, 2002)
        XCTAssertEqual(tagWritten.taggingDateTime?.month, 11)
        XCTAssertEqual(tagWritten.taggingDateTime?.day, 7)
        XCTAssertEqual(tagWritten.taggingDateTime?.hour, 9)
        XCTAssertEqual(tagWritten.taggingDateTime?.minute, 23)
    }
    
    // MARK: TDTG, Expected, Overwrite, Components
    func testTDTGExpectedInputComponentsOverwriteFileV24() throws {
        let mp3Url = Bundle.writtenV24
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.taggingDateTime?.year = 2002
        tag.taggingDateTime?.month = 11
        tag.taggingDateTime?.day = 7
        tag.taggingDateTime?.hour = 9
        tag.taggingDateTime?.minute = 23
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/FrameTDTGtest3.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.taggingDateTime?.year, 2002)
        XCTAssertEqual(tagWritten.taggingDateTime?.month, 11)
        XCTAssertEqual(tagWritten.taggingDateTime?.day, 7)
        XCTAssertEqual(tagWritten.taggingDateTime?.hour, 9)
        XCTAssertEqual(tagWritten.taggingDateTime?.minute, 23)
    }
    
    // MARK: TDTG, Expected, Overwrite, Tuple
    func testTDTGExpectedInputTupleOverwriteFileV24() throws {
        let mp3Url = Bundle.writtenV24
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.taggingDateTime = (year: 2002, month: 11, day: 7, hour: 9, minute: 23)
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/FrameTDTGtest4.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.taggingDateTime?.year, 2002)
        XCTAssertEqual(tagWritten.taggingDateTime?.month, 11)
        XCTAssertEqual(tagWritten.taggingDateTime?.day, 7)
        XCTAssertEqual(tagWritten.taggingDateTime?.hour, 9)
        XCTAssertEqual(tagWritten.taggingDateTime?.minute, 23)
    }
    
    // MARK: TDTG, Unexpected, Blank, Components
    func testTDTGUnxpectedInputComponentsBlankFileV24() throws {
        let mp3Url = Bundle.v23NoMeta
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.taggingDateTime?.year = 2002
        tag.taggingDateTime?.month = 55
        tag.taggingDateTime?.day = 119
        tag.taggingDateTime?.hour = nil
        tag.taggingDateTime?.minute = 6784
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/FrameTDTGtest5.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.taggingDateTime?.year, 2006)
        XCTAssertEqual(tagWritten.taggingDateTime?.month, 10)
        XCTAssertEqual(tagWritten.taggingDateTime?.day, 31)
        XCTAssertEqual(tagWritten.taggingDateTime?.hour, 17)
        XCTAssertEqual(tagWritten.taggingDateTime?.minute, 4)
    }
    
    // MARK: TDTG, Unexpected, Blank, Tuple
    func testTDTGUnexpectedInputTupleBlankFileV24() throws {
        let mp3Url = Bundle.v23NoMeta
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.taggingDateTime = (year: 2002, month: 55, day: 119, hour: nil, minute: 6784)
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/FrameTDTGtest6.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.taggingDateTime?.year, 2006)
        XCTAssertEqual(tagWritten.taggingDateTime?.month, 10)
        XCTAssertEqual(tagWritten.taggingDateTime?.day, 31)
        XCTAssertEqual(tagWritten.taggingDateTime?.hour, 17)
        XCTAssertEqual(tagWritten.taggingDateTime?.minute, 4)
    }
    
    // MARK: TDTG, Unexpected, Overwrite, Components
    func testTDTGUnexpectedInputComponentsOverwriteFileV24() throws {
        let mp3Url = Bundle.writtenV24
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.taggingDateTime?.year = 2002
        tag.taggingDateTime?.month = 55
        tag.taggingDateTime?.day = 119
        tag.taggingDateTime?.hour = nil
        tag.taggingDateTime?.minute = 6784
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/FrameTDTGtest7.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.taggingDateTime?.year, 2006)
        XCTAssertEqual(tagWritten.taggingDateTime?.month, 10)
        XCTAssertEqual(tagWritten.taggingDateTime?.day, 31)
        XCTAssertEqual(tagWritten.taggingDateTime?.hour, 17)
        XCTAssertEqual(tagWritten.taggingDateTime?.minute, 4)
    }
    
    // MARK: TDTG, Unexpected, Overwrite, Tuple
    func testTDTGUnexpectedInputTupleOverwriteFileV24() throws {
        let mp3Url = Bundle.writtenV24
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.taggingDateTime = (year: 2002, month: 55, day: 119, hour: nil, minute: 6784)
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/FrameTDTGtest8.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.taggingDateTime?.year, 2006)
        XCTAssertEqual(tagWritten.taggingDateTime?.month, 10)
        XCTAssertEqual(tagWritten.taggingDateTime?.day, 31)
        XCTAssertEqual(tagWritten.taggingDateTime?.hour, 17)
        XCTAssertEqual(tagWritten.taggingDateTime?.minute, 4)
    }

    // MARK: TDRL, Expected, Blank, Components
    func testTDRLExpectedInputComponentsBlankFileV24() throws {
        let mp3Url = Bundle.v23NoMeta
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.releaseDateTime?.year = 2002
        tag.releaseDateTime?.month = 11
        tag.releaseDateTime?.day = 7
        tag.releaseDateTime?.hour = 9
        tag.releaseDateTime?.minute = 23
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/FrameTDRLtest1.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.releaseDateTime?.year, 2002)
        XCTAssertEqual(tagWritten.releaseDateTime?.month, 11)
        XCTAssertEqual(tagWritten.releaseDateTime?.day, 7)
        XCTAssertEqual(tagWritten.releaseDateTime?.hour, 9)
        XCTAssertEqual(tagWritten.releaseDateTime?.minute, 23)
    }
    
    // MARK: TDRL, Expected, Blank, Tuple
    func testTDRLExpectedInputTupleBlankFileV24() throws {
        let mp3Url = Bundle.v23NoMeta
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.releaseDateTime = (year: 2002, month: 11, day: 7, hour: 9, minute: 23)
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/FrameTDRLtest2.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.releaseDateTime?.year, 2002)
        XCTAssertEqual(tagWritten.releaseDateTime?.month, 11)
        XCTAssertEqual(tagWritten.releaseDateTime?.day, 7)
        XCTAssertEqual(tagWritten.releaseDateTime?.hour, 9)
        XCTAssertEqual(tagWritten.releaseDateTime?.minute, 23)
    }
    
    // MARK: TDRL, Expected, Overwrite, Components
    func testTDRLExpectedInputComponentsOverwriteFileV24() throws {
        let mp3Url = Bundle.writtenV24
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.releaseDateTime?.year = 2002
        tag.releaseDateTime?.month = 11
        tag.releaseDateTime?.day = 7
        tag.releaseDateTime?.hour = 9
        tag.releaseDateTime?.minute = 23
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/FrameTDRLtest3.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.releaseDateTime?.year, 2002)
        XCTAssertEqual(tagWritten.releaseDateTime?.month, 11)
        XCTAssertEqual(tagWritten.releaseDateTime?.day, 7)
        XCTAssertEqual(tagWritten.releaseDateTime?.hour, 9)
        XCTAssertEqual(tagWritten.releaseDateTime?.minute, 23)
    }
    
    // MARK: TDRL, Expected, Overwrite, Tuple
    func testTDRLExpectedInputTupleOverwriteFileV24() throws {
        let mp3Url = Bundle.writtenV24
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.releaseDateTime = (year: 2002, month: 11, day: 7, hour: 9, minute: 23)
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/FrameTDRLtest4.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.releaseDateTime?.year, 2002)
        XCTAssertEqual(tagWritten.releaseDateTime?.month, 11)
        XCTAssertEqual(tagWritten.releaseDateTime?.day, 7)
        XCTAssertEqual(tagWritten.releaseDateTime?.hour, 9)
        XCTAssertEqual(tagWritten.releaseDateTime?.minute, 23)
    }
    
    // MARK: TDRL, Unexpected, Blank, Components
    func testTDRLUnxpectedInputComponentsBlankFileV24() throws {
        let mp3Url = Bundle.v23NoMeta
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.releaseDateTime?.year = 2002
        tag.releaseDateTime?.month = 55
        tag.releaseDateTime?.day = 119
        tag.releaseDateTime?.hour = nil
        tag.releaseDateTime?.minute = 6784
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/FrameTDRLtest5.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.releaseDateTime?.year, 2006)
        XCTAssertEqual(tagWritten.releaseDateTime?.month, 10)
        XCTAssertEqual(tagWritten.releaseDateTime?.day, 31)
        XCTAssertEqual(tagWritten.releaseDateTime?.hour, 17)
        XCTAssertEqual(tagWritten.releaseDateTime?.minute, 4)
    }
    
    // MARK: TDRL, Unexpected, Blank, Tuple
    func testTDRLUnexpectedInputTupleBlankFileV24() throws {
        let mp3Url = Bundle.v23NoMeta
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.releaseDateTime = (year: 2002, month: 55, day: 119, hour: nil, minute: 6784)
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/FrameTDRLtest6.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.releaseDateTime?.year, 2006)
        XCTAssertEqual(tagWritten.releaseDateTime?.month, 10)
        XCTAssertEqual(tagWritten.releaseDateTime?.day, 31)
        XCTAssertEqual(tagWritten.releaseDateTime?.hour, 17)
        XCTAssertEqual(tagWritten.releaseDateTime?.minute, 4)
    }
    
    // MARK: TDRL, Unexpected, Overwrite, Components
    func testTDRLUnexpectedInputComponentsOverwriteFileV24() throws {
        let mp3Url = Bundle.writtenV24
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.releaseDateTime?.year = 2002
        tag.releaseDateTime?.month = 55
        tag.releaseDateTime?.day = 119
        tag.releaseDateTime?.hour = nil
        tag.releaseDateTime?.minute = 6784
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/FrameTDRLtest7.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.releaseDateTime?.year, 2006)
        XCTAssertEqual(tagWritten.releaseDateTime?.month, 10)
        XCTAssertEqual(tagWritten.releaseDateTime?.day, 31)
        XCTAssertEqual(tagWritten.releaseDateTime?.hour, 17)
        XCTAssertEqual(tagWritten.releaseDateTime?.minute, 4)
    }
    
    // MARK: TDRL, Unexpected, Overwrite, Tuple
    func testTDRLUnexpectedInputTupleOverwriteFileV24() throws {
        let mp3Url = Bundle.writtenV24
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.releaseDateTime = (year: 2002, month: 55, day: 119, hour: nil, minute: 6784)
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/FrameTDRLtest8.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.releaseDateTime?.year, 2006)
        XCTAssertEqual(tagWritten.releaseDateTime?.month, 10)
        XCTAssertEqual(tagWritten.releaseDateTime?.day, 31)
        XCTAssertEqual(tagWritten.releaseDateTime?.hour, 17)
        XCTAssertEqual(tagWritten.releaseDateTime?.minute, 4)
    }
    
    // MARK: TDRC, Expected, Blank, Components
    func testTDRCExpectedInputComponentsBlankFileV24() throws {
        let mp3Url = Bundle.v23NoMeta
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.recordingDateTime?.year = 2002
        tag.recordingDateTime?.month = 11
        tag.recordingDateTime?.day = 7
        tag.recordingDateTime?.hour = 9
        tag.recordingDateTime?.minute = 23
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/FrameTDRCtest1v24.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.recordingDateTime?.year, 2002)
        XCTAssertEqual(tagWritten.recordingDateTime?.month, 11)
        XCTAssertEqual(tagWritten.recordingDateTime?.day, 7)
        XCTAssertEqual(tagWritten.recordingDateTime?.hour, 9)
        XCTAssertEqual(tagWritten.recordingDateTime?.minute, 23)
    }
    
    func testTDRCExpectedInputComponentsBlankFileV23() throws {
        let mp3Url = Bundle.v23NoMeta
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.recordingDateTime?.year = 2002
        tag.recordingDateTime?.month = 11
        tag.recordingDateTime?.day = 7
        tag.recordingDateTime?.hour = 9
        tag.recordingDateTime?.minute = 23
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/FrameTDRCtest1v23.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_3, using: tag, writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.recordingDateTime?.year, 2002)
        XCTAssertEqual(tagWritten.recordingDateTime?.month, 11)
        XCTAssertEqual(tagWritten.recordingDateTime?.day, 7)
        XCTAssertEqual(tagWritten.recordingDateTime?.hour, 9)
        XCTAssertEqual(tagWritten.recordingDateTime?.minute, 23)
    }
    
    func testTDRCExpectedInputComponentsBlankFileV22() throws {
        let mp3Url = Bundle.v23NoMeta
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.recordingDateTime?.year = 2002
        tag.recordingDateTime?.month = 11
        tag.recordingDateTime?.day = 7
        tag.recordingDateTime?.hour = 9
        tag.recordingDateTime?.minute = 23
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/FrameTDRCtest1v22.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_2, using: tag, writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.recordingDateTime?.year, 2002)
        XCTAssertEqual(tagWritten.recordingDateTime?.month, 11)
        XCTAssertEqual(tagWritten.recordingDateTime?.day, 7)
        XCTAssertEqual(tagWritten.recordingDateTime?.hour, 9)
        XCTAssertEqual(tagWritten.recordingDateTime?.minute, 23)
    }
    
     // MARK: TDRC, Expected, Blank, Tuple
    func testTDRCExpectedInputTupleBlankFileV24() throws {
        let mp3Url = Bundle.v23NoMeta
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.recordingDateTime = (year: 2002, month: 11, day: 7, hour: 9, minute: 23)
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/FrameTDRCtest2v24.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.recordingDateTime?.year, 2002)
        XCTAssertEqual(tagWritten.recordingDateTime?.month, 11)
        XCTAssertEqual(tagWritten.recordingDateTime?.day, 7)
        XCTAssertEqual(tagWritten.recordingDateTime?.hour, 9)
        XCTAssertEqual(tagWritten.recordingDateTime?.minute, 23)
    }
    
    func testTDRCExpectedInputTupleBlankFileV23() throws {
        let mp3Url = Bundle.v23NoMeta
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.recordingDateTime = (year: 2002, month: 11, day: 7, hour: 9, minute: 23)
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/FrameTDRCtest2v23.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_3, using: tag, writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.recordingDateTime?.year, 2002)
        XCTAssertEqual(tagWritten.recordingDateTime?.month, 11)
        XCTAssertEqual(tagWritten.recordingDateTime?.day, 7)
        XCTAssertEqual(tagWritten.recordingDateTime?.hour, 9)
        XCTAssertEqual(tagWritten.recordingDateTime?.minute, 23)
    }
    
    func testTDRCExpectedInputTupleBlankFileV22() throws {
        let mp3Url = Bundle.v23NoMeta
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.recordingDateTime = (year: 2002, month: 11, day: 7, hour: 9, minute: 23)
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/FrameTDRCtest2v22.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_2, using: tag, writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.recordingDateTime?.year, 2002)
        XCTAssertEqual(tagWritten.recordingDateTime?.month, 11)
        XCTAssertEqual(tagWritten.recordingDateTime?.day, 7)
        XCTAssertEqual(tagWritten.recordingDateTime?.hour, 9)
        XCTAssertEqual(tagWritten.recordingDateTime?.minute, 23)
    }
    
    // MARK: TDRC, Expected, Overwrite, Components
    func testTDRCExpectedInputComponentsOverwriteFileV24() throws {
        let mp3Url = Bundle.writtenV24
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.recordingDateTime?.year = 2002
        tag.recordingDateTime?.month = 11
        tag.recordingDateTime?.day = 7
        tag.recordingDateTime?.hour = 9
        tag.recordingDateTime?.minute = 23
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/FrameTDRCtest3v24.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.recordingDateTime?.year, 2002)
        XCTAssertEqual(tagWritten.recordingDateTime?.month, 11)
        XCTAssertEqual(tagWritten.recordingDateTime?.day, 7)
        XCTAssertEqual(tagWritten.recordingDateTime?.hour, 9)
        XCTAssertEqual(tagWritten.recordingDateTime?.minute, 23)
    }
    
    func testTDRCExpectedInputComponentsOverwriteFileV23() throws {
        let mp3Url = Bundle.writtenV23
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.recordingDateTime?.year = 2002
        tag.recordingDateTime?.month = 11
        tag.recordingDateTime?.day = 7
        tag.recordingDateTime?.hour = 9
        tag.recordingDateTime?.minute = 23
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/FrameTDRCtest3v23.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_3, using: tag, writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.recordingDateTime?.year, 2002)
        XCTAssertEqual(tagWritten.recordingDateTime?.month, 11)
        XCTAssertEqual(tagWritten.recordingDateTime?.day, 7)
        XCTAssertEqual(tagWritten.recordingDateTime?.hour, 9)
        XCTAssertEqual(tagWritten.recordingDateTime?.minute, 23)
    }
    
    func testTDRCExpectedInputComponentsOverwriteFileV22() throws {
        let mp3Url = Bundle.writtenV22
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.recordingDateTime?.year = 2002
        tag.recordingDateTime?.month = 11
        tag.recordingDateTime?.day = 7
        tag.recordingDateTime?.hour = 9
        tag.recordingDateTime?.minute = 23
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/FrameTDRCtest3v22.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_2, using: tag, writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.recordingDateTime?.year, 2002)
        XCTAssertEqual(tagWritten.recordingDateTime?.month, 11)
        XCTAssertEqual(tagWritten.recordingDateTime?.day, 7)
        XCTAssertEqual(tagWritten.recordingDateTime?.hour, 9)
        XCTAssertEqual(tagWritten.recordingDateTime?.minute, 23)
    }
    
    // MARK: TDRC, Expected, Overwrite, Tuple
    func testTDRCExpectedInputTupleOverwriteFileV24() throws {
        let mp3Url = Bundle.writtenV24
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.recordingDateTime = (year: 2002, month: 11, day: 7, hour: 9, minute: 23)
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/FrameTDRCtest4v24.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.recordingDateTime?.year, 2002)
        XCTAssertEqual(tagWritten.recordingDateTime?.month, 11)
        XCTAssertEqual(tagWritten.recordingDateTime?.day, 7)
        XCTAssertEqual(tagWritten.recordingDateTime?.hour, 9)
        XCTAssertEqual(tagWritten.recordingDateTime?.minute, 23)
    }
    
    func testTDRCExpectedInputTupleOverwriteFileV23() throws {
        let mp3Url = Bundle.writtenV23
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.recordingDateTime = (year: 2002, month: 11, day: 7, hour: 9, minute: 23)
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/FrameTDRCtest4v23.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_3, using: tag, writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.recordingDateTime?.year, 2002)
        XCTAssertEqual(tagWritten.recordingDateTime?.month, 11)
        XCTAssertEqual(tagWritten.recordingDateTime?.day, 7)
        XCTAssertEqual(tagWritten.recordingDateTime?.hour, 9)
        XCTAssertEqual(tagWritten.recordingDateTime?.minute, 23)
    }
    
    func testTDRCExpectedInputTupleOverwriteFileV22() throws {
        let mp3Url = Bundle.writtenV22
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.recordingDateTime = (year: 2002, month: 11, day: 7, hour: 9, minute: 23)
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/FrameTDRCtest4v22.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_2, using: tag, writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.recordingDateTime?.year, 2002)
        XCTAssertEqual(tagWritten.recordingDateTime?.month, 11)
        XCTAssertEqual(tagWritten.recordingDateTime?.day, 7)
        XCTAssertEqual(tagWritten.recordingDateTime?.hour, 9)
        XCTAssertEqual(tagWritten.recordingDateTime?.minute, 23)
    }
    
    // MARK: TDRC, Unexpected, Blank, Components
    func testTDRCUnxpectedInputComponentsBlankFileV24() throws {
        let mp3Url = Bundle.v23NoMeta
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.recordingDateTime?.year = 2002
        tag.recordingDateTime?.month = 55
        tag.recordingDateTime?.day = 119
        tag.recordingDateTime?.hour = nil
        tag.recordingDateTime?.minute = 6784
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/FrameTDRCtest5v24.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.recordingDateTime?.year, 2006)
        XCTAssertEqual(tagWritten.recordingDateTime?.month, 10)
        XCTAssertEqual(tagWritten.recordingDateTime?.day, 31)
        XCTAssertEqual(tagWritten.recordingDateTime?.hour, 17)
        XCTAssertEqual(tagWritten.recordingDateTime?.minute, 4)
    }
    
    func testTDRCUnxpectedInputComponentsBlankFileV23() throws {
        let mp3Url = Bundle.v23NoMeta
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.recordingDateTime?.year = 2002
        tag.recordingDateTime?.month = 55
        tag.recordingDateTime?.day = 119
        tag.recordingDateTime?.hour = nil
        tag.recordingDateTime?.minute = 6784
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/FrameTDRCtest5v23.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_3, using: tag, writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.recordingDateTime?.year, 2006)
        XCTAssertEqual(tagWritten.recordingDateTime?.month, 10)
        XCTAssertEqual(tagWritten.recordingDateTime?.day, 31)
        XCTAssertEqual(tagWritten.recordingDateTime?.hour, 17)
        XCTAssertEqual(tagWritten.recordingDateTime?.minute, 4)
    }
    
    func testTDRCUnxpectedInputComponentsBlankFileV22() throws {
        let mp3Url = Bundle.v23NoMeta
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.recordingDateTime?.year = 2002
        tag.recordingDateTime?.month = 55
        tag.recordingDateTime?.day = 119
        tag.recordingDateTime?.hour = nil
        tag.recordingDateTime?.minute = 6784
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/FrameTDRCtest5v22.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_2, using: tag, writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.recordingDateTime?.year, 2006)
        XCTAssertEqual(tagWritten.recordingDateTime?.month, 10)
        XCTAssertEqual(tagWritten.recordingDateTime?.day, 31)
        XCTAssertEqual(tagWritten.recordingDateTime?.hour, 17)
        XCTAssertEqual(tagWritten.recordingDateTime?.minute, 4)
    }
    
   // MARK: TDRC, Unexpected, Blank, Tuple
    func testTDRCUnexpectedInputTupleBlankFileV24() throws {
        let mp3Url = Bundle.v23NoMeta
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.recordingDateTime = (year: 2002, month: 55, day: 119, hour: nil, minute: 6784)
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/FrameTDRCtest6v24.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.recordingDateTime?.year, 2006)
        XCTAssertEqual(tagWritten.recordingDateTime?.month, 10)
        XCTAssertEqual(tagWritten.recordingDateTime?.day, 31)
        XCTAssertEqual(tagWritten.recordingDateTime?.hour, 17)
        XCTAssertEqual(tagWritten.recordingDateTime?.minute, 4)
    }
    
    func testTDRCUnexpectedInputTupleBlankFileV23() throws {
        let mp3Url = Bundle.v23NoMeta
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.recordingDateTime = (year: 2002, month: 55, day: 119, hour: nil, minute: 6784)
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/FrameTDRCtest6v23.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_3, using: tag, writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.recordingDateTime?.year, 2006)
        XCTAssertEqual(tagWritten.recordingDateTime?.month, 10)
        XCTAssertEqual(tagWritten.recordingDateTime?.day, 31)
        XCTAssertEqual(tagWritten.recordingDateTime?.hour, 17)
        XCTAssertEqual(tagWritten.recordingDateTime?.minute, 4)
    }
    
    func testTDRCUnexpectedInputTupleBlankFileV22() throws {
        let mp3Url = Bundle.v23NoMeta
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.recordingDateTime = (year: 2002, month: 55, day: 119, hour: nil, minute: 6784)
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/FrameTDRCtest6v22.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_2, using: tag, writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.recordingDateTime?.year, 2006)
        XCTAssertEqual(tagWritten.recordingDateTime?.month, 10)
        XCTAssertEqual(tagWritten.recordingDateTime?.day, 31)
        XCTAssertEqual(tagWritten.recordingDateTime?.hour, 17)
        XCTAssertEqual(tagWritten.recordingDateTime?.minute, 4)
    }
    
    // MARK: TDRC, Unexpected, Overwrite, Components
    func testTDRCUnexpectedInputComponentsOverwriteFileV24() throws {
        let mp3Url = Bundle.writtenV24
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.recordingDateTime?.year = 2002
        tag.recordingDateTime?.month = 55
        tag.recordingDateTime?.day = 119
        tag.recordingDateTime?.hour = nil
        tag.recordingDateTime?.minute = 6784
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/FrameTDRCtest7v24.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.recordingDateTime?.year, 2006)
        XCTAssertEqual(tagWritten.recordingDateTime?.month, 10)
        XCTAssertEqual(tagWritten.recordingDateTime?.day, 31)
        XCTAssertEqual(tagWritten.recordingDateTime?.hour, 17)
        XCTAssertEqual(tagWritten.recordingDateTime?.minute, 4)
    }
    
    func testTDRCUnexpectedInputComponentsOverwriteFileV23() throws {
        let mp3Url = Bundle.writtenV23
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.recordingDateTime?.year = 2002
        tag.recordingDateTime?.month = 55
        tag.recordingDateTime?.day = 119
        tag.recordingDateTime?.hour = nil
        tag.recordingDateTime?.minute = 6784
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/FrameTDRCtest7v23.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_3, using: tag, writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.recordingDateTime?.year, 2006)
        XCTAssertEqual(tagWritten.recordingDateTime?.month, 10)
        XCTAssertEqual(tagWritten.recordingDateTime?.day, 31)
        XCTAssertEqual(tagWritten.recordingDateTime?.hour, 17)
        XCTAssertEqual(tagWritten.recordingDateTime?.minute, 4)
    }
    
    func testTDRCUnexpectedInputComponentsOverwriteFileV22() throws {
        let mp3Url = Bundle.writtenV22
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.recordingDateTime?.year = 2002
        tag.recordingDateTime?.month = 55
        tag.recordingDateTime?.day = 119
        tag.recordingDateTime?.hour = nil
        tag.recordingDateTime?.minute = 6784
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/FrameTDRCtest7v22.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_2, using: tag, writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.recordingDateTime?.year, 2006)
        XCTAssertEqual(tagWritten.recordingDateTime?.month, 10)
        XCTAssertEqual(tagWritten.recordingDateTime?.day, 31)
        XCTAssertEqual(tagWritten.recordingDateTime?.hour, 17)
        XCTAssertEqual(tagWritten.recordingDateTime?.minute, 4)
    }
    
    // MARK: TDRC, Unexpected, Overwrite, Tuple
    func testTDRCUnexpectedInputTupleOverwriteFileV24() throws {
        let mp3Url = Bundle.writtenV24
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.recordingDateTime = (year: 2002, month: 55, day: 119, hour: nil, minute: 6784)
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/FrameTDRCtest8v24.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.recordingDateTime?.year, 2006)
        XCTAssertEqual(tagWritten.recordingDateTime?.month, 10)
        XCTAssertEqual(tagWritten.recordingDateTime?.day, 31)
        XCTAssertEqual(tagWritten.recordingDateTime?.hour, 17)
        XCTAssertEqual(tagWritten.recordingDateTime?.minute, 4)
    }

    func testTDRCUnexpectedInputTupleOverwriteFileV23() throws {
        let mp3Url = Bundle.writtenV23
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.recordingDateTime = (year: 2002, month: 55, day: 119, hour: nil, minute: 6784)
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/FrameTDRCtest8v23.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_3, using: tag, writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.recordingDateTime?.year, 2006)
        XCTAssertEqual(tagWritten.recordingDateTime?.month, 10)
        XCTAssertEqual(tagWritten.recordingDateTime?.day, 31)
        XCTAssertEqual(tagWritten.recordingDateTime?.hour, 17)
        XCTAssertEqual(tagWritten.recordingDateTime?.minute, 4)
    }
    
    func testTDRCUnexpectedInputTupleOverwriteFileV22() throws {
        let mp3Url = Bundle.writtenV22
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.recordingDateTime = (year: 2002, month: 55, day: 119, hour: nil, minute: 6784)
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/FrameTDRCtest8v22.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_2, using: tag, writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.recordingDateTime?.year, 2006)
        XCTAssertEqual(tagWritten.recordingDateTime?.month, 10)
        XCTAssertEqual(tagWritten.recordingDateTime?.day, 31)
        XCTAssertEqual(tagWritten.recordingDateTime?.hour, 17)
        XCTAssertEqual(tagWritten.recordingDateTime?.minute, 4)
    }
    
    // MARK: TDOR, Expected, Blank, Components
    func testTDORExpectedInputComponentsBlankFileV24() throws {
        let mp3Url = Bundle.v23NoMeta
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.originalReleaseTime?.year = 2002
        tag.originalReleaseTime?.month = 11
        tag.originalReleaseTime?.day = 7
        tag.originalReleaseTime?.hour = 9
        tag.originalReleaseTime?.minute = 23
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/FrameTDORtest1v24.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.originalReleaseTime?.year, 2002)
        XCTAssertEqual(tagWritten.originalReleaseTime?.month, 11)
        XCTAssertEqual(tagWritten.originalReleaseTime?.day, 7)
        XCTAssertEqual(tagWritten.originalReleaseTime?.hour, 9)
        XCTAssertEqual(tagWritten.originalReleaseTime?.minute, 23)
    }
    
    func testTDORExpectedInputComponentsBlankFileV23() throws {
        let mp3Url = Bundle.v23NoMeta
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.originalReleaseYear = 2002
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/FrameTDORtest1v23.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_3, using: tag, writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.originalReleaseYear, 2002)
    }

    func testTDORExpectedInputComponentsBlankFileV22() throws {
        let mp3Url = Bundle.v23NoMeta
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.originalReleaseYear = 2002
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/FrameTDORtest1v22.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_2, using: tag, writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.originalReleaseYear, 2002)
    }

    // MARK: TDOR, Expected, Blank, Tuple
    func testTDORExpectedInputTupleBlankFileV24() throws {
        let mp3Url = Bundle.v23NoMeta
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.originalReleaseTime = (year: 2002, month: 11, day: 7, hour: 9, minute: 23)
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/FrameTDORtest2.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.originalReleaseTime?.year, 2002)
        XCTAssertEqual(tagWritten.originalReleaseTime?.month, 11)
        XCTAssertEqual(tagWritten.originalReleaseTime?.day, 7)
        XCTAssertEqual(tagWritten.originalReleaseTime?.hour, 9)
        XCTAssertEqual(tagWritten.originalReleaseTime?.minute, 23)
    }
    
    // MARK: TDOR, Expected, Overwrite, Components
    func testTDORExpectedInputComponentsOverwriteFileV24() throws {
        let mp3Url = Bundle.writtenV24
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.originalReleaseTime?.year = 2002
        tag.originalReleaseTime?.month = 11
        tag.originalReleaseTime?.day = 7
        tag.originalReleaseTime?.hour = 9
        tag.originalReleaseTime?.minute = 23
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/FrameTDORtest3.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.originalReleaseTime?.year, 2002)
        XCTAssertEqual(tagWritten.originalReleaseTime?.month, 11)
        XCTAssertEqual(tagWritten.originalReleaseTime?.day, 7)
        XCTAssertEqual(tagWritten.originalReleaseTime?.hour, 9)
        XCTAssertEqual(tagWritten.originalReleaseTime?.minute, 23)
    }
    
    // MARK: TDOR, Expected, Overwrite, Tuple
    func testTDORExpectedInputTupleOverwriteFileV24() throws {
        let mp3Url = Bundle.writtenV24
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.originalReleaseTime = (year: 2002, month: 11, day: 7, hour: 9, minute: 23)
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/FrameTDORtest4.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.originalReleaseTime?.year, 2002)
        XCTAssertEqual(tagWritten.originalReleaseTime?.month, 11)
        XCTAssertEqual(tagWritten.originalReleaseTime?.day, 7)
        XCTAssertEqual(tagWritten.originalReleaseTime?.hour, 9)
        XCTAssertEqual(tagWritten.originalReleaseTime?.minute, 23)
    }
    
    // MARK: TDOR, Unexpected, Blank, Components
    func testTDORUnxpectedInputComponentsBlankFileV24() throws {
        let mp3Url = Bundle.v23NoMeta
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.originalReleaseTime?.year = 2002
        tag.originalReleaseTime?.month = 55
        tag.originalReleaseTime?.day = 119
        tag.originalReleaseTime?.hour = nil
        tag.originalReleaseTime?.minute = 6784
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/FrameTDORtest5.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.originalReleaseTime?.year, 2006)
        XCTAssertEqual(tagWritten.originalReleaseTime?.month, 10)
        XCTAssertEqual(tagWritten.originalReleaseTime?.day, 31)
        XCTAssertEqual(tagWritten.originalReleaseTime?.hour, 17)
        XCTAssertEqual(tagWritten.originalReleaseTime?.minute, 4)
    }
    
    // MARK: TDOR, Unexpected, Blank, Tuple
    func testTDORUnexpectedInputTupleBlankFileV24() throws {
        let mp3Url = Bundle.v23NoMeta
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.originalReleaseTime = (year: 2002, month: 55, day: 119, hour: nil, minute: 6784)
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/FrameTDORtest6.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.originalReleaseTime?.year, 2006)
        XCTAssertEqual(tagWritten.originalReleaseTime?.month, 10)
        XCTAssertEqual(tagWritten.originalReleaseTime?.day, 31)
        XCTAssertEqual(tagWritten.originalReleaseTime?.hour, 17)
        XCTAssertEqual(tagWritten.originalReleaseTime?.minute, 4)
    }
    
    // MARK: TDOR, Unexpected, Overwrite, Components
    func testTDORUnexpectedInputComponentsOverwriteFileV24() throws {
        let mp3Url = Bundle.writtenV24
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.originalReleaseTime?.year = 2002
        tag.originalReleaseTime?.month = 55
        tag.originalReleaseTime?.day = 119
        tag.originalReleaseTime?.hour = nil
        tag.originalReleaseTime?.minute = 6784
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/FrameTDORtest7.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.originalReleaseTime?.year, 2006)
        XCTAssertEqual(tagWritten.originalReleaseTime?.month, 10)
        XCTAssertEqual(tagWritten.originalReleaseTime?.day, 31)
        XCTAssertEqual(tagWritten.originalReleaseTime?.hour, 17)
        XCTAssertEqual(tagWritten.originalReleaseTime?.minute, 4)
    }
    
    // MARK: TDOR, Unexpected, Overwrite, Tuple
    func testTDORUnexpectedInputTupleOverwriteFileV24() throws {
        let mp3Url = Bundle.writtenV24
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.originalReleaseTime = (year: 2002, month: 55, day: 119, hour: nil, minute: 6784)
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/FrameTDORtest8.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.originalReleaseTime?.year, 2006)
        XCTAssertEqual(tagWritten.originalReleaseTime?.month, 10)
        XCTAssertEqual(tagWritten.originalReleaseTime?.day, 31)
        XCTAssertEqual(tagWritten.originalReleaseTime?.hour, 17)
        XCTAssertEqual(tagWritten.originalReleaseTime?.minute, 4)
    }
    

}
