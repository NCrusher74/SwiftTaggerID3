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
    var size: Int { get }
    var identifier: FrameLayoutIdentifier { get }
    
    func encodeContents(version: Version) throws -> Data
    init(decodingContents contents: Data.SubSequence,
         version: Version,
         frameIdentifier: FrameLayoutIdentifier,
         flags: Data) throws
}

extension FrameProtocol {
    
    /*
     (v2.2)
     The three character frame identifier is followed by a three byte size descriptor, making a total header size of six bytes in every frame. The size is calculated as framesize excluding frame identifier and size descriptor (frame size - 6).
     
     (v2.3 & v2.4)
     All ID3v2 frames consists of one frame header followed by one or more fields containing the actual information. The header is always 10 bytes and laid out as follows:
     
     Frame ID      $xx xx xx xx  (four characters)
     Size      4 * %0xxxxxxx
     Flags         $xx xx
     */
    
    //    func encode(version: Version) throws -> Data {
    //        let contents = try self.encodeContents(version: version)
    //        let size =
    //        let frameData = // header stuff plus the contents
    //        return frameData
    //    }
    init(decodingFromStartOf data: inout Data.SubSequence,
         version: Version,
         frameIdentifier: FrameLayoutIdentifier) throws {

        let dataStart = data.startIndex
        
        // parse identifier
        let frameDataStart = data.startIndex
        let frameIdentifierRange = frameDataStart ..< frameDataStart + version.identifierLength
        guard frameIdentifierRange.upperBound <= data.endIndex
            else { throw Mp3File.Error.DataOutOfBounds }
        let frameIdentifierBytes = data.subdata(in: frameIdentifierRange)
        let frameIdentifierString = String(ascii: frameIdentifierBytes)
        let frameId3Identifiers = frameIdentifier.id3Identifier(version: version)
        assert(frameIdentifierString == frameId3Identifiers, "Unknown Frame Identifier")

        // parse size
        let sizeDataStart = dataStart + version.sizeDeclarationOffset
        let sizeDataRange = sizeDataStart ..< sizeDataStart + version.sizeDeclarationLength
        guard sizeDataRange.upperBound <= data.endIndex
            else { throw Mp3File.Error.DataOutOfBounds }
        let frameSizeData = data.subdata(in: sizeDataRange)
        var frameSize: Int = 0
        let raw = UInt32(parsing: frameSizeData, .bigEndian)
        switch version {
            case .v2_2, .v2_3: frameSize = Int(raw)
            case .v2_4: frameSize = Int(raw.decodingSynchsafe())
        }
        // total size is content size plus header size
        let size = frameSize + version.frameHeaderLength

        // parse flags
        let flagDataStart = data.startIndex + version.flagsOffset
        let flagDataRange = flagDataStart ..< flagDataStart + version.flagsLength
        guard flagDataRange.upperBound <= data.endIndex
            else { throw Mp3File.Error.DataOutOfBounds }
        let flags = data.subdata(in: flagDataRange)

        let contentDataStart = data.startIndex + version.frameHeaderLength
        let contentDataRange = contentDataStart ..< contentDataStart + size
        let contentData = data.subdata(in: contentDataRange)
            try self.init(decodingContents: contentData, version: version, frameIdentifier: frameIdentifier, flags: flags)
        
        data.dropFirst(contentData.count)
        // This line leaves the slice ready for the next frame to read from the beginning.
    }
    
    
}
