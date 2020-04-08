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
    }
}
