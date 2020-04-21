//
//  Mp3File.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/7/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

/// An audio file represents an audio file somewhere on disk.
///
/// This wrapper houses methods for querying or modifying information about the file.

public struct Mp3File {
 
    public let location: URL
    var data: Data

    /// - Parameters:
    ///     - location: The location of the audio file in the local file system.
    ///     - data: The content of the file presented as Data.
    public init(location: URL) throws {
        self.location = location
        do {
            self.data = try Data(contentsOf: location)
        } catch {
            throw Mp3File.Error.CannotReadFile
        }
    }

    public func read() throws {
        let tag = Tag()
        try tag.parseFramesFromTag(file: self)
    }
    
//    public func write(from sourceAudio: Mp3File, to outputLocation: URL) throws {
//    }
}
