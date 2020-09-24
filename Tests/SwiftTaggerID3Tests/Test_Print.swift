//
//  File.swift
//  
//
//  Created by Nolaine Crusher on 9/19/20.
//

import Foundation

import XCTest
import SwiftTaggerID3
@testable import SwiftTaggerID3

// Tests for chapter frame and CTOC frame
class SwiftTaggerID3_Parsing_Tests: XCTestCase {
    
    func testPrintLocalDirectory() throws {
        let data = try Data(contentsOf: try localOutputDirectory("localizedtestV24"))
        let range = 00000010 ..< 0000047
        let subdata = data.subdata(in: range)
        print(subdata.hexadecimal())
    }
        
    func testPrintTestFiles() throws {
        let data = try Data(contentsOf: sample24Url)
        let range = 00000400 ..< 00000435
        let subdata = data.subdata(in: range)
        print(subdata.hexadecimal())
    }
    
    func testWriteTagLessFile() throws {
        let data = try Data(contentsOf: sampleNoMeta)
        print(data.count)
        let newData = data.dropFirst(10)
        print(newData.count)
        try newData.write(to: try localOutputDirectory("tagless"))
    }
}
