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
    
    /// Check to see if the mp3 has a valid file extension
    private var isValid: Bool {
        if self.location.fileExtension.lowercased() == "mp3" {
            return true
        } else {
            return false
        }
    }
    
    func readMP3File() throws -> Data {
        if self.isValid {
            return try Data(contentsOf: self.location)
        } else {
            throw Error.InvalidFileFormat
        }
    }
    
    public func read() throws -> TagData {
        let tagData = TagData(from: self)
        return tagData
    }
    
    public func write(from sourceAudio: Mp3File, to outputLocation: URL) throws {
//        let outputFileAsData = readMP3File() + TagData
//        try FileManager.default.createDirectory(
//            at: outputLocation.parentDirectory,
//            withIntermediateDirectories: true)
//        try
//
    }
}
