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

    
    func testToolsAndExtensions() throws {
    }
    
    func testRead() throws {
        let mp3NoMetaFile = try Mp3File(location: Bundle.v23NoMeta)
        let noMetaData = mp3NoMetaFile.data
        let propertiesNoMeta = TagProperties(for: mp3NoMetaFile)
        
        let mp3v22File = try Mp3File(location: Bundle.writtenV22)
        let v22Data = mp3v22File.data
        let propertiesV22 = TagProperties(for: mp3v22File)
//        print(propertiesV22.extractVersionData(data: v22Data))

        let mp3v23File = try Mp3File(location: Bundle.writtenV23)
        let v23Data = mp3v23File.data
        let propertiesV23 = TagProperties(for: mp3v23File)
        
        let mp3v24File = try Mp3File(location: Bundle.writtenV24)
        let v24Data = mp3v24File.data
        let propertiesV24 = TagProperties(for: mp3v24File)
        
        XCTAssertEqual(try propertiesNoMeta.version(data: noMetaData), Version.v2_3)
        XCTAssertEqual(try propertiesV22.version(data: v22Data), Version.v2_2)
        XCTAssertEqual(try propertiesV23.version(data: v23Data), Version.v2_3)
        XCTAssertEqual(try propertiesV24.version(data: v24Data), Version.v2_4)

    }

    func testValidation() throws {
        // test error handling
        let notMp3File = try Mp3File(location: Bundle.notMp3)
        XCTAssertThrowsError(try TagValidator(for: notMp3File).isValidMp3())

        let mp3Corrupted = try Mp3File(location: Bundle.corruptedV23)
        let validatorCorrupted = TagValidator(for: mp3Corrupted)
        XCTAssertTrue(try validatorCorrupted.isValidMp3())
        XCTAssertTrue(try validatorCorrupted.hasValidTagSize())
        XCTAssertThrowsError(try validatorCorrupted.hasValidVersionData())
        XCTAssertThrowsError(try validatorCorrupted.hasValidTag())
 
        let v22Validator = TagValidator(for: try Mp3File(location: Bundle.writtenV22))
        let v23Validator = TagValidator(for: try Mp3File(location: Bundle.writtenV23))
        let v24Validator = TagValidator(for: try Mp3File(location: Bundle.writtenV24))

        // test v2.2
        XCTAssertTrue(try v22Validator.isValidMp3())
        XCTAssertTrue(try v22Validator.hasValidVersionData())
        XCTAssertTrue(try v22Validator.hasValidTagSize())
        XCTAssertTrue(try v22Validator.hasValidTag())

        // test v2.3
        XCTAssertTrue(try v23Validator.isValidMp3())
        XCTAssertTrue(try v23Validator.hasValidVersionData())
        XCTAssertTrue(try v23Validator.hasValidTagSize())
        XCTAssertTrue(try v23Validator.hasValidTag())

        // test v2.4
        XCTAssertTrue(try v24Validator.isValidMp3())
        XCTAssertTrue(try v24Validator.hasValidVersionData())
        XCTAssertTrue(try v24Validator.hasValidTagSize())
        XCTAssertTrue(try v24Validator.hasValidTag())
    }

}
