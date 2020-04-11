//
//  FrameParser.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/9/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

/**
 A protocol to which all frame parser types will conform
 */
internal protocol FrameParser {
    var frameName: FrameName { get }
}

extension FrameParser {

    /// extracts the header data from the frame, which includes `identifier`, `sizeDeclaration`, and `flags`
    ///  - parameter frameData: the data of frame
    ///  - parameter version: the ID3 version of the frame.
    ///  - parameter frameInfo: a type containing methods of handling the content of a frame based on frame type.
    internal func extractHeader(
        from frameData: inout Data.SubSequence,
            version: Version,
            frameInfo: FrameInformation) {
        let identifier = frameData.extractFirst(version.identifierLength)
        assert(
            String(ascii: identifier) == frameInfo.id3Identifier(version: version),
            "Mismatched frame name: \(String(ascii: identifier)) ≠ \(String(describing: frameInfo.id3Identifier))"
        )
        _ = frameData.extractFirst(version.sizeDeclarationLength)
        _ = frameData.extractFirst(version.flagsLength)
    }
    
    /// extracts the encoding byte from the frame, which is the byte immediately following the header
    ///  - parameter frameData: the data of frame
    internal func extractEncoding(from frameData: inout Data.SubSequence) throws -> StringEncoding {
        return frameData.extractFirst(1).first.flatMap({ StringEncoding(rawValue: $0) })
            ?? .utf8
    }

    /// extracts a content string from a `StringFrame` type of frame, based on encoding
    ///  - parameter frameData: the data of frame
    ///  - parameter encoding: the encoding of the string
    internal func extractContentString(
        from frameData: inout Data.SubSequence,
        encoding: StringEncoding
    ) -> String {
        return frameData.extractPrefixAsStringUntilNullTermination(encoding) ?? ""
    }

    
    
}
