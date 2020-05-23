/*

 Print.swift
 SwiftTaggerID3

 Copyright ©2020 Nolaine Crusher. All rights reserved.

 */

import XCTest
import SwiftTaggerID3

@available(OSX 10.12, *)
class TestPrint: XCTestCase {
    
    
    func testPrint() throws {
//        let path = "/Users/nolainecrusher/Desktop/test output/testV24Writing.mp3"
//        let mp3Url = URL(fileURLWithPath: path)
//        let mp3Url = 
//        let mp3File = try Mp3File(location: mp3Url)
//        let mp3Data = mp3File.data
//        
//        let rangeIn = 1302
//        let rangeOut = 1350
//        let range = rangeIn ..< rangeOut
//        
//        let data = mp3Data.subdata(in: range)
//        print(data.hexadecimal())
    }
    
    func testWipe() throws {
        var tag = try TestFile.noMeta.tag()
        tag?.album = nil
//        tag?.trackNumber = nil
        tag?.fileType = nil
        tag?.involvedPeopleList = nil
        tag?.recordingDateTime = nil
        
        tag?.removeCommentFrame(withDescription: "")
        
        let outputUrl = try localDirectory(fileName: "nometatest", fileExtension: "mp3")
        XCTAssertNoThrow(try TestFile.noMeta.mp3File()?.write(tagVersion: .v2_3,
                                                              using: tag ?? Tag(readFrom: Mp3File(location: TestFile.noMeta.url)),
                                               writingTo: outputUrl))
        
        // MARK: Confirm accuracy
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        print(tagWritten)
    }
}
