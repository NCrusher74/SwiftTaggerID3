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
    
    func testProperties() throws {
        let propertiesNoMeta = TagProperties(for: try Mp3File(location: Bundle.v23NoMeta))
        let propertiesV22 = TagProperties(for: try Mp3File(location: Bundle.writtenV22))
        let propertiesV23 = TagProperties(for: try Mp3File(location: Bundle.writtenV23))
        let propertiesV24 = TagProperties(for: try Mp3File(location: Bundle.writtenV24))
        
        XCTAssertEqual(propertiesNoMeta.version, Version.v2_3)
        XCTAssertEqual(propertiesV22.version, Version.v2_2)
        XCTAssertEqual(propertiesV23.version, Version.v2_3)
        XCTAssertEqual(propertiesV24.version, Version.v2_4)

    }

    func testValidation() throws {
        let notMp3File = try Mp3File(location: Bundle.notMp3)
        let mp3Corrupted = try Mp3File(location: Bundle.corruptedV23)
        let validatorCorrupted = TagValidator(for: mp3Corrupted)

        let v22Validator = TagValidator(for: try Mp3File(location: Bundle.writtenV22))
        let v23Validator = TagValidator(for: try Mp3File(location: Bundle.writtenV23))
        let v24Validator = TagValidator(for: try Mp3File(location: Bundle.writtenV24))
        
        XCTAssertThrowsError(try TagValidator(for: notMp3File).isValidMp3())
        XCTAssertTrue(try TagValidator(for: mp3Corrupted).isValidMp3())
        XCTAssertThrowsError(try validatorCorrupted.hasValidTag())
        
        XCTAssertTrue(try v22Validator.hasValidTag())
        XCTAssertTrue(try v23Validator.hasValidTag())
        XCTAssertTrue(try v24Validator.hasValidTag())
    }

}
