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
        XCTAssertNil(tag?.fileType)
        XCTAssertNil(tag?.fileTypeRefinement)
        XCTAssertEqual(tag?.additionalFileTypeInformation, "File Type")
        XCTAssertEqual(tag?.presetGenre, .Audiobook)
        XCTAssertEqual(tag?.genre, "Genre Type")
        XCTAssertNil(tag?.mediaType)
        XCTAssertNil(tag?.mediaTypeRefinement)
        XCTAssertEqual(tag?.additionalMediaTypeInformation, "Media Type")
    }

    @available(OSX 10.12, *)
    func testPresetOptionsReadingV23() throws {
        let tag = try TestFile.v23.tag()
        XCTAssertNil(tag?.fileType)
        XCTAssertNil(tag?.fileTypeRefinement)
        XCTAssertEqual(tag?.additionalFileTypeInformation, "File Type")
        XCTAssertEqual(tag?.presetGenre, .Audiobook)
        XCTAssertEqual(tag?.genre, "Genre Type")
        XCTAssertNil(tag?.mediaType)
        XCTAssertNil(tag?.mediaTypeRefinement)
        XCTAssertEqual(tag?.additionalMediaTypeInformation, "Media Type")
    }

    @available(OSX 10.12, *)
    func testPresetOptionsReadingV22() throws {
        let tag = try TestFile.v22.tag()
        XCTAssertNil(tag?.fileType)
        XCTAssertNil(tag?.fileTypeRefinement)
        XCTAssertEqual(tag?.additionalFileTypeInformation, "File Type")
        XCTAssertEqual(tag?.presetGenre, .Audiobook)
        XCTAssertEqual(tag?.genre, "Genre Type")
        XCTAssertNil(tag?.mediaType)
        XCTAssertNil(tag?.mediaTypeRefinement)
        XCTAssertEqual(tag?.additionalMediaTypeInformation, "Media Type")
    }

    
    @available(OSX 10.12, *)
    func testPresetOptionsWriting() throws {
        var tag = Tag()
        
        tag.presetGenre = .Blues
        tag.genre = "Blues Refinement"
        
        tag.mediaType = .otherDigital
        tag.mediaTypeRefinement = .analogTransfer
        tag.additionalMediaTypeInformation = "Additional Information"
        
        tag.fileType = .MPG
        tag.fileTypeRefinement = .mpegLayerIII
        tag.additionalFileTypeInformation = "Additional Information"

        let output = try tempDirectory().appendingPathComponent("test.mp3")
        XCTAssertNoThrow(try TestFile.noMeta.mp3File()?.write(tagVersion: .v2_4, using: tag, writingTo: output))
        
        let fileWritten = try Mp3File(location: output)
        let tagWritten = try Tag(readFrom: fileWritten)

        XCTAssertEqual(tagWritten.presetGenre, .Blues)
        XCTAssertEqual(tagWritten.genre, "Blues Refinement")
        
        XCTAssertEqual(tagWritten.mediaType, .otherDigital)
        XCTAssertEqual(tagWritten.mediaTypeRefinement, .analogTransfer)
        XCTAssertEqual(tagWritten.additionalMediaTypeInformation, "Additional Information")
        
        XCTAssertEqual(tagWritten.fileType, .MPG)
        XCTAssertEqual(tagWritten.fileTypeRefinement, .mpegLayerIII)
        XCTAssertEqual(tagWritten.additionalFileTypeInformation, "Additional Information")
    }
    
    @available(OSX 10.12, *)
    func testPresetOptionsOverWriting() throws {
        var tag = try TestFile.v24.tag()!
        
        tag.presetGenre = .Blues
        tag.genre = "Blues Refinement"
        
        tag.mediaType = .otherDigital
        tag.mediaTypeRefinement = .analogTransfer
        tag.additionalMediaTypeInformation = "Additional Information"
        
        tag.fileType = .MPG
        tag.fileTypeRefinement = .mpegLayerIII
        tag.additionalFileTypeInformation = "Additional Information"
        
        let output = try tempDirectory().appendingPathComponent("test.mp3")
        XCTAssertNoThrow(try TestFile.noMeta.mp3File()?.write(tagVersion: .v2_4, using: tag, writingTo: output))
        
        let fileWritten = try Mp3File(location: output)
        let tagWritten = try Tag(readFrom: fileWritten)
        
        XCTAssertEqual(tagWritten.presetGenre, .Blues)
        XCTAssertEqual(tagWritten.genre, "Blues Refinement")
        
        XCTAssertEqual(tagWritten.mediaType, .otherDigital)
        XCTAssertEqual(tagWritten.mediaTypeRefinement, .analogTransfer)
        XCTAssertEqual(tagWritten.additionalMediaTypeInformation, "Additional Information")
        
        XCTAssertEqual(tagWritten.fileType, .MPG)
        XCTAssertEqual(tagWritten.fileTypeRefinement, .mpegLayerIII)
        XCTAssertEqual(tagWritten.additionalFileTypeInformation, "Additional Information")
    }

}
