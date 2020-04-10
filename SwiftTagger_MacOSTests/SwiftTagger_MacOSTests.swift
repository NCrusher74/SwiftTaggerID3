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

    
//    func testExtensions() {
//        print("ID3".hexEncodedString)
//    }
    
    func testProperties() throws {
        let propertiesNoMeta = Bundle.propertiesNoMeta
        let propertiesV22 = Bundle.propertiesV22FileWritten
        let propertiesV23 = Bundle.propertiesV23FileWritten
        let propertiesV24 = Bundle.propertiesV24FileWritten
        
        XCTAssertEqual(try propertiesNoMeta.version(), ID3Version.version23)
        XCTAssertEqual(try propertiesV22.version(), ID3Version.version22)
        XCTAssertEqual(try propertiesV23.version(), ID3Version.version23)
        XCTAssertEqual(try propertiesV24.version(), ID3Version.version24)

    }

    func testValidation() throws {
        let notMp3File = Mp3File(location: Bundle.notMp3)
        let mp3Corrupted = Mp3File(location: Bundle.corruptedV23)
        let validatorCorrupted = TagValidator(for: mp3Corrupted)
        let propertiesCorrupted = TagProperties(for: mp3Corrupted)

        let propertiesV22 = Bundle.propertiesV22FileWritten
        let propertiesV23 = Bundle.propertiesV23FileWritten
        let propertiesV24 = Bundle.propertiesV24FileWritten

        let v22Validator = Bundle.validatorV22FileWritten
        let v23Validator = Bundle.validatorV23FileWritten
        let v24Validator = Bundle.validatorV24FileWritten
        
        XCTAssertThrowsError(try TagValidator(for: notMp3File).isValidMp3())
        XCTAssertTrue(try TagValidator(for: mp3Corrupted).isValidMp3())
        XCTAssertThrowsError(try validatorCorrupted.hasValidTag(properties: propertiesCorrupted))
        
        XCTAssertTrue(try v22Validator.hasValidTag(properties: propertiesV22))
        XCTAssertTrue(try v23Validator.hasValidTag(properties: propertiesV23))
        XCTAssertTrue(try v24Validator.hasValidTag(properties: propertiesV24))
    }

}
