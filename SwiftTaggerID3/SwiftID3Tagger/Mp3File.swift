//
//  Mp3File.swift
//  SwiftTaggerID3
//
//  Created by Nolaine Crusher on 4/10/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation
/// An Mp3File represents an MP3 audio file somewhere on disk.
///
/// This wrapper houses variables and methods for reading and writing to this file.
public struct Mp3File {
    
    /// the location of the Mp3File on the local disk
    let location: URL
    /// the Mp3File presented as data
    public var data: Data
    
    /// initialize an Mp3File instance
    /// - Parameter location: the location of the Mp3File
    /// - Throws: If reading the file fails.
    public init(location: URL) throws {
        // initialize the `location` parameter
        self.location = location
        do {
            // initialize the `data` parameter using the `location` of the file
            self.data = try Data(contentsOf: location)
        } catch {
            throw Mp3File.Error.CannotReadFile
        }
    }
    
    /// Read an `Mp3File` from disk and return a `Tag` instance
    /// - Throws: The caller will determine how to handle any errors.
    /// - Returns: `Tag`, a structure containing all the `Mp3File` metadata.
    public func read() throws -> Tag {
       return try Tag(readFrom: self)
    }
    
    /// Build a new mp3 file from a `Tag` instance and the audio data of the current `Mp3File` instance
    /// - Parameters:
    ///   - tag: `Tag` instance holding the ID3 metadata to be written
    ///   - version: ID3 `Version` of the tag being used
    /// - Throws: caller will determine how to handle any errors.
    /// - Returns: data to be written to a new file
    private func buildNewFile(using tag: Tag, version: Version) throws -> Data {
        // initialize an empty data array
        var fileData = Data()
        // append the tag data to the data array
        fileData.append(try tag.buildTag(version: version))
        // append the audio data to the array
        fileData.append(self.data)
        // return the data
        return fileData
    }
    
    /// Write an Mp3File to disk with new or updated `Tag` data.
    /// - Parameters:
    ///   - tagVersion: ID3 `Version` of the tag being used
    ///   - tag: `Tag` instance holding the ID3 metadata to be written
    ///   - url: the location for the new file to be written to.
    /// - Throws: the caller will determine how to handle any errors
    public func write(tagVersion: Version,
                      using tag: Tag,
                      writingTo url: URL) throws {
        // build a new file for writing
        let fileData = try buildNewFile(using: tag, version: tagVersion)
        // create a new directory if necessary
        try FileManager.default.createDirectory(
            at: url.parentDirectory,
            withIntermediateDirectories: true)
        // write the file
        try fileData.write(to: url)
    }
}
