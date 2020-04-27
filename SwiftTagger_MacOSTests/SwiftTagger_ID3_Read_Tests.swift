//
//  SwiftTagger_ID3_Read_Tests.swift
//  SwiftTagger_MacOSTests
//
//  Created by Nolaine Crusher on 4/21/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import XCTest
import SwiftTagger_MacOS

class SwiftTagger_ID3_Read_Tests: XCTestCase {

    func testReadV23() throws {
        let mp3File = try Bundle.mp3V23()
        let tag = try mp3File.read()

        XCTAssertEqual(tag.frames.count, 56) // ??
        let frames = tag.frames
        print(frames[.album])
    }
    
    
}
