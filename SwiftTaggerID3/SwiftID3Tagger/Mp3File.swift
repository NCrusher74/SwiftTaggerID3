//
//  Mp3File.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/7/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

/// An audio file represents an audio file somewhere on disk.
public struct Mp3File {
 
    let location: URL
    public var data: Data

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

    /// read the data from an MP3 File and return an ID3 Tag instance
    public func read() throws -> Tag {
       return try Tag(readFrom: self)
    }
    
    private func buildNewFile(using tag: Tag, version: Version) throws -> Data {
        var fileData = Data()
        fileData.append(try tag.buildTag(version: version))
        fileData.append(self.data)
        return fileData
    }
    
    public func write(tagVersion: Version,
                      using tag: Tag,
                      writingTo url: URL) throws {
        let fileData = try buildNewFile(using: tag, version: tagVersion)
        try FileManager.default.createDirectory(
            at: url.parentDirectory,
            withIntermediateDirectories: true)
        try fileData.write(to: url)
    }
}
