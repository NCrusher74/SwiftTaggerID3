//
//  File.swift
//
//
//  Created by Nolaine Crusher on 9/19/20.
//

import Foundation

import XCTest
@testable import SwiftTaggerID3

// Tests for chapter frame and CTOC frame
class SwiftTaggerID3_Print_Tests: XCTestCase {

    func testPrintLocalDirectory() throws {
        let data = try Data(contentsOf: try localOutputDirectory("testAll"))
        let range = 00001737 ..< 00001794
        let subdata = data.subdata(in: range)
        print(subdata.hexadecimal())
    }
    
    /*
     54 50 52 4f // TPRO
     0 0 0 2f // 47
     0 0
     1
     ff fe //
     17 21 // ℗
     20 0 //
     32 0 30 0 32 0 30 0 // 2020
     20 0
     50 0 72 0 6f 0 64 0 75 0 63 0 65 0 64 0 // Produced
     20 0
     4e 0 6f 0 74 0 69 0 63 0 65 0 // Notice
     */

    func testPrintTestFiles() throws {
        let data = try Data(contentsOf: sampleUnknown)
        let range = 0 ..< 164
        let subdata = data.subdata(in: range)
        print(subdata.hexadecimal())
    }
}
