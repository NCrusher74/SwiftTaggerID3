/*

 SwiftTaggerID3_PresetOptionsFrame_Tests.swift
 SwiftTaggerID3

 Copyright ©2020 Nolaine Crusher. All rights reserved.

 */

import XCTest
import SwiftTaggerID3




class SwiftTaggerID3_PresetOptionsFrame_Tests: XCTestCase {
    
    @available(OSX 10.12, *)
    func testPresetOptionsReadingV24() throws {
        let tag = try TestFile.v24.tag()
        XCTAssertNil(tag?.fileType?.fileType)
        XCTAssertNil(tag?.fileType?.fileTypeRefinement)
        XCTAssertEqual(tag?.fileType?.additionalInformation, "File Type")
        XCTAssertEqual(tag?.presetGenre, .Audiobook)
        XCTAssertEqual(tag?.customGenre, "Genre Type")
        XCTAssertNil(tag?.mediaType?.mediaType)
        XCTAssertNil(tag?.mediaType?.mediaTypeRefinement)
        XCTAssertEqual(tag?.mediaType?.additionalInformation, "Media Type")
    }

    @available(OSX 10.12, *)
    func testPresetOptionsReadingV23() throws {
        let tag = try TestFile.v23.tag()
        XCTAssertNil(tag?.fileType?.fileType)
        XCTAssertNil(tag?.fileType?.fileTypeRefinement)
        XCTAssertEqual(tag?.fileType?.additionalInformation, "File Type")
        XCTAssertEqual(tag?.presetGenre, .Audiobook)
        XCTAssertEqual(tag?.customGenre, "Genre Type")
        XCTAssertNil(tag?.mediaType?.mediaType)
        XCTAssertNil(tag?.mediaType?.mediaTypeRefinement)
        XCTAssertEqual(tag?.mediaType?.additionalInformation, "Media Type")
    }

    @available(OSX 10.12, *)
    func testPresetOptionsReadingV22() throws {
        let tag = try TestFile.v22.tag()
        XCTAssertNil(tag?.fileType?.fileType)
        XCTAssertNil(tag?.fileType?.fileTypeRefinement)
        XCTAssertEqual(tag?.fileType?.additionalInformation, "File Type")
        XCTAssertEqual(tag?.presetGenre, .Audiobook)
        XCTAssertEqual(tag?.customGenre, "Genre Type")
        XCTAssertNil(tag?.mediaType?.mediaType)
        XCTAssertNil(tag?.mediaType?.mediaTypeRefinement)
        XCTAssertEqual(tag?.mediaType?.additionalInformation, "Media Type")
    }

    
    @available(OSX 10.12, *)
    func testPresetOptionsWriting() throws {
        var tag = Tag()
        
        tag.presetGenre = .Blues
        tag.customGenre = "Blues Refinement"
        
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

        XCTAssertEqual(tagWritten.presetGenre, .Blues)
        XCTAssertEqual(tagWritten.customGenre, "Blues Refinement")
        
        XCTAssertEqual(tagWritten.mediaType?.mediaType, .otherDigital)
        XCTAssertEqual(tagWritten.mediaType?.mediaTypeRefinement, .analogTransfer)
        XCTAssertEqual(tagWritten.mediaType?.additionalInformation, "Additional Information")
        
        XCTAssertEqual(tagWritten.fileType?.fileType, .MPG)
        XCTAssertEqual(tagWritten.fileType?.fileTypeRefinement, .mpegLayerIII)
        XCTAssertEqual(tagWritten.fileType?.additionalInformation, "Additional Information")
    }
    
    @available(OSX 10.12, *)
    func testPresetOptionsOverWriting() throws {
        var tag = try TestFile.v24.tag()!
        
        tag.presetGenre = .Blues
        tag.customGenre = "Blues Refinement"
        
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
        
        XCTAssertEqual(tagWritten.presetGenre, .Blues)
        XCTAssertEqual(tagWritten.customGenre, "Blues Refinement")
        
        XCTAssertEqual(tagWritten.mediaType?.mediaType, .otherDigital)
        XCTAssertEqual(tagWritten.mediaType?.mediaTypeRefinement, .analogTransfer)
        XCTAssertEqual(tagWritten.mediaType?.additionalInformation, "Additional Information")
        
        XCTAssertEqual(tagWritten.fileType?.fileType, .MPG)
        XCTAssertEqual(tagWritten.fileType?.fileTypeRefinement, .mpegLayerIII)
        XCTAssertEqual(tagWritten.fileType?.additionalInformation, "Additional Information")
    }

}
