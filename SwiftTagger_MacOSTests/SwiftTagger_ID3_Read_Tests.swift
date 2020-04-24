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

    func testRead() throws {
        let mp3File = try Bundle.mp3V23()
        try mp3File.read()
   }
    
    func testPrint() throws {
        var v23Data = try Bundle.mp3V23Data()
        print(v23Data.extractFirst(20).hexadecimal())
//        49 44 33 3 0 - 0 - 0 0 1e 3b - 54 49 54 32 - 0 0 - 0 6 0 0
    }
}
