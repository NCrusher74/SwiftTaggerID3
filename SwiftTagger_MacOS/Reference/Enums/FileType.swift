//
//  FileType.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/29/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

public enum FileType: String {
    case MIME
    case MPG
    case VQF
    case PCM
    
}

public enum FileTypeRefinements: String {
    case mpegLayerI = "MPEG 1/2 layer I"
    case mpegLayerII = "MPEG 1/2 layer II"
    case mpegLayerIII = "MPEG 1/2 layer III"
    case mpegTwoPointFive = "MPEG 2.5"
    case advancedAudioCompression = "Advanced Audio Compression"
    
    var code: String {
        switch self {
            case .mpegLayerI: return "/1"
            case .mpegLayerII: return "/2"
            case .mpegLayerIII: return "/3"
            case .mpegTwoPointFive: return "/2.5"
            case .advancedAudioCompression: return "/AAC"
        }
    }
}
