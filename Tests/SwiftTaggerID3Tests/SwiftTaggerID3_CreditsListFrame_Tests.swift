/*

 SwiftTaggerID3_CreditsListFrame_Tests.swift
 SwiftTaggerID3

 Copyright ©2020 Nolaine Crusher. All rights reserved.

 */

import XCTest
import SwiftTaggerID3
@testable import SwiftTaggerID3

class SwiftTaggerID3_CreditsListFrame_Tests: XCTestCase {

    @available(OSX 10.12, *)
    func testCreditsListFrameReadingv24() throws {
        let mp3 = try Mp3File(location: sample24Url)
        let tag = try mp3.tag()

        XCTAssertEqual(tag.musicianCreditsList[.soprano], sopranoCredit)
        XCTAssertEqual(tag.musicianCreditsList[.alto], altoCredit)
    }


    @available(OSX 10.12, *)
    func testCreditsListFrameWritingv24() throws {
        let mp3 = try Mp3File(location: sample24Url)
        var tag = try mp3.tag()

        tag.addMusicianCredit(role: .soprano, person: "Soprano Name")
        tag.addMusicianCredit(role: .alto, person: "Alto Name")

        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        XCTAssertNoThrow(try mp3.write(tag: &tag, version: .v2_4, outputLocation: outputUrl))
        
        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try outputMp3.tag()

        XCTAssertEqual(output.musicianCreditsList[.soprano], sopranoCredit)
        XCTAssertEqual(output.musicianCreditsList[.alto], altoCredit)
    }

    @available(OSX 10.12, *)
    func testCreditsListFrameRemovalv24() throws {
        let mp3 = try Mp3File(location: sample24Url)
        var tag = try mp3.tag()


        tag.clearMusicianCreditList()
        tag.clearInvolvementCreditList()

        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        XCTAssertNoThrow(try mp3.write(tag: &tag, version: .v2_4, outputLocation: outputUrl))

        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try outputMp3.tag()

        XCTAssertTrue(output.musicianCreditsList.isEmpty)
        XCTAssertTrue(output.involvementCreditsList.isEmpty)
    }

    @available(OSX 10.12, *)
    func testCreditsListFrameRemovalv23() throws {
        let mp3 = try Mp3File(location: sample23Url)
        var tag = try mp3.tag()

        
        tag.clearInvolvementCreditList()
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        XCTAssertNoThrow(try mp3.write(tag: &tag, version: .v2_3, outputLocation: outputUrl))

        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try outputMp3.tag()
        
        XCTAssertTrue(output.involvementCreditsList.isEmpty)
    }

    @available(OSX 10.12, *)
    func testCreditsListFrameRemovalv22() throws {
        let mp3 = try Mp3File(location: sample22Url)
        var tag = try mp3.tag()

        
        tag.clearInvolvementCreditList()
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        XCTAssertNoThrow(try mp3.write(tag: &tag, version: .v2_2, outputLocation: outputUrl))

        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try outputMp3.tag()
        
        XCTAssertTrue(output.involvementCreditsList.isEmpty)
    }

    @available(OSX 10.12, *)
    func testCreditsListSingleItemRemovalv24() throws {
        let mp3 = try Mp3File(location: sample24Url)
        var tag = try mp3.tag()

        
        tag.removeMusicianCredit(role: .soprano)
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        XCTAssertNoThrow(try mp3.write(tag: &tag, version: .v2_4, outputLocation: outputUrl))

        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try outputMp3.tag()
        
        XCTAssertNil(output.musicianCreditsList[.soprano])
        XCTAssertEqual(output.musicianCreditsList[.alto], altoCredit)
    }
    
    @available(OSX 10.12, *)
    func testCreditsListDuplicateCatchingv24() throws {
        let mp3 = try Mp3File(location: sample24Url)
        var tag = try mp3.tag()

        
        tag.addMusicianCredit(role: .soprano, person: "Soprano Name")
        tag.addMusicianCredit(role: .alto, person: "New Alto Name")
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        XCTAssertNoThrow(try mp3.write(tag: &tag, version: .v2_4, outputLocation: outputUrl))

        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try outputMp3.tag()
        
        XCTAssertEqual(output.musicianCreditsList[.soprano], sopranoCredit)
        XCTAssertEqual(output.musicianCreditsList[.alto], ["Alto Name", "New Alto Name"])
    }
    
    @available(OSX 10.12, *)
    func testMusicianCreditV23() throws {
        let mp3 = try Mp3File(location: sample24Url)
        var tag = try mp3.tag()

        
        tag.addMusicianCredit(role: .soprano, person: "Soprano Name")
        tag.addMusicianCredit(role: .alto, person: "Alto Name")
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        XCTAssertNoThrow(try mp3.write(tag: &tag, version: .v2_4, outputLocation: outputUrl))

        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try outputMp3.tag()
        
        XCTAssertEqual(output.musicianCreditsList[.soprano], sopranoCredit)
        XCTAssertEqual(output.musicianCreditsList[.alto], altoCredit)
    }
}
