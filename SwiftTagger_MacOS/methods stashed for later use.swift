//
//  methods stashed for later use.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/10/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

// You can put this method wherever
// and swap whatever you want between parameters and type properties.
func declaredSize(
    file: Data,
    frameStart: Data.Index,
    version: Version
) -> Int {
    
    let sizeDataStart = frameStart + version.sizeDeclarationOffset
    let sizeDataRange = sizeDataStart ..< sizeDataStart + version.sizeDeclarationLength
    guard sizeDataRange.upperBound <= file.endIndex else {
        // If the data is corrupt and doesn’t even have room for a size declaration,
        // it also doesn’t have room for content,
        // and the header isn’t considered part of the size.
        return 0
    }
    let frameSizeData = file[sizeDataRange]
    let raw = UInt32(parsing: frameSizeData, .bigEndian)
    switch version {
        case .v2_2, .v2_3:
            return Int(raw)
        case .v2_4:
            return Int(raw.decodingSynchsafe())
    }
}
