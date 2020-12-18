/*

 SwiftTaggerID3_CreditsListFrame_Tests.swift
 SwiftTaggerID3

 Copyright ©2020 Nolaine Crusher. All rights reserved.

 */

import XCTest
@testable import SwiftTaggerID3

@available(OSX 11.0, iOS 14.0, *)
class SwiftTaggerID3_CreditsListFrame_Tests: XCTestCase {
    
    func testCreditsListFrameReadingv24() throws {
        let tag = tagV24

        XCTAssertEqual(tag.musicianCreditsList[.soprano], sopranoCredit)
        XCTAssertEqual(tag.musicianCreditsList[.alto], altoCredit)
    }

    func testCreditsListFrameWritingv24() throws {
        var tag = tagV24

        tag.addMusicianCredit(role: .soprano, person: "Soprano Name")
        tag.addMusicianCredit(role: .alto, person: "Alto Name")

        let outputUrl = tempOutputDirectory
        XCTAssertNoThrow(try mp3V24.write(tag: &tag, version: .v2_4, outputLocation: outputUrl))
        
        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try outputMp3.tag()

        XCTAssertEqual(output.musicianCreditsList[.soprano], sopranoCredit)
        XCTAssertEqual(output.musicianCreditsList[.alto], altoCredit)
    }

    func testCreditsListFrameRemovalv24() throws {
        var tag = tagV24

        tag.clearMusicianCreditList()
        tag.clearInvolvementCreditList()

        let outputUrl = tempOutputDirectory
        XCTAssertNoThrow(try mp3V24.write(tag: &tag, version: .v2_4, outputLocation: outputUrl))

        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try outputMp3.tag()

        XCTAssertTrue(output.musicianCreditsList.isEmpty)
        XCTAssertTrue(output.involvementCreditsList.isEmpty)
    }

    func testCreditsListFrameRemovalv23() throws {
        var tag = tagV23
        
        tag.clearInvolvementCreditList()
        
        let outputUrl = tempOutputDirectory
        XCTAssertNoThrow(try mp3V23.write(tag: &tag, version: .v2_3, outputLocation: outputUrl))

        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try outputMp3.tag()
        
        XCTAssertTrue(output.involvementCreditsList.isEmpty)
    }

    func testCreditsListFrameRemovalv22() throws {
        var tag = tagV22

        tag.clearInvolvementCreditList()
        
        let outputUrl = tempOutputDirectory
        XCTAssertNoThrow(try mp3V22.write(tag: &tag, version: .v2_2, outputLocation: outputUrl))

        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try outputMp3.tag()
        
        XCTAssertTrue(output.involvementCreditsList.isEmpty)
    }

    func testCreditsListSingleItemRemovalv24() throws {
        var tag = tagV24

        tag.removeMusicianCredit(role: .soprano)
        
        let outputUrl = tempOutputDirectory
        XCTAssertNoThrow(try mp3V24.write(tag: &tag, version: .v2_4, outputLocation: outputUrl))

        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try outputMp3.tag()
        
        XCTAssertNil(output.musicianCreditsList[.soprano])
        XCTAssertEqual(output.musicianCreditsList[.alto], altoCredit)
    }
    
    func testCreditsListDuplicateCatchingv24() throws {
        var tag = tagV24

        tag.addMusicianCredit(role: .soprano, person: "Soprano Name")
        tag.addMusicianCredit(role: .alto, person: "New Alto Name")
        
        let outputUrl = tempOutputDirectory
        XCTAssertNoThrow(try mp3V24.write(tag: &tag, version: .v2_4, outputLocation: outputUrl))

        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try outputMp3.tag()
        
        XCTAssertEqual(output.musicianCreditsList[.soprano], sopranoCredit)
        XCTAssertEqual(output.musicianCreditsList[.alto], ["Alto Name", "New Alto Name"])
    }
    
    func testMusicianCreditV23() throws {
        var tag = tagV24

        tag.addMusicianCredit(role: .soprano, person: "Soprano Name")
        tag.addMusicianCredit(role: .alto, person: "Alto Name")
        
        let outputUrl = tempOutputDirectory
        XCTAssertNoThrow(try mp3V24.write(tag: &tag, version: .v2_4, outputLocation: outputUrl))

        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try outputMp3.tag()
        
        XCTAssertEqual(output.musicianCreditsList[.soprano], sopranoCredit)
        XCTAssertEqual(output.musicianCreditsList[.alto], altoCredit)
    }
}
