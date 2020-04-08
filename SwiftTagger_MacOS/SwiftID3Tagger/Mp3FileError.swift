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
        case invalidFileFormat
    }
}
