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
        XCTAssertNoThrow(try validatorCorrupted.hasValidTagSize())
        XCTAssertNoThrow(try validatorCorrupted.hasValidTag())

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

        XCTAssertThrowsError(validatorNotMp3.hasValidExtension)
        XCTAssertNoThrow(validatorCorrupted.hasValidExtension)
        XCTAssertTrue(validatorV22.hasValidExtension)
        XCTAssertTrue(validatorV23.hasValidExtension)
        XCTAssertTrue(validatorV24.hasValidExtension)
        
        XCTAssertThrowsError(validatorNotMp3.isValidSize)
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

        // Note to self: add tests for flags and size data and extraction
        
        XCTAssertEqual([UInt8](propertiesCorrupted.extractVersionData(
            data: corruptedData)), v23VersionBytes)
        XCTAssertEqual([UInt8](propertiesNoMeta.extractVersionData(
            data: noMetaData)), v23VersionBytes)
        XCTAssertEqual([UInt8](propertiesV22.extractVersionData(
            data: v22Data)), v22VersionBytes)
        XCTAssertEqual([UInt8](propertiesV23.extractVersionData(
            data: v23Data)), v23VersionBytes)
        XCTAssertEqual([UInt8](propertiesV24.extractVersionData(
            data: v24Data)), v24VersionBytes)

        XCTAssertEqual(try propertiesCorrupted.version(data: corruptedData), Version.v2_3)
        XCTAssertEqual(try propertiesNoMeta.version(data: noMetaData), Version.v2_3)
        XCTAssertEqual(try propertiesV22.version(data: v22Data), Version.v2_2)
        XCTAssertEqual(try propertiesV23.version(data: v23Data), Version.v2_3)
        XCTAssertEqual(try propertiesV24.version(data: v24Data), Version.v2_4)
    }

}
