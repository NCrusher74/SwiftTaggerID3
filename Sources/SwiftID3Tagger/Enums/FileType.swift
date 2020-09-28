/*

 FileType.swift
 SwiftTaggerID3

 Copyright ©2020 Nolaine Crusher. All rights reserved.

 */

import Foundation

enum FileType: String, CaseIterable {
    case MIME
    case MPG
    case VQF
    case PCM
    case none
    
}

enum FileTypeRefinements: String, CaseIterable {
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
    case none = "none"
}
