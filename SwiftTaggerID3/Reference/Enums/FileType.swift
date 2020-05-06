//
//  FileType.swift
//  SwiftTaggerID3
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

public enum FileTypeRefinements: String, CaseIterable {
    /// MPEG 1/2 layer I
    case mpegLayerI = "/1"
    /// MPEG 1/2 layer II
    case mpegLayerII = "/2"
    /// MPEG 1/2 layer III
    case mpegLayerIII = "/3"
    /// MPEG 2.5
    case mpeg25 = "/2.5"
    /// Advanced Audio Compression
    case AAC = "/AAC"
    case none = ""
}
