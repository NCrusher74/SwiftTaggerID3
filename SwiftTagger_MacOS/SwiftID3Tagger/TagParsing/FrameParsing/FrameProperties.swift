//
//  FrameProperties.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/9/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

struct FrameProperties {
    
    var version: ID3Version
    
    init(version: ID3Version) {
        self.version = version
    }
    
    /// the version-dependent size of the frame header, in bytes
    internal var frameHeaderSize: Int {
        switch self.version {
            case .version22: return 6
            case .version23, .version24: return 10
        }
    }
    
    /// the version-dependent byte offset for frame size
    internal var sizeOffset: Int {
        switch self.version {
            case .version22: return 2
            case .version23, .version24: return 4
        }
    }
    
    /// I have no idea what this is for
    internal var sizeMask: UInt32 {
        switch self.version {
            case .version22: return 0x00FFFFFF
            case .version23, .version24: return 0xFFFFFFFF
        }
    }
    
    /// the version-dependent byte-count of the id3identifier
    internal var identifierSize: Int {
        switch self.version {
            case .version22: return 3
            case .version23, .version24: return 4
        }
    }
    
    /// the version-dependent position of the encoding byte
    internal var encodingBytePosition: Int {
        switch self.version {
            case .version22: return 6
            case .version23, .version24: return 10
        }
    }
    
    internal var encodingByteSize: Int = 1
    
    internal var flags: [UInt8] {
        switch self.version {
            case .version22: return []
            case .version23, .version24: return [0x0, 0x0]
        }
    }

}
