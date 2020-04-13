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
    
    func encode(version: Version) throws -> Data {
        let contents = try self.encodeContents(version: version)
        let size =
        let frameData = // header stuff plus the contents
        return frameData
    }

    init(decodingFromStartOf data: inout Data.SubSequence, version: Version, frameIdentifier: FrameLayoutIdentifier) throws {
        let size = frameSize
        let flags = // parse them out
        let contentData = // pull out however much you should
            
            try self.init(decodingContents: contentData, version: version, frameIdentifier: frameIdentifier, flags: flags)
        
        data.dropFirst(/* however much you pulled */)
        // This line leaves the slice ready for the next frame to read from the beginning.
    }

    ///  the size of the content of the frame, in bytes
    private func frameSize(
        frameStart: Data.Index,
        version: Version,
        mp3File: Mp3File
    ) -> Int {
        // calculate content size
        let mp3Data = mp3File.data
        let sizeDataStart = frameStart + version.sizeDeclarationOffset
        let sizeDataRange = sizeDataStart ..< sizeDataStart + version.sizeDeclarationLength
        guard sizeDataRange.upperBound <= mp3Data.endIndex else {
            // If the data is corrupt and doesn’t even have room for a size declaration,
            // it also doesn’t have room for content,
            // and the header isn’t considered part of the size.
            return 0
        }
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
    
}
