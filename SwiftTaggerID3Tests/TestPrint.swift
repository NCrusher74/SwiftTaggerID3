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
        
        tag.genre?.presetGenre = GenreType.none
        tag.genre?.customGenre = "Custom Genre"
        tag.mediaType?.mediaType = .otherDigital
        tag.mediaType?.mediaTypeRefinement = .analogTransfer
        tag.mediaType?.additionalInformation = "Media Type String"
        tag.fileType?.fileType = .MPG
        tag.fileType?.fileTypeRefinement = .mpegLayerIII
        tag.fileType?.additionalInformation = "File Type String"
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/testV24Writing.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))
        
        // MARK: Confirm accuracy
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.genre?.presetGenre, GenreType.none)
        XCTAssertEqual(tagWritten.genre?.customGenre, "Custom Genre")
        XCTAssertEqual(tagWritten.mediaType?.mediaType, .otherDigital)
        XCTAssertEqual(tagWritten.mediaType?.mediaTypeRefinement, .analogTransfer)
        XCTAssertEqual(tagWritten.mediaType?.additionalInformation, "Media Type String")
        XCTAssertEqual(tagWritten.fileType?.fileType, .MPG)
        XCTAssertEqual(tagWritten.fileType?.fileTypeRefinement, .mpegLayerIII)
        XCTAssertEqual(tagWritten.fileType?.additionalInformation, "File Type String")        
    }
}

