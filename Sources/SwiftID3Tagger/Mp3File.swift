/*

 Mp3File.swift
 SwiftTaggerID3

 Copyright ©2020 Nolaine Crusher. All rights reserved.

 */

import Foundation
import AVFoundation

/// An Mp3File represets an mp3-format file on the local drive
/// This wrapper houses variables and methods for querying and modifying an Mp3File
@available(OSX 10.12, *)
public struct Mp3File {
    
    /// The location of an mp3-format file somewhere on the local drive
    let location: URL
    /// The Mp3File as data
    public var data: Data
    
    /// Initialize an Mp3File instance and the data from the file
    /// - Parameter location: The location of an mp3-format file somewhere on the local drive
    /// - Throws: `CannotReadFile` If the file cannot be reached
    /// - Throws: `InvalidFileFormat` If the file does not have an mp3 extension
    public init(location: URL) throws {
        self.location = location
        // validate that the file is an mp3 file
        guard location.pathExtension.lowercased() == "mp3" else {
            throw Mp3File.Error.InvalidFileFormat
        }
        // get the file as data, retrying once in case the file isn't released yet after being accessed from another attempt
        do {
            self.data = try Data(contentsOf: location)
        } catch {
            do {
                self.data = try Data(contentsOf: location)
            } catch {
                throw Mp3File.Error.CannotReadFile
            }
        }
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
    
    private func buildNewFile(using tag: Tag, version: Version) throws -> Data {
        var fileData = self.data
        let properties = TagProperties()
        let tagSizeDataRange = properties.tagSizeDeclarationOffset ..<
            properties.tagSizeDeclarationOffset +
            properties.tagSizeDeclarationLength
        
        let tagSizeData = fileData.subdata(in: tagSizeDataRange)
        let tagDataCount = try properties.size(data: tagSizeData, version: version)
        let tagDataRange = fileData.startIndex ..<
            properties.tagHeaderLength + tagDataCount
        
        let tagData = try tag.buildTag(version: version)
        fileData.replaceSubrange(tagDataRange, with: tagData)
        return fileData
    }
}
