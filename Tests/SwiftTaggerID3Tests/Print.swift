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

    func testPrintTestFiles() throws {
        let data = try Data(contentsOf: sampleUnknown)
        let range = 0 ..< 164
        let subdata = data.subdata(in: range)
        print(subdata.hexadecimal())
    }

    func testPrintLocalDirectory() throws {
        let data = try Data(contentsOf: localOutputDirectory("releaseDateTime"))
        let range = 00000010 ..< 00000041
        let subdata = data.subdata(in: range)
        print(subdata.hexadecimal())
    }
}
