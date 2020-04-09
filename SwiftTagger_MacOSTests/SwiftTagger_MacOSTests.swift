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

    func testBasicReadAndWrite() throws {
        XCTAssertNoThrow(try Bundle.testMp3File.readMP3File(), "error reading file")
        XCTAssertNoThrow(try Bundle.testMp3File.write(
            from: Bundle.testMp3File, to: URL(fileURLWithPath: "/Users/nolainecrusher/Downloads/audiobook_tools/sampleaax/test/test-output.mp3")), "error writing file")
    }
}
