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
        let mp3File = try Bundle.mp3V23()
        let fileData = mp3File.data
        let readIn: Int = 1320
        let readOut: Int = 1350
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
// 0 (encoding byte)
// 4a 50 47 (image format) (0x50 0x4e 0x47 for PNG / 0x4a 0x50 0x47 for JPG)
// 3 (picture type)
// 0 (description?)
// ff d8 ff e0 (magic number)

//<Header for 'Attached picture', ID: "APIC">
//Text encoding      $xx
//MIME type          <text string> $00
//Picture type       $xx
//Description        <text string according to encoding> $00 (00)
//Picture data       <binary data>

// 41 50 49 43 - identifier
// 0 0 4a d - size
// 0 0 - flags
// 0 - encoding
// 69 6d 61 67 65 - 2f - 6a 70 65 67 0 - Mime String (image/jpeg)
// 3 - picture type
// 0 - description
// ff d8 ff e0 - magic number
