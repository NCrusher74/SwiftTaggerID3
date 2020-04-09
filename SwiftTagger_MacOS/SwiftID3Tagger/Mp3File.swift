//
//  Mp3File.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/7/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation
import AVFoundation

struct Mp3File {
    
    let location: URL
    
    init(location: URL) {
        self.location = location
    }
            
//    public func read() throws -> TagData {
//        let tagData = TagData(from: self)
//        return tagData
//    }
    
    public func write(from sourceAudio: Mp3File, to outputLocation: URL) throws {
//        let outputFileAsData = readMP3File() + TagData
//        try FileManager.default.createDirectory(
//            at: outputLocation.parentDirectory,
//            withIntermediateDirectories: true)
//        try
//
    }
}
