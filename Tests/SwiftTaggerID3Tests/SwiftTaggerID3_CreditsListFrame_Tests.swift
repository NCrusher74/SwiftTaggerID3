///*
//
// SwiftTaggerID3_CreditsListFrame_Tests.swift
// SwiftTaggerID3
//
// Copyright ©2020 Nolaine Crusher. All rights reserved.
//
// */
//
//import XCTest
//import SwiftTaggerID3
//
//class SwiftTaggerID3_CreditsListFrame_Tests: XCTestCase {
//
//    @available(OSX 10.12, *)
//    func testCreditsListFrameReadingv24() throws {
//        let tag = try TestFile.v24.tag()
//
//        XCTAssertEqual(tag?.performanceCreditsList[.soprano], ["Soprano Name"])
//        XCTAssertEqual(tag?.performanceCreditsList[.alto], ["Alto Name"])
//    }
//
//
//    @available(OSX 10.12, *)
//    func testCreditsListFrameWritingv24() throws {
//        var tag = try TestFile.noMeta.tag()
//
//        tag?.addPerformanceCredit(role: .soprano, person: "Soprano Name")
//        tag?.addPerformanceCredit(role: .alto, person: "Alto Name")
//
//        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
//        XCTAssertNoThrow(try TestFile.noMeta.mp3File()?.write(tagVersion: .v2_4, using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v24.url)), writingTo: outputUrl))
//        
//        
//        let mp3UrlWritten = outputUrl
//        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
//        let tagWritten = try Tag(readFrom: mp3FileWritten)
//
//        XCTAssertEqual(tagWritten.performanceCreditsList[.soprano], ["Soprano Name"])
//        XCTAssertEqual(tagWritten.performanceCreditsList[.alto], ["Alto Name"])
//    }
//
//    @available(OSX 10.12, *)
//    func testCreditsListFrameRemovalv24() throws {
//        var tag = try TestFile.v24.tag()
//
//        tag?.clearPerformanceCreditList()
//        tag?.clearInvolvementCreditList()
//
//        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
//        XCTAssertNoThrow(try TestFile.v24.mp3File()?.write(tagVersion: .v2_4, using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v24.url)), writingTo: outputUrl))
//        
//        let mp3UrlWritten = outputUrl
//        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
//        let tagWritten = try Tag(readFrom: mp3FileWritten)
//
//        XCTAssertTrue(tagWritten.performanceCreditsList.isEmpty)
//        XCTAssertTrue(tagWritten.involvementCreditsList.isEmpty)
//    }
//
//    @available(OSX 10.12, *)
//    func testCreditsListFrameRemovalv23() throws {
//        var tag = try TestFile.v23.tag()
//        
//        tag?.clearInvolvementCreditList()
//        
//        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
//        XCTAssertNoThrow(try TestFile.v23.mp3File()?.write(tagVersion: .v2_3, using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v23.url)), writingTo: outputUrl))
//        
//        let mp3UrlWritten = outputUrl
//        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
//        let tagWritten = try Tag(readFrom: mp3FileWritten)
//        
//        XCTAssertTrue(tagWritten.involvementCreditsList.isEmpty)
//    }
//
//    @available(OSX 10.12, *)
//    func testCreditsListFrameRemovalv22() throws {
//        var tag = try TestFile.v22.tag()
//        
//        tag?.clearInvolvementCreditList()
//        
//        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
//        XCTAssertNoThrow(try TestFile.v22.mp3File()?.write(tagVersion: .v2_2, using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v22.url)), writingTo: outputUrl))
//        
//        let mp3UrlWritten = outputUrl
//        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
//        let tagWritten = try Tag(readFrom: mp3FileWritten)
//        
//        XCTAssertTrue(tagWritten.involvementCreditsList.isEmpty)
//    }
//
//    @available(OSX 10.12, *)
//    func testCreditsListSingleItemRemovalv24() throws {
//        var tag = try TestFile.v24.tag()
//        
//        tag?.removePerformanceCredit(role: .soprano)
//        
//        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
//        XCTAssertNoThrow(try TestFile.v24.mp3File()?.write(tagVersion: .v2_4, using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v24.url)), writingTo: outputUrl))
//        
//        let mp3UrlWritten = outputUrl
//        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
//        let tagWritten = try Tag(readFrom: mp3FileWritten)
//        
//        XCTAssertNil(tagWritten.performanceCreditsList[.soprano])
//        XCTAssertEqual(tagWritten.performanceCreditsList[.alto], ["Alto Name"])
//    }
//    
//    @available(OSX 10.12, *)
//    func testCreditsListDuplicateCatchingv24() throws {
//        var tag = try TestFile.v24.tag()
//        
//        tag?.addPerformanceCredit(role: .soprano, person: "Soprano Name")
//        tag?.addPerformanceCredit(role: .alto, person: "New Alto Name")
//        
//        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
//        XCTAssertNoThrow(try TestFile.v24.mp3File()?.write(tagVersion: .v2_4, using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v24.url)), writingTo: outputUrl))
//                
//        let mp3UrlWritten = outputUrl
//        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
//        let tagWritten = try Tag(readFrom: mp3FileWritten)
//        
//        XCTAssertEqual(tagWritten.performanceCreditsList[.soprano], ["Soprano Name"])
//        XCTAssertEqual(tagWritten.performanceCreditsList[.alto], ["Alto Name", "New Alto Name"])
//    }
//    
//    @available(OSX 10.12, *)
//    func testMusicianCreditV23() throws {
//        var tag = try TestFile.v24.tag()
//        
//        tag?.addPerformanceCredit(role: .soprano, person: "Soprano Name")
//        tag?.addPerformanceCredit(role: .alto, person: "Alto Name")
//        
//        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
//        XCTAssertNoThrow(try TestFile.v24.mp3File()?.write(tagVersion: .v2_4, using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v24.url)), writingTo: outputUrl))
//        
//        let mp3UrlWritten = outputUrl
//        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
//        let tagWritten = try Tag(readFrom: mp3FileWritten)
//        
//        XCTAssertEqual(tagWritten.performanceCreditsList[.soprano], ["Soprano Name"])
//        XCTAssertEqual(tagWritten.performanceCreditsList[.alto], ["Alto Name"])
//    }
//}
