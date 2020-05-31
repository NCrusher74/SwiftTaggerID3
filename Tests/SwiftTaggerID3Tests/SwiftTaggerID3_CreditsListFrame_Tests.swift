/*

 SwiftTaggerID3_CreditsListFrame_Tests.swift
 SwiftTaggerID3

 Copyright ©2020 Nolaine Crusher. All rights reserved.

 */

import XCTest
import SwiftTaggerID3

class SwiftTaggerID3_CreditsListFrame_Tests: XCTestCase {

    func testCreditsListFrameReadingv24() throws {
        let tag = try TestFile.v24.tag()

        XCTAssertEqual(tag?.involvedPeopleList?[.actor], ["Actor Name"])
        XCTAssertEqual(tag?.involvedPeopleList?[.actress], ["Actress Name"])
        XCTAssertEqual(tag?.musicianCreditsList?[.soprano], ["Soprano Name"])
        XCTAssertEqual(tag?.musicianCreditsList?[.alto], ["Alto Name"])
    }

    func testCreditsListFrameReadingv23() throws {
        let tag = try TestFile.v23.tag()
        
        XCTAssertEqual(tag?.involvedPeopleList?[.actor], ["Actor Name"])
        XCTAssertEqual(tag?.involvedPeopleList?[.actress], ["Actress Name"])
    }

    func testCreditsListFrameReadingv22() throws {
        let tag = try TestFile.v22.tag()
        
        XCTAssertEqual(tag?.involvedPeopleList?[.actor], ["Actor Name"])
        XCTAssertEqual(tag?.involvedPeopleList?[.actress], ["Actress Name"])
    }

    @available(OSX 10.12, *)
    func testCreditsListFrameWritingv24() throws {
        var tag = try TestFile.noMeta.tag()

        tag?.addInvolvedPersonCredit(role: .actor, person: "Actor Name")
        tag?.addInvolvedPersonCredit(role: .actress, person: "Actress Name")
        tag?.addMusicianCredit(role: .soprano, person: "Soprano Name")
        tag?.addMusicianCredit(role: .alto, person: "Alto Name")

        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        XCTAssertNoThrow(try TestFile.noMeta.mp3File()?.write(tagVersion: .v2_4, using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v24.url)), writingTo: outputUrl))
        
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)

        XCTAssertEqual(tagWritten.involvedPeopleList?[.actor], ["Actor Name"])
        XCTAssertEqual(tagWritten.involvedPeopleList?[.actress], ["Actress Name"])
        XCTAssertEqual(tagWritten.musicianCreditsList?[.soprano], ["Soprano Name"])
        XCTAssertEqual(tagWritten.musicianCreditsList?[.alto], ["Alto Name"])
    }

    @available(OSX 10.12, *)
    func testCreditsListFrameWritingv23() throws {
        var tag = try TestFile.noMeta.tag()
        
        tag?.addInvolvedPersonCredit(role: .actor, person: "Actor Name")
        tag?.addInvolvedPersonCredit(role: .actress, person: "Actress Name")
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        XCTAssertNoThrow(try TestFile.noMeta.mp3File()?.write(tagVersion: .v2_3, using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v23.url)), writingTo: outputUrl))
        
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.involvedPeopleList?[.actor], ["Actor Name"])
        XCTAssertEqual(tagWritten.involvedPeopleList?[.actress], ["Actress Name"])
    }
    
    @available(OSX 10.12, *)
    func testCreditsListFrameWritingv22() throws {
        var tag = try TestFile.noMeta.tag()
        
        tag?.addInvolvedPersonCredit(role: .actor, person: "Actor Name")
        tag?.addInvolvedPersonCredit(role: .actress, person: "Actress Name")
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        XCTAssertNoThrow(try TestFile.noMeta.mp3File()?.write(tagVersion: .v2_2, using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v22.url)), writingTo: outputUrl))
        
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.involvedPeopleList?[.actor], ["Actor Name"])
        XCTAssertEqual(tagWritten.involvedPeopleList?[.actress], ["Actress Name"])
    }
    
    @available(OSX 10.12, *)
    func testCreditsListFrameRemovalv24() throws {
        var tag = try TestFile.v24.tag()

        tag?.clearMusicianCreditsList()
        tag?.clearInvolvedPeopleList()

        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        XCTAssertNoThrow(try TestFile.v24.mp3File()?.write(tagVersion: .v2_4, using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v24.url)), writingTo: outputUrl))
        
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)

        XCTAssertNil(tagWritten.musicianCreditsList)
        XCTAssertNil(tagWritten.involvedPeopleList)
    }

    @available(OSX 10.12, *)
    func testCreditsListFrameRemovalv23() throws {
        var tag = try TestFile.v23.tag()
        
        tag?.clearInvolvedPeopleList()
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        XCTAssertNoThrow(try TestFile.v23.mp3File()?.write(tagVersion: .v2_3, using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v23.url)), writingTo: outputUrl))
        
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertNil(tagWritten.involvedPeopleList)
    }

    @available(OSX 10.12, *)
    func testCreditsListFrameRemovalv22() throws {
        var tag = try TestFile.v22.tag()
        
        tag?.clearInvolvedPeopleList()
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        XCTAssertNoThrow(try TestFile.v22.mp3File()?.write(tagVersion: .v2_2, using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v22.url)), writingTo: outputUrl))
        
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertNil(tagWritten.involvedPeopleList)
    }

    @available(OSX 10.12, *)
    func testCreditsListSingleItemRemovalv24() throws {
        var tag = try TestFile.v24.tag()
        
        tag?.clearInvolvedPeopleForRole(role: .actor)
        tag?.clearMusicianCreditsForRole(role: .soprano)
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        XCTAssertNoThrow(try TestFile.v24.mp3File()?.write(tagVersion: .v2_4, using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v24.url)), writingTo: outputUrl))
        
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertNil(tagWritten.involvedPeopleList?[.actor])
        XCTAssertEqual(tagWritten.involvedPeopleList?[.actress], ["Actress Name"])
        XCTAssertNil(tagWritten.musicianCreditsList?[.soprano])
        XCTAssertEqual(tagWritten.musicianCreditsList?[.alto], ["Alto Name"])
    }
    
    @available(OSX 10.12, *)
    func testCreditsListSingleItemRemovalv23() throws {
        var tag = try TestFile.v23.tag()
        
        tag?.clearInvolvedPeopleForRole(role: .actor)
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        XCTAssertNoThrow(try TestFile.v23.mp3File()?.write(tagVersion: .v2_3, using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v23.url)), writingTo: outputUrl))
        
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertNil(tagWritten.involvedPeopleList?[.actor])
        XCTAssertEqual(tagWritten.involvedPeopleList?[.actress], ["Actress Name"])
    }

    @available(OSX 10.12, *)
    func testCreditsListSingleItemRemovalv22() throws {
        var tag = try TestFile.v22.tag()
        
        tag?.clearInvolvedPeopleForRole(role: .actor)
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        XCTAssertNoThrow(try TestFile.v22.mp3File()?.write(tagVersion: .v2_2, using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v22.url)), writingTo: outputUrl))
        
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertNil(tagWritten.involvedPeopleList?[.actor])
        XCTAssertEqual(tagWritten.involvedPeopleList?[.actress], ["Actress Name"])
    }

    @available(OSX 10.12, *)
    func testCreditsListDuplicateCatchingv24() throws {
        var tag = try TestFile.v24.tag()
        
        tag?.addInvolvedPersonCredit(role: .actress, person: "Actress Name")
        tag?.addInvolvedPersonCredit(role: .actor, person: "New Actor Name")
        tag?.addMusicianCredit(role: .soprano, person: "Soprano Name")
        tag?.addMusicianCredit(role: .alto, person: "New Alto Name")
        
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        XCTAssertNoThrow(try TestFile.v24.mp3File()?.write(tagVersion: .v2_4, using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v24.url)), writingTo: outputUrl))
        
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.involvedPeopleList?[.actor], ["Actor Name", "New Actor Name"])
        XCTAssertEqual(tagWritten.involvedPeopleList?[.actress], ["Actress Name"])
        XCTAssertEqual(tagWritten.musicianCreditsList?[.soprano], ["Soprano Name"])
        XCTAssertEqual(tagWritten.musicianCreditsList?[.alto], ["Alto Name", "New Alto Name"])
    }
    
    @available(OSX 10.12, *)
    func testMusicianCreditV23() throws {
        var tag = try TestFile.noMeta.tag()
        
        tag?.addMusicianCredit(role: .soprano, person: "Soprano Name")
        tag?.addMusicianCredit(role: .alto, person: "Alto Name")
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        XCTAssertNoThrow(try TestFile.noMeta.mp3File()?.write(tagVersion: .v2_3, using: tag ?? Tag(readFrom: Mp3File(location: TestFile.noMeta.url)), writingTo: outputUrl))
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.musicianCreditsList?[.soprano], ["Soprano Name"])
        XCTAssertEqual(tagWritten.musicianCreditsList?[.alto], ["Alto Name"])
    }
}
