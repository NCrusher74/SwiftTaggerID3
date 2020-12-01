/*

 SwiftTaggerID3_ComplexTypesFrame_Tests.swift
 SwiftTaggerID3

 Copyright ©2020 Nolaine Crusher. All rights reserved.

 */

import XCTest
@testable import SwiftTaggerID3

@available(OSX 11.0, *)
class SwiftTaggerID3_ComplexTypesFrame_Tests: XCTestCase {
    
    func testPresetOptionsReadingV24() throws {
        let tag = tagV24
        XCTAssertNil(tag.fileType.fileType)
        XCTAssertNil(tag.fileType.fileTypeRefinement)
        XCTAssertEqual(tag.fileType.additionalInformation, "File Type")
        XCTAssertEqual(tag.genre.genreCategory, .Audiobook)
        XCTAssertEqual(tag.genre.genre, "Genre Type")
        XCTAssertNil(tag.mediaType.mediaType)
        XCTAssertNil(tag.mediaType.mediaTypeRefinement)
        XCTAssertEqual(tag.mediaType.additionalInformation, "Media Type")
    }
    
    func testPresetOptionsReadingV23() throws {
        let tag = tagV23
        XCTAssertNil(tag.fileType.fileType)
        XCTAssertNil(tag.fileType.fileTypeRefinement)
        XCTAssertEqual(tag.fileType.additionalInformation, "File Type")
        XCTAssertEqual(tag.genre.genreCategory, .Audiobook)
        XCTAssertEqual(tag.genre.genre, "Genre Type")
        XCTAssertNil(tag.mediaType.mediaType)
        XCTAssertNil(tag.mediaType.mediaTypeRefinement)
        XCTAssertEqual(tag.mediaType.additionalInformation, "Media Type")
    }
    
    func testPresetOptionsReadingV22() throws {
        let tag = tagV22
        XCTAssertNil(tag.fileType.fileType)
        XCTAssertNil(tag.fileType.fileTypeRefinement)
        XCTAssertEqual(tag.fileType.additionalInformation, "File Type")
        XCTAssertEqual(tag.genre.genreCategory, .Audiobook)
        XCTAssertEqual(tag.genre.genre, "Genre Type")
        XCTAssertNil(tag.mediaType.mediaType)
        XCTAssertNil(tag.mediaType.mediaTypeRefinement)
        XCTAssertEqual(tag.mediaType.additionalInformation, "Media Type")
    }
    
    
    func testPresetOptionsWriting() throws {
        var tag = tagNoMeta
        
        tag.genre.genreCategory = .Blues
        tag.genre.genre = "Blues Refinement"
        
        tag.mediaType.mediaType = .otherDigital
        tag.mediaType.mediaTypeRefinement = .analogTransfer
        tag.mediaType.additionalInformation = "Additional Information"
        
        tag.fileType.fileType = .MPG
        tag.fileType.fileTypeRefinement = .mpegLayerIII
        tag.fileType.additionalInformation = "Additional Information"
        
        let outputUrl = tempOutputDirectory
        XCTAssertNoThrow(try mp3NoMeta.write(tag: &tag, version: .v2_4, outputLocation: outputUrl))
        
        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try Tag(mp3File: outputMp3)
        
        XCTAssertEqual(output.genre.genreCategory, .Blues)
        XCTAssertEqual(output.genre.genre, "Blues Refinement")
        
        XCTAssertEqual(output.mediaType.mediaType, .otherDigital)
        XCTAssertEqual(output.mediaType.mediaTypeRefinement, .analogTransfer)
        XCTAssertEqual(output.mediaType.additionalInformation, "Additional Information")
        
        XCTAssertEqual(output.fileType.fileType, .MPG)
        XCTAssertEqual(output.fileType.fileTypeRefinement, .mpegLayerIII)
        XCTAssertEqual(output.fileType.additionalInformation, "Additional Information")
    }
    
    func testPresetOptionsOverWriting() throws {
        var tag = tagV24
        
        tag.genre.genreCategory = .Blues
        tag.genre.genre = "Blues Refinement"
        
        tag.mediaType.mediaType = .otherDigital
        tag.mediaType.mediaTypeRefinement = .analogTransfer
        tag.mediaType.additionalInformation = "Additional Information"
        
        tag.fileType.fileType = .MPG
        tag.fileType.fileTypeRefinement = .mpegLayerIII
        tag.fileType.additionalInformation = "Additional Information"
        
        let outputUrl = tempOutputDirectory
        XCTAssertNoThrow(try mp3NoMeta.write(tag: &tag, version: .v2_4, outputLocation: outputUrl))
        
        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try Tag(mp3File: outputMp3)
        
        XCTAssertEqual(output.genre.genreCategory, .Blues)
        XCTAssertEqual(output.genre.genre, "Blues Refinement")
        
        XCTAssertEqual(output.mediaType.mediaType, .otherDigital)
        XCTAssertEqual(output.mediaType.mediaTypeRefinement, .analogTransfer)
        XCTAssertEqual(output.mediaType.additionalInformation, "Additional Information")
        
        XCTAssertEqual(output.fileType.fileType, .MPG)
        XCTAssertEqual(output.fileType.fileTypeRefinement, .mpegLayerIII)
        XCTAssertEqual(output.fileType.additionalInformation, "Additional Information")
    }
    
    func testSetToNil() throws {
        var tag = tagV24
        
        tag.genre.genreCategory = nil
        tag.genre.genre = nil
        
        tag.mediaType.mediaType = nil
        tag.mediaType.mediaTypeRefinement = nil
        tag.mediaType.additionalInformation = nil
        
        tag.fileType.fileType = nil
        tag.fileType.fileTypeRefinement = nil
        tag.fileType.additionalInformation = nil
        
        XCTAssertNil(tag.frames.first(where: {$0.key == .genre}))
        XCTAssertNil(tag.frames.first(where: {$0.key == .mediaType}))
        XCTAssertNil(tag.frames.first(where: {$0.key == .fileType}))
        
        let outputUrl = tempOutputDirectory
        XCTAssertNoThrow(try mp3NoMeta.write(tag: &tag, version: .v2_4, outputLocation: outputUrl))
        
        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try Tag(mp3File: outputMp3)
        
        XCTAssertNil(output.genre.genreCategory)
        XCTAssertNil(output.genre.genre)
        
        XCTAssertNil(output.mediaType.mediaType)
        XCTAssertNil(output.mediaType.mediaTypeRefinement)
        XCTAssertNil(output.mediaType.additionalInformation)
        
        XCTAssertNil(output.fileType.fileType)
        XCTAssertNil(output.fileType.fileTypeRefinement)
        XCTAssertNil(output.fileType.additionalInformation)
        
        XCTAssertNil(output.frames.first(where: {$0.key == .genre}))
        XCTAssertNil(output.frames.first(where: {$0.key == .mediaType}))
        XCTAssertNil(output.frames.first(where: {$0.key == .fileType}))
    }
}
