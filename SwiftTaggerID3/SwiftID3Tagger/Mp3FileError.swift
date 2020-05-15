//
//  Mp3FileError.swift
//  SwiftTaggerID3
//
//  Created by Nolaine Crusher on 4/7/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

extension Mp3File {
    
    public enum Error: Swift.Error {
        /// Error generated when the mp3 file cannot be converted to Data
        case CannotReadFile;
        /// Error generated when an invalid file format is passed to the ID3TagEditor.
        case InvalidFileFormat;
        /// Error generated when there's not valid data in the tag.
        case InvalidTagData;
        /// Error thrown when the tag version cannot be determined
        case InvalidVersionData;
        /// Error thrown when the tag is not large enough to hold at least one valid frame
        case InvalidTagSize;
        /// Error thrown when string is not convertible
        case InconvertibleString
        /// Error thrown when the data requested is out of bounds
        case DataOutOfBounds
        /// Error thrown when the image is in an unhandled format
        case UnhandledImageFormat
        /// Error thrown when the data cannot be retrieved from a frame
        case UnreadableFrame
        /// Error thrown when the date formatter cannot parse a correctly formatted date from the string
        case InvalidDateString
    }
}

extension Mp3File.Error: LocalizedError {
    public var errorDescription: String? {
        switch self {
            case .CannotReadFile:
                return NSLocalizedString(
                    "Cannot Read MP3 File", comment: "")
            case .InvalidFileFormat:
                return NSLocalizedString(
                    "The file needs to be an MP3 file", comment: "")
            case .InvalidTagData:
                return NSLocalizedString(
                    "The tag header is unrecognized", comment: "")
            case .InconvertibleString:
                return NSLocalizedString(
                    "String is not representable in ISO 8859‐1", comment: "")
            case .DataOutOfBounds:
                return NSLocalizedString(
                    "The requested data range is out of bounds", comment: "")
            case .UnhandledImageFormat:
                return NSLocalizedString(
                    "This image type is not handled by SwiftTagger", comment: "")
            case .UnreadableFrame:
                return NSLocalizedString("The data in this frame cannot be retrieved", comment: "")
            case .InvalidVersionData:
                return NSLocalizedString("The ID3 version for the tag cannot be determined", comment: "")
            case .InvalidTagSize:
                return NSLocalizedString("The tag is not large enough to hold valid frame data", comment: "")
            case .InvalidDateString:
            return NSLocalizedString("A date cannot be parsed from the string in the required format", comment: "String needs to be in ISO8601 (yyyy-MM-dd`T`HH:mm) format, per ID3 specs")
        }
    }
}
