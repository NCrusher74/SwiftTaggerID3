//
//  FrameProperties.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/9/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

struct FrameProperties {
    
    var mp3File: Mp3File
    var version: Version
    
    init(mp3File: Mp3File, version: Version) {
        self.mp3File = mp3File
        self.version = version
    }
    
    internal func frameIdentifier(
        from frameData: inout Data.SubSequence,
        version: Version,
        frameInfo: FrameInformation
    ) -> String {
        let identifier = frameData.extractFirst(version.identifierLength)
        assert(
            String(ascii: identifier) == frameInfo.id3Identifier(version: version),
            "Mismatched frame name: \(String(ascii: identifier)) ≠ \(String(describing: frameInfo.id3Identifier))"
        )
        return String(ascii: identifier)
    }
    
    internal func frameSize(
        frameStart: Data.Index,
        version: Version
    ) -> Int {
        let headerLength = version.frameHeaderLength
        return headerLength + frameContentSize(
            frameStart: frameStart, version: version)
    }
    
    private func frameContentSize(
        frameStart: Data.Index,
        version: Version
    ) -> Int {
        let mp3Data = self.mp3File.data
        let sizeDataStart = frameStart + version.sizeDeclarationOffset
        let sizeDataRange = sizeDataStart ..< sizeDataStart + version.sizeDeclarationLength
        guard sizeDataRange.upperBound <= mp3Data.endIndex else {
            // If the data is corrupt and doesn’t even have room for a size declaration,
            // it also doesn’t have room for content,
            // and the header isn’t considered part of the size.
            return 0
        }
        let frameSizeData = mp3Data[sizeDataRange]
        let raw = UInt32(parsing: frameSizeData, .bigEndian)
        switch version {
            case .v2_2, .v2_3:
                return Int(raw)
            case .v2_4:
                return Int(raw.decodingSynchsafe())
        }
    }
}
