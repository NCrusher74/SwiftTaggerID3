/*

 SwiftTaggerID3_LocalizedFrame_Tests.swift
 SwiftTaggerID3

 Copyright ©2020 Nolaine Crusher. All rights reserved.

 */

import XCTest
import SwiftLanguageAndLocaleCodes
@testable import SwiftTaggerID3

@available(OSX 10.12, iOS 12.0, *)
class SwiftTaggerID3_LocalizedFrame_Tests: XCTestCase {
    
    // Localized Frame tests
    func testLocalizedFrameReadingv24() throws {
        let tag = tagV24

        XCTAssertEqual(tag.languages, [.english])
        XCTAssertEqual(tag[comment: "Comment", .eng], "Comment Content")
        XCTAssertEqual(tag[comment: "Description", .eng], "Description Content")
        XCTAssertEqual(tag[comment: "LongDescription", .eng], "Long Description Content")
        XCTAssertEqual(tag[comment: "Series Description", .eng], "Series Description Content")
        XCTAssertEqual(tag[comment: "Liner Notes", .eng], "Liner Notes Content")
        XCTAssertEqual(tag[lyrics: "Lyrics", .eng], "Lyrics Content")
        XCTAssertEqual(tag["UserText"], "User Text Content")
        XCTAssertEqual(tag[userDefinedUrl: "UserURL"], "http://userdefined.url")
    }
    
    func testLocalizedFrameReadingv23() throws {
        let tag = tagV23
        
        XCTAssertEqual(tag.languages, [.english])
        XCTAssertEqual(tag[comment: "Comment", .eng], "Comment Content")
        XCTAssertEqual(tag[comment: "Description", .eng], "Description Content")
        XCTAssertEqual(tag[comment: "LongDescription", .eng], "Long Description Content")
        XCTAssertEqual(tag[comment: "Series Description", .eng], "Series Description Content")
        XCTAssertEqual(tag[comment: "Liner Notes", .eng], "Liner Notes Content")
        XCTAssertEqual(tag[lyrics: "Lyrics", .eng], "Lyrics Content")
        XCTAssertEqual(tag["UserText"], "User Text Content")
        XCTAssertEqual(tag[userDefinedUrl: "UserURL"], "http://userdefined.url")
    }

    func testLocalizedFrameReadingv22() throws {
        let tag = tagV22
        
        XCTAssertEqual(tag.languages, [.english])
        XCTAssertEqual(tag[comment: "Comment", .eng], "Comment Content")
        XCTAssertEqual(tag[comment: "Description", .eng], "Description Content")
        XCTAssertEqual(tag[comment: "LongDescription", .eng], "Long Description Content")
        XCTAssertEqual(tag[comment: "Series Description", .eng], "Series Description Content")
        XCTAssertEqual(tag[comment: "Liner Notes", .eng], "Liner Notes Content")
        XCTAssertEqual(tag[lyrics: "Lyrics", .eng], "Lyrics Content")
        XCTAssertEqual(tag["UserText"], "User Text Content")
        XCTAssertEqual(tag[userDefinedUrl: "UserURL"], "http://userdefined.url")
    }

    func testFrameRemovalv22() throws {
        var tag = tagV22
        
        // check comment, lyrics, and subscripted user text visually in Yate
        tag[comment: "Comment", .eng] = nil
        tag[comment: "Description", .eng] = nil
        tag[comment: "LongDescription", .eng] = nil
        tag[comment: "Liner Notes", .eng] = nil
        tag[comment: "Song Description", .eng] = nil
        tag[comment: "Series Description", .eng] = nil
        tag[lyrics: "Lyrics", .eng] = nil

        tag["UserText"] = nil
        tag["Acknowledgment"] = nil
        tag["Thanks"] = nil
        tag["Keywords"] = nil
        tag["Network"] = nil
        tag["Source Credit"] = nil
        tag["Content Rating"] = nil
        tag["Content Advisory"] = nil
        tag["Season"] = nil
        tag["Episode Number"] = nil
        tag["Episode Name"] = nil
        tag["Series Name"] = nil

        tag[userDefinedUrl: "Online Extras"] = nil
        tag[userDefinedUrl: "UserURL"] = nil
        
//        let outputUrl = try localOutputDirectory("localizedtest")
        let outputUrl = tempOutputDirectory
        XCTAssertNoThrow(try mp3V22.write(tag: &tag, version: .v2_2, outputLocation: outputUrl))
        XCTAssertNil(tag[comment: "Comment", .eng])
        XCTAssertNil(tag[comment: "Description", .eng])
        XCTAssertNil(tag[comment: "LongDescription", .eng])
        XCTAssertNil(tag[comment: "Liner Notes", .eng])
        XCTAssertNil(tag[comment: "Song Description", .eng])
        XCTAssertNil(tag[comment: "Series Description", .eng])
        XCTAssertNil(tag[lyrics: "Lyrics", .eng])
        XCTAssertNil(tag["UserText"])
        XCTAssertNil(tag["Acknowledgment"])
        XCTAssertNil(tag["Thanks"])
        XCTAssertNil(tag["Keywords"])
        XCTAssertNil(tag["Network"])
        XCTAssertNil(tag["Source Credit"])
        XCTAssertNil(tag["Content Rating"])
        XCTAssertNil(tag["Content Advisory"])
        XCTAssertNil(tag["Season"])
        XCTAssertNil(tag["Episode Number"])
        XCTAssertNil(tag["Episode Name"])
        XCTAssertNil(tag["Series Name"])
        
        XCTAssertNil(tag[userDefinedUrl: "Online Extras"])
        XCTAssertNil(tag[userDefinedUrl: "UserURL"])
    }
    
    func testFrameRemovalv23() throws {
        var tag = tagV23
        
        // check comment, lyrics, and subscripted user text visually in Yate
        tag[comment: "Comment", .eng] = nil
        tag[comment: "Description", .eng] = nil
        tag[comment: "LongDescription", .eng] = nil
        tag[comment: "Liner Notes", .eng] = nil
        tag[comment: "Song Description", .eng] = nil
        tag[comment: "Series Description", .eng] = nil
        tag[lyrics: "Lyrics", .eng] = nil
        
        tag["UserText"] = nil
        tag["Acknowledgment"] = nil
        tag["Thanks"] = nil
        tag["Keywords"] = nil
        tag["Network"] = nil
        tag["Source Credit"] = nil
        tag["Content Rating"] = nil
        tag["Content Advisory"] = nil
        tag["Season"] = nil
        tag["Episode Number"] = nil
        tag["Episode Name"] = nil
        tag["Series Name"] = nil
        
        tag[userDefinedUrl: "Online Extras"] = nil
        tag[userDefinedUrl: "UserURL"] = nil
        
        let outputUrl = tempOutputDirectory
        XCTAssertNoThrow(try mp3V23.write(tag: &tag, version: .v2_3, outputLocation: outputUrl))

        XCTAssertNil(tag[comment: "Comment", .eng])
        XCTAssertNil(tag[comment: "Description", .eng])
        XCTAssertNil(tag[comment: "LongDescription", .eng])
        XCTAssertNil(tag[comment: "Liner Notes", .eng])
        XCTAssertNil(tag[comment: "Song Description", .eng])
        XCTAssertNil(tag[comment: "Series Description", .eng])
        XCTAssertNil(tag[lyrics: "Lyrics", .eng])
        XCTAssertNil(tag["UserText"])
        XCTAssertNil(tag["Acknowledgment"])
        XCTAssertNil(tag["Thanks"])
        XCTAssertNil(tag["Keywords"])
        XCTAssertNil(tag["Network"])
        XCTAssertNil(tag["Source Credit"])
        XCTAssertNil(tag["Content Rating"])
        XCTAssertNil(tag["Content Advisory"])
        XCTAssertNil(tag["Season"])
        XCTAssertNil(tag["Episode Number"])
        XCTAssertNil(tag["Episode Name"])
        XCTAssertNil(tag["Series Name"])
        
        XCTAssertNil(tag[userDefinedUrl: "Online Extras"])
        XCTAssertNil(tag[userDefinedUrl: "UserURL"])
    }

    func testFrameRemovalv24() throws {
        var tag = tagV24
        
        // check comment, lyrics, and subscripted user text visually in Yate
        tag[comment: "Comment", .eng] = nil
        tag[comment: "Description", .eng] = nil
        tag[comment: "LongDescription", .eng] = nil
        tag[comment: "Liner Notes", .eng] = nil
        tag[comment: "Song Description", .eng] = nil
        tag[comment: "Series Description", .eng] = nil
        tag[lyrics: "Lyrics", .eng] = nil
        
        tag["UserText"] = nil
        tag["Acknowledgment"] = nil
        tag["Thanks"] = nil
        tag["Keywords"] = nil
        tag["Network"] = nil
        tag["Source Credit"] = nil
        tag["Content Rating"] = nil
        tag["Content Advisory"] = nil
        tag["Season"] = nil
        tag["Episode Number"] = nil
        tag["Episode Name"] = nil
        tag["Series Name"] = nil
        
        tag[userDefinedUrl: "Online Extras"] = nil
        tag[userDefinedUrl: "UserURL"] = nil

        let outputUrl = tempOutputDirectory
        XCTAssertNoThrow(try mp3V24.write(tag: &tag, version: .v2_4, outputLocation: outputUrl))

        XCTAssertNil(tag[comment: "Comment", .eng])
        XCTAssertNil(tag[comment: "Description", .eng])
        XCTAssertNil(tag[comment: "LongDescription", .eng])
        XCTAssertNil(tag[comment: "Liner Notes", .eng])
        XCTAssertNil(tag[comment: "Song Description", .eng])
        XCTAssertNil(tag[comment: "Series Description", .eng])
        XCTAssertNil(tag[lyrics: "Lyrics", .eng])
        XCTAssertNil(tag["UserText"])
        XCTAssertNil(tag["Acknowledgment"])
        XCTAssertNil(tag["Thanks"])
        XCTAssertNil(tag["Keywords"])
        XCTAssertNil(tag["Network"])
        XCTAssertNil(tag["Source Credit"])
        XCTAssertNil(tag["Content Rating"])
        XCTAssertNil(tag["Content Advisory"])
        XCTAssertNil(tag["Season"])
        XCTAssertNil(tag["Episode Number"])
        XCTAssertNil(tag["Episode Name"])
        XCTAssertNil(tag["Series Name"])
        
        XCTAssertNil(tag[userDefinedUrl: "Online Extras"])
        XCTAssertNil(tag[userDefinedUrl: "UserURL"])
    }

    func testLocalizedFrameWritingv24() throws {
        var tag = tagNoMeta

        tag[comment: "Comment", .eng] = "Comment Content"
        tag[lyrics: "Lyrics", .eng] = "Lyrics Content"
        tag[userDefinedUrl: "UserURL"] = "http://userdefined.url"
        tag["UserText"] = "User Text Content"

//        let outputUrl = try localOutputDirectory("localizedtestV24")
        let outputUrl = tempOutputDirectory
        XCTAssertNoThrow(try mp3NoMeta.write(tag: &tag, version: .v2_4, outputLocation: outputUrl))
        
        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try Tag(mp3File: outputMp3)
        
        XCTAssertEqual(output[comment: "Comment", .eng], "Comment Content")
        XCTAssertEqual(output[lyrics: "Lyrics", .eng], "Lyrics Content")
        XCTAssertEqual(output[userDefinedUrl: "UserURL"], "http://userdefined.url")
        XCTAssertEqual(output["UserText"], "User Text Content")
    }
    
    func testLocalizedFrameWritingv23() throws {
        var tag = tagNoMeta
        
        tag[comment: "Comment", .eng] = "Comment Content"
        tag[lyrics: "Lyrics", .eng] = "Lyrics Content"
        tag[userDefinedUrl: "UserURL"] = "http://userdefined.url"
        tag["UserText"] = "User Text Content"
        
//        let outputUrl = try localOutputDirectory("localizedtestV23")
        let outputUrl = tempOutputDirectory
        XCTAssertNoThrow(try mp3NoMeta.write(tag: &tag, version: .v2_3, outputLocation: outputUrl))
        
        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try Tag(mp3File: outputMp3)
        
        XCTAssertEqual(output[comment: "Comment", .eng], "Comment Content")
        XCTAssertEqual(output[lyrics: "Lyrics", .eng], "Lyrics Content")
        XCTAssertEqual(output[userDefinedUrl: "UserURL"], "http://userdefined.url")
        XCTAssertEqual(output["UserText"], "User Text Content")
    }

    func testLocalizedFrameWritingv22() throws {
        var tag = tagNoMeta
        tag.version = .v2_2
        
        tag[comment: "Comment", .eng] = "Comment Content"
        tag[lyrics: "Lyrics", .eng] = "Lyrics Content"
        tag[userDefinedUrl: "UserURL"] = "http://userdefined.url"
        tag["UserText"] = "User Text Content"

//        let outputUrl = try localOutputDirectory("localizedtestV22")
        let outputUrl = tempOutputDirectory
        XCTAssertNoThrow(try mp3NoMeta.write(tag: &tag, version: .v2_2, outputLocation: outputUrl))

        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try Tag(mp3File: outputMp3)
        
        XCTAssertEqual(output[comment: "Comment", .eng], "Comment Content")
        XCTAssertEqual(output[lyrics: "Lyrics", .eng], "Lyrics Content")
        XCTAssertEqual(output[userDefinedUrl: "UserURL"], "http://userdefined.url")
        XCTAssertEqual(output["UserText"], "User Text Content")
    }
    
    func testLocalizedVersionSwitch() throws {
        var tag = tagV24
        tag.version = .v2_2
        
//        let outputUrl = try localOutputDirectory("localizedtestV22")
        let outputUrl = tempOutputDirectory
        XCTAssertNoThrow(try mp3V24.write(tag: &tag, version: .v2_2, outputLocation: outputUrl))
        
        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try Tag(mp3File: outputMp3)
        XCTAssertEqual(output.version, .v2_2)
        XCTAssertEqual(output.languages, [.english])
        XCTAssertEqual(output[comment: "Comment", .eng], "Comment Content")
        XCTAssertEqual(output[comment: "Description", .eng], "Description Content")
        XCTAssertEqual(output[comment: "LongDescription", .eng], "Long Description Content")
        XCTAssertEqual(output[comment: "Series Description", .eng], "Series Description Content")
        XCTAssertEqual(output[comment: "Liner Notes", .eng], "Liner Notes Content")
        XCTAssertEqual(output[lyrics: "Lyrics", .eng], "Lyrics Content")
        XCTAssertEqual(output["UserText"], "User Text Content")
        XCTAssertEqual(output[userDefinedUrl: "UserURL"], "http://userdefined.url")
        
        for (_, frame) in output.frames {
            if frame.identifier == .unsynchronizedLyrics {
                let idString = frame.identifier.idString(version: tag.version)
                XCTAssertEqual(idString, "ULT")
            }
            if frame.identifier == .userDefinedWebpage {
                let idString = frame.identifier.idString(version: tag.version)
                XCTAssertEqual(idString, "WXX")
            }
            if frame.identifier == .userDefinedText {
                let idString = frame.identifier.idString(version: tag.version)
                XCTAssertEqual(idString, "TXX")
            }
            if frame.identifier == .comments {
                let idString = frame.identifier.idString(version: tag.version)
                XCTAssertEqual(idString, "COM")
            }
        }
    }
}
