//
//  Mp3FileError.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/7/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

extension Mp3File {
    
    public enum Error: Swift.Error {
        /// Error generated when an invalid file format is passed to the ID3TagEditor.
        case InvalidFileFormat;
        /// Error generated when the tag size exceed 256 MB.
        case TagTooBig;
        /// Error generated when there's not valid data in the tag.
        case InvalidTagData;
        /// Error generated when the file is corrupted.
        case CorruptedFile;
        /// Error generated if the file size is too small for a valid tag.
        case FileTooSmall;
    }
}

extension Mp3File.Error: LocalizedError {
    var errorDescription: String? {
        switch self {
            
            case .InvalidFileFormat:
                return NSLocalizedString(
                    "The file needs to be an MP3 file", comment: "")
            case .TagTooBig:
                return NSLocalizedString(
                    "Tag size exceeds limit", comment: "")
            case .InvalidTagData:
                return NSLocalizedString(
                    "The tag header is unrecognized", comment: "")
            case .CorruptedFile:
                return NSLocalizedString(
                    "Tag data size cannot exceed file size", comment: "")
            case .FileTooSmall:
                return NSLocalizedString(
                    "The file is too small to hold a valid ID3 tag", comment: "")
        }
    }
}
