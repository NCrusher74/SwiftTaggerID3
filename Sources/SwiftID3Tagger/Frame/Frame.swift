//
//  File.swift
//  
//
//  Created by Nolaine Crusher on 9/17/20.
//

import Foundation

class Frame {
    var identifier: FrameIdentifier
    var version: Version
    var size: Int
    var flags: Data
    
    func frameKey(version: Version) throws -> String {
        fatalError("Must be overridden from frame subclass")
    }

    @available(OSX 10.12, *)
    var contentData: Data {
        fatalError("Must be overridden from frame subclass")
    }
        
    init(identifier: FrameIdentifier,
         version: Version,
         size: Int,
         flags: Data) {
        self.identifier = identifier
        self.version = version
        self.size = size
        self.flags = flags
    }
}

enum FrameError: Error {
    case UnableToDecodeStringData
    case InvalidDateString
    case InvalidIdentifierString(String)
}
