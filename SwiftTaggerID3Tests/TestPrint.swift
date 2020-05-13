//
//  TestPrint.swift
//  SwiftTaggerID3Tests
//
//  Created by Nolaine Crusher on 4/28/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import XCTest
import SwiftTaggerID3

class TestPrint: XCTestCase {
    
    
    func testPrint() throws {
        let path = "/Users/nolainecrusher/Desktop/test output/testV24Writing.mp3"
        let mp3Url = URL(fileURLWithPath: path)
//        let mp3Url = Bundle.writtenV24
        let mp3File = try Mp3File(location: mp3Url)
        let mp3Data = mp3File.data
        
        let rangeIn = 1302
        let rangeOut = 1350
        let range = rangeIn ..< rangeOut
        
        let data = mp3Data.subdata(in: range)
        print(data.hexadecimal())
    }

  /*

     0 65 6e 67
     43 6f 6d 6d 65 6e 74 44 65 73 63 72 69 70 74 69 6f 6e 0
     43 6f 6d 6d 65 6e 74 20 43 6f 6e 74 65 6e 74

     0 65 6e 67 0
     43 6f 6d 6d 65 6e 74 0
     43 6f 6d 6d 65 6e 74 20 43 6f 6e 74 65 6e 74 0

     */
    
    
    
    
    func testProblems() throws {
        let mp3Url = Bundle.v23NoMeta
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        // MARK: Localized Frame
        tag[comments: .eng, "Comment"] = "Comment Content"
//        tag[lyrics: .eng, "Lyrics"] = "Lyrics Content" // same here - null term not working?
//        tag[customComment: .eng, .description] = "Description Content"
//        tag[customComment: .eng, .linerNotes] = "Liner Notes Content"
//        tag[customComment: .eng, .longDescription] = "Long Description Content"
//        tag[customComment: .eng, .seriesDescription] = "Series Description Content"
//        tag[customComment: .eng, .songDescription] = "Song Description Content"
//
//        tag[userDefinedUrl: "UserURL"] = "http://userdefined.url"
//        tag.onlineExtras = "http://onlineextras.url"
//
//        tag[userDefinedText: "UserText"] = "User Text Content"
//        tag.thanks = "Thanks"
//        tag.sourceCredit = "Source Credit"
//        tag.season = 8
//        tag.seriesName = "Series Name"
//        tag.network = "Network"
//        tag.acknowledgment = "Acknowledgment"
//        tag.episodeName = "Episode Name"
//        tag.episodeNumber = 7
//        tag.keywords = ["Key","Words"]
//        tag.contentRating = .clean
//        tag.contentAdvisory = .usMovieUnrated
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/testV24Writing.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))
        
        // MARK: Confirm accuracy
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
//        XCTAssertEqual(tagWritten.contentAdvisory, .usMovieUnrated)
//        XCTAssertEqual(tagWritten.contentRating, .clean)
//        XCTAssertEqual(tagWritten.episodeName, "Episode Name")
//        XCTAssertEqual(tagWritten.episodeNumber, 7)
//        XCTAssertEqual(tagWritten.keywords, ["Key","Words"])
//        XCTAssertEqual(tagWritten.network, "Network")
//        XCTAssertEqual(tagWritten.onlineExtras, "http://onlineextras.url")
//        XCTAssertEqual(tagWritten.season, 8)
//        XCTAssertEqual(tagWritten.seriesName, "Series Name")
//        XCTAssertEqual(tagWritten.sourceCredit, "Source Credit")
//        XCTAssertEqual(tagWritten.thanks, "Thanks")
        XCTAssertEqual(tagWritten[comments: .eng, "Comment"], "Comment Content")
    }
}

