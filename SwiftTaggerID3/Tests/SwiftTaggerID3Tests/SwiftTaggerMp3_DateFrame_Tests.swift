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
    
    // MARK: EncodingTime frame tests
    func testTDENv24ExpectedInputBlankFileAsComponents() throws {
        var tag = try Bundle.tagNoMeta()
        tag.encodingDateTime?.year = 2002
        tag.encodingDateTime?.month = 11
        tag.encodingDateTime?.day = 7
        tag.encodingDateTime?.hour = 9
        tag.encodingDateTime?.minute = 23
        
        let outputUrl = try Bundle.createTempFile(fileNameWithExtension: "testFile.mp3")
        let outputMp3 = try Bundle.mp3NoMeta()
        XCTAssertNoThrow(try outputMp3.write(tagVersion: .v2_4,
                            using: tag,
                            writingTo: outputUrl))

        let resultMp3 = try Mp3File(location: outputUrl)
        let result = try Tag(readFrom: resultMp3)
        XCTAssertEqual(result.encodingDateTime?.year, 2002)
        XCTAssertEqual(result.encodingDateTime?.month, 11)
        XCTAssertEqual(result.encodingDateTime?.day, 7)
        XCTAssertEqual(result.encodingDateTime?.hour, 9)
        XCTAssertEqual(result.encodingDateTime?.minute, 23)
    }

    func testTDENv24ExpectedInputOverwriteFileAsComponents() throws {
        var tag = try Bundle.tagV24()
        tag.encodingDateTime?.year = 2003
        tag.encodingDateTime?.month = 12
        tag.encodingDateTime?.day = 8
        tag.encodingDateTime?.hour = 10
        tag.encodingDateTime?.minute = 24
        
        let outputUrl = try Bundle.createTempFile(fileNameWithExtension: "testFile.mp3")
        let outputMp3 = try Bundle.mp3v24()
        XCTAssertNoThrow(try outputMp3.write(tagVersion: .v2_4,
                                             using: tag,
                                             writingTo: outputUrl))
        
        let resultMp3 = try Mp3File(location: outputUrl)
        let result = try Tag(readFrom: resultMp3)
        XCTAssertEqual(result.encodingDateTime?.year, 2003)
        XCTAssertEqual(result.encodingDateTime?.month, 12)
        XCTAssertEqual(result.encodingDateTime?.day, 8)
        XCTAssertEqual(result.encodingDateTime?.hour, 10)
        XCTAssertEqual(result.encodingDateTime?.minute, 24)
    }

    func testTDENv24ExpectedInputBlankFileAsTuple() throws {
        var tag = try Bundle.tagNoMeta()
        tag.encodingDateTime = (year: 2004, month: 01, day: 09, hour: 11, minute: 25)
        
        let outputUrl = try Bundle.createTempFile(fileNameWithExtension: "testFile.mp3")
        let outputMp3 = try Bundle.mp3NoMeta()
        XCTAssertNoThrow(try outputMp3.write(tagVersion: .v2_4,
                                             using: tag,
                                             writingTo: outputUrl))
        
        let resultMp3 = try Mp3File(location: outputUrl)
        let result = try Tag(readFrom: resultMp3)
        XCTAssertEqual(result.encodingDateTime?.year, 2004)
        XCTAssertEqual(result.encodingDateTime?.month, 01)
        XCTAssertEqual(result.encodingDateTime?.day, 09)
        XCTAssertEqual(result.encodingDateTime?.hour, 11)
        XCTAssertEqual(result.encodingDateTime?.minute, 25)
    }
    
    func testTDENv24ExpectedInputOverwriteFileAsTuple() throws {
        var tag = try Bundle.tagV24()
        tag.encodingDateTime = (year: 2005, month: 02, day: 10, hour: 12, minute: 26)

        let outputUrl = try Bundle.createTempFile(fileNameWithExtension: "testFile.mp3")
        let outputMp3 = try Bundle.mp3v24()
        XCTAssertNoThrow(try outputMp3.write(tagVersion: .v2_4,
                                             using: tag,
                                             writingTo: outputUrl))
        
        let resultMp3 = try Mp3File(location: outputUrl)
        let result = try Tag(readFrom: resultMp3)
        XCTAssertEqual(result.encodingDateTime?.year, 2005)
        XCTAssertEqual(result.encodingDateTime?.month, 02)
        XCTAssertEqual(result.encodingDateTime?.day, 10)
        XCTAssertEqual(result.encodingDateTime?.hour, 12)
        XCTAssertEqual(result.encodingDateTime?.minute, 26)
    }
    
    func testTDENVersionErrorv22Overwrite() throws {
        var tag = try Bundle.tagV22()
        tag.encodingDateTime?.year = 2002
        tag.encodingDateTime?.month = 11
        tag.encodingDateTime?.day = 7
        tag.encodingDateTime?.hour = 9
        tag.encodingDateTime?.minute = 23
        
        let outputUrl = try Bundle.createTempFile(fileNameWithExtension: "testFile.mp3")
        let outputMp3 = try Bundle.mp3v22()
        XCTAssertThrowsError(try outputMp3.write(tagVersion: .v2_2,
                                             using: tag,
                                             writingTo: outputUrl))
    }

    func testTDENVersionErrorv23Overwrite() throws {
        var tag = try Bundle.tagV23()
        tag.encodingDateTime?.year = 2002
        tag.encodingDateTime?.month = 11
        tag.encodingDateTime?.day = 7
        tag.encodingDateTime?.hour = 9
        tag.encodingDateTime?.minute = 23
        
        let outputUrl = try Bundle.createTempFile(fileNameWithExtension: "testFile.mp3")
        let outputMp3 = try Bundle.mp3v23()
        XCTAssertThrowsError(try outputMp3.write(tagVersion: .v2_3,
                                                 using: tag,
                                                 writingTo: outputUrl))
    }

    func testTDENVersionErrorv22Blank() throws {
        var tag = try Bundle.tagNoMeta()
        tag.encodingDateTime?.year = 2002
        tag.encodingDateTime?.month = 11
        tag.encodingDateTime?.day = 7
        tag.encodingDateTime?.hour = 9
        tag.encodingDateTime?.minute = 23
        
        let outputUrl = try Bundle.createTempFile(fileNameWithExtension: "testFile.mp3")
        let outputMp3 = try Bundle.mp3NoMeta()
        XCTAssertThrowsError(try outputMp3.write(tagVersion: .v2_2,
                                                 using: tag,
                                                 writingTo: outputUrl))
    }
    
    func testTDENVersionErrorv23Blank() throws {
        var tag = try Bundle.tagNoMeta()
        tag.encodingDateTime?.year = 2002
        tag.encodingDateTime?.month = 11
        tag.encodingDateTime?.day = 7
        tag.encodingDateTime?.hour = 9
        tag.encodingDateTime?.minute = 23
        
        let outputUrl = try Bundle.createTempFile(fileNameWithExtension: "testFile.mp3")
        let outputMp3 = try Bundle.mp3NoMeta()
        XCTAssertThrowsError(try outputMp3.write(tagVersion: .v2_3,
                                                 using: tag,
                                                 writingTo: outputUrl))
    }
    
    // MARK: TaggingTime frame tests
    func testTDTGv24ExpectedInputBlankFileAsComponents() throws {
        var tag = try Bundle.tagNoMeta()
        tag.taggingDateTime?.year = 2002
        tag.taggingDateTime?.month = 11
        tag.taggingDateTime?.day = 7
        tag.taggingDateTime?.hour = 9
        tag.taggingDateTime?.minute = 23
        
        let outputUrl = try Bundle.createTempFile(fileNameWithExtension: "testFile.mp3")
        let outputMp3 = try Bundle.mp3NoMeta()
        XCTAssertNoThrow(try outputMp3.write(tagVersion: .v2_4,
                                             using: tag,
                                             writingTo: outputUrl))
        
        let resultMp3 = try Mp3File(location: outputUrl)
        let result = try Tag(readFrom: resultMp3)
        XCTAssertEqual(result.taggingDateTime?.year, 2002)
        XCTAssertEqual(result.taggingDateTime?.month, 11)
        XCTAssertEqual(result.taggingDateTime?.day, 7)
        XCTAssertEqual(result.taggingDateTime?.hour, 9)
        XCTAssertEqual(result.taggingDateTime?.minute, 23)
    }
    
    func testTDTGv24ExpectedInputOverwriteFileAsComponents() throws {
        var tag = try Bundle.tagV24()
        tag.taggingDateTime?.year = 2003
        tag.taggingDateTime?.month = 12
        tag.taggingDateTime?.day = 8
        tag.taggingDateTime?.hour = 10
        tag.taggingDateTime?.minute = 24
        
        let outputUrl = try Bundle.createTempFile(fileNameWithExtension: "testFile.mp3")
        let outputMp3 = try Bundle.mp3v24()
        XCTAssertNoThrow(try outputMp3.write(tagVersion: .v2_4,
                                             using: tag,
                                             writingTo: outputUrl))
        
        let resultMp3 = try Mp3File(location: outputUrl)
        let result = try Tag(readFrom: resultMp3)
        XCTAssertEqual(result.taggingDateTime?.year, 2003)
        XCTAssertEqual(result.taggingDateTime?.month, 12)
        XCTAssertEqual(result.taggingDateTime?.day, 8)
        XCTAssertEqual(result.taggingDateTime?.hour, 10)
        XCTAssertEqual(result.taggingDateTime?.minute, 24)
    }
    
    func testTDTGv24ExpectedInputBlankFileAsTuple() throws {
        var tag = try Bundle.tagNoMeta()
        tag.taggingDateTime = (year: 2004, month: 01, day: 09, hour: 11, minute: 25)
        
        let outputUrl = try Bundle.createTempFile(fileNameWithExtension: "testFile.mp3")
        let outputMp3 = try Bundle.mp3NoMeta()
        XCTAssertNoThrow(try outputMp3.write(tagVersion: .v2_4,
                                             using: tag,
                                             writingTo: outputUrl))
        
        let resultMp3 = try Mp3File(location: outputUrl)
        let result = try Tag(readFrom: resultMp3)
        XCTAssertEqual(result.taggingDateTime?.year, 2004)
        XCTAssertEqual(result.taggingDateTime?.month, 01)
        XCTAssertEqual(result.taggingDateTime?.day, 09)
        XCTAssertEqual(result.taggingDateTime?.hour, 11)
        XCTAssertEqual(result.taggingDateTime?.minute, 25)
    }
    
    func testTDTGv24ExpectedInputOverwriteFileAsTuple() throws {
        var tag = try Bundle.tagV24()
        tag.taggingDateTime = (year: 2005, month: 02, day: 10, hour: 12, minute: 26)
        
        let outputUrl = try Bundle.createTempFile(fileNameWithExtension: "testFile.mp3")
        let outputMp3 = try Bundle.mp3v24()
        XCTAssertNoThrow(try outputMp3.write(tagVersion: .v2_4,
                                             using: tag,
                                             writingTo: outputUrl))
        
        let resultMp3 = try Mp3File(location: outputUrl)
        let result = try Tag(readFrom: resultMp3)
        XCTAssertEqual(result.taggingDateTime?.year, 2005)
        XCTAssertEqual(result.taggingDateTime?.month, 02)
        XCTAssertEqual(result.taggingDateTime?.day, 10)
        XCTAssertEqual(result.taggingDateTime?.hour, 12)
        XCTAssertEqual(result.taggingDateTime?.minute, 26)
    }
    
    func testTDTGVersionErrorv22Overwrite() throws {
        var tag = try Bundle.tagV22()
        tag.taggingDateTime?.year = 2002
        tag.taggingDateTime?.month = 11
        tag.taggingDateTime?.day = 7
        tag.taggingDateTime?.hour = 9
        tag.taggingDateTime?.minute = 23
        
        let outputUrl = try Bundle.createTempFile(fileNameWithExtension: "testFile.mp3")
        let outputMp3 = try Bundle.mp3v22()
        XCTAssertThrowsError(try outputMp3.write(tagVersion: .v2_2,
                                                 using: tag,
                                                 writingTo: outputUrl))
    }
    
    func testTDTGVersionErrorv23Overwrite() throws {
        var tag = try Bundle.tagV23()
        tag.taggingDateTime?.year = 2002
        tag.taggingDateTime?.month = 11
        tag.taggingDateTime?.day = 7
        tag.taggingDateTime?.hour = 9
        tag.taggingDateTime?.minute = 23
        
        let outputUrl = try Bundle.createTempFile(fileNameWithExtension: "testFile.mp3")
        let outputMp3 = try Bundle.mp3v23()
        XCTAssertThrowsError(try outputMp3.write(tagVersion: .v2_3,
                                                 using: tag,
                                                 writingTo: outputUrl))
    }
    
    func testTDTGVersionErrorv22Blank() throws {
        var tag = try Bundle.tagNoMeta()
        tag.taggingDateTime?.year = 2002
        tag.taggingDateTime?.month = 11
        tag.taggingDateTime?.day = 7
        tag.taggingDateTime?.hour = 9
        tag.taggingDateTime?.minute = 23
        
        let outputUrl = try Bundle.createTempFile(fileNameWithExtension: "testFile.mp3")
        let outputMp3 = try Bundle.mp3NoMeta()
        XCTAssertThrowsError(try outputMp3.write(tagVersion: .v2_2,
                                                 using: tag,
                                                 writingTo: outputUrl))
    }
    
    func testTDTGVersionErrorv23Blank() throws {
        var tag = try Bundle.tagNoMeta()
        tag.taggingDateTime?.year = 2002
        tag.taggingDateTime?.month = 11
        tag.taggingDateTime?.day = 7
        tag.taggingDateTime?.hour = 9
        tag.taggingDateTime?.minute = 23
        
        let outputUrl = try Bundle.createTempFile(fileNameWithExtension: "testFile.mp3")
        let outputMp3 = try Bundle.mp3NoMeta()
        XCTAssertThrowsError(try outputMp3.write(tagVersion: .v2_3,
                                                 using: tag,
                                                 writingTo: outputUrl))
    }
    
    // MARK: ReleaseTime frame tests
    func testTDRLv24ExpectedInputBlankFileAsComponents() throws {
        var tag = try Bundle.tagNoMeta()
        tag.releaseDateTime?.year = 2002
        tag.releaseDateTime?.month = 11
        tag.releaseDateTime?.day = 7
        tag.releaseDateTime?.hour = 9
        tag.releaseDateTime?.minute = 23
        
        let outputUrl = try Bundle.createTempFile(fileNameWithExtension: "testFile.mp3")
        let outputMp3 = try Bundle.mp3NoMeta()
        XCTAssertNoThrow(try outputMp3.write(tagVersion: .v2_4,
                                             using: tag,
                                             writingTo: outputUrl))
        
        let resultMp3 = try Mp3File(location: outputUrl)
        let result = try Tag(readFrom: resultMp3)
        XCTAssertEqual(result.releaseDateTime?.year, 2002)
        XCTAssertEqual(result.releaseDateTime?.month, 11)
        XCTAssertEqual(result.releaseDateTime?.day, 7)
        XCTAssertEqual(result.releaseDateTime?.hour, 9)
        XCTAssertEqual(result.releaseDateTime?.minute, 23)
    }
    
    func testTDRLv24ExpectedInputOverwriteFileAsComponents() throws {
        var tag = try Bundle.tagV24()
        tag.releaseDateTime?.year = 2003
        tag.releaseDateTime?.month = 12
        tag.releaseDateTime?.day = 8
        tag.releaseDateTime?.hour = 10
        tag.releaseDateTime?.minute = 24
        
        let outputUrl = try Bundle.createTempFile(fileNameWithExtension: "testFile.mp3")
        let outputMp3 = try Bundle.mp3v24()
        XCTAssertNoThrow(try outputMp3.write(tagVersion: .v2_4,
                                             using: tag,
                                             writingTo: outputUrl))
        
        let resultMp3 = try Mp3File(location: outputUrl)
        let result = try Tag(readFrom: resultMp3)
        XCTAssertEqual(result.releaseDateTime?.year, 2003)
        XCTAssertEqual(result.releaseDateTime?.month, 12)
        XCTAssertEqual(result.releaseDateTime?.day, 8)
        XCTAssertEqual(result.releaseDateTime?.hour, 10)
        XCTAssertEqual(result.releaseDateTime?.minute, 24)
    }
    
    func testTDRLv24ExpectedInputBlankFileAsTuple() throws {
        var tag = try Bundle.tagNoMeta()
        tag.releaseDateTime = (year: 2004, month: 01, day: 09, hour: 11, minute: 25)
        
        let outputUrl = try Bundle.createTempFile(fileNameWithExtension: "testFile.mp3")
        let outputMp3 = try Bundle.mp3NoMeta()
        XCTAssertNoThrow(try outputMp3.write(tagVersion: .v2_4,
                                             using: tag,
                                             writingTo: outputUrl))
        
        let resultMp3 = try Mp3File(location: outputUrl)
        let result = try Tag(readFrom: resultMp3)
        XCTAssertEqual(result.releaseDateTime?.year, 2004)
        XCTAssertEqual(result.releaseDateTime?.month, 01)
        XCTAssertEqual(result.releaseDateTime?.day, 09)
        XCTAssertEqual(result.releaseDateTime?.hour, 11)
        XCTAssertEqual(result.releaseDateTime?.minute, 25)
    }
    
    func testTDRLv24ExpectedInputOverwriteFileAsTuple() throws {
        var tag = try Bundle.tagV24()
        tag.releaseDateTime = (year: 2005, month: 02, day: 10, hour: 12, minute: 26)
        
        let outputUrl = try Bundle.createTempFile(fileNameWithExtension: "testFile.mp3")
        let outputMp3 = try Bundle.mp3v24()
        XCTAssertNoThrow(try outputMp3.write(tagVersion: .v2_4,
                                             using: tag,
                                             writingTo: outputUrl))
        
        let resultMp3 = try Mp3File(location: outputUrl)
        let result = try Tag(readFrom: resultMp3)
        XCTAssertEqual(result.releaseDateTime?.year, 2005)
        XCTAssertEqual(result.releaseDateTime?.month, 02)
        XCTAssertEqual(result.releaseDateTime?.day, 10)
        XCTAssertEqual(result.releaseDateTime?.hour, 12)
        XCTAssertEqual(result.releaseDateTime?.minute, 26)
    }
    
    func testTDRLVersionErrorv22Overwrite() throws {
        var tag = try Bundle.tagV22()
        tag.releaseDateTime?.year = 2002
        tag.releaseDateTime?.month = 11
        tag.releaseDateTime?.day = 7
        tag.releaseDateTime?.hour = 9
        tag.releaseDateTime?.minute = 23
        
        let outputUrl = try Bundle.createTempFile(fileNameWithExtension: "testFile.mp3")
        let outputMp3 = try Bundle.mp3v22()
        XCTAssertThrowsError(try outputMp3.write(tagVersion: .v2_2,
                                                 using: tag,
                                                 writingTo: outputUrl))
    }
    
    func testTDRLVersionErrorv23Overwrite() throws {
        var tag = try Bundle.tagV23()
        tag.releaseDateTime?.year = 2002
        tag.releaseDateTime?.month = 11
        tag.releaseDateTime?.day = 7
        tag.releaseDateTime?.hour = 9
        tag.releaseDateTime?.minute = 23
        
        let outputUrl = try Bundle.createTempFile(fileNameWithExtension: "testFile.mp3")
        let outputMp3 = try Bundle.mp3v23()
        XCTAssertThrowsError(try outputMp3.write(tagVersion: .v2_3,
                                                 using: tag,
                                                 writingTo: outputUrl))
    }
    
    func testTDRLVersionErrorv22Blank() throws {
        var tag = try Bundle.tagNoMeta()
        tag.releaseDateTime?.year = 2002
        tag.releaseDateTime?.month = 11
        tag.releaseDateTime?.day = 7
        tag.releaseDateTime?.hour = 9
        tag.releaseDateTime?.minute = 23
        
        let outputUrl = try Bundle.createTempFile(fileNameWithExtension: "testFile.mp3")
        let outputMp3 = Bundle.mp3NoMeta
        XCTAssertThrowsError(try outputMp3().write(tagVersion: .v2_2,
                                                 using: tag,
                                                 writingTo: outputUrl))
    }
    
    func testTDRLVersionErrorv23Blank() throws {
        var tag = try Bundle.tagNoMeta()
        tag.releaseDateTime?.year = 2002
        tag.releaseDateTime?.month = 11
        tag.releaseDateTime?.day = 7
        tag.releaseDateTime?.hour = 9
        tag.releaseDateTime?.minute = 23
        
        let outputUrl = try Bundle.createTempFile(fileNameWithExtension: "testFile.mp3")
        let outputMp3 = try Bundle.mp3NoMeta()
        XCTAssertThrowsError(try outputMp3.write(tagVersion: .v2_3,
                                                 using: tag,
                                                 writingTo: outputUrl))
    }
    
    // MARK: Date frame tests
    func testTDAExpectedInputv22BlankAsComponents() throws {
        var tag = try Bundle.tagNoMeta()
        tag.date?.month = 11
        tag.date?.day = 7
        
        let outputUrl = try Bundle.createTempFile(fileNameWithExtension: "testFile.mp3")
        let outputMp3 = try Mp3File(location: Bundle.noMeta)
        XCTAssertNoThrow(try outputMp3.write(tagVersion: .v2_2,
                                             using: tag,
                                             writingTo: outputUrl))
        
        let resultMp3 = try Mp3File(location: outputUrl)
        let result = try Tag(readFrom: resultMp3)
        XCTAssertEqual(result.date?.month, 11)
        XCTAssertEqual(result.date?.day, 7)
    }

    func testTDAExpectedInputv22BlankAsTuple() throws {
        var tag = try Bundle.tagNoMeta()
        tag.date = (day: 7, month: 11)
        
        let outputUrl = try Bundle.createTempFile(fileNameWithExtension: "testFile.mp3")
        let outputMp3 = try Bundle.mp3NoMeta()
        XCTAssertNoThrow(try outputMp3.write(tagVersion: .v2_2,
                                             using: tag,
                                             writingTo: outputUrl))
        
        let resultMp3 = try Mp3File(location: outputUrl)
        let result = try Tag(readFrom: resultMp3)
        XCTAssertEqual(result.date?.month, 11)
        XCTAssertEqual(result.date?.day, 7)
    }

    func testTDAExpectedInputv22OverwriteAsComponents() throws {
        var tag = try Bundle.tagV22()
        tag.date?.month = 11
        tag.date?.day = 7
        
        let outputUrl = try Bundle.createTempFile(fileNameWithExtension: "testFile.mp3")
        let outputMp3 = try Bundle.mp3v22()
        XCTAssertNoThrow(try outputMp3.write(tagVersion: .v2_2,
                                             using: tag,
                                             writingTo: outputUrl))
        
        let resultMp3 = try Mp3File(location: outputUrl)
        let result = try Tag(readFrom: resultMp3)
        XCTAssertEqual(result.date?.month, 11)
        XCTAssertEqual(result.date?.day, 7)
    }
    
    func testTDAExpectedInputv22OverwriteAsTuple() throws {
        var tag = try Bundle.tagV22()
        tag.date = (day: 7, month: 11)
        
        let outputUrl = try Bundle.createTempFile(fileNameWithExtension: "testFile.mp3")
        let outputMp3 = try Bundle.mp3v22()
        XCTAssertNoThrow(try outputMp3.write(tagVersion: .v2_2,
                                             using: tag,
                                             writingTo: outputUrl))
        
        let resultMp3 = try Mp3File(location: outputUrl)
        let result = try Tag(readFrom: resultMp3)
        XCTAssertEqual(result.date?.month, 11)
        XCTAssertEqual(result.date?.day, 7)
    }

    func testTDAExpectedInputv23BlankAsComponents() throws {
        var tag = try Bundle.tagNoMeta()
        tag.date?.month = 11
        tag.date?.day = 7
        
        let outputUrl = try Bundle.createTempFile(fileNameWithExtension: "testFile.mp3")
        let outputMp3 = try Mp3File(location: Bundle.noMeta)
        XCTAssertNoThrow(try outputMp3.write(tagVersion: .v2_3,
                                             using: tag,
                                             writingTo: outputUrl))
        
        let resultMp3 = try Mp3File(location: outputUrl)
        let result = try Tag(readFrom: resultMp3)
        XCTAssertEqual(result.date?.month, 11)
        XCTAssertEqual(result.date?.day, 7)
    }
    
    func testTDAExpectedInputv23BlankAsTuple() throws {
        var tag = try Bundle.tagNoMeta()
        tag.date = (day: 7, month: 11)
        
        let outputUrl = try Bundle.createTempFile(fileNameWithExtension: "testFile.mp3")
        let outputMp3 = try Bundle.mp3NoMeta()
        XCTAssertNoThrow(try outputMp3.write(tagVersion: .v2_3,
                                             using: tag,
                                             writingTo: outputUrl))
        
        let resultMp3 = try Mp3File(location: outputUrl)
        let result = try Tag(readFrom: resultMp3)
        XCTAssertEqual(result.date?.month, 11)
        XCTAssertEqual(result.date?.day, 7)
    }
    
    func testTDAExpectedInputv23OverwriteAsComponents() throws {
        var tag = try Bundle.tagV23()
        tag.date?.month = 11
        tag.date?.day = 7
        
        let outputUrl = try Bundle.createTempFile(fileNameWithExtension: "testFile.mp3")
        let outputMp3 = try Bundle.mp3v23()
        XCTAssertNoThrow(try outputMp3.write(tagVersion: .v2_3,
                                             using: tag,
                                             writingTo: outputUrl))
        
        let resultMp3 = try Mp3File(location: outputUrl)
        let result = try Tag(readFrom: resultMp3)
        XCTAssertEqual(result.date?.month, 11)
        XCTAssertEqual(result.date?.day, 7)
    }
    
    func testTDAExpectedInputv23OverwriteAsTuple() throws {
        var tag = try Bundle.tagV23()
        tag.date = (day: 7, month: 11)
        
        let outputUrl = try Bundle.createTempFile(fileNameWithExtension: "testFile.mp3")
        let outputMp3 = try Bundle.mp3v23()
        XCTAssertNoThrow(try outputMp3.write(tagVersion: .v2_3,
                                             using: tag,
                                             writingTo: outputUrl))
        
        let resultMp3 = try Mp3File(location: outputUrl)
        let result = try Tag(readFrom: resultMp3)
        XCTAssertEqual(result.date?.month, 11)
        XCTAssertEqual(result.date?.day, 7)
    }
    
    func testTDRLVersionErrorv24OverwriteAsComponents() throws {
        var tag = try Bundle.tagV24()
        tag.date?.month = 11
        tag.date?.day = 7
        
        let outputUrl = try Bundle.createTempFile(fileNameWithExtension: "testFile.mp3")
        let outputMp3 = try Bundle.mp3v24()
        XCTAssertThrowsError(try outputMp3.write(tagVersion: .v2_4,
                                             using: tag,
                                             writingTo: outputUrl))
    }

}
