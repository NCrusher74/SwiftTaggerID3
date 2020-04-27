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
        let mp3File = try Bundle.mp3V22()
        print(try mp3File.read())
   }
    
    func testPrint() throws {
        let mp3File = try Bundle.mp3V22()
        let mp3Data = mp3File.data
        let frameSizeRange = 10..<31
        print(mp3Data.subdata(in: frameSizeRange).hexadecimal())
    }
    
}
