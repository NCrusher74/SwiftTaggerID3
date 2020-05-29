/*
 
 SwiftTaggerID3_LocalizedFrame_Tests.swift
 SwiftTaggerID3
 
 Copyright ©2020 Nolaine Crusher. All rights reserved.
 
 */

import XCTest
import SwiftTaggerID3

@available(OSX 10.12, *)
class SwiftTaggerID3_LocalizedFrame_Tests: XCTestCase {
    
    // Localized Frame tests
    func testLocalizedFrameReadingv24() throws {
        let tag = try TestFile.v24.tag()

        XCTAssertEqual(tag?.acknowledgment, "Acknowledgment")
        XCTAssertEqual(tag?.keywords, ["Key","Words"])
        XCTAssertEqual(tag?.contentAdvisory, .usMovieUnrated)
        XCTAssertEqual(tag?.contentRating, .clean)
        XCTAssertEqual(tag?.network, "Network")
        XCTAssertEqual(tag?.episodeName, "Episode Name")
        XCTAssertEqual(tag?.episodeNumber, 7)
        XCTAssertEqual(tag?.languages, [.eng])
        XCTAssertEqual(tag?.thanks, "Thanks")
        XCTAssertEqual(tag?.season, 8)
        XCTAssertEqual(tag?.series, "Content Group")
        XCTAssertEqual(tag?.seriesName, "Series Name")
        XCTAssertEqual(tag?.sourceCredit, "Source Credit")
        XCTAssertEqual(tag?.studio, "Publisher")
        XCTAssertEqual(tag?.onlineExtras, "http://onlineextras.url")
        XCTAssertEqual(tag?[comments: .eng, "Comment"], "Comment Content")
        XCTAssertEqual(tag?[comments: .eng, "Description"], "Description Content")
        XCTAssertEqual(tag?[comments: .eng, "LongDescription"], "Long Description Content")
        XCTAssertEqual(tag?[comments: .eng, "Series Description"], "Series Description Content")
        XCTAssertEqual(tag?[comments: .eng, "Liner Notes"], "Liner Notes Content")
        XCTAssertEqual(tag?[lyrics: .eng, "Lyrics"], "Lyrics Content")
        XCTAssertEqual(tag?[userDefinedText: "UserText"], "User Text Content")
        XCTAssertEqual(tag?[userDefinedUrl: "UserURL"], "http://userdefined.url")
    }
    
    func testLocalizedFrameReadingv23() throws {
        let tag = try TestFile.v23.tag()
        
        XCTAssertEqual(tag?.acknowledgment, "Acknowledgment")
        XCTAssertEqual(tag?.keywords, ["Key","Words"])
        XCTAssertEqual(tag?.contentAdvisory, .usMovieUnrated)
        XCTAssertEqual(tag?.contentRating, .clean)
        XCTAssertEqual(tag?.network, "Network")
        XCTAssertEqual(tag?.episodeName, "Episode Name")
        XCTAssertEqual(tag?.episodeNumber, 7)
        XCTAssertEqual(tag?.languages, [.eng])
        XCTAssertEqual(tag?.thanks, "Thanks")
        XCTAssertEqual(tag?.season, 8)
        XCTAssertEqual(tag?.series, "Content Group")
        XCTAssertEqual(tag?.seriesName, "Series Name")
        XCTAssertEqual(tag?.sourceCredit, "Source Credit")
        XCTAssertEqual(tag?.studio, "Publisher")
        XCTAssertEqual(tag?.onlineExtras, "http://onlineextras.url")
        XCTAssertEqual(tag?[comments: .eng, "Comment"], "Comment Content")
        XCTAssertEqual(tag?[comments: .eng, "Description"], "Description Content")
        XCTAssertEqual(tag?[comments: .eng, "LongDescription"], "Long Description Content")
        XCTAssertEqual(tag?[comments: .eng, "Series Description"], "Series Description Content")
        XCTAssertEqual(tag?[comments: .eng, "Liner Notes"], "Liner Notes Content")
        XCTAssertEqual(tag?[lyrics: .eng, "Lyrics"], "Lyrics Content")
        XCTAssertEqual(tag?[userDefinedText: "UserText"], "User Text Content")
        XCTAssertEqual(tag?[userDefinedUrl: "UserURL"], "http://userdefined.url")
    }

    func testLocalizedFrameReadingv22() throws {
        let tag = try TestFile.v22.tag()
        
        XCTAssertEqual(tag?.acknowledgment, "Acknowledgment")
        XCTAssertEqual(tag?.keywords, ["Key","Words"])
        XCTAssertEqual(tag?.contentAdvisory, .usMovieUnrated)
        XCTAssertEqual(tag?.contentRating, .clean)
        XCTAssertEqual(tag?.network, "Network")
        XCTAssertEqual(tag?.episodeName, "Episode Name")
        XCTAssertEqual(tag?.episodeNumber, 7)
        XCTAssertEqual(tag?.languages, [.eng])
        XCTAssertEqual(tag?.thanks, "Thanks")
        XCTAssertEqual(tag?.season, 8)
        XCTAssertEqual(tag?.series, "Content Group")
        XCTAssertEqual(tag?.seriesName, "Series Name")
        XCTAssertEqual(tag?.sourceCredit, "Source Credit")
        XCTAssertEqual(tag?.studio, "Publisher")
        XCTAssertEqual(tag?.onlineExtras, "http://onlineextras.url")
        XCTAssertEqual(tag?[comments: .eng, "Comment"], "Comment Content")
        XCTAssertEqual(tag?[comments: .eng, "Description"], "Description Content")
        XCTAssertEqual(tag?[comments: .eng, "LongDescription"], "Long Description Content")
        XCTAssertEqual(tag?[comments: .eng, "Series Description"], "Series Description Content")
        XCTAssertEqual(tag?[comments: .eng, "Liner Notes"], "Liner Notes Content")
        XCTAssertEqual(tag?[lyrics: .eng, "Lyrics"], "Lyrics Content")
        XCTAssertEqual(tag?[userDefinedText: "UserText"], "User Text Content")
        XCTAssertEqual(tag?[userDefinedUrl: "UserURL"], "http://userdefined.url")        
    }

    func testFrameRemovalv22() throws {
        var tag = try TestFile.v22.tag()
        
        // check comment, lyrics, and subscripted user text visually in Yate
        tag?.removeCommentFrame(withDescription: "Comment")
        tag?.removeCommentFrame(withDescription: "Description")
        tag?.removeCommentFrame(withDescription: "LongDescription")
        tag?.removeCommentFrame(withDescription: "Liner Notes")
        tag?.removeCommentFrame(withDescription: "Song Description")
        tag?.removeCommentFrame(withDescription: "Series Description")
        tag?.removeLyricsFrame(withDescription: "Lyrics")
        tag?.removeUserTextFrame(withDescription: "UserText")
        tag?.removeUserTextFrame(withDescription: "Acknowledgment")
        tag?.removeUserTextFrame(withDescription: "Thanks")
        tag?.removeUserTextFrame(withDescription: "Keywords")
        tag?.removeUserTextFrame(withDescription: "Network")
        tag?.removeUserTextFrame(withDescription: "Source Credit")
        tag?.removeUserTextFrame(withDescription: "Content Rating")
        tag?.removeUserTextFrame(withDescription: "Content Advisory")
        tag?.removeUserTextFrame(withDescription: "Season")
        tag?.removeUserTextFrame(withDescription: "Episode Number")
        tag?.removeUserTextFrame(withDescription: "Episode Name")
        tag?.removeUserTextFrame(withDescription: "Series Name")
        tag?.removeUserUrlFrame(withDescription: "Online Extras")
        tag?.removeUserUrlFrame(withDescription: "UserURL")
        
        let outputUrl = try localDirectory(fileName: "removaltest", fileExtension: "mp3")
        XCTAssertNoThrow(try TestFile.v22.mp3File()?.write(
            tagVersion: .v2_2,
            using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v22.url)),
            writingTo: outputUrl))
        
        // MARK: Confirm accuracy
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertNil(tagWritten.acknowledgment)
        XCTAssertNil(tagWritten.thanks)
        XCTAssertNil(tagWritten.contentAdvisory)
        XCTAssertNil(tagWritten.contentRating)
        XCTAssertNil(tagWritten.episodeName)
        XCTAssertNil(tagWritten.episodeNumber)
        XCTAssertNil(tagWritten.keywords)
        XCTAssertNil(tagWritten.onlineExtras)
        XCTAssertNil(tagWritten.season)
        XCTAssertNil(tagWritten.seriesName)
        XCTAssertNil(tagWritten.network)
        XCTAssertNil(tagWritten.sourceCredit)
    }
    
    func testFrameRemovalv23() throws {
        var tag = try TestFile.v23.tag()
        
        // check comment, lyrics, and subscripted user text visually in Yate
        tag?.removeCommentFrame(withDescription: "Comment")
        tag?.removeCommentFrame(withDescription: "Description")
        tag?.removeCommentFrame(withDescription: "LongDescription")
        tag?.removeCommentFrame(withDescription: "Liner Notes")
        tag?.removeCommentFrame(withDescription: "Song Description")
        tag?.removeCommentFrame(withDescription: "Series Description")
        tag?.removeLyricsFrame(withDescription: "Lyrics")
        tag?.removeUserTextFrame(withDescription: "UserText")
        tag?.removeUserTextFrame(withDescription: "Acknowledgment")
        tag?.removeUserTextFrame(withDescription: "Thanks")
        tag?.removeUserTextFrame(withDescription: "Keywords")
        tag?.removeUserTextFrame(withDescription: "Network")
        tag?.removeUserTextFrame(withDescription: "Source Credit")
        tag?.removeUserTextFrame(withDescription: "Content Rating")
        tag?.removeUserTextFrame(withDescription: "Content Advisory")
        tag?.removeUserTextFrame(withDescription: "Season")
        tag?.removeUserTextFrame(withDescription: "Episode Number")
        tag?.removeUserTextFrame(withDescription: "Episode Name")
        tag?.removeUserTextFrame(withDescription: "Series Name")
        tag?.removeUserUrlFrame(withDescription: "Online Extras")
        tag?.removeUserUrlFrame(withDescription: "UserURL")
        
        let outputUrl = try localDirectory(fileName: "removaltest", fileExtension: "mp3")
        XCTAssertNoThrow(try TestFile.v23.mp3File()?.write(
            tagVersion: .v2_3,
            using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v23.url)),
            writingTo: outputUrl))
        
        // MARK: Confirm accuracy
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertNil(tagWritten.acknowledgment)
        XCTAssertNil(tagWritten.thanks)
        XCTAssertNil(tagWritten.contentAdvisory)
        XCTAssertNil(tagWritten.contentRating)
        XCTAssertNil(tagWritten.episodeName)
        XCTAssertNil(tagWritten.episodeNumber)
        XCTAssertNil(tagWritten.keywords)
        XCTAssertNil(tagWritten.onlineExtras)
        XCTAssertNil(tagWritten.season)
        XCTAssertNil(tagWritten.seriesName)
        XCTAssertNil(tagWritten.network)
        XCTAssertNil(tagWritten.sourceCredit)
    }

    func testFrameRemovalv24() throws {
        var tag = try TestFile.v24.tag()
        
        // check comment, lyrics, and subscripted user text visually in Yate
        tag?.removeCommentFrame(withDescription: "Comment")
        tag?.removeCommentFrame(withDescription: "Description")
        tag?.removeCommentFrame(withDescription: "LongDescription")
        tag?.removeCommentFrame(withDescription: "Liner Notes")
        tag?.removeCommentFrame(withDescription: "Song Description")
        tag?.removeCommentFrame(withDescription: "Series Description")
        tag?.removeLyricsFrame(withDescription: "Lyrics")
        tag?.removeUserTextFrame(withDescription: "UserText")
        tag?.removeUserTextFrame(withDescription: "Acknowledgment")
        tag?.removeUserTextFrame(withDescription: "Thanks")
        tag?.removeUserTextFrame(withDescription: "Keywords")
        tag?.removeUserTextFrame(withDescription: "Network")
        tag?.removeUserTextFrame(withDescription: "Source Credit")
        tag?.removeUserTextFrame(withDescription: "Content Rating")
        tag?.removeUserTextFrame(withDescription: "Content Advisory")
        tag?.removeUserTextFrame(withDescription: "Season")
        tag?.removeUserTextFrame(withDescription: "Episode Number")
        tag?.removeUserTextFrame(withDescription: "Episode Name")
        tag?.removeUserTextFrame(withDescription: "Series Name")
        tag?.removeUserUrlFrame(withDescription: "Online Extras")
        tag?.removeUserUrlFrame(withDescription: "UserURL")
        
        let outputUrl = try localDirectory(fileName: "removaltest", fileExtension: "mp3")
        XCTAssertNoThrow(try TestFile.v24.mp3File()?.write(
            tagVersion: .v2_4,
            using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v24.url)),
            writingTo: outputUrl))
        
        // MARK: Confirm accuracy
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertNil(tagWritten.acknowledgment)
        XCTAssertNil(tagWritten.thanks)
        XCTAssertNil(tagWritten.contentAdvisory)
        XCTAssertNil(tagWritten.contentRating)
        XCTAssertNil(tagWritten.episodeName)
        XCTAssertNil(tagWritten.episodeNumber)
        XCTAssertNil(tagWritten.keywords)
        XCTAssertNil(tagWritten.onlineExtras)
        XCTAssertNil(tagWritten.season)
        XCTAssertNil(tagWritten.seriesName)
        XCTAssertNil(tagWritten.network)
        XCTAssertNil(tagWritten.sourceCredit)
    }

    func testLocalizedFrameWritingv24() throws {
        var tag = try TestFile.noMeta.tag()

        tag?[comments: .eng, "Comment"] = "Comment Content"
        tag?[lyrics: .eng, "Lyrics"] = "Lyrics Content"
        tag?[customComment: .eng, .description] = "Description Content"
        tag?[customComment: .eng, .linerNotes] = "Liner Notes Content"
        tag?[customComment: .eng, .longDescription] = "Long Description Content"
        tag?[customComment: .eng, .seriesDescription] = "Series Description Content"
        tag?[customComment: .eng, .songDescription] = "Song Description Content"
        
        tag?[userDefinedUrl: "UserURL"] = "http://userdefined.url"
        tag?.onlineExtras = "http://onlineextras.url"
        
        tag?[userDefinedText: "UserText"] = "User Text Content"
        tag?.thanks = "Thanks"
        tag?.sourceCredit = "Source Credit"
        tag?.season = 8
        tag?.seriesName = "Series Name"
        tag?.network = "Network"
        tag?.acknowledgment = "Acknowledgment"
        tag?.episodeName = "Episode Name"
        tag?.episodeNumber = 7
        tag?.keywords = ["Key","Words"]
        tag?.contentRating = .clean
        tag?.contentAdvisory = .usMovieUnrated

        let outputUrl = try tempDirectory().appendingPathComponent("testV24Writing.mp3")
        XCTAssertNoThrow(try TestFile.noMeta.mp3File()?.write(tagVersion: .v2_4, using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v24.url)), writingTo: outputUrl))
        
        // MARK: Confirm accuracy
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)

    }
    //
    func testWithOneValueWrittenOnBlankFile() throws {
    }
    
    func testOverwriting() throws {
    }
    
    func testOverwritingWithOnlyPart() throws {
    }
    
}
