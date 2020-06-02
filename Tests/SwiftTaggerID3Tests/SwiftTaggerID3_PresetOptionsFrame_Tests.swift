//
//  SwiftTaggerID3_PresetOptionsFrame_Tests.swift
//  
//
//  Created by Nolaine Crusher on 6/1/20.
//

import XCTest
import SwiftTaggerID3


@available(OSX 10.12, *)
class SwiftTaggerID3_PresetOptionsFrame_Tests: XCTestCase {
    
    func testPresetOptionsReadingV24() throws {
        let tag = try TestFile.v24.tag()
        XCTAssertNil(tag?.fileType?.fileType)
        XCTAssertNil(tag?.fileType?.fileTypeRefinement)
        XCTAssertEqual(tag?.fileType?.additionalInformation, "File Type")
        XCTAssertEqual(tag?.genre?.presetGenre, .Audiobook)
        XCTAssertEqual(tag?.genre?.customGenre, "Genre Type")
        XCTAssertNil(tag?.mediaType?.mediaType)
        XCTAssertNil(tag?.mediaType?.mediaTypeRefinement)
        XCTAssertEqual(tag?.mediaType?.additionalInformation, "Media Type")
    }

    func testPresetOptionsReadingV23() throws {
        let tag = try TestFile.v23.tag()
        XCTAssertNil(tag?.fileType?.fileType)
        XCTAssertNil(tag?.fileType?.fileTypeRefinement)
        XCTAssertEqual(tag?.fileType?.additionalInformation, "File Type")
        XCTAssertEqual(tag?.genre?.presetGenre, .Audiobook)
        XCTAssertEqual(tag?.genre?.customGenre, "Genre Type")
        XCTAssertNil(tag?.mediaType?.mediaType)
        XCTAssertNil(tag?.mediaType?.mediaTypeRefinement)
        XCTAssertEqual(tag?.mediaType?.additionalInformation, "Media Type")
    }

    func testPresetOptionsReadingV22() throws {
        let tag = try TestFile.v22.tag()
        XCTAssertNil(tag?.fileType?.fileType)
        XCTAssertNil(tag?.fileType?.fileTypeRefinement)
        XCTAssertEqual(tag?.fileType?.additionalInformation, "File Type")
        XCTAssertEqual(tag?.genre?.presetGenre, .Audiobook)
        XCTAssertEqual(tag?.genre?.customGenre, "Genre Type")
        XCTAssertNil(tag?.mediaType?.mediaType)
        XCTAssertNil(tag?.mediaType?.mediaTypeRefinement)
        XCTAssertEqual(tag?.mediaType?.additionalInformation, "Media Type")
    }

    
    func testPresetOptionsWriting() throws {
        var tag = Tag()
        
        tag.genre?.presetGenre = .Blues
        tag.genre?.customGenre = "Blues Refinement"
        
        tag.mediaType?.mediaType = .otherDigital
        tag.mediaType?.mediaTypeRefinement = .analogTransfer
        tag.mediaType?.additionalInformation = "Additional Information"
        
        tag.fileType?.fileType = .MPG
        tag.fileType?.fileTypeRefinement = .mpegLayerIII
        tag.fileType?.additionalInformation = "Additional Information"
        
        let output = try tempDirectory().appendingPathComponent("test.mp3")
        XCTAssertNoThrow(try TestFile.noMeta.mp3File()?.write(tagVersion: .v2_4, using: tag, writingTo: output))
        
        let fileWritten = try Mp3File(location: output)
        let tagWritten = try Tag(readFrom: fileWritten)

        XCTAssertEqual(tagWritten.genre?.presetGenre, .Blues)
        XCTAssertEqual(tagWritten.genre?.customGenre, "Blues Refinement")
        
        XCTAssertEqual(tagWritten.mediaType?.mediaType, .otherDigital)
        XCTAssertEqual(tagWritten.mediaType?.mediaTypeRefinement, .analogTransfer)
        XCTAssertEqual(tagWritten.mediaType?.additionalInformation, "Additional Information")
        
        XCTAssertEqual(tagWritten.fileType?.fileType, .MPG)
        XCTAssertEqual(tagWritten.fileType?.fileTypeRefinement, .mpegLayerIII)
        XCTAssertEqual(tagWritten.fileType?.additionalInformation, "Additional Information")
    }
}
