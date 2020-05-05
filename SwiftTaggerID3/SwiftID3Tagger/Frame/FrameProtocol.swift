//
//  FrameProtocol.swift
//  SwiftTaggerID3
//
//  Created by Nolaine Crusher on 4/9/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation
/**
 A type representing the properties and methods used by all frames
 */
protocol FrameProtocol {
    
    /// The frame flags property.
    ///
    /// Typically this is two bytes `[0x00, 0x00]`
    /// SwiftTagger does not support altering these flags.
    var flags: Data { get set }
    /// The layout property describes the unique structure of a given frame
    var layout: FrameLayoutIdentifier { get }
    /** The frameKey property
     
        Provides a unique identifier to permits duplication of frame types that the ID3 spec allows to be duplicated within a tag. */
    var frameKey: FrameKey { get set }
    /** A boolean value indicating whether or not frames of a particular type are permitted to be duplicated in a valid ID3 tag */
    var allowMultipleFrames: Bool { get }
    
    /// Encodes the contents of a frame
    func encodeContents(version: Version) throws -> Data
    
    /// Initialize a frame parsing operation
    /// - Parameters:
    ///   - contents: the slice of data containing the frame
    ///   - version: the ID3 version of the tag
    ///   - layout: the frame's FrameLayoutIdentifier
    ///   - flags: (current unsupported by SwiftTagger) [0x00, 0x00]
    init(decodingContents contents: Data.SubSequence,
         version: Version,
         layout: FrameLayoutIdentifier,
         flags: Data
    ) throws
}

extension FrameProtocol {
    
    /// Encode a frame to data, including frame headers
    /// - Parameter version: The version of the ID3 tag
    /// - Throws: Caller will determine how to handle errors
    /// - Returns: `Data` containing frame header and contents
    func encode(version: Version) throws -> Data {
        let contents = try self.encodeContents(version: version)
        
        var frameData = Data()
        // encode and append header data
        frameData.append(Self.identifierData(layout: layout, version: version))
        frameData.append(Self.calculateFrameContentSize(encodedContent: contents, version: version))
        switch version {
            case .v2_2:
                break // Skip flags.
            case .v2_3, .v2_4:
                frameData.append(Self.defaultFlags)
        }
        // append encoded frame content data
        frameData.append(contents)
        return frameData
    }
    
    
    /// Parses the frame data
    /// - Parameters:
    ///   - data: the remaining data in the `Tag`
    ///   - version: the version of the ID3 tag
    ///   - layout: the FrameLayoutIdentifier
    /// - Throws: Caller will determine how errors are handled
    init(decodingFromStartOf data: inout Data.SubSequence,
         version: Version,
         layout: FrameLayoutIdentifier) throws {
        // parse size data first
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
    
    /// Calculates the size of the frame for encoding purposes
    /// - Parameters:
    ///   - encodedContent: The byte-count of the content data for the frame
    ///   - version: The version of the ID3 tag
    /// - Returns:
    ///   - Version 2.2: three bytes of frame-size data.
    ///   - Versions 2.3 & 2.4: four bytes of frame-size data
    static func calculateFrameContentSize(encodedContent: Data, version: Version) -> Data {
        let contentSize = encodedContent.count.truncatedUInt32
        switch version {
            case .v2_2:
                let contentUInt8Array = [UInt8](contentSize.bigEndianData)
                return Data(contentUInt8Array.dropFirst())
            case .v2_3: return contentSize.bigEndianData
            case .v2_4: return contentSize.encodingSynchsafe().bigEndianData
        }
    }
    
    /// Calculates and extracts the ID3 indentifier from the layout
    /// - Parameters:
    ///   - layout: the FrameLayoutIdentifier
    ///   - version: The version of the ID3 tag
    /// - Returns: The encoded identifier string
    static func identifierData(
        layout: FrameLayoutIdentifier,
        version: Version) -> Data {
        guard let identifierString = layout.id3Identifier(version: version)?.encoded(withNullTermination: false) else {
            switch version {
                case .v2_2: return "TXX".encoded(withNullTermination: false)
                case .v2_3, .v2_4: return "TXXX".encoded(
                    withNullTermination: false)
            }
        }
        return identifierString
    }
    
    /// Flags are rarely used and are unhandled by SwiftTagger
    static var defaultFlags: Data {
        let flagBytes: [UInt8] = [0x00, 0x00]
        return Data(flagBytes)
    }
    
    /** Extracts and decodes the encoding byte, leaving the remaining data ready to be parsed and returning information on the encoding of the frame's contents
    - Parameters:
      - data: The frame data beginning at the encoding byte
      - version: The ID3 version of the tag
      - Throws: Caller will determine how to handle any errors
      - Returns: A `StringEncoding` instance */
    static func extractEncoding(data: inout Data.SubSequence, version: Version) throws -> StringEncoding {
        let encodingData = data.extractFirst(1)
        let encodingByteArray = [UInt8](encodingData)
        let encodingByte = encodingByteArray.first ?? 0x00
        return StringEncoding(rawValue: encodingByte) ?? .utf8
    }
    
    /// Extracts and decodes description and content strings for frame types that use them.
    /// - Parameters:
    ///   - frameData: The frame's data beginning at the description string
    ///   - encoding: The `StringEncoding` instance parsed out of the frame content previously
    /// - Throws: Caller will determine how to handle any errors
    /// - Returns: The frame's description and content strings
    static func extractDescriptionAndContent(
        from frameData: inout Data.SubSequence,
        encoding: StringEncoding
    ) throws -> (description: String?, content: String) {
        let description = frameData.extractPrefixAsStringUntilNullTermination(encoding)
        let content = frameData.extractPrefixAsStringUntilNullTermination(encoding) ?? ""
        return (description: description, content: content)
    }
}
