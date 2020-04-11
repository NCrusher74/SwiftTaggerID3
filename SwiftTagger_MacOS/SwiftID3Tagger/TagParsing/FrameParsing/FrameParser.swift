//
//  TagParser.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/9/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

internal protocol FrameParser {
    var frameName: FrameName { get }
}

extension FrameParser {

    internal func extractHeader(from frameData: inout Data.SubSequence, version: Version, frameInfo: FrameInformation) {
        let identifier = frameData.extractFirst(version.identifierLength)
        assert(
            String(ascii: identifier) == frameInfo.id3Identifier(version: version),
            "Mismatched frame name: \(String(ascii: identifier)) ≠ \(String(describing: frameInfo.id3Identifier))"
        )
        _ = frameData.extractFirst(version.sizeDeclarationLength)
        _ = frameData.extractFirst(version.flagsLength)
    }
    
    internal func extractEncoding(from frameData: inout Data.SubSequence) throws -> StringEncoding {
        return frameData.extractFirst(1).first.flatMap({ StringEncoding(rawValue: $0) })
            ?? .utf8
    }

    internal func extractContentString(
        from frameData: inout Data.SubSequence,
        encoding: StringEncoding
    ) -> String {
        return frameData.extractPrefixAsStringUntilNullTermination(encoding) ?? ""
    }

    
    
}
