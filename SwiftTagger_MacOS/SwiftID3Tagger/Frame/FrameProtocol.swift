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
     
     Frame ID      $xx xx xx  (three characters) - 3 bytes
     Size      3 * %0xxxxx - 3 bytes
     
     (v2.3 & v2.4)
     All ID3v2 frames consists of one frame header followed by one or more fields containing the actual information. The header is always 10 bytes and laid out as follows:
     
     Frame ID      $xx xx xx xx  (four characters) - 4 bytes
     Size      4 * %0xxxxxxx - 4 bytes
     Flags         $xx xx - 2 bytes
     */
    
//    func encode(version: Version) throws -> Data {
//        let contents = try self.encodeContents(version: version)
//
//        let frameData = // header stuff plus the contents
//        return frameData
//    }
    
    
    init(decodingFromStartOf data: inout Data.SubSequence,
         version: Version,
         frameIdentifier: FrameLayoutIdentifier) throws {
        
        // parse content size
        // (The ID3 size declaration describes only the content;
        // it does not include the header.)
        let frameSizeData = data.extractFirst(version.sizeDeclarationLength)
        var frameSize: Int = 0
        let raw = UInt32(parsing: frameSizeData, .bigEndian)
        switch version {
            case .v2_2, .v2_3: frameSize = Int(raw)
            case .v2_4: frameSize = Int(raw.decodingSynchsafe())
        }
        
        // parse flags
        let flagsData = data.extractFirst(version.flagsLength)
        
        let contentDataStart = data.startIndex + version.frameHeaderLength
        let contentDataRange = contentDataStart ..< contentDataStart + frameSize
        let contentData = data.subdata(in: contentDataRange)
        
        try self.init(decodingContents: contentData,
                      version: version,
                      frameIdentifier: frameIdentifier,
                      flags: flagsData)
        
        data = data.dropFirst(version.frameHeaderLength + contentData.count)
        // This line leaves the slice ready for the next frame to read from the beginning.
    }
    
//    internal static func calculateContentSize() -> Data {
//        
//    }
            
    internal static func extractEncoding(data: inout Data.SubSequence, version: Version) -> StringEncoding {
        let encodingByteOffset = version.encodingByteOffset
        let encodingByte = data[encodingByteOffset]
        let validEncodingBytes: [UInt8] = [0x00, 0x01, 0x02, 0x03]
        assert(
            validEncodingBytes.contains(encodingByte), "Invalid encoding detected. Attempting default encoding."
        )
        return StringEncoding(rawValue: encodingByte) ?? .utf8
    }
    
    internal func extractTerminatedString(
        data: inout Data.SubSequence,
        version: Version,
        encoding: StringEncoding) -> String {
        return data.extractPrefixAsStringUntilNullTermination(encoding) ?? ""
    }
}
