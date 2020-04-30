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
    
    var flags: Data { get set }
    var layout: FrameLayoutIdentifier { get }
    var frameKey: FrameKey { get set }
    
    func encodeContents(version: Version) throws -> Data
    
    init(decodingContents contents: Data.SubSequence,
         version: Version,
         layout: FrameLayoutIdentifier,
         flags: Data
    ) throws
}

extension FrameProtocol {
    
    // encode the contents of the frames to data
    func encode(version: Version) throws -> Data {
        let contents = try self.encodeContents(version: version)
        
        // header data
        let identifier = Self.identifierData(layout: layout, version: version)
        let size = Self.calculateFrameContentSize(encodedContent: contents, version: version)
        var flags = Data()
        switch version {
            case .v2_2:
                break // Skip flags.
            case .v2_3, .v2_4:
                flags = Self.defaultFlags
        }
        
        let frameData = identifier + size + flags + contents
        return frameData
    }
    
    
    init(decodingFromStartOf data: inout Data.SubSequence,
         version: Version,
         layout: FrameLayoutIdentifier) throws {
        // parse size first
        let frameSizeData = data.extractFirst(version.sizeDeclarationLength)
        var frameSize: Int = 0
        let raw = UInt32(parsing: frameSizeData, .bigEndian)
        switch version {
            case .v2_2, .v2_3: frameSize = Int(raw)
            case .v2_4: frameSize = Int(raw.decodingSynchsafe())
        }

        // parse flags second
        var flagsData: Data
        switch version {
            case .v2_2: flagsData = Data()
            case .v2_3, .v2_4: flagsData = data.extractFirst(version.flagsLength)
        }

        // parse content last
        let contentDataStart = data.startIndex
        let contentDataRange = contentDataStart ..< contentDataStart + frameSize
        let contentData = data.subdata(in: contentDataRange)
        try self.init(decodingContents: contentData,
                      version: version,
                      layout: layout,
                      flags: flagsData
        )
        
        data = data.dropFirst(contentData.count)
        // This line leaves the slice ready for the next frame to read from the beginning.
    }
    
    // calculates the size of the frame for encoding purposes
    static func calculateFrameContentSize(encodedContent: Data, version: Version) -> Data {
        let contentSize = UInt32(encodedContent.count)
        switch version {
            case .v2_2:
                let contentUInt8Array = [UInt8](contentSize.bigEndianData)
                return Data(contentUInt8Array.dropFirst())
            case .v2_3: return contentSize.bigEndianData
            case .v2_4: return contentSize.encodingSynchsafe().bigEndianData
        }
    }
    
    // calculates the ID3 Indentifier from the layout
    static func identifierData(layout: FrameLayoutIdentifier, version: Version) -> Data {
        guard let identifierString = layout.id3Identifier(version: version)?.encoded(withNullTermination: false) else {
            switch version {
                case .v2_2: return "TXX".encoded(withNullTermination: false)
                case .v2_3, .v2_4: return "TXXX".encoded(
                    withNullTermination: false)
            }
        }
        return identifierString
    }
    
    // flags are rarely used and are unhandled by SwiftTagger
    static var defaultFlags: Data {
        let flagBytes: [UInt8] = [0x00, 0x00]
        return Data(flagBytes)
    }
    
    /* extracts and decodes the encoding byte, leaving the remaining data ready to be parsed and returning information on the encoding of the frame's contents */
    static func extractEncoding(data: inout Data.SubSequence, version: Version) throws -> StringEncoding {
        let encodingData = data.extractFirst(1)
        let encodingByteArray = [UInt8](encodingData)
        let encodingByte = encodingByteArray.first ?? 0x00
        return StringEncoding(rawValue: encodingByte) ?? .utf8
    }
    
    // extracts and decodes description and content strings for frame types that use them.
    static func extractDescriptionAndContent(
        from frameData: inout Data.SubSequence,
        encoding: StringEncoding
    ) throws -> (description: String?, content: String) {
        let description = frameData.extractPrefixAsStringUntilNullTermination(encoding)
        let content = frameData.extractPrefixAsStringUntilNullTermination(encoding) ?? ""
        return (description: description, content: content)
    }
}
