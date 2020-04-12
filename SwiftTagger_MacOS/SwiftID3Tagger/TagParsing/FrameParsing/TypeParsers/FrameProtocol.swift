//
//  FrameProtocol.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/9/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation
/**
 A type representing the properties of a frame
 */
protocol FrameProtocol {
    
    var mp3File: Mp3File { get }
    var version: Version { get }
    var frameData: Data.SubSequence { get }
    
    ///  - parameter mp3File: the mp3 file containing the tag containing the frame.
    ///  - parameter version: the version of the tag, and hence the frame.
    init(mp3File: Mp3File, version: Version)
}

extension FrameProtocol {
    
    internal func frameHeader(
        from frameData: inout Data.SubSequence,
        version: Version,
        frameID: FrameLayoutIdentifier) -> FrameLayoutIdentifier {
        let name = frameData.extractFirst(version.identifierLength)
        
        assert(
            String(ascii: name) == frameID.id3Identifier(version: version),
            "Mismatched frame name: \(String(ascii: name)) ≠ \(String(describing: frameID.id3Identifier))"
        )
        _ = frameData.extractFirst(version.sizeDeclarationLength)
        _ = frameData.extractFirst(version.flagsLength)
        return FrameLayoutIdentifier(identifier: (String(ascii: name)))
    }
    
    
    internal func frameEncoding(from frameData: inout Data.SubSequence) -> StringEncoding {
        return frameData.extractFirst(1).first.flatMap({ StringEncoding(rawValue: $0) })
            ?? .utf8
    }
    
    /// the size of the frame, in bytes
    /// calculated from the size of the content and the size of the header
    internal func frameSize(
        frameStart: Data.Index,
        version: Version
    ) -> Int {
        let headerLength = version.frameHeaderLength
        return headerLength + frameContentSize(
            frameStart: frameStart, version: version)
    }
    
    ///  the size of the content of the frame, in bytes
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
