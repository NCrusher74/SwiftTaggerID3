/*

 SwiftTaggerID3_CreditsListFrame_Tests.swift
 SwiftTaggerID3

 Copyright ©2020 Nolaine Crusher. All rights reserved.

 */

import XCTest
@testable import SwiftTaggerID3

class SwiftTaggerID3_CreditsListFrame_Tests: XCTestCase {
    
    @available(OSX 10.12, *)
    func testCreditsListFrameReadingv24() throws {
        let tag = tagV24

        XCTAssertEqual(tag.musicianCreditsList[.soprano], sopranoCredit)
        XCTAssertEqual(tag.musicianCreditsList[.alto], altoCredit)
    }

    @available(OSX 10.12, *)
    func testCreditsListFrameWritingv24() throws {
        var tag = tagV24

        tag.addMusicianCredit(role: .soprano, person: "Soprano Name")
        tag.addMusicianCredit(role: .alto, person: "Alto Name")

        let outputUrl = tempOutputDirectory
        XCTAssertNoThrow(try mp3V24.write(tag: tag, outputLocation: outputUrl))
        
        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try outputMp3.tag()

        XCTAssertEqual(output.musicianCreditsList[.soprano], sopranoCredit)
        XCTAssertEqual(output.musicianCreditsList[.alto], altoCredit)
    }

    @available(OSX 10.12, *)
    func testCreditsListFrameRemovalv24() throws {
        var tag = tagV24

        tag.clearMusicianCreditList()
        tag.clearInvolvementCreditList()

        let outputUrl = tempOutputDirectory
        XCTAssertNoThrow(try mp3V24.write(tag: tag, outputLocation: outputUrl))

        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try outputMp3.tag()

        XCTAssertTrue(output.musicianCreditsList.isEmpty)
        XCTAssertTrue(output.involvementCreditsList.isEmpty)
    }

    @available(OSX 10.12, *)
    func testCreditsListFrameRemovalv23() throws {
        var tag = tagV23
        
        tag.clearInvolvementCreditList()
        
        let outputUrl = tempOutputDirectory
        XCTAssertNoThrow(try mp3V23.write(tag: tag, outputLocation: outputUrl))

        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try outputMp3.tag()
        
        XCTAssertTrue(output.involvementCreditsList.isEmpty)
    }

    @available(OSX 10.12, *)
    func testCreditsListFrameRemovalv22() throws {
        var tag = tagV22

        tag.clearInvolvementCreditList()
        
        let outputUrl = tempOutputDirectory
        XCTAssertNoThrow(try mp3V22.write(tag: tag, outputLocation: outputUrl))

        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try outputMp3.tag()
        
        XCTAssertTrue(output.involvementCreditsList.isEmpty)
    }

    @available(OSX 10.12, *)
    func testCreditsListSingleItemRemovalv24() throws {
        var tag = tagV24

        tag.removeMusicianCredit(role: .soprano)
        
        let outputUrl = tempOutputDirectory
        XCTAssertNoThrow(try mp3V24.write(tag: tag, outputLocation: outputUrl))

        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try outputMp3.tag()
        
        XCTAssertNil(output.musicianCreditsList[.soprano])
        XCTAssertEqual(output.musicianCreditsList[.alto], altoCredit)
    }
    
    @available(OSX 10.12, *)
    func testCreditsListDuplicateCatchingv24() throws {
        var tag = tagV24

        tag.addMusicianCredit(role: .soprano, person: "Soprano Name")
        tag.addMusicianCredit(role: .alto, person: "New Alto Name")
        
        let outputUrl = tempOutputDirectory
        XCTAssertNoThrow(try mp3V24.write(tag: tag, outputLocation: outputUrl))

        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try outputMp3.tag()
        
        XCTAssertEqual(output.musicianCreditsList[.soprano], sopranoCredit)
        XCTAssertEqual(output.musicianCreditsList[.alto], ["Alto Name", "New Alto Name"])
    }
    
    @available(OSX 10.12, *)
    func testMusicianCreditV23() throws {
        var tag = tagV24

        tag.addMusicianCredit(role: .soprano, person: "Soprano Name")
        tag.addMusicianCredit(role: .alto, person: "Alto Name")
        
        let outputUrl = tempOutputDirectory
        XCTAssertNoThrow(try mp3V24.write(tag: tag, outputLocation: outputUrl))

        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try outputMp3.tag()
        
        XCTAssertEqual(output.musicianCreditsList[.soprano], sopranoCredit)
        XCTAssertEqual(output.musicianCreditsList[.alto], altoCredit)
    }
}
