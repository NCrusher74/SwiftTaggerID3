//
//  FrameParser.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/12/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

internal protocol FrameParser {
    var frameName: FrameLayoutIdentifier { get }
}

extension FrameParser {
    
    internal func extractHeader(from frameData: inout Data.SubSequence, version: Version) {
        let name = frameData.extractFirst(version.identifierLength)
        assert(
            String(ascii: name) == frameName.id3Identifier(version: version),
            "Mismatched frame name: \(String(ascii: name)) ≠ \(String(describing: frameName.id3Identifier))"
        )
        _ = frameData.extractFirst(version.sizeDeclarationLength)
        _ = frameData.extractFirst(version.flagsLength)
    }
    
    internal func extractEncoding(from frameData: inout Data.SubSequence) -> StringEncoding {
        return frameData.extractFirst(1).first.flatMap({ StringEncoding(rawValue: $0) })
            ?? .utf8
    }
    
    internal func extractDescriptionAndValue(
        from frameData: inout Data.SubSequence,
        encoding: StringEncoding
    ) -> (description: String?, value: String) {
        let description = frameData.extractPrefixAsStringUntilNullTermination(encoding)
        let content = frameData.extractPrefixAsStringUntilNullTermination(encoding) ?? ""
        return (description: description, value: content)
    }
    
    internal func extractCreditStrings(
        from frameData: inout Data.SubSequence,
        encoding: StringEncoding
    ) -> [(String, String)] {
        var strings: [String] = []
        
        while !frameData.isEmpty,
            let next = frameData.extractPrefixAsStringUntilNullTermination(encoding) {
                strings.append(next)
        }
        let rolePersonArray = strings.pairs()
        return rolePersonArray as! [(String, String)]
    }
    
//    internal func extractChapterElements(
//        from frameData: inout Data.SubSequence,
//        version: Version,
//        encoding: StringEncoding
//    ) -> (
//        elementID: String,
//        startTime: Int,
//        endTime: Int,
//        startByteOffset: Int,
//        endByteOffset: Int,
//        embeddedSubframes: [FrameKey: Frame]?
//        ) {
//            let elementID = frameData.extractPrefixAsStringUntilNullTermination(encoding) ?? "chXX"
//
//            let startTime = Int(frameData.extractFirst(4).uint32)
//            let endTime = Int(frameData.extractFirst(4).uint32)
//            let startByteOffset = Int(frameData.extractFirst(4).uint32)
//            let endByteOffset = Int(frameData.extractFirst(4).uint32)
//
//            let subframePseudoTag = subframePseudoTagParser.parse(
//                subframeData: frameData, version: version)
//            let embeddedSubframes = subframePseudoTag?.frames
//
//            return (elementID: elementID,
//                    startTime: startTime,
//                    endTime: endTime,
//                    startByteOffset: startByteOffset,
//                    endByteOffset: endByteOffset,
//                    embeddedSubframes: embeddedSubframes)
//    }
}
