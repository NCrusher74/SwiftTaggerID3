//
//  File.swift
//  
//
//  Created by Nolaine Crusher on 9/19/20.
//

import Foundation

import XCTest
import SwiftTaggerID3

// Tests for chapter frame and CTOC frame
class SwiftTaggerID3_Parsing_Tests: XCTestCase {
    
    func testTagReadingv2_4() throws {
        let mp3 = try Mp3File(location: sample24Url)
        let tag = try Tag(mp3File: mp3)
        
        print(tag.frames.count)
        for item in tag.frames {
            print(item)
        }
    }
}
