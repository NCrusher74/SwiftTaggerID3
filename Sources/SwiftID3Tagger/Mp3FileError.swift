//
//  File.swift
//  
//
//  Created by Nolaine Crusher on 9/17/20.
//

import Foundation

enum Mp3FileError: Error {
    case InvalidFileFormat
    case UnableToReadFileData
    case InvalidStringEncodingByte
    case UnableToDetermineUniqueFrameID(String)
}
