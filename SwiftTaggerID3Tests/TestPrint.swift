//
//  TestPrint.swift
//  SwiftTaggerID3Tests
//
//  Created by Nolaine Crusher on 4/28/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import XCTest
import SwiftTaggerID3

class TestPrint: XCTestCase {

    
    func testMediaType() throws {
        let url = Bundle.writtenV23
        
        let mp3File = try Mp3File(location: url)
        let mp3Data = mp3File.data
        let startIndex = 205
        let endIndex = 226
        let range = startIndex ..< endIndex
        let slice = mp3Data.subdata(in: range)
        
        print(slice.hexadecimal())
        // 54 4d 45 44 0 0 0 a 0 0 0 4d 65 64 69 61 54 79 70 65
        // 4d 65 64 69 61 54 79 70 65 (before parsing - "Test Genre")
        
        // 54 43 4f 4e 0 0 0 b 0 0 0 54 65 73 74 20 47 65 6e 72 65
        // 0 54 65 73 74 20 47 65 6e 72 65 (before parsing - "MediaType")
        
        // 46 69 6c 65 54 79 70 65 (before parsing - "FileType")
    }

    func testPrint() throws {
        let url = Bundle.writtenV24

        let mp3File = try Mp3File(location: url)
        let mp3Data = mp3File.data
        let startIndex = 971
        let endIndex = 1023
        let range = startIndex ..< endIndex
        
        let slice = mp3Data.subdata(in: range)
        print(slice.hexadecimal())
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

