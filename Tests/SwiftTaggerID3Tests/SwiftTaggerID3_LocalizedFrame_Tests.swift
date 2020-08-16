/*

 SwiftTaggerID3_LocalizedFrame_Tests.swift
 SwiftTaggerID3

 Copyright ©2020 Nolaine Crusher. All rights reserved.

 */

import XCTest
import SwiftTaggerID3



class SwiftTaggerID3_LocalizedFrame_Tests: XCTestCase {
    
    // Localized Frame tests
    @available(OSX 10.12, *)
    func testLocalizedFrameReadingv24() throws {
        let tag = try TestFile.v24.tag()

//        XCTAssertEqual(tag?.acknowledgment, "Acknowledgment")
//        XCTAssertEqual(tag?.keywords, ["Key","Words"])
//        XCTAssertEqual(tag?.contentAdvisory, .usMovieUnrated)
//        XCTAssertEqual(tag?.contentRating, .clean)
//        XCTAssertEqual(tag?.network, "Network")
//        XCTAssertEqual(tag?.episodeName, "Episode Name")
//        XCTAssertEqual(tag?.episodeNumber, 7)
        XCTAssertEqual(tag?.languages, [.eng])
//        XCTAssertEqual(tag?.thanks, "Thanks")
//        XCTAssertEqual(tag?.season, 8)
        XCTAssertEqual(tag?.series, "Content Group")
//        XCTAssertEqual(tag?.seriesName, "Series Name")
//        XCTAssertEqual(tag?.sourceCredit, "Source Credit")
        XCTAssertEqual(tag?.studio, "Publisher")
//        XCTAssertEqual(tag?.onlineExtras, "http://onlineextras.url")
        XCTAssertEqual(tag?[comments: .eng, "Comment"], "Comment Content")
        XCTAssertEqual(tag?[comments: .eng, "Description"], "Description Content")
        XCTAssertEqual(tag?[comments: .eng, "LongDescription"], "Long Description Content")
        XCTAssertEqual(tag?[comments: .eng, "Series Description"], "Series Description Content")
        XCTAssertEqual(tag?[comments: .eng, "Liner Notes"], "Liner Notes Content")
        XCTAssertEqual(tag?[lyrics: .eng, "Lyrics"], "Lyrics Content")
        XCTAssertEqual(tag?[userDefinedText: "UserText"], "User Text Content")
        XCTAssertEqual(tag?[userDefinedUrl: "UserURL"], "http://userdefined.url")
    }
    
    @available(OSX 10.12, *)
    func testLocalizedFrameReadingv23() throws {
        let tag = try TestFile.v23.tag()
        
//        XCTAssertEqual(tag?.acknowledgment, "Acknowledgment")
//        XCTAssertEqual(tag?.keywords, ["Key","Words"])
//        XCTAssertEqual(tag?.contentAdvisory, .usMovieUnrated)
//        XCTAssertEqual(tag?.contentRating, .clean)
//        XCTAssertEqual(tag?.network, "Network")
//        XCTAssertEqual(tag?.episodeName, "Episode Name")
//        XCTAssertEqual(tag?.episodeNumber, 7)
        XCTAssertEqual(tag?.languages, [.eng])
//        XCTAssertEqual(tag?.thanks, "Thanks")
//        XCTAssertEqual(tag?.season, 8)
        XCTAssertEqual(tag?.series, "Content Group")
//        XCTAssertEqual(tag?.seriesName, "Series Name")
//        XCTAssertEqual(tag?.sourceCredit, "Source Credit")
        XCTAssertEqual(tag?.studio, "Publisher")
//        XCTAssertEqual(tag?.onlineExtras, "http://onlineextras.url")
        XCTAssertEqual(tag?[comments: .eng, "Comment"], "Comment Content")
        XCTAssertEqual(tag?[comments: .eng, "Description"], "Description Content")
        XCTAssertEqual(tag?[comments: .eng, "LongDescription"], "Long Description Content")
        XCTAssertEqual(tag?[comments: .eng, "Series Description"], "Series Description Content")
        XCTAssertEqual(tag?[comments: .eng, "Liner Notes"], "Liner Notes Content")
        XCTAssertEqual(tag?[lyrics: .eng, "Lyrics"], "Lyrics Content")
        XCTAssertEqual(tag?[userDefinedText: "UserText"], "User Text Content")
        XCTAssertEqual(tag?[userDefinedUrl: "UserURL"], "http://userdefined.url")
    }

    @available(OSX 10.12, *)
    func testLocalizedFrameReadingv22() throws {
        let tag = try TestFile.v22.tag()
        
//        XCTAssertEqual(tag?.acknowledgment, "Acknowledgment")
//        XCTAssertEqual(tag?.keywords, ["Key","Words"])
//        XCTAssertEqual(tag?.contentAdvisory, .usMovieUnrated)
//        XCTAssertEqual(tag?.contentRating, .clean)
//        XCTAssertEqual(tag?.network, "Network")
//        XCTAssertEqual(tag?.episodeName, "Episode Name")
//        XCTAssertEqual(tag?.episodeNumber, 7)
        XCTAssertEqual(tag?.languages, [.eng])
//        XCTAssertEqual(tag?.thanks, "Thanks")
//        XCTAssertEqual(tag?.season, 8)
        XCTAssertEqual(tag?.series, "Content Group")
//        XCTAssertEqual(tag?.seriesName, "Series Name")
//        XCTAssertEqual(tag?.sourceCredit, "Source Credit")
        XCTAssertEqual(tag?.studio, "Publisher")
//        XCTAssertEqual(tag?.onlineExtras, "http://onlineextras.url")
        XCTAssertEqual(tag?[comments: .eng, "Comment"], "Comment Content")
        XCTAssertEqual(tag?[comments: .eng, "Description"], "Description Content")
        XCTAssertEqual(tag?[comments: .eng, "LongDescription"], "Long Description Content")
        XCTAssertEqual(tag?[comments: .eng, "Series Description"], "Series Description Content")
        XCTAssertEqual(tag?[comments: .eng, "Liner Notes"], "Liner Notes Content")
        XCTAssertEqual(tag?[lyrics: .eng, "Lyrics"], "Lyrics Content")
        XCTAssertEqual(tag?[userDefinedText: "UserText"], "User Text Content")
        XCTAssertEqual(tag?[userDefinedUrl: "UserURL"], "http://userdefined.url")        
    }

    @available(OSX 10.12, *)
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
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        XCTAssertNoThrow(try TestFile.v22.mp3File()?.write(
            tagVersion: .v2_2,
            using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v22.url)),
            writingTo: outputUrl))
        
        
//        let mp3UrlWritten = outputUrl
//        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
//        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
//        XCTAssertNil(tagWritten.acknowledgment)
//        XCTAssertNil(tagWritten.thanks)
//        XCTAssertNil(tagWritten.contentAdvisory)
//        XCTAssertNil(tagWritten.contentRating)
//        XCTAssertNil(tagWritten.episodeName)
//        XCTAssertNil(tagWritten.episodeNumber)
//        XCTAssertNil(tagWritten.keywords)
//        XCTAssertNil(tagWritten.onlineExtras)
//        XCTAssertNil(tagWritten.season)
//        XCTAssertNil(tagWritten.seriesName)
//        XCTAssertNil(tagWritten.network)
//        XCTAssertNil(tagWritten.sourceCredit)
    }
    
    @available(OSX 10.12, *)
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
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        XCTAssertNoThrow(try TestFile.v23.mp3File()?.write(
            tagVersion: .v2_3,
            using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v23.url)),
            writingTo: outputUrl))
        
        
//        let mp3UrlWritten = outputUrl
//        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
//        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
//        XCTAssertNil(tagWritten.acknowledgment)
//        XCTAssertNil(tagWritten.thanks)
//        XCTAssertNil(tagWritten.contentAdvisory)
//        XCTAssertNil(tagWritten.contentRating)
//        XCTAssertNil(tagWritten.episodeName)
//        XCTAssertNil(tagWritten.episodeNumber)
//        XCTAssertNil(tagWritten.keywords)
//        XCTAssertNil(tagWritten.onlineExtras)
//        XCTAssertNil(tagWritten.season)
//        XCTAssertNil(tagWritten.seriesName)
//        XCTAssertNil(tagWritten.network)
//        XCTAssertNil(tagWritten.sourceCredit)
    }

    @available(OSX 10.12, *)
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
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        XCTAssertNoThrow(try TestFile.v24.mp3File()?.write(
            tagVersion: .v2_4,
            using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v24.url)),
            writingTo: outputUrl))
        
        
//        let mp3UrlWritten = outputUrl
//        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
//        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
//        XCTAssertNil(tagWritten.acknowledgment)
//        XCTAssertNil(tagWritten.thanks)
//        XCTAssertNil(tagWritten.contentAdvisory)
//        XCTAssertNil(tagWritten.contentRating)
//        XCTAssertNil(tagWritten.episodeName)
//        XCTAssertNil(tagWritten.episodeNumber)
//        XCTAssertNil(tagWritten.keywords)
//        XCTAssertNil(tagWritten.onlineExtras)
//        XCTAssertNil(tagWritten.season)
//        XCTAssertNil(tagWritten.seriesName)
//        XCTAssertNil(tagWritten.network)
//        XCTAssertNil(tagWritten.sourceCredit)
    }

    @available(OSX 10.12, *)
    func testLocalizedFrameWritingv24() throws {
        var tag = try TestFile.noMeta.tag()

        tag?[comments: .eng, "Comment"] = "Comment Content"
        tag?[lyrics: .eng, "Lyrics"] = "Lyrics Content"
        tag?[userDefinedUrl: "UserURL"] = "http://userdefined.url"
        tag?[userDefinedText: "UserText"] = "User Text Content"
//        tag?.onlineExtras = "http://onlineextras.url"        
//        tag?.thanks = "Thanks"
//        tag?.sourceCredit = "Source Credit"
//        tag?.season = 8
//        tag?.seriesName = "Series Name"
//        tag?.network = "Network"
//        tag?.acknowledgment = "Acknowledgment"
//        tag?.episodeName = "Episode Name"
//        tag?.episodeNumber = 7
//        tag?.keywords = ["Key","Words"]
//        tag?.contentRating = .clean
//        tag?.contentAdvisory = .usMovieUnrated

        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        XCTAssertNoThrow(try TestFile.noMeta.mp3File()?.write(tagVersion: .v2_4, using: tag ?? Tag(readFrom: Mp3File(location: TestFile.noMeta.url)), writingTo: outputUrl))
        
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten[comments: .eng, "Comment"], "Comment Content")
        XCTAssertEqual(tagWritten[customComment: .eng, .description], "Description Content")
        XCTAssertEqual(tagWritten[customComment: .eng, .linerNotes], "Liner Notes Content")
        XCTAssertEqual(tagWritten[customComment: .eng, .longDescription], "Long Description Content")
        XCTAssertEqual(tagWritten[customComment: .eng, .songDescription], "Song Description Content")
        XCTAssertEqual(tagWritten[customComment: .eng, .seriesDescription], "Series Description Content")
        XCTAssertEqual(tagWritten[lyrics: .eng, "Lyrics"], "Lyrics Content")
        XCTAssertEqual(tagWritten[userDefinedUrl: "UserURL"], "http://userdefined.url")
//        XCTAssertEqual(tagWritten.onlineExtras, "http://onlineextras.url")
        XCTAssertEqual(tagWritten[userDefinedText: "UserText"], "User Text Content")
//        XCTAssertEqual(tagWritten.acknowledgment, "Acknowledgment")
//        XCTAssertEqual(tagWritten.contentRating, .clean)
//        XCTAssertEqual(tagWritten.contentAdvisory, .usMovieUnrated)
//        XCTAssertEqual(tagWritten.episodeName, "Episode Name")
//        XCTAssertEqual(tagWritten.episodeNumber, 7)
//        XCTAssertEqual(tagWritten.keywords, ["Key","Words"])
//        XCTAssertEqual(tagWritten.network, "Network")
//        XCTAssertEqual(tagWritten.season, 8)
//        XCTAssertEqual(tagWritten.seriesName, "Series Name")
//        XCTAssertEqual(tagWritten.sourceCredit, "Source Credit")
//        XCTAssertEqual(tagWritten.thanks, "Thanks")
    }
    
    @available(OSX 10.12, *)
    func testLocalizedFrameWritingv23() throws {
        var tag = try TestFile.noMeta.tag()
        
        tag?[comments: .eng, "Comment"] = "Comment Content"
        tag?[lyrics: .eng, "Lyrics"] = "Lyrics Content"
        tag?[customComment: .eng, .description] = "Description Content"
        tag?[customComment: .eng, .linerNotes] = "Liner Notes Content"
        tag?[customComment: .eng, .longDescription] = "Long Description Content"
        tag?[customComment: .eng, .seriesDescription] = "Series Description Content"
        tag?[customComment: .eng, .songDescription] = "Song Description Content"
        
        tag?[userDefinedUrl: "UserURL"] = "http://userdefined.url"
//        tag?.onlineExtras = "http://onlineextras.url"
        
        tag?[userDefinedText: "UserText"] = "User Text Content"
//        tag?.thanks = "Thanks"
//        tag?.sourceCredit = "Source Credit"
//        tag?.season = 8
//        tag?.seriesName = "Series Name"
//        tag?.network = "Network"
//        tag?.acknowledgment = "Acknowledgment"
//        tag?.episodeName = "Episode Name"
//        tag?.episodeNumber = 7
//        tag?.keywords = ["Key","Words"]
//        tag?.contentRating = .clean
//        tag?.contentAdvisory = .usMovieUnrated
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        XCTAssertNoThrow(try TestFile.noMeta.mp3File()?.write(tagVersion: .v2_3, using: tag ?? Tag(readFrom: Mp3File(location: TestFile.noMeta.url)), writingTo: outputUrl))
        
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten[comments: .eng, "Comment"], "Comment Content")
        XCTAssertEqual(tagWritten[customComment: .eng, .description], "Description Content")
        XCTAssertEqual(tagWritten[customComment: .eng, .linerNotes], "Liner Notes Content")
        XCTAssertEqual(tagWritten[customComment: .eng, .longDescription], "Long Description Content")
        XCTAssertEqual(tagWritten[customComment: .eng, .songDescription], "Song Description Content")
        XCTAssertEqual(tagWritten[customComment: .eng, .seriesDescription], "Series Description Content")
        XCTAssertEqual(tagWritten[lyrics: .eng, "Lyrics"], "Lyrics Content")
        XCTAssertEqual(tagWritten[userDefinedUrl: "UserURL"], "http://userdefined.url")
//        XCTAssertEqual(tagWritten.onlineExtras, "http://onlineextras.url")
        XCTAssertEqual(tagWritten[userDefinedText: "UserText"], "User Text Content")
//        XCTAssertEqual(tagWritten.acknowledgment, "Acknowledgment")
//        XCTAssertEqual(tagWritten.contentRating, .clean)
//        XCTAssertEqual(tagWritten.contentAdvisory, .usMovieUnrated)
//        XCTAssertEqual(tagWritten.episodeName, "Episode Name")
//        XCTAssertEqual(tagWritten.episodeNumber, 7)
//        XCTAssertEqual(tagWritten.keywords, ["Key","Words"])
//        XCTAssertEqual(tagWritten.network, "Network")
//        XCTAssertEqual(tagWritten.season, 8)
//        XCTAssertEqual(tagWritten.seriesName, "Series Name")
//        XCTAssertEqual(tagWritten.sourceCredit, "Source Credit")
//        XCTAssertEqual(tagWritten.thanks, "Thanks")
    }

    @available(OSX 10.12, *)
    func testLocalizedFrameWritingv22() throws {
        var tag = try TestFile.noMeta.tag()
        
        tag?[comments: .eng, "Comment"] = "Comment Content"
        tag?[lyrics: .eng, "Lyrics"] = "Lyrics Content"
        tag?[customComment: .eng, .description] = "Description Content"
        tag?[customComment: .eng, .linerNotes] = "Liner Notes Content"
        tag?[customComment: .eng, .longDescription] = "Long Description Content"
        tag?[customComment: .eng, .seriesDescription] = "Series Description Content"
        tag?[customComment: .eng, .songDescription] = "Song Description Content"
        
        tag?[userDefinedUrl: "UserURL"] = "http://userdefined.url"
//        tag?.onlineExtras = "http://onlineextras.url"
        
        tag?[userDefinedText: "UserText"] = "User Text Content"
//        tag?.thanks = "Thanks"
//        tag?.sourceCredit = "Source Credit"
//        tag?.season = 8
//        tag?.seriesName = "Series Name"
//        tag?.network = "Network"
//        tag?.acknowledgment = "Acknowledgment"
//        tag?.episodeName = "Episode Name"
//        tag?.episodeNumber = 7
//        tag?.keywords = ["Key","Words"]
//        tag?.contentRating = .clean
//        tag?.contentAdvisory = .usMovieUnrated
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        XCTAssertNoThrow(try TestFile.noMeta.mp3File()?.write(tagVersion: .v2_2, using: tag ?? Tag(readFrom: Mp3File(location: TestFile.noMeta.url)), writingTo: outputUrl))
        
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten[comments: .eng, "Comment"], "Comment Content")
        XCTAssertEqual(tagWritten[customComment: .eng, .description], "Description Content")
        XCTAssertEqual(tagWritten[customComment: .eng, .linerNotes], "Liner Notes Content")
        XCTAssertEqual(tagWritten[customComment: .eng, .longDescription], "Long Description Content")
        XCTAssertEqual(tagWritten[customComment: .eng, .songDescription], "Song Description Content")
        XCTAssertEqual(tagWritten[customComment: .eng, .seriesDescription], "Series Description Content")
        XCTAssertEqual(tagWritten[lyrics: .eng, "Lyrics"], "Lyrics Content")
        XCTAssertEqual(tagWritten[userDefinedUrl: "UserURL"], "http://userdefined.url")
//        XCTAssertEqual(tagWritten.onlineExtras, "http://onlineextras.url")
        XCTAssertEqual(tagWritten[userDefinedText: "UserText"], "User Text Content")
//        XCTAssertEqual(tagWritten.acknowledgment, "Acknowledgment")
//        XCTAssertEqual(tagWritten.contentRating, .clean)
//        XCTAssertEqual(tagWritten.contentAdvisory, .usMovieUnrated)
//        XCTAssertEqual(tagWritten.episodeName, "Episode Name")
//        XCTAssertEqual(tagWritten.episodeNumber, 7)
//        XCTAssertEqual(tagWritten.keywords, ["Key","Words"])
//        XCTAssertEqual(tagWritten.network, "Network")
//        XCTAssertEqual(tagWritten.season, 8)
//        XCTAssertEqual(tagWritten.seriesName, "Series Name")
//        XCTAssertEqual(tagWritten.sourceCredit, "Source Credit")
//        XCTAssertEqual(tagWritten.thanks, "Thanks")
    }

    @available(OSX 10.12, *)
    func testLocalizedFrameOverwritingV24() throws {
        var tag = try TestFile.v24.tag()
        
//        tag?.acknowledgment = "New Acknowledgment"
//        tag?.contentAdvisory = .ustvUnrated
//        tag?.contentRating = .explicit
//        tag?.episodeName = "New Episode"
//        tag?.episodeNumber = 5
//        tag?.keywords = ["Word", "Keys"]
//        tag?.network = "New Network"
//        tag?.season = 6
//        tag?.seriesName = "New Series Name"
//        tag?.sourceCredit = "New Source Credit"
//        tag?.thanks = "New Thanks"
//        tag?.onlineExtras = "http://onlineextras.com"
        tag?[comments: .eng, "Comment"] =
        """
        New
        Comment
        Content
        """
        tag?[lyrics: .eng, "Lyrics"] =
        """
        New
        Lyrics
        Content
        """
        tag?[userDefinedText: "UserText"] = "New User Text Content"
        tag?[userDefinedUrl: "UserUrl"] = "http://userdefined.com"
        tag?[customComment: .eng, .description] =
        """
        New
        Description
        Content
        """
        tag?[customComment: .eng, .longDescription] =
        """
        New
        Long Description
        Content
        """
        tag?[customComment: .eng, .seriesDescription] =
        """
        New
        Series Description
        Content
        """
        tag?[customComment: .eng, .linerNotes] =
        """
        New
        Liner Notes
        Content
        """
        tag?[customComment: .eng, .songDescription] =
        """
        New
        Song Description
        Content
        """

        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        XCTAssertNoThrow(try TestFile.v24.mp3File()?.write(tagVersion: .v2_4, using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v24.url)), writingTo: outputUrl))
        
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        

//        XCTAssertEqual(tagWritten.acknowledgment, "New Acknowledgment")
//        XCTAssertEqual(tagWritten.contentAdvisory, .ustvUnrated)
//        XCTAssertEqual(tagWritten.contentRating, .explicit)
//        XCTAssertEqual(tagWritten.episodeName, "New Episode")
//        XCTAssertEqual(tagWritten.episodeNumber, 5)
//        XCTAssertEqual(tagWritten.keywords, ["Word", "Keys"])
//        XCTAssertEqual(tagWritten.network, "New Network")
//        XCTAssertEqual(tagWritten.onlineExtras, "http://onlineextras.com")
//        XCTAssertEqual(tagWritten.season, 6)
//        XCTAssertEqual(tagWritten.seriesName, "New Series Name")
//        XCTAssertEqual(tagWritten.sourceCredit, "New Source Credit")
//        XCTAssertEqual(tagWritten.thanks, "New Thanks")
        XCTAssertEqual(tagWritten[comments: .eng, "Comment"],
        """
        New
        Comment
        Content
        """)
        XCTAssertEqual(tagWritten[lyrics: .eng, "Lyrics"],
        """
        New
        Lyrics
        Content
        """)
        XCTAssertEqual(tagWritten[userDefinedText: "UserText"], "New User Text Content")
        XCTAssertEqual(tagWritten[userDefinedUrl: "UserUrl"], "http://userdefined.com")
        XCTAssertEqual(tagWritten[customComment: .eng, .description],
        """
        New
        Description
        Content
        """)
        XCTAssertEqual(tagWritten[customComment: .eng, .longDescription],
        """
        New
        Long Description
        Content
        """)
        XCTAssertEqual(tagWritten[customComment: .eng, .seriesDescription],
        """
        New
        Series Description
        Content
        """)
        XCTAssertEqual(tagWritten[customComment: .eng, .linerNotes],
        """
        New
        Liner Notes
        Content
        """)
        XCTAssertEqual(tagWritten[customComment: .eng, .songDescription],
        """
        New
        Song Description
        Content
        """)
    }

    @available(OSX 10.12, *)
    func testLocalizedFrameOverwritingV23() throws {
        var tag = try TestFile.v23.tag()
        
//        tag?.acknowledgment = "New Acknowledgment"
//        tag?.contentAdvisory = .ustvUnrated
//        tag?.contentRating = .explicit
//        tag?.episodeName = "New Episode"
//        tag?.episodeNumber = 5
//        tag?.keywords = ["Word", "Keys"]
//        tag?.network = "New Network"
//        tag?.season = 6
//        tag?.seriesName = "New Series Name"
//        tag?.sourceCredit = "New Source Credit"
//        tag?.thanks = "New Thanks"
//        tag?.onlineExtras = "http://onlineextras.com"
        tag?[comments: .eng, "Comment"] =
        """
        New
        Comment
        Content
        """
        tag?[lyrics: .eng, "Lyrics"] =
        """
        New
        Lyrics
        Content
        """
        tag?[userDefinedText: "UserText"] = "New User Text Content"
        tag?[userDefinedUrl: "UserUrl"] = "http://userdefined.com"
        tag?[customComment: .eng, .description] =
        """
        New
        Description
        Content
        """
        tag?[customComment: .eng, .longDescription] =
        """
        New
        Long Description
        Content
        """
        tag?[customComment: .eng, .seriesDescription] =
        """
        New
        Series Description
        Content
        """
        tag?[customComment: .eng, .linerNotes] =
        """
        New
        Liner Notes
        Content
        """
        tag?[customComment: .eng, .songDescription] =
        """
        New
        Song Description
        Content
        """
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        XCTAssertNoThrow(try TestFile.v23.mp3File()?.write(tagVersion: .v2_3, using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v23.url)), writingTo: outputUrl))
        
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        
//        XCTAssertEqual(tagWritten.acknowledgment, "New Acknowledgment")
//        XCTAssertEqual(tagWritten.contentAdvisory, .ustvUnrated)
//        XCTAssertEqual(tagWritten.contentRating, .explicit)
//        XCTAssertEqual(tagWritten.episodeName, "New Episode")
//        XCTAssertEqual(tagWritten.episodeNumber, 5)
//        XCTAssertEqual(tagWritten.keywords, ["Word", "Keys"])
//        XCTAssertEqual(tagWritten.network, "New Network")
//        XCTAssertEqual(tagWritten.onlineExtras, "http://onlineextras.com")
//        XCTAssertEqual(tagWritten.season, 6)
//        XCTAssertEqual(tagWritten.seriesName, "New Series Name")
//        XCTAssertEqual(tagWritten.sourceCredit, "New Source Credit")
//        XCTAssertEqual(tagWritten.thanks, "New Thanks")
        XCTAssertEqual(tagWritten[comments: .eng, "Comment"],
                       """
        New
        Comment
        Content
        """)
        XCTAssertEqual(tagWritten[lyrics: .eng, "Lyrics"],
                       """
        New
        Lyrics
        Content
        """)
        XCTAssertEqual(tagWritten[userDefinedText: "UserText"], "New User Text Content")
        XCTAssertEqual(tagWritten[userDefinedUrl: "UserUrl"], "http://userdefined.com")
        XCTAssertEqual(tagWritten[customComment: .eng, .description],
                       """
        New
        Description
        Content
        """)
        XCTAssertEqual(tagWritten[customComment: .eng, .longDescription],
                       """
        New
        Long Description
        Content
        """)
        XCTAssertEqual(tagWritten[customComment: .eng, .seriesDescription],
                       """
        New
        Series Description
        Content
        """)
        XCTAssertEqual(tagWritten[customComment: .eng, .linerNotes],
                       """
        New
        Liner Notes
        Content
        """)
        XCTAssertEqual(tagWritten[customComment: .eng, .songDescription],
                       """
        New
        Song Description
        Content
        """)
    }

    @available(OSX 10.12, *)
    func testLocalizedFrameOverwritingV22() throws {
        var tag = try TestFile.v22.tag()
        
//        tag?.acknowledgment = "New Acknowledgment"
//        tag?.contentAdvisory = .ustvUnrated
//        tag?.contentRating = .explicit
//        tag?.episodeName = "New Episode"
//        tag?.episodeNumber = 5
//        tag?.keywords = ["Word", "Keys"]
//        tag?.network = "New Network"
//        tag?.season = 6
//        tag?.seriesName = "New Series Name"
//        tag?.sourceCredit = "New Source Credit"
//        tag?.thanks = "New Thanks"
//        tag?.onlineExtras = "http://onlineextras.com"
        tag?[comments: .eng, "Comment"] =
        """
        New
        Comment
        Content
        """
        tag?[lyrics: .eng, "Lyrics"] =
        """
        New
        Lyrics
        Content
        """
        tag?[userDefinedText: "UserText"] = "New User Text Content"
        tag?[userDefinedUrl: "UserUrl"] = "http://userdefined.com"
        tag?[customComment: .eng, .description] =
        """
        New
        Description
        Content
        """
        tag?[customComment: .eng, .longDescription] =
        """
        New
        Long Description
        Content
        """
        tag?[customComment: .eng, .seriesDescription] =
        """
        New
        Series Description
        Content
        """
        tag?[customComment: .eng, .linerNotes] =
        """
        New
        Liner Notes
        Content
        """
        tag?[customComment: .eng, .songDescription] =
        """
        New
        Song Description
        Content
        """
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        XCTAssertNoThrow(try TestFile.v22.mp3File()?.write(tagVersion: .v2_2, using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v22.url)), writingTo: outputUrl))
        
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        
//        XCTAssertEqual(tagWritten.acknowledgment, "New Acknowledgment")
//        XCTAssertEqual(tagWritten.contentAdvisory, .ustvUnrated)
//        XCTAssertEqual(tagWritten.contentRating, .explicit)
//        XCTAssertEqual(tagWritten.episodeName, "New Episode")
//        XCTAssertEqual(tagWritten.episodeNumber, 5)
//        XCTAssertEqual(tagWritten.keywords, ["Word", "Keys"])
//        XCTAssertEqual(tagWritten.network, "New Network")
//        XCTAssertEqual(tagWritten.onlineExtras, "http://onlineextras.com")
//        XCTAssertEqual(tagWritten.season, 6)
//        XCTAssertEqual(tagWritten.seriesName, "New Series Name")
//        XCTAssertEqual(tagWritten.sourceCredit, "New Source Credit")
//        XCTAssertEqual(tagWritten.thanks, "New Thanks")
        XCTAssertEqual(tagWritten[comments: .eng, "Comment"],
                       """
        New
        Comment
        Content
        """)
        XCTAssertEqual(tagWritten[lyrics: .eng, "Lyrics"],
                       """
        New
        Lyrics
        Content
        """)
        XCTAssertEqual(tagWritten[userDefinedText: "UserText"], "New User Text Content")
        XCTAssertEqual(tagWritten[userDefinedUrl: "UserUrl"], "http://userdefined.com")
        XCTAssertEqual(tagWritten[customComment: .eng, .description],
                       """
        New
        Description
        Content
        """)
        XCTAssertEqual(tagWritten[customComment: .eng, .longDescription],
                       """
        New
        Long Description
        Content
        """)
        XCTAssertEqual(tagWritten[customComment: .eng, .seriesDescription],
                       """
        New
        Series Description
        Content
        """)
        XCTAssertEqual(tagWritten[customComment: .eng, .linerNotes],
                       """
        New
        Liner Notes
        Content
        """)
        XCTAssertEqual(tagWritten[customComment: .eng, .songDescription],
                       """
        New
        Song Description
        Content
        """)
    }
    
    @available(OSX 10.12, *)
    func testLanguageFrameReading() throws {
        let tagV24 = try TestFile.v24.tag()
        let tagV23 = try TestFile.v23.tag()
        let tagV22 = try TestFile.v22.tag()

        XCTAssertEqual(tagV24?.languages, [.eng])
        XCTAssertEqual(tagV23?.languages, [.eng])
        XCTAssertEqual(tagV22?.languages, [.eng])
    }
    
    @available(OSX 10.12, *)
    func testLanguageFrameWritingV24() throws {
        var tag = try TestFile.noMeta.tag()
        
        tag?.languages = ISO6392Codes.allCases
        
        let output = try tempDirectory().appendingPathComponent("test.mp3")
        XCTAssertNoThrow(try TestFile.noMeta.mp3File()?.write(tagVersion: .v2_4, using: tag ?? Tag(readFrom: Mp3File(location: TestFile.noMeta.url)), writingTo: output))

        let fileWritten = try Mp3File(location: output)
        let tagWritten = try Tag(readFrom: fileWritten)
        XCTAssertEqual(tagWritten.languages, ISO6392Codes.allCases)
    }

    @available(OSX 10.12, *)
    func testLanguageFrameWritingV23() throws {
        var tag = try TestFile.noMeta.tag()
        
        tag?.languages = ISO6392Codes.allCases
        
        let output = try tempDirectory().appendingPathComponent("test.mp3")
        XCTAssertNoThrow(try TestFile.noMeta.mp3File()?.write(tagVersion: .v2_3, using: tag ?? Tag(readFrom: Mp3File(location: TestFile.noMeta.url)), writingTo: output))
        
        let fileWritten = try Mp3File(location: output)
        let tagWritten = try Tag(readFrom: fileWritten)
        XCTAssertEqual(tagWritten.languages, ISO6392Codes.allCases)
    }

    @available(OSX 10.12, *)
    func testLanguageFrameWritingV22() throws {
        var tag = try TestFile.noMeta.tag()
        
        tag?.languages = ISO6392Codes.allCases
        
        let output = try tempDirectory().appendingPathComponent("test.mp3")
        XCTAssertNoThrow(try TestFile.noMeta.mp3File()?.write(tagVersion: .v2_2, using: tag ?? Tag(readFrom: Mp3File(location: TestFile.noMeta.url)), writingTo: output))
        
        let fileWritten = try Mp3File(location: output)
        let tagWritten = try Tag(readFrom: fileWritten)
        XCTAssertEqual(tagWritten.languages, ISO6392Codes.allCases)
    }
}
