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
        let data = try Data(contentsOf: try localOutputDirectory("chapterTest"))
        let range = 00000178 ..< 00000188
        let subdata = data.subdata(in: range)
        print(subdata.hexadecimal())
    }
        
    /*
     TDRC
     TDEN
     TDOR
     TDRL
     TDTG
     */
    
    func testPrintTestFiles() throws {
        let data = try Data(contentsOf: sampleChapterUrl)
        let range = 886 ..< 907
        let subdata = data.subdata(in: range)
        print(subdata.hexadecimal())
    }
}
