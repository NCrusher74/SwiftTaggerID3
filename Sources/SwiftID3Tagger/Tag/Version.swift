/*

 Version.swift
 SwiftTaggerID3

 Copyright ©2020 Nolaine Crusher. All rights reserved.

 */

import Foundation

/**
 An enum determining ID3 version and housing variables and methods are that dependent upon ID3 version
 */
public enum Version: CaseIterable {
    /// ID3 v2.2
    case v2_2
    /// ID3 v2.3
    case v2_3
    /// ID3 v2.4
    case v2_4
        
}

extension Version {
    // MARK: Frame component sizes.
    /// The known version-dependent byte-count of the ID3 identifier string
    var identifierLength: Int {
        switch self {
            case .v2_2:
                return 3
            case .v2_3, .v2_4:
                return 4
        }
    }
    
    /// The known version-dependent byte-count of the frame size declaration
    var sizeDeclarationLength: Int {
        switch self {
            case .v2_2:
                return 3
            case .v2_3, .v2_4:
                return 4
        }
    }
    
    /// The known version-dependent byte-count of the frame flags
    var flagsLength: Int {
        switch self {
            case .v2_2:
                return 0
            case .v2_3, .v2_4:
                return 2
        }
    }
    
    /// The version-dependent size of the frame header, in bytes
    var frameHeaderLength: Int {
        return identifierLength + sizeDeclarationLength + flagsLength
    }
    
    // MARK: Frame component offsets:
    /// The known byte offset of the frame identifier from start of frame data
    var identifierOffset: Data.Index {
        return 0
    }
    
    /// The byte offset of the frame size declaration
    var sizeDeclarationOffset: Data.Index {
        return identifierOffset  + identifierLength
    }
    
    /// The byte offset of the frame flags
    var flagsOffset: Data.Index {
        return sizeDeclarationOffset + sizeDeclarationLength
    }
    
    /// The version-dependent position of the encoding byte
    var encodingByteOffset: Data.Index {
        return frameHeaderLength
    }
}
