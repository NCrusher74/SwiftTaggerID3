//
//  SwiftTaggerMp3_DateFrame_Tests.swift
//  SwiftTaggerID3Tests
//
//  Created by Nolaine Crusher on 5/18/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import XCTest
import SwiftTaggerID3

class SwiftTaggerMp3_DateFrame_Tests: XCTestCase {

    func testTENCExpectedInputComponentsBlankFileV24() throws {
        let mp3Url = Bundle.v23NoMeta
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)

        tag.encodingDateTime?.year = 2002
        tag.encodingDateTime?.month = 11
        tag.encodingDateTime?.day = 7
        tag.encodingDateTime?.hour = 9
        tag.encodingDateTime?.minute = 23
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/FrameTENCtest1.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))
        
        // MARK: Confirm accuracy
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)

        XCTAssertEqual(tagWritten.encodingDateTime?.year, 2002)
        XCTAssertEqual(tagWritten.encodingDateTime?.month, 11)
        XCTAssertEqual(tagWritten.encodingDateTime?.day, 7)
        XCTAssertEqual(tagWritten.encodingDateTime?.hour, 9)
        XCTAssertEqual(tagWritten.encodingDateTime?.minute, 23)
    }

}
