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
        let size = try frameSize(frameStart: 0,
                             version: version,
                             mp3File: <#T##Mp3File#>)
        let flags = try frameFlags(frameStart: 0,
                               version: version,
                               mp3File: <#T##Mp3File#>)
        let contentData = // pull out however much you should
            
            try self.init(decodingContents: contentData, version: version, frameIdentifier: frameIdentifier, flags: flags)
        
        data.dropFirst(/* however much you pulled */)
        // This line leaves the slice ready for the next frame to read from the beginning.
    }
}


    
    internal func extractHeader(
        from frameData: inout Data.SubSequence,
        version: Version) {
        let id3Identifier = frameData.extractFirst(version.identifierLength)
//        assert(
//            String(ascii: name) == frameName.identifier(version: version),
//            "Mismatched frame name: \(String(ascii: name)) ≠ \(String(describing: frameName.identifier))"
//        )
        _ = frameData.extractFirst(version.sizeDeclarationLength)
        _ = frameData.extractFirst(version.flagsLength)
    }


    private func frameIdentifier(
        frameStart: Data.Index,
        version: Version,
        mp3File: Mp3File,
        knownFrameLayoutIdentifier: KnownFrameLayoutIdentifier
    ) throws -> FrameLayoutIdentifier {
        let mp3Data = mp3File.data
        let frameDataStart = version.identifierOffset
        let frameIdentifierRange = frameDataStart ..< frameDataStart + version.identifierLength
        guard frameIdentifierRange.upperBound <= mp3Data.endIndex
            else { throw Mp3File.Error.DataOutOfBounds }
        let frameIdentifierString = String(ascii: mp3Data[frameIdentifierRange])
        let knownFrameId3Identifiers = knownFrameLayoutIdentifier.id3Identifier(version: version)
        assert(frameIdentifierString == knownFrameId3Identifiers, "Unknown Frame Identifier")
        return FrameLayoutIdentifier(identifier: frameIdentifierString)
    }
    
    ///  the byte count of the frame
    private func frameSize(
        frameStart: Data.Index,
        version: Version,
        mp3File: Mp3File
    ) throws -> Int {
        // calculate content size
        let mp3Data = mp3File.data
        let sizeDataStart = frameStart + version.sizeDeclarationOffset
        let sizeDataRange = sizeDataStart ..< sizeDataStart + version.sizeDeclarationLength
        guard sizeDataRange.upperBound <= mp3Data.endIndex
            else { throw Mp3File.Error.DataOutOfBounds }
        
        let frameSizeData = mp3Data[sizeDataRange]
        var size: Int = 0
        let raw = UInt32(parsing: frameSizeData, .bigEndian)
        switch version {
            case .v2_2, .v2_3: size = Int(raw)
            case .v2_4: size = Int(raw.decodingSynchsafe())
        }
        // total size is content size plus header size
        return size + version.frameHeaderLength
    }
    
    private func frameFlags(
        frameStart: Data.Index,
        version: Version,
        mp3File: Mp3File
    ) throws -> Data {
        let mp3Data = mp3File.data
        let flagDataStart = frameStart + version.flagsOffset
        let flagDataRange = flagDataStart ..< flagDataStart + version.flagsLength
        guard flagDataRange.upperBound <= mp3Data.endIndex
            else { throw Mp3File.Error.DataOutOfBounds }
        return mp3Data[flagDataRange]
    }
    
    
    
    
}
