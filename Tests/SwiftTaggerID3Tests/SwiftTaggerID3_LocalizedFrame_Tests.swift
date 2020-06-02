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

    //
    func testWithOneValueWrittenOnBlankFile() throws {
    }
    
    func testOverwriting() throws {
    }
    
    func testOverwritingWithOnlyPart() throws {
    }
    
}
