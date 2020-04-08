//
//  Mp3File.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/7/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

struct Mp3File {
    
    let location: URL
    
    init(location: URL) {
        self.location = location
    }
    
    var isValid: Bool {
        if self.location.fileExtension.lowercased() == "mp3" {
            return true
        } else {
            return false
        }
    }
    
    public func read() throws -> Data {
        if self.isValid {
            return try Data(contentsOf: self.location)
        } else {
            throw Error.invalidFileFormat
        }
    }
    
    public func write(/*tagData: TagData, */mp3File: Mp3File, outputLocation: URL) throws {
        do {
            let inputData = try mp3File.read()
            try FileManager.default.createDirectory(
                at: outputLocation.parentDirectory,
                withIntermediateDirectories: true)
            try inputData.write(to: outputLocation)
        }
    }
    
}
