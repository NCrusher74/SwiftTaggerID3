//
//  SwiftTagger_MacOSTests.swift
//  SwiftTagger_MacOSTests
//
//  Created by Nolaine Crusher on 4/7/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import XCTest
import AVFoundation

@testable import SwiftTagger_MacOS

class SwiftTagger_MacOSTests: XCTestCase {
    
    
    func testPrint() throws {
    }
    
    func testValidatorPropertyChecks() throws {
        let validatorCorrupted = TagValidator(for: try Bundle.mp3Corrupted())
        let validatorV22 = TagValidator(for: try Bundle.mp3V22())
        let validatorV23 = TagValidator(for: try Bundle.mp3V23())
        let validatorV24 = TagValidator(for: try Bundle.mp3V24())
        
        XCTAssertNoThrow(try validatorCorrupted.hasValidVersionData())
        XCTAssertThrowsError(try validatorCorrupted.hasValidTagSize())
        XCTAssertThrowsError(try validatorCorrupted.hasValidTag())
        
        // test v2.2
        XCTAssertTrue(try validatorV22.hasValidVersionData())
        XCTAssertTrue(try validatorV22.hasValidTagSize())
        XCTAssertTrue(try validatorV22.hasValidTag())
        
        // test v2.3
        XCTAssertTrue(try validatorV23.hasValidVersionData())
        XCTAssertTrue(try validatorV23.hasValidTagSize())
        XCTAssertTrue(try validatorV23.hasValidTag())
        
        // test v2.4
        XCTAssertTrue(try validatorV24.hasValidVersionData())
        XCTAssertTrue(try validatorV24.hasValidTagSize())
        XCTAssertTrue(try validatorV24.hasValidTag())
    }
    
    
    func testValidatorFileChecks() throws {
        let notAnMp3File = try Mp3File(location: Bundle.notMp3)
        let validatorNotMp3 = TagValidator(for: notAnMp3File)
        let validatorCorrupted = TagValidator(for: try Bundle.mp3Corrupted())
        let validatorV22 = TagValidator(for: try Bundle.mp3V22())
        let validatorV23 = TagValidator(for: try Bundle.mp3V23())
        let validatorV24 = TagValidator(for: try Bundle.mp3V24())
        
        XCTAssertNoThrow(validatorCorrupted.hasValidExtension)
        XCTAssertTrue(validatorV22.hasValidExtension)
        XCTAssertTrue(validatorV23.hasValidExtension)
        XCTAssertTrue(validatorV24.hasValidExtension)
        
        XCTAssertNoThrow(validatorCorrupted.isValidSize)
        XCTAssertTrue(validatorV22.isValidSize)
        XCTAssertTrue(validatorV23.isValidSize)
        XCTAssertTrue(validatorV24.isValidSize)
        
        XCTAssertThrowsError(try validatorNotMp3.isValidMp3())
        XCTAssertNoThrow(try validatorCorrupted.isValidMp3())
        XCTAssertTrue(try validatorV22.isValidMp3())
        XCTAssertTrue(try validatorV23.isValidMp3())
        XCTAssertTrue(try validatorV24.isValidMp3())
        
    }
    
    func testProperties() throws {
        let v22VersionBytes: [UInt8] = [0x49, 0x44, 0x33, 0x02, 0x00]
        let v23VersionBytes: [UInt8] = [0x49, 0x44, 0x33, 0x03, 0x00]
        let v24VersionBytes: [UInt8] = [0x49, 0x44, 0x33, 0x04, 0x00]

        let flagByte: [UInt8] = [0x00]

        let corruptedSizeBytes: [UInt8] = [0x00, 0x02, 0x0b, 0x33]
        let noMetaSizeBytes: [UInt8] = [0x00, 0x00, 0x0d, 0x47]
        let v22SizeBytes: [UInt8] = [0x00, 0x00, 0x18, 0x3e]
        let v23SizeBytes: [UInt8] = [0x00, 0x00, 0x1e, 0x3b]
        let v24SizeBytes: [UInt8] = [0x00, 0x00, 0x15, 0x36]
        
        let noMetaData = try Bundle.mp3NoMetaData()
        let corruptedData = try Bundle.mp3CorruptedData()
        let v22Data = try Bundle.mp3V22Data()
        let v23Data = try Bundle.mp3V23Data()
        let v24Data = try Bundle.mp3V24Data()
        
        let propertiesNoMeta = TagProperties(for: try Bundle.mp3NoMeta())
        let propertiesCorrupted = TagProperties(for: try Bundle.mp3Corrupted())
        let propertiesV22 = TagProperties(for: try Bundle.mp3V22())
        let propertiesV23 = TagProperties(for: try Bundle.mp3V23())
        let propertiesV24 = TagProperties(for: try Bundle.mp3V24())
        
        let corruptedExtractedVersionData = [UInt8](propertiesCorrupted.extractVersionData(
            data: corruptedData))
        let noMetaExtractedVersionData = [UInt8](propertiesNoMeta.extractVersionData(
            data: noMetaData))
        let v22ExtractedVersionData = [UInt8](propertiesV22.extractVersionData(
            data: v22Data))
        let v23ExtractedVersionData = [UInt8](propertiesV23.extractVersionData(
            data: v23Data))
        let v24ExtractedVersionData = [UInt8](propertiesV24.extractVersionData(
            data: v24Data))

        let corruptedExtractedFlagData = [UInt8](propertiesCorrupted.extractFlagData(
            data: corruptedData))
        let noMetaExtractedFlagData = [UInt8](propertiesNoMeta.extractFlagData(
            data: noMetaData))
        let v22ExtractedFlagData = [UInt8](propertiesV22.extractFlagData(
            data: v22Data))
        let v23ExtractedFlagData = [UInt8](propertiesV23.extractFlagData(
            data: v23Data))
        let v24ExtractedFlagData = [UInt8](propertiesV24.extractFlagData(
            data: v24Data))

        let corruptedExtractedSizeData = [UInt8](propertiesCorrupted.extractTagSizeData(
            data: corruptedData))
        let noMetaExtractedSizeData = [UInt8](propertiesNoMeta.extractTagSizeData(
            data: noMetaData))
        let v22ExtractedSizeData = [UInt8](propertiesV22.extractTagSizeData(
            data: v22Data))
        let v23ExtractedSizeData = [UInt8](propertiesV23.extractTagSizeData(
            data: v23Data))
        let v24ExtractedSizeData = [UInt8](propertiesV24.extractTagSizeData(
            data: v24Data))
        
        XCTAssertEqual(corruptedExtractedVersionData, v23VersionBytes)
        XCTAssertEqual(noMetaExtractedVersionData, v23VersionBytes)
        XCTAssertEqual(v22ExtractedVersionData, v22VersionBytes)
        XCTAssertEqual(v23ExtractedVersionData, v23VersionBytes)
        XCTAssertEqual(v24ExtractedVersionData, v24VersionBytes)
        
        XCTAssertEqual(try propertiesCorrupted.version(data: corruptedData), Version.v2_3)
        XCTAssertEqual(try propertiesNoMeta.version(data: noMetaData), Version.v2_3)
        XCTAssertEqual(try propertiesV22.version(data: v22Data), Version.v2_2)
        XCTAssertEqual(try propertiesV23.version(data: v23Data), Version.v2_3)
        XCTAssertEqual(try propertiesV24.version(data: v24Data), Version.v2_4)

        XCTAssertEqual(corruptedExtractedFlagData, flagByte)
        XCTAssertEqual(noMetaExtractedFlagData, flagByte)
        XCTAssertEqual(v22ExtractedFlagData, flagByte)
        XCTAssertEqual(v23ExtractedFlagData, flagByte)
        XCTAssertEqual(v24ExtractedFlagData, flagByte)
        
        XCTAssertEqual(corruptedExtractedSizeData, corruptedSizeBytes)
        XCTAssertEqual(noMetaExtractedSizeData, noMetaSizeBytes)
        XCTAssertEqual(v22ExtractedSizeData, v22SizeBytes)
        XCTAssertEqual(v23ExtractedSizeData, v23SizeBytes)
        XCTAssertEqual(v24ExtractedSizeData, v24SizeBytes)
    }
    
}
