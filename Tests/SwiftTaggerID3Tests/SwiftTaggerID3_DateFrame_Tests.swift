/*

 SwiftTaggerID3_DateFrame_Tests.swift
 SwiftTaggerID3

 Copyright ©2020 Nolaine Crusher. All rights reserved.

 */

import XCTest
import SwiftTaggerID3

class SwiftTaggerID3_DateFrame_Tests: XCTestCase {
    
    // // MARK: - EncodingTime frame tests
    // Test EncodingTime frame for version 2.4, with expected input, writing values as individual components to file without metadata
    func testTDENv24ExpectedInputBlankFileAsComponents() throws {
      if #available(macOS 10.12, *) {

        var tag = try TestFile.noMeta.tag()

        tag?.encodingDateTime?.year = 2002
        tag?.encodingDateTime?.month = 11
        tag?.encodingDateTime?.day = 7
        tag?.encodingDateTime?.hour = 9
        tag?.encodingDateTime?.minute = 23
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        let outputMp3 = try TestFile.noMeta.mp3File()
        XCTAssertNoThrow(try outputMp3?.write(tagVersion: .v2_4,
                            using: tag ?? Tag(readFrom: Mp3File(location: TestFile.noMeta.url)),
                            writingTo: outputUrl))

        let resultMp3 = try Mp3File(location: outputUrl)
        let result = try Tag(readFrom: resultMp3)
        XCTAssertEqual(result.encodingDateTime?.year, 2002)
        XCTAssertEqual(result.encodingDateTime?.month, 11)
        XCTAssertEqual(result.encodingDateTime?.day, 7)
        XCTAssertEqual(result.encodingDateTime?.hour, 9)
        XCTAssertEqual(result.encodingDateTime?.minute, 23)
      }
    }

    // Test EncodingTime frame for version 2.4, with expected input, writing values as individual components to file with metadata
    func testTDENv24ExpectedInputOverwriteFileAsComponents() throws {
      if #available(macOS 10.12, *) {
        var tag = try TestFile.v24.tag()
        tag?.encodingDateTime?.year = 2003
        tag?.encodingDateTime?.month = 12
        tag?.encodingDateTime?.day = 8
        tag?.encodingDateTime?.hour = 10
        tag?.encodingDateTime?.minute = 24
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        let outputMp3 = try TestFile.v24.mp3File()
        XCTAssertNoThrow(try outputMp3?.write(tagVersion: .v2_4,
                                             using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v24.url)),
                                             writingTo: outputUrl))
        
        let resultMp3 = try Mp3File(location: outputUrl)
        let result = try Tag(readFrom: resultMp3)
        XCTAssertEqual(result.encodingDateTime?.year, 2003)
        XCTAssertEqual(result.encodingDateTime?.month, 12)
        XCTAssertEqual(result.encodingDateTime?.day, 8)
        XCTAssertEqual(result.encodingDateTime?.hour, 10)
        XCTAssertEqual(result.encodingDateTime?.minute, 24)
      }
    }

    // Test EncodingTime frame for version 2.4, with expected input, writing values as tuple to file without metadata
    func testTDENv24ExpectedInputBlankFileAsTuple() throws {
      if #available(macOS 10.12, *) {
        var tag = try TestFile.noMeta.tag()
        tag?.encodingDateTime = (year: 2004, month: 01, day: 09, hour: 11, minute: 25)
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        let outputMp3 = try TestFile.noMeta.mp3File()
        XCTAssertNoThrow(try outputMp3?.write(tagVersion: .v2_4,
                                             using: tag ?? Tag(readFrom: Mp3File(location: TestFile.noMeta.url)),
                                             writingTo: outputUrl))
        
        let resultMp3 = try Mp3File(location: outputUrl)
        let result = try Tag(readFrom: resultMp3)
        XCTAssertEqual(result.encodingDateTime?.year, 2004)
        XCTAssertEqual(result.encodingDateTime?.month, 01)
        XCTAssertEqual(result.encodingDateTime?.day, 09)
        XCTAssertEqual(result.encodingDateTime?.hour, 11)
        XCTAssertEqual(result.encodingDateTime?.minute, 25)
      }
    }
    
    // Test EncodingTime frame for version 2.4, with expected input, writing values as tuple to file with metadata
    func testTDENv24ExpectedInputOverwriteFileAsTuple() throws {
      if #available(macOS 10.12, *) {
        var tag = try TestFile.v24.tag()
        tag?.encodingDateTime = (year: 2005, month: 02, day: 10, hour: 12, minute: 26)

        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        let outputMp3 = try TestFile.v24.mp3File()
        XCTAssertNoThrow(try outputMp3?.write(tagVersion: .v2_4,
                                             using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v24.url)),
                                             writingTo: outputUrl))
        
        let resultMp3 = try Mp3File(location: outputUrl)
        let result = try Tag(readFrom: resultMp3)
        XCTAssertEqual(result.encodingDateTime?.year, 2005)
        XCTAssertEqual(result.encodingDateTime?.month, 02)
        XCTAssertEqual(result.encodingDateTime?.day, 10)
        XCTAssertEqual(result.encodingDateTime?.hour, 12)
        XCTAssertEqual(result.encodingDateTime?.minute, 26)
      }
    }
    
    // Test EncodingTime frame will throw error when attempting to use with version 2.2, writing to file with metadata
    func testTDENVersionErrorv22Overwrite() throws {
      if #available(macOS 10.12, *) {
        var tag = try TestFile.v22.tag()
        tag?.encodingDateTime?.year = 2002
        tag?.encodingDateTime?.month = 11
        tag?.encodingDateTime?.day = 7
        tag?.encodingDateTime?.hour = 9
        tag?.encodingDateTime?.minute = 23
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        let outputMp3 = try TestFile.v22.mp3File()
        XCTAssertThrowsError(try outputMp3?.write(tagVersion: .v2_2,
                                             using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v22.url)),
                                             writingTo: outputUrl))
      }
    }

    // Test EncodingTime frame will throw error when attempting to use with version 2.3, writing to file with metadata
    func testTDENVersionErrorv23Overwrite() throws {
      if #available(macOS 10.12, *) {
        var tag = try TestFile.v23.tag()
        tag?.encodingDateTime?.year = 2002
        tag?.encodingDateTime?.month = 11
        tag?.encodingDateTime?.day = 7
        tag?.encodingDateTime?.hour = 9
        tag?.encodingDateTime?.minute = 23
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        let outputMp3 = try TestFile.v23.mp3File()
        XCTAssertThrowsError(try outputMp3?.write(tagVersion: .v2_3,
                                                 using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v23.url)),
                                                 writingTo: outputUrl))
      }
    }

    // Test EncodingTime frame will throw error when attempting to use with version 2.2 writing to file without metadata
    func testTDENVersionErrorv22Blank() throws {
      if #available(macOS 10.12, *) {
        var tag = try TestFile.noMeta.tag()
        tag?.encodingDateTime?.year = 2002
        tag?.encodingDateTime?.month = 11
        tag?.encodingDateTime?.day = 7
        tag?.encodingDateTime?.hour = 9
        tag?.encodingDateTime?.minute = 23
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        let outputMp3 = try TestFile.noMeta.mp3File()
        XCTAssertThrowsError(try outputMp3?.write(tagVersion: .v2_2,
                                                 using: tag ?? Tag(readFrom: Mp3File(location: TestFile.noMeta.url)),
                                                 writingTo: outputUrl))
      }
    }
    
    // Test EncodingTime frame will throw error when attempting to use with version 2.3 writing to file without metadata
    func testTDENVersionErrorv23Blank() throws {
      if #available(macOS 10.12, *) {
        var tag = try TestFile.noMeta.tag()
        tag?.encodingDateTime?.year = 2002
        tag?.encodingDateTime?.month = 11
        tag?.encodingDateTime?.day = 7
        tag?.encodingDateTime?.hour = 9
        tag?.encodingDateTime?.minute = 23
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        let outputMp3 = try TestFile.noMeta.mp3File()
        XCTAssertThrowsError(try outputMp3?.write(tagVersion: .v2_3,
                                                 using: tag ?? Tag(readFrom: Mp3File(location: TestFile.noMeta.url)),
                                                 writingTo: outputUrl))
      }
    }
    
    // // MARK: - TaggingTime frame tests
    // Test TaggingTime frame for version 2.4, with expected input, writing values as individual components to file without metadata
    func testTDTGv24ExpectedInputBlankFileAsComponents() throws {
      if #available(macOS 10.12, *) {
        var tag = try TestFile.noMeta.tag()
        tag?.taggingDateTime?.year = 2002
        tag?.taggingDateTime?.month = 11
        tag?.taggingDateTime?.day = 7
        tag?.taggingDateTime?.hour = 9
        tag?.taggingDateTime?.minute = 23
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        let outputMp3 = try TestFile.noMeta.mp3File()
        XCTAssertNoThrow(try outputMp3?.write(tagVersion: .v2_4,
                                             using: tag ?? Tag(readFrom: Mp3File(location: TestFile.noMeta.url)),
                                             writingTo: outputUrl))
        
        let resultMp3 = try Mp3File(location: outputUrl)
        let result = try Tag(readFrom: resultMp3)
        XCTAssertEqual(result.taggingDateTime?.year, 2002)
        XCTAssertEqual(result.taggingDateTime?.month, 11)
        XCTAssertEqual(result.taggingDateTime?.day, 7)
        XCTAssertEqual(result.taggingDateTime?.hour, 9)
        XCTAssertEqual(result.taggingDateTime?.minute, 23)
      }
    }
    
    // Test TaggingTime frame for version 2.4, with expected input, writing values as individual components to file with metadata
    func testTDTGv24ExpectedInputOverwriteFileAsComponents() throws {
      if #available(macOS 10.12, *) {
        var tag = try TestFile.v24.tag()
        tag?.taggingDateTime?.year = 2003
        tag?.taggingDateTime?.month = 12
        tag?.taggingDateTime?.day = 8
        tag?.taggingDateTime?.hour = 10
        tag?.taggingDateTime?.minute = 24
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        let outputMp3 = try TestFile.v24.mp3File()
        XCTAssertNoThrow(try outputMp3?.write(tagVersion: .v2_4,
                                             using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v24.url)),
                                             writingTo: outputUrl))
        
        let resultMp3 = try Mp3File(location: outputUrl)
        let result = try Tag(readFrom: resultMp3)
        XCTAssertEqual(result.taggingDateTime?.year, 2003)
        XCTAssertEqual(result.taggingDateTime?.month, 12)
        XCTAssertEqual(result.taggingDateTime?.day, 8)
        XCTAssertEqual(result.taggingDateTime?.hour, 10)
        XCTAssertEqual(result.taggingDateTime?.minute, 24)
      }
    }
    
    // Test TaggingTime frame for version 2.4, with expected input, writing values as tuple to file without metadata
    func testTDTGv24ExpectedInputBlankFileAsTuple() throws {
      if #available(macOS 10.12, *) {
        var tag = try TestFile.noMeta.tag()
        tag?.taggingDateTime = (year: 2004, month: 01, day: 09, hour: 11, minute: 25)
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        let outputMp3 = try TestFile.noMeta.mp3File()
        XCTAssertNoThrow(try outputMp3?.write(tagVersion: .v2_4,
                                             using: tag ?? Tag(readFrom: Mp3File(location: TestFile.noMeta.url)),
                                             writingTo: outputUrl))
        
        let resultMp3 = try Mp3File(location: outputUrl)
        let result = try Tag(readFrom: resultMp3)
        XCTAssertEqual(result.taggingDateTime?.year, 2004)
        XCTAssertEqual(result.taggingDateTime?.month, 01)
        XCTAssertEqual(result.taggingDateTime?.day, 09)
        XCTAssertEqual(result.taggingDateTime?.hour, 11)
        XCTAssertEqual(result.taggingDateTime?.minute, 25)
      }
    }
    
    // Test TaggingTime frame for version 2.4, with expected input, writing values as individual components to file with metadata
    func testTDTGv24ExpectedInputOverwriteFileAsTuple() throws {
      if #available(macOS 10.12, *) {
        var tag = try TestFile.v24.tag()
        tag?.taggingDateTime = (year: 2005, month: 02, day: 10, hour: 12, minute: 26)
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        let outputMp3 = try TestFile.v24.mp3File()
        XCTAssertNoThrow(try outputMp3?.write(tagVersion: .v2_4,
                                             using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v24.url)),
                                             writingTo: outputUrl))
        
        let resultMp3 = try Mp3File(location: outputUrl)
        let result = try Tag(readFrom: resultMp3)
        XCTAssertEqual(result.taggingDateTime?.year, 2005)
        XCTAssertEqual(result.taggingDateTime?.month, 02)
        XCTAssertEqual(result.taggingDateTime?.day, 10)
        XCTAssertEqual(result.taggingDateTime?.hour, 12)
        XCTAssertEqual(result.taggingDateTime?.minute, 26)
      }
    }
    
    // Test TaggingTime frame will throw error when attempting to use with version 2.2 writing to file with metadata
    func testTDTGVersionErrorv22Overwrite() throws {
      if #available(macOS 10.12, *) {
        var tag = try TestFile.v22.tag()
        tag?.taggingDateTime?.year = 2002
        tag?.taggingDateTime?.month = 11
        tag?.taggingDateTime?.day = 7
        tag?.taggingDateTime?.hour = 9
        tag?.taggingDateTime?.minute = 23
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        let outputMp3 = try TestFile.v22.mp3File()
        XCTAssertThrowsError(try outputMp3?.write(tagVersion: .v2_2,
                                                 using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v22.url)),
                                                 writingTo: outputUrl))
      }
    }
    
    // Test TaggingTime frame will throw error when attempting to use with version 2.3 writing to file with metadata
    func testTDTGVersionErrorv23Overwrite() throws {
      if #available(macOS 10.12, *) {
        var tag = try TestFile.v23.tag()
        tag?.taggingDateTime?.year = 2002
        tag?.taggingDateTime?.month = 11
        tag?.taggingDateTime?.day = 7
        tag?.taggingDateTime?.hour = 9
        tag?.taggingDateTime?.minute = 23
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        let outputMp3 = try TestFile.v23.mp3File()
        XCTAssertThrowsError(try outputMp3?.write(tagVersion: .v2_3,
                                                 using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v23.url)),
                                                 writingTo: outputUrl))
      }
    }
    
    // Test TaggingTime frame will throw error when attempting to use with version 2.2 writing to file without metadata
    func testTDTGVersionErrorv22Blank() throws {
      if #available(macOS 10.12, *) {
        var tag = try TestFile.noMeta.tag()
        tag?.taggingDateTime?.year = 2002
        tag?.taggingDateTime?.month = 11
        tag?.taggingDateTime?.day = 7
        tag?.taggingDateTime?.hour = 9
        tag?.taggingDateTime?.minute = 23
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        let outputMp3 = try TestFile.noMeta.mp3File()
        XCTAssertThrowsError(try outputMp3?.write(tagVersion: .v2_2,
                                                 using: tag ?? Tag(readFrom: Mp3File(location: TestFile.noMeta.url)),
                                                 writingTo: outputUrl))
      }
    }
    
    // Test TaggingTime frame will throw error when attempting to use with version 2.3 writing to file without metadata
    func testTDTGVersionErrorv23Blank() throws {
      if #available(macOS 10.12, *) {
        var tag = try TestFile.noMeta.tag()
        tag?.taggingDateTime?.year = 2002
        tag?.taggingDateTime?.month = 11
        tag?.taggingDateTime?.day = 7
        tag?.taggingDateTime?.hour = 9
        tag?.taggingDateTime?.minute = 23
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        let outputMp3 = try TestFile.noMeta.mp3File()
        XCTAssertThrowsError(try outputMp3?.write(tagVersion: .v2_3,
                                                 using: tag ?? Tag(readFrom: Mp3File(location: TestFile.noMeta.url)),
                                                 writingTo: outputUrl))
      }
    }
    
    // // MARK: - ReleaseTime frame tests
    // Test ReleaseTime frame for version 2.4, with expected input, writing values as individual components to file without metadata
    func testTDRLv24ExpectedInputBlankFileAsComponents() throws {
      if #available(macOS 10.12, *) {
        var tag = try TestFile.noMeta.tag()
        tag?.releaseDateTime?.year = 2002
        tag?.releaseDateTime?.month = 11
        tag?.releaseDateTime?.day = 7
        tag?.releaseDateTime?.hour = 9
        tag?.releaseDateTime?.minute = 23
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        let outputMp3 = try TestFile.noMeta.mp3File()
        XCTAssertNoThrow(try outputMp3?.write(tagVersion: .v2_4,
                                             using: tag ?? Tag(readFrom: Mp3File(location: TestFile.noMeta.url)),
                                             writingTo: outputUrl))
        
        let resultMp3 = try Mp3File(location: outputUrl)
        let result = try Tag(readFrom: resultMp3)
        XCTAssertEqual(result.releaseDateTime?.year, 2002)
        XCTAssertEqual(result.releaseDateTime?.month, 11)
        XCTAssertEqual(result.releaseDateTime?.day, 7)
        XCTAssertEqual(result.releaseDateTime?.hour, 9)
        XCTAssertEqual(result.releaseDateTime?.minute, 23)
      }
    }
    
    // Test ReleaseTime frame for version 2.4, with expected input, writing values as individual components to file with metadata
    func testTDRLv24ExpectedInputOverwriteFileAsComponents() throws {
      if #available(macOS 10.12, *) {
        var tag = try TestFile.v24.tag()
        tag?.releaseDateTime?.year = 2003
        tag?.releaseDateTime?.month = 12
        tag?.releaseDateTime?.day = 8
        tag?.releaseDateTime?.hour = 10
        tag?.releaseDateTime?.minute = 24
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        let outputMp3 = try TestFile.v24.mp3File()
        XCTAssertNoThrow(try outputMp3?.write(tagVersion: .v2_4,
                                             using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v24.url)),
                                             writingTo: outputUrl))
        
        let resultMp3 = try Mp3File(location: outputUrl)
        let result = try Tag(readFrom: resultMp3)
        XCTAssertEqual(result.releaseDateTime?.year, 2003)
        XCTAssertEqual(result.releaseDateTime?.month, 12)
        XCTAssertEqual(result.releaseDateTime?.day, 8)
        XCTAssertEqual(result.releaseDateTime?.hour, 10)
        XCTAssertEqual(result.releaseDateTime?.minute, 24)
      }
    }
    
    // Test ReleaseTime frame for version 2.4, with expected input, writing values as tuple to file without metadata
    func testTDRLv24ExpectedInputBlankFileAsTuple() throws {
      if #available(macOS 10.12, *) {
        var tag = try TestFile.noMeta.tag()
        tag?.releaseDateTime = (year: 2004, month: 01, day: 09, hour: 11, minute: 25)
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        let outputMp3 = try TestFile.noMeta.mp3File()
        XCTAssertNoThrow(try outputMp3?.write(tagVersion: .v2_4,
                                             using: tag ?? Tag(readFrom: Mp3File(location: TestFile.noMeta.url)),
                                             writingTo: outputUrl))
        
        let resultMp3 = try Mp3File(location: outputUrl)
        let result = try Tag(readFrom: resultMp3)
        XCTAssertEqual(result.releaseDateTime?.year, 2004)
        XCTAssertEqual(result.releaseDateTime?.month, 01)
        XCTAssertEqual(result.releaseDateTime?.day, 09)
        XCTAssertEqual(result.releaseDateTime?.hour, 11)
        XCTAssertEqual(result.releaseDateTime?.minute, 25)
      }
    }
    
    // Test ReleaseTime frame for version 2.4, with expected input, writing values as tuple to file with metadata
    func testTDRLv24ExpectedInputOverwriteFileAsTuple() throws {
      if #available(macOS 10.12, *) {
        var tag = try TestFile.v24.tag()
        tag?.releaseDateTime = (year: 2005, month: 02, day: 10, hour: 12, minute: 26)
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        let outputMp3 = try TestFile.v24.mp3File()
        XCTAssertNoThrow(try outputMp3?.write(tagVersion: .v2_4,
                                             using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v24.url)),
                                             writingTo: outputUrl))
        
        let resultMp3 = try Mp3File(location: outputUrl)
        let result = try Tag(readFrom: resultMp3)
        XCTAssertEqual(result.releaseDateTime?.year, 2005)
        XCTAssertEqual(result.releaseDateTime?.month, 02)
        XCTAssertEqual(result.releaseDateTime?.day, 10)
        XCTAssertEqual(result.releaseDateTime?.hour, 12)
        XCTAssertEqual(result.releaseDateTime?.minute, 26)
      }
    }
    
    // Test ReleaseTime frame will throw error when attempting to use with version 2.2 writing to file with metadata
    func testTDRLVersionErrorv22Overwrite() throws {
      if #available(macOS 10.12, *) {
        var tag = try TestFile.v22.tag()
        tag?.releaseDateTime?.year = 2002
        tag?.releaseDateTime?.month = 11
        tag?.releaseDateTime?.day = 7
        tag?.releaseDateTime?.hour = 9
        tag?.releaseDateTime?.minute = 23
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        let outputMp3 = try TestFile.v22.mp3File()
        XCTAssertThrowsError(try outputMp3?.write(tagVersion: .v2_2,
                                                 using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v22.url)),
                                                 writingTo: outputUrl))
      }
    }
    
    // Test ReleaseTime frame will throw error when attempting to use with version 2.3 writing to file with metadata
    func testTDRLVersionErrorv23Overwrite() throws {
      if #available(macOS 10.12, *) {
        var tag = try TestFile.v23.tag()
        tag?.releaseDateTime?.year = 2002
        tag?.releaseDateTime?.month = 11
        tag?.releaseDateTime?.day = 7
        tag?.releaseDateTime?.hour = 9
        tag?.releaseDateTime?.minute = 23
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        let outputMp3 = try TestFile.v23.mp3File()
        XCTAssertThrowsError(try outputMp3?.write(tagVersion: .v2_3,
                                                 using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v23.url)),
                                                 writingTo: outputUrl))
      }
    }
    
    // Test ReleaseTime frame will throw error when attempting to use with version 2.2 writing to file without metadata
    func testTDRLVersionErrorv22Blank() throws {
      if #available(macOS 10.12, *) {
        var tag = try TestFile.noMeta.tag()
        tag?.releaseDateTime?.year = 2002
        tag?.releaseDateTime?.month = 11
        tag?.releaseDateTime?.day = 7
        tag?.releaseDateTime?.hour = 9
        tag?.releaseDateTime?.minute = 23
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        let outputMp3 = try TestFile.noMeta.mp3File()
        XCTAssertThrowsError(try outputMp3?.write(tagVersion: .v2_2,
                                                 using: tag ?? Tag(readFrom: Mp3File(location: TestFile.noMeta.url)),
                                                 writingTo: outputUrl))
      }
    }
    
    // Test ReleaseTime frame will throw error when attempting to use with version 2.3 writing to file without metadata
    func testTDRLVersionErrorv23Blank() throws {
      if #available(macOS 10.12, *) {
        var tag = try TestFile.noMeta.tag()
        tag?.releaseDateTime?.year = 2002
        tag?.releaseDateTime?.month = 11
        tag?.releaseDateTime?.day = 7
        tag?.releaseDateTime?.hour = 9
        tag?.releaseDateTime?.minute = 23
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        let outputMp3 = try TestFile.noMeta.mp3File()
        XCTAssertThrowsError(try outputMp3?.write(tagVersion: .v2_3,
                                                 using: tag ?? Tag(readFrom: Mp3File(location: TestFile.noMeta.url)),
                                                 writingTo: outputUrl))
      }
    }
    
    // // MARK: - Date frame tests
    // test DATE frame works in version 2.2, when writing expected input to file without metadata, as individual components
    func testTDAExpectedInputv22BlankAsComponents() throws {
      if #available(macOS 10.12, *) {
        var tag = try TestFile.noMeta.tag()
        tag?.date?.month = 11
        tag?.date?.day = 7
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        let outputMp3 = try Mp3File(location: TestFile.noMeta.url)
        XCTAssertNoThrow(try outputMp3.write(tagVersion: .v2_2,
                                             using: tag ?? Tag(readFrom: Mp3File(location: TestFile.noMeta.url)),
                                             writingTo: outputUrl))
        
        let resultMp3 = try Mp3File(location: outputUrl)
        let result = try Tag(readFrom: resultMp3)
        XCTAssertEqual(result.date?.month, 11)
        XCTAssertEqual(result.date?.day, 7)
      }
    }

    // test DATE frame works in version 2.2, when writing expected input to file without metadata, as tuple
    func testTDAExpectedInputv22BlankAsTuple() throws {
      if #available(macOS 10.12, *) {
        var tag = try TestFile.noMeta.tag()
        tag?.date = (day: 7, month: 11)
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        let outputMp3 = try TestFile.noMeta.mp3File()
        XCTAssertNoThrow(try outputMp3?.write(tagVersion: .v2_2,
                                             using: tag ?? Tag(readFrom: Mp3File(location: TestFile.noMeta.url)),
                                             writingTo: outputUrl))
        
        let resultMp3 = try Mp3File(location: outputUrl)
        let result = try Tag(readFrom: resultMp3)
        XCTAssertEqual(result.date?.month, 11)
        XCTAssertEqual(result.date?.day, 7)
      }
    }

    // test DATE frame works in version 2.2, when writing expected input to file with metadata, as individual components
    func testTDAExpectedInputv22OverwriteAsComponents() throws {
      if #available(macOS 10.12, *) {
        var tag = try TestFile.v22.tag()
        tag?.date?.month = 11
        tag?.date?.day = 7
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        let outputMp3 = try TestFile.v22.mp3File()
        XCTAssertNoThrow(try outputMp3?.write(tagVersion: .v2_2,
                                             using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v22.url)),
                                             writingTo: outputUrl))
        
        let resultMp3 = try Mp3File(location: outputUrl)
        let result = try Tag(readFrom: resultMp3)
        XCTAssertEqual(result.date?.month, 11)
        XCTAssertEqual(result.date?.day, 7)
      }
    }
    
    // test DATE frame works in version 2.2, when writing expected input to file with metadata, as tuple
    func testTDAExpectedInputv22OverwriteAsTuple() throws {
      if #available(macOS 10.12, *) {
        var tag = try TestFile.v22.tag()
        tag?.date = (day: 7, month: 11)
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        let outputMp3 = try TestFile.v22.mp3File()
        XCTAssertNoThrow(try outputMp3?.write(tagVersion: .v2_2,
                                             using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v22.url)),
                                             writingTo: outputUrl))
        
        let resultMp3 = try Mp3File(location: outputUrl)
        let result = try Tag(readFrom: resultMp3)
        XCTAssertEqual(result.date?.month, 11)
        XCTAssertEqual(result.date?.day, 7)
      }
    }

    // test DATE frame works in version 2.3, when writing expected input to file without metadata, as individual components
    func testTDATExpectedInputv23BlankAsComponents() throws {
      if #available(macOS 10.12, *) {
        var tag = try TestFile.noMeta.tag()
        tag?.date?.month = 11
        tag?.date?.day = 7
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        let outputMp3 = try Mp3File(location: TestFile.noMeta.url)
        XCTAssertNoThrow(try outputMp3.write(tagVersion: .v2_3,
                                             using: tag ?? Tag(readFrom: Mp3File(location: TestFile.noMeta.url)),
                                             writingTo: outputUrl))
        
        let resultMp3 = try Mp3File(location: outputUrl)
        let result = try Tag(readFrom: resultMp3)
        XCTAssertEqual(result.date?.month, 11)
        XCTAssertEqual(result.date?.day, 7)
      }
    }
    
    // test DATE frame works in version 2.3, when writing expected input to file without metadata, as tuple
    func testTDATExpectedInputv23BlankAsTuple() throws {
      if #available(macOS 10.12, *) {
        var tag = try TestFile.noMeta.tag()
        tag?.date = (day: 7, month: 11)
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        let outputMp3 = try TestFile.noMeta.mp3File()
        XCTAssertNoThrow(try outputMp3?.write(tagVersion: .v2_3,
                                             using: tag ?? Tag(readFrom: Mp3File(location: TestFile.noMeta.url)),
                                             writingTo: outputUrl))
        
        let resultMp3 = try Mp3File(location: outputUrl)
        let result = try Tag(readFrom: resultMp3)
        XCTAssertEqual(result.date?.month, 11)
        XCTAssertEqual(result.date?.day, 7)
      }
    }
    
    // test DATE frame works in version 2.3, when writing expected input to file with metadata, as individual components
    func testTDATExpectedInputv23OverwriteAsComponents() throws {
      if #available(macOS 10.12, *) {
        var tag = try TestFile.v23.tag()
        tag?.date?.month = 11
        tag?.date?.day = 7
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        let outputMp3 = try TestFile.v23.mp3File()
        XCTAssertNoThrow(try outputMp3?.write(tagVersion: .v2_3,
                                             using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v23.url)),
                                             writingTo: outputUrl))
        
        let resultMp3 = try Mp3File(location: outputUrl)
        let result = try Tag(readFrom: resultMp3)
        XCTAssertEqual(result.date?.month, 11)
        XCTAssertEqual(result.date?.day, 7)
      }
    }
    
    // test DATE frame works in version 2.3, when writing expected input to file with metadata, as tuple
    func testTDATExpectedInputv23OverwriteAsTuple() throws {
      if #available(macOS 10.12, *) {
        var tag = try TestFile.v23.tag()
        tag?.date = (day: 7, month: 11)
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        let outputMp3 = try TestFile.v23.mp3File()
        XCTAssertNoThrow(try outputMp3?.write(tagVersion: .v2_3,
                                             using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v23.url)),
                                             writingTo: outputUrl))
        
        let resultMp3 = try Mp3File(location: outputUrl)
        let result = try Tag(readFrom: resultMp3)
        XCTAssertEqual(result.date?.month, 11)
        XCTAssertEqual(result.date?.day, 7)
      }
    }
    
    // test DATE frame will throw error when attempting to use with version 2.4
    func testTDRLVersionErrorv24OverwriteAsComponents() throws {
      if #available(macOS 10.12, *) {
        var tag = try TestFile.v24.tag()
        tag?.date?.month = 11
        tag?.date?.day = 7
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        let outputMp3 = try TestFile.v24.mp3File()
        XCTAssertThrowsError(try outputMp3?.write(tagVersion: .v2_4,
                                             using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v24.url)),
                                             writingTo: outputUrl))
      }
    }

    // // MARK: - Time frame tests
    // test TIME frame works in version 2.2, when writing expected input to file without metadata, as individual components
    func testTIMExpectedInputv22BlankAsComponents() throws {
      if #available(macOS 10.12, *) {
        var tag = try TestFile.noMeta.tag()
        tag?.time?.hour = 9
        tag?.time?.minute = 23
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        let outputMp3 = try Mp3File(location: TestFile.noMeta.url)
        XCTAssertNoThrow(try outputMp3.write(tagVersion: .v2_2,
                                             using: tag ?? Tag(readFrom: Mp3File(location: TestFile.noMeta.url)),
                                             writingTo: outputUrl))
        
        let resultMp3 = try Mp3File(location: outputUrl)
        let result = try Tag(readFrom: resultMp3)
        XCTAssertEqual(result.time?.hour, 9)
        XCTAssertEqual(result.time?.minute, 23)
      }
    }
    
    // test TIME frame works in version 2.2, when writing expected input to file without metadata, as tuple
    func testTIMExpectedInputv22BlankAsTuple() throws {
      if #available(macOS 10.12, *) {
        var tag = try TestFile.noMeta.tag()
        tag?.time = (hour: 9, minute: 23)
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        let outputMp3 = try TestFile.noMeta.mp3File()
        XCTAssertNoThrow(try outputMp3?.write(tagVersion: .v2_2,
                                             using: tag ?? Tag(readFrom: Mp3File(location: TestFile.noMeta.url)),
                                             writingTo: outputUrl))
        
        let resultMp3 = try Mp3File(location: outputUrl)
        let result = try Tag(readFrom: resultMp3)
        XCTAssertEqual(result.time?.hour, 9)
        XCTAssertEqual(result.time?.minute, 23)
      }
    }
    
    // test TIME frame works in version 2.2, when writing expected input to file with metadata, as individual components
    func testTIMExpectedInputv22OverwriteAsComponents() throws {
      if #available(macOS 10.12, *) {
        var tag = try TestFile.v22.tag()
        tag?.time?.hour = 9
        tag?.time?.minute = 23
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        let outputMp3 = try TestFile.v22.mp3File()
        XCTAssertNoThrow(try outputMp3?.write(tagVersion: .v2_2,
                                             using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v22.url)),
                                             writingTo: outputUrl))
        
        let resultMp3 = try Mp3File(location: outputUrl)
        let result = try Tag(readFrom: resultMp3)
        XCTAssertEqual(result.time?.hour, 9)
        XCTAssertEqual(result.time?.minute, 23)
      }
    }
    
    // test TIME frame works in version 2.2, when writing expected input to file with metadata, as tuple
    func testTIMExpectedInputv22OverwriteAsTuple() throws {
      if #available(macOS 10.12, *) {
        var tag = try TestFile.v22.tag()
        tag?.time = (hour: 9, minute: 23)
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        let outputMp3 = try TestFile.v22.mp3File()
        XCTAssertNoThrow(try outputMp3?.write(tagVersion: .v2_2,
                                             using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v22.url)),
                                             writingTo: outputUrl))
        
        let resultMp3 = try Mp3File(location: outputUrl)
        let result = try Tag(readFrom: resultMp3)
        XCTAssertEqual(result.time?.hour, 9)
        XCTAssertEqual(result.time?.minute, 23)
      }
    }
    
    // test TIME frame works in version 2.3, when writing expected input to file without metadata, as individual components
    func testTIMEExpectedInputv23BlankAsComponents() throws {
      if #available(macOS 10.12, *) {
        var tag = try TestFile.noMeta.tag()
        tag?.time?.hour = 9
        tag?.time?.minute = 23
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        let outputMp3 = try Mp3File(location: TestFile.noMeta.url)
        XCTAssertNoThrow(try outputMp3.write(tagVersion: .v2_3,
                                             using: tag ?? Tag(readFrom: Mp3File(location: TestFile.noMeta.url)),
                                             writingTo: outputUrl))
        
        let resultMp3 = try Mp3File(location: outputUrl)
        let result = try Tag(readFrom: resultMp3)
        XCTAssertEqual(result.time?.hour, 9)
        XCTAssertEqual(result.time?.minute, 23)
      }
    }
    
    // test TIME frame works in version 2.3, when writing expected input to file without metadata, as tuple
    func testTIMEExpectedInputv23BlankAsTuple() throws {
      if #available(macOS 10.12, *) {
        var tag = try TestFile.noMeta.tag()
        tag?.time = (hour: 9, minute: 23)
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        let outputMp3 = try TestFile.noMeta.mp3File()
        XCTAssertNoThrow(try outputMp3?.write(tagVersion: .v2_3,
                                             using: tag ?? Tag(readFrom: Mp3File(location: TestFile.noMeta.url)),
                                             writingTo: outputUrl))
        
        let resultMp3 = try Mp3File(location: outputUrl)
        let result = try Tag(readFrom: resultMp3)
        XCTAssertEqual(result.time?.hour, 9)
        XCTAssertEqual(result.time?.minute, 23)
      }
    }
    
    // test TIME frame works in version 2.3, when writing expected input to file with metadata, as individual components
    func testTIMEExpectedInputv23OverwriteAsComponents() throws {
      if #available(macOS 10.12, *) {
        var tag = try TestFile.v23.tag()
        tag?.time?.hour = 9
        tag?.time?.minute = 23
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        let outputMp3 = try TestFile.v23.mp3File()
        XCTAssertNoThrow(try outputMp3?.write(tagVersion: .v2_3,
                                             using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v23.url)),
                                             writingTo: outputUrl))
        
        let resultMp3 = try Mp3File(location: outputUrl)
        let result = try Tag(readFrom: resultMp3)
        XCTAssertEqual(result.time?.hour, 9)
        XCTAssertEqual(result.time?.minute, 23)
      }
    }
    
    // test TIME frame works in version 2.3, when writing expected input to file with metadata, as tuple
    func testTIMEExpectedInputv23OverwriteAsTuple() throws {
      if #available(macOS 10.12, *) {
        var tag = try TestFile.v23.tag()
        tag?.time = (hour: 9, minute: 23)
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        let outputMp3 = try TestFile.v23.mp3File()
        XCTAssertNoThrow(try outputMp3?.write(tagVersion: .v2_3,
                                             using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v23.url)),
                                             writingTo: outputUrl))
        
        let resultMp3 = try Mp3File(location: outputUrl)
        let result = try Tag(readFrom: resultMp3)
        XCTAssertEqual(result.time?.hour, 9)
        XCTAssertEqual(result.time?.minute, 23)
      }
    }
    
    // test TIME frame will throw error when attempting to use with version 2.4
    func testTIMEVersionErrorv24Overwrite() throws {
      if #available(macOS 10.12, *) {
        var tag = try TestFile.v24.tag()
        tag?.time?.hour = 11
        tag?.time?.minute = 23
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        let outputMp3 = try TestFile.v24.mp3File()
        XCTAssertThrowsError(try outputMp3?.write(tagVersion: .v2_4,
                                                 using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v24.url)),
                                                 writingTo: outputUrl))
      }
    }
    
    // // MARK: - Year frame tests
    // test YEAR frame works in version 2.2, when writing expected input to file without metadata
    func testTYEExpectedInputv22Blank() throws {
      if #available(macOS 10.12, *) {
        var tag = try TestFile.noMeta.tag()
        tag?.year = 2005
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        let outputMp3 = try TestFile.noMeta.mp3File()
        XCTAssertNoThrow(try outputMp3?.write(tagVersion: .v2_2,
                                             using: tag ?? Tag(readFrom: Mp3File(location: TestFile.noMeta.url)),
                                             writingTo: outputUrl))
        
        let resultMp3 = try Mp3File(location: outputUrl)
        let result = try Tag(readFrom: resultMp3)
        XCTAssertEqual(result.year, 2005)
      }
    }
    
    // test YEAR frame works in version 2.2, when writing expected input to file with metadata
    func testTYEExpectedInputv22Overwrite() throws {
      if #available(macOS 10.12, *) {
        var tag = try TestFile.v22.tag()
        tag?.year = 2005
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        let outputMp3 = try TestFile.v22.mp3File()
        XCTAssertNoThrow(try outputMp3?.write(tagVersion: .v2_2,
                                             using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v22.url)),
                                             writingTo: outputUrl))
        
        let resultMp3 = try Mp3File(location: outputUrl)
        let result = try Tag(readFrom: resultMp3)
        XCTAssertEqual(result.year, 2005)
      }
    }
    
    // test YEAR frame works in version 2.3, when writing expected input to file without metadata
    func testTYERExpectedInputv23Blank() throws {
      if #available(macOS 10.12, *) {
        var tag = try TestFile.noMeta.tag()
        tag?.year = 2005
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        let outputMp3 = try TestFile.noMeta.mp3File()
        XCTAssertNoThrow(try outputMp3?.write(tagVersion: .v2_3,
                                             using: tag ?? Tag(readFrom: Mp3File(location: TestFile.noMeta.url)),
                                             writingTo: outputUrl))
        
        let resultMp3 = try Mp3File(location: outputUrl)
        let result = try Tag(readFrom: resultMp3)
        XCTAssertEqual(result.year, 2005)
      }
    }
    
    // test YEAR frame works in version 2.3, when writing expected input to file with metadata
    func testTYERExpectedInputv23Overwrite() throws {
      if #available(macOS 10.12, *) {
        var tag = try TestFile.v23.tag()
        tag?.year = 2005
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        let outputMp3 = try TestFile.v23.mp3File()
        XCTAssertNoThrow(try outputMp3?.write(tagVersion: .v2_3,
                                             using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v23.url)),
                                             writingTo: outputUrl))
        
        let resultMp3 = try Mp3File(location: outputUrl)
        let result = try Tag(readFrom: resultMp3)
        XCTAssertEqual(result.year, 2005)
      }
    }
    
    // test YEAR frame will throw error when attempting to use with version 2.4
    func testTYERVersionErrorv24Overwrite() throws {
      if #available(macOS 10.12, *) {
        var tag = try TestFile.v24.tag()
        tag?.year = 2005
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        let outputMp3 = try TestFile.v24.mp3File()
        XCTAssertThrowsError(try outputMp3?.write(tagVersion: .v2_4,
                                                 using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v24.url)),
                                                 writingTo: outputUrl))
      }
    }
}
