///*
//
// SwiftTaggerID3_LocalizedFrame_Tests.swift
// SwiftTaggerID3
//
// Copyright ©2020 Nolaine Crusher. All rights reserved.
//
// */
//
//import XCTest
//import SwiftTaggerID3
//import SwiftLanguageAndLocaleCodes
//
//class SwiftTaggerID3_LocalizedFrame_Tests: XCTestCase {
//    
//    // Localized Frame tests
//    @available(OSX 10.12, *)
//    func testLocalizedFrameReadingv24() throws {
//        let tag = try TestFile.v24.tag()
//
//        XCTAssertEqual(tag?.languages, [.eng])
//        XCTAssertEqual(tag?.series, "Content Group")
//        XCTAssertEqual(tag?.studio, "Publisher")
//        XCTAssertEqual(tag?["Comment", .eng], "Comment Content")
//        XCTAssertEqual(tag?["Description", .eng], "Description Content")
//        XCTAssertEqual(tag?["LongDescription", .eng], "Long Description Content")
//        XCTAssertEqual(tag?["Series Description", .eng], "Series Description Content")
//        XCTAssertEqual(tag?["Liner Notes", .eng], "Liner Notes Content")
//        XCTAssertEqual(tag?[lyrics: "Lyrics", .eng], "Lyrics Content")
//        XCTAssertEqual(tag?["UserText"], "User Text Content")
//        XCTAssertEqual(tag?[userDefinedUrl: "UserURL"], "http://userdefined.url")
//    }
//    
//    @available(OSX 10.12, *)
//    func testLocalizedFrameReadingv23() throws {
//        let tag = try TestFile.v23.tag()
//        
//        XCTAssertEqual(tag?.languages, [.eng])
//        XCTAssertEqual(tag?.series, "Content Group")
//        XCTAssertEqual(tag?.studio, "Publisher")
//        XCTAssertEqual(tag?["Comment", .eng], "Comment Content")
//        XCTAssertEqual(tag?["Description", .eng], "Description Content")
//        XCTAssertEqual(tag?["LongDescription", .eng], "Long Description Content")
//        XCTAssertEqual(tag?["Series Description", .eng], "Series Description Content")
//        XCTAssertEqual(tag?["Liner Notes", .eng], "Liner Notes Content")
//        XCTAssertEqual(tag?[lyrics: "Lyrics", .eng], "Lyrics Content")
//        XCTAssertEqual(tag?["UserText"], "User Text Content")
//        XCTAssertEqual(tag?[userDefinedUrl: "UserURL"], "http://userdefined.url")
//    }
//
//    @available(OSX 10.12, *)
//    func testLocalizedFrameReadingv22() throws {
//        let tag = try TestFile.v22.tag()
//        
//        XCTAssertEqual(tag?.languages, [.eng])
//        XCTAssertEqual(tag?.series, "Content Group")
//        XCTAssertEqual(tag?.studio, "Publisher")
//        XCTAssertEqual(tag?["Comment", .eng], "Comment Content")
//        XCTAssertEqual(tag?["Description", .eng], "Description Content")
//        XCTAssertEqual(tag?["LongDescription", .eng], "Long Description Content")
//        XCTAssertEqual(tag?["Series Description", .eng], "Series Description Content")
//        XCTAssertEqual(tag?["Liner Notes", .eng], "Liner Notes Content")
//        XCTAssertEqual(tag?[lyrics: "Lyrics", .eng], "Lyrics Content")
//        XCTAssertEqual(tag?["UserText"], "User Text Content")
//        XCTAssertEqual(tag?[userDefinedUrl: "UserURL"], "http://userdefined.url")        
//    }
//
//    @available(OSX 10.12, *)
//    func testFrameRemovalv22() throws {
//        var tag = try TestFile.v22.tag()
//        
//        // check comment, lyrics, and subscripted user text visually in Yate
//        tag?["Comment", .eng] = nil
//        tag?["Description", .eng] = nil
//        tag?["Long Description", .eng] = nil
//        tag?["Liner Notes", .eng] = nil
//        tag?["Song Description", .eng] = nil
//        tag?["Series Description", .eng] = nil
//        tag?[lyrics: "Lyrics", .eng] = nil
//
//        tag?["UserText"] = nil
//        tag?["Acknowledgment"] = nil
//        tag?["Thanks"] = nil
//        tag?["Keywords"] = nil
//        tag?["Network"] = nil
//        tag?["Source Credit"] = nil
//        tag?["Content Rating"] = nil
//        tag?["Content Advisory"] = nil
//        tag?["Season"] = nil
//        tag?["Episode Number"] = nil
//        tag?["Episode Name"] = nil
//        tag?["Series Name"] = nil
//
//        tag?[userDefinedUrl: "Online Extras"] = nil
//        tag?[userDefinedUrl: "UserURL"] = nil
//        
//        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
//        XCTAssertNoThrow(try TestFile.v22.mp3File()?.write(
//            tagVersion: .v2_2,
//            using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v22.url)),
//            writingTo: outputUrl))
//    }
//    
//    @available(OSX 10.12, *)
//    func testFrameRemovalv23() throws {
//        var tag = try TestFile.v23.tag()
//        
//        // check comment, lyrics, and subscripted user text visually in Yate
//        tag?["Comment", .eng] = nil
//        tag?["Description", .eng] = nil
//        tag?["Long Description", .eng] = nil
//        tag?["Liner Notes", .eng] = nil
//        tag?["Song Description", .eng] = nil
//        tag?["Series Description", .eng] = nil
//        tag?[lyrics: "Lyrics", .eng] = nil
//        
//        tag?["UserText"] = nil
//        tag?["Acknowledgment"] = nil
//        tag?["Thanks"] = nil
//        tag?["Keywords"] = nil
//        tag?["Network"] = nil
//        tag?["Source Credit"] = nil
//        tag?["Content Rating"] = nil
//        tag?["Content Advisory"] = nil
//        tag?["Season"] = nil
//        tag?["Episode Number"] = nil
//        tag?["Episode Name"] = nil
//        tag?["Series Name"] = nil
//        
//        tag?[userDefinedUrl: "Online Extras"] = nil
//        tag?[userDefinedUrl: "UserURL"] = nil
//        
//        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
//        XCTAssertNoThrow(try TestFile.v23.mp3File()?.write(
//            tagVersion: .v2_3,
//            using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v23.url)),
//            writingTo: outputUrl))
//    }
//
//    @available(OSX 10.12, *)
//    func testFrameRemovalv24() throws {
//        var tag = try TestFile.v24.tag()
//        
//        // check comment, lyrics, and subscripted user text visually in Yate
//        tag?["Comment", .eng] = nil
//        tag?["Description", .eng] = nil
//        tag?["Long Description", .eng] = nil
//        tag?["Liner Notes", .eng] = nil
//        tag?["Song Description", .eng] = nil
//        tag?["Series Description", .eng] = nil
//        tag?[lyrics: "Lyrics", .eng] = nil
//        
//        tag?["UserText"] = nil
//        tag?["Acknowledgment"] = nil
//        tag?["Thanks"] = nil
//        tag?["Keywords"] = nil
//        tag?["Network"] = nil
//        tag?["Source Credit"] = nil
//        tag?["Content Rating"] = nil
//        tag?["Content Advisory"] = nil
//        tag?["Season"] = nil
//        tag?["Episode Number"] = nil
//        tag?["Episode Name"] = nil
//        tag?["Series Name"] = nil
//        
//        tag?[userDefinedUrl: "Online Extras"] = nil
//        tag?[userDefinedUrl: "UserURL"] = nil
//
//        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
//        XCTAssertNoThrow(try TestFile.v24.mp3File()?.write(
//            tagVersion: .v2_4,
//            using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v24.url)),
//            writingTo: outputUrl))
//    }
//
//    @available(OSX 10.12, *)
//    func testLocalizedFrameWritingv24() throws {
//        var tag = try TestFile.noMeta.tag()
//
//        tag?["Comment", .eng] = "Comment Content"
//        tag?[lyrics: "Lyrics", .eng] = "Lyrics Content"
//        tag?[userDefinedUrl: "UserURL"] = "http://userdefined.url"
//        tag?["UserText"] = "User Text Content"
//
//        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
//        XCTAssertNoThrow(try TestFile.noMeta.mp3File()?.write(tagVersion: .v2_4, using: tag ?? Tag(readFrom: Mp3File(location: TestFile.noMeta.url)), writingTo: outputUrl))
//        
//        
//        let mp3UrlWritten = outputUrl
//        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
//        let tagWritten = try Tag(readFrom: mp3FileWritten)
//        
//        XCTAssertEqual(tagWritten["Comment", .eng], "Comment Content")
//        XCTAssertEqual(tagWritten[lyrics: "Lyrics", .eng], "Lyrics Content")
//        XCTAssertEqual(tagWritten[userDefinedUrl: "UserURL"], "http://userdefined.url")
//        XCTAssertEqual(tagWritten["UserText"], "User Text Content")
//    }
//    
//    @available(OSX 10.12, *)
//    func testLocalizedFrameWritingv23() throws {
//        var tag = try TestFile.noMeta.tag()
//        
//        tag?["Comment", .eng] = "Comment Content"
//        tag?[lyrics: "Lyrics", .eng] = "Lyrics Content"
//        tag?[userDefinedUrl: "UserURL"] = "http://userdefined.url"
//        tag?["UserText"] = "User Text Content"
//        
//        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
//        XCTAssertNoThrow(try TestFile.noMeta.mp3File()?.write(tagVersion: .v2_3, using: tag ?? Tag(readFrom: Mp3File(location: TestFile.noMeta.url)), writingTo: outputUrl))
//        
//        
//        let mp3UrlWritten = outputUrl
//        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
//        let tagWritten = try Tag(readFrom: mp3FileWritten)
//        
//        XCTAssertEqual(tagWritten["Comment", .eng], "Comment Content")
//        XCTAssertEqual(tagWritten[lyrics: "Lyrics", .eng], "Lyrics Content")
//        XCTAssertEqual(tagWritten[userDefinedUrl: "UserURL"], "http://userdefined.url")
//        XCTAssertEqual(tagWritten["UserText"], "User Text Content")
//    }
//
//    @available(OSX 10.12, *)
//    func testLocalizedFrameWritingv22() throws {
//        var tag = try TestFile.noMeta.tag()
//        
//        tag?["Comment", .eng] = "Comment Content"
//        tag?[lyrics: "Lyrics", .eng] = "Lyrics Content"
//        tag?[userDefinedUrl: "UserURL"] = "http://userdefined.url"
//        tag?["UserText"] = "User Text Content"
//        
//        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
//        XCTAssertNoThrow(try TestFile.noMeta.mp3File()?.write(tagVersion: .v2_2, using: tag ?? Tag(readFrom: Mp3File(location: TestFile.noMeta.url)), writingTo: outputUrl))
//        
//        
//        let mp3UrlWritten = outputUrl
//        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
//        let tagWritten = try Tag(readFrom: mp3FileWritten)
//        
//        XCTAssertEqual(tagWritten["Comment", .eng], "Comment Content")
//        XCTAssertEqual(tagWritten[lyrics: "Lyrics", .eng], "Lyrics Content")
//        XCTAssertEqual(tagWritten[userDefinedUrl: "UserURL"], "http://userdefined.url")
//        XCTAssertEqual(tagWritten["UserText"], "User Text Content")
//    }
//
//    @available(OSX 10.12, *)
//    func testLanguageFrameReading() throws {
//        let tagV24 = try TestFile.v24.tag()
//        let tagV23 = try TestFile.v23.tag()
//        let tagV22 = try TestFile.v22.tag()
//
//        XCTAssertEqual(tagV24?.languages, [.eng])
//        XCTAssertEqual(tagV23?.languages, [.eng])
//        XCTAssertEqual(tagV22?.languages, [.eng])
//    }
//    
//    @available(OSX 10.12, *)
//    func testLanguageFrameWritingV24() throws {
//        var tag = try TestFile.noMeta.tag()
//        
//        tag?.languages = ISO6392Code.allCases
//        
//        let output = try tempDirectory().appendingPathComponent("test.mp3")
//        XCTAssertNoThrow(try TestFile.noMeta.mp3File()?.write(tagVersion: .v2_4, using: tag ?? Tag(readFrom: Mp3File(location: TestFile.noMeta.url)), writingTo: output))
//
//        let fileWritten = try Mp3File(location: output)
//        let tagWritten = try Tag(readFrom: fileWritten)
//        XCTAssertEqual(tagWritten.languages, ISO6392Code.allCases)
//    }
//
//    @available(OSX 10.12, *)
//    func testLanguageFrameWritingV23() throws {
//        var tag = try TestFile.noMeta.tag()
//        
//        tag?.languages = ISO6392Code.allCases
//        
//        let output = try tempDirectory().appendingPathComponent("test.mp3")
//        XCTAssertNoThrow(try TestFile.noMeta.mp3File()?.write(tagVersion: .v2_3, using: tag ?? Tag(readFrom: Mp3File(location: TestFile.noMeta.url)), writingTo: output))
//        
//        let fileWritten = try Mp3File(location: output)
//        let tagWritten = try Tag(readFrom: fileWritten)
//        XCTAssertEqual(tagWritten.languages, ISO6392Code.allCases)
//    }
//
//    @available(OSX 10.12, *)
//    func testLanguageFrameWritingV22() throws {
//        var tag = try TestFile.noMeta.tag()
//        
//        tag?.languages = ISO6392Code.allCases
//        
//        let output = try tempDirectory().appendingPathComponent("test.mp3")
//        XCTAssertNoThrow(try TestFile.noMeta.mp3File()?.write(tagVersion: .v2_2, using: tag ?? Tag(readFrom: Mp3File(location: TestFile.noMeta.url)), writingTo: output))
//        
//        let fileWritten = try Mp3File(location: output)
//        let tagWritten = try Tag(readFrom: fileWritten)
//        XCTAssertEqual(tagWritten.languages, ISO6392Code.allCases)
//    }
//}
