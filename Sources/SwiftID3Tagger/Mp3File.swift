//
//  Mp3File.swift
//  
//
//  Created by Nolaine Crusher on 9/17/20.
//

import Foundation
import AVFoundation
/// An Mp3File represets an mp3-format file on the local drive
/// This wrapper houses variables and methods for querying and modifying an Mp3File
public struct Mp3File {
    
    /// The location of an mp3-format file somewhere on the local drive
    let location: URL
    let duration: Int
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
            throw Mp3FileError.InvalidFileFormat
        }
        // get the file as data, retrying once in case the file isn't released yet after being accessed from another attempt
        do {
            self.data = try Data(contentsOf: location)
        } catch {
            do {
                self.data = try Data(contentsOf: location)
            } catch {
                throw Mp3FileError.UnableToReadFileData
            }
        }
        // initialize the duration of the MP3 file for use in length and chapter frames
        let asset = AVAsset(url: location)
        let seconds = asset.duration.seconds
        self.duration = Int(seconds * 1000)
    }
    
    @available(OSX 10.12, *)
    public func tag() throws -> Tag {
            return try Tag(mp3File: self)
    }
    
    @available(OSX 10.12, *)
    public func write(tag: Tag,
                      outputLocation: URL) throws {
        let data = buildNewFile(tag: tag)
        try data.write(to: outputLocation)
    }
    
    @available(OSX 10.12, *)
    private func buildNewFile(tag: Tag) -> Data {
        var data = self.data
        let tagSizeData = data.subdata(in: tag.tagSizeDataRange)
        
        let size = (tagSizeData as NSData)
            .bytes.assumingMemoryBound(to: UInt32.self).pointee.bigEndian
        let tagSize = size.decodingSynchsafe().toInt

        let tagDataRange = data.startIndex ..< tag.tagHeaderLength + tagSize
        
        let tagData = tag.tagWithHeader
        data.replaceSubrange(tagDataRange, with: tagData)
        return data
    }
}
