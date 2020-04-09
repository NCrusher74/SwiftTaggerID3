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

    func testValidation() throws {
        let mp3v22File = Mp3File(location: Bundle.writtenV22)
        let mp3v23File = Mp3File(location: Bundle.writtenV23)
        let mp3v24File = Mp3File(location: Bundle.writtenV24)
        let notMp3File = Mp3File(location: Bundle.notMp3)
        let mp3Corrupted = Mp3File(location: Bundle.corruptedV23)
        
        let failedFileValidator = TagValidator(from: notMp3File)
        XCTAssertThrowsError(try failedFileValidator.isValidMp3())

        let failedTagValidator = TagValidator(from: mp3Corrupted)
        XCTAssertThrowsError(try failedTagValidator.hasValidTag(version: .version23))
        
        let succeededFileValidator = TagValidator(from: mp3v24File)
        XCTAssertTrue(try succeededFileValidator.isValidMp3())
        
        let tagValidtorV22 = TagValidator(from: mp3v22File)
        XCTAssertTrue(try tagValidtorV22.hasValidTag(version: .version22))

        let tagValidtorV23 = TagValidator(from: mp3v23File)
        XCTAssertTrue(try tagValidtorV23.hasValidTag(version: .version23))

        let tagValidtorV24 = TagValidator(from: mp3v24File)
        XCTAssertTrue(try tagValidtorV24.hasValidTag(version: .version24))
    }

}
