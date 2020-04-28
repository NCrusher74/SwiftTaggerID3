//
//  TestPrint.swift
//  SwiftTagger_MacOSTests
//
//  Created by Nolaine Crusher on 4/28/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import XCTest

class TestPrint: XCTestCase {

    func testExample() throws {
        let mp3File = try Bundle.mp3V22()
        let fileData = mp3File.data
        let readIn: Int = 168
        let readOut: Int = 198
        let range = readIn ..< readOut
        let subdata = fileData.subdata(in: range)
        print(subdata.hexadecimal())
        
    }

}

//Attached picture   "PIC"
//Frame size         $xx xx xx
//Text encoding      $xx
//Image format       $xx xx xx
//Picture type       $xx
//Description        <textstring> $00 (00)
//Picture data       <binary data>

// 50 49 43 (identifier)
// 0 25 5 (size)
// 0
// 4a 50 47
// 3
// 0
// ff d8 ff e0 (magic number)
// 0
// 10 4a 46 49 46 (JFIF)
// - 0 - 1 1 1 0 90 0 90
