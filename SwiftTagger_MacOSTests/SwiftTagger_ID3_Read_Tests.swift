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
    
//    func testPrint() throws {
//        let longLyricsFile = Bundle.longLyricsFile
//        let longLyricsMp3File = try Mp3File(location: longLyricsFile)
//        let longLyricsData = longLyricsMp3File.data
//        let frameSizeRange = 1221..<5689
//        print(longLyricsData.subdata(in: frameSizeRange).hexadecimal())
//    }
    
}
