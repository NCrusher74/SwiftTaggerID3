//
//  Mp3FileError.swift
//  SwiftTaggerID3
//
//  Created by Nolaine Crusher on 9/17/20.
//

import Foundation

enum Mp3FileError: Error {
    case InvalidFileFormat
    case UnableToReadFileData
    case InvalidVersionData
    case UnableToDetermineID3Version
    case InvalidStringEncodingByte
    case UnableToDetermineUniqueFrameID(String)
}
