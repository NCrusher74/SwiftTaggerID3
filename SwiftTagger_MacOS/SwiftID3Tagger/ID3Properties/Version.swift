//
//  Version.swift
//  SwiftTagger_MacOS
//
//  This code is adapted from ID3TagEditor
//  Created by Fabrizio Duroni on 27/02/2018.
//  2018 Fabrizio Duroni. https://github.com/chicio/ID3TagEditor
//
//  Created by Nolaine Crusher on 4/8/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

public enum Version {
    /// ID3 v2.2
    case v2_2
    /// ID3 v2.3
    case v2_3
    /// ID3 v2.4
    case v2_4
    
}

extension Version {
    // Tag Components    
    /// the version-dependent byte-count of the version declaration
    var versionLength: Int {
        switch self {
            case .v2_2:
                return 3
            case .v2_3, .v2_4:
                return 4
        }
    }
    
    
    // Frame component sizes.
    /// the version-dependent byte-count of the id3identifier
    var identifierLength: Int {
        switch self {
            case .v2_2:
                return 3
            case .v2_3, .v2_4:
                return 4
        }
    }
    
    /// the version-dependent byte-count of the frame size declaration
    var sizeDeclarationLength: Int {
        switch self {
            case .v2_2:
                return 3
            case .v2_3, .v2_4:
                return 4
        }
    }
    
    /// the version-dependent byte-count of the frame flags
    var flagsLength: Int {
        switch self {
            case .v2_2:
                return 0
            case .v2_3, .v2_4:
                return 2
        }
    }
    
    /// the version-dependent size of the frame header, in bytes
    internal var frameHeaderLength: Int {
        return identifierLength + sizeDeclarationLength + flagsLength
    }
    
    // Frame component offsets:
    ///the byte offset of the frame identifier
    var identifierOffset: Int {
        return 0
    }
    
    /// the byte offset of the frame size declaration
    var sizeDeclarationOffset: Int {
        return identifierOffset  + identifierLength
    }
    
    /// the byte offset of the frame flags
    var flagsOffset: Int {
        return sizeDeclarationOffset + sizeDeclarationLength
    }
    
    /// the version-dependent position of the encoding byte
    internal var encodingByteOffset: Int {
        return frameHeaderLength
    }
    
    /// the version-dependent flags in a frame header
    internal var flags: [UInt8] {
        switch self {
            case .v2_2: return []
            case .v2_3, .v2_4: return [0x0, 0x0]
        }
    }
    
    
}
