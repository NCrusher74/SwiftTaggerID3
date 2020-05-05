//
//  UnknownFrame.swift
//  SwiftTaggerID3
//
//  Created by Nolaine Crusher on 4/16/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

/** a type that passes through any unrecognized or unhandled frame content as-is */
public struct UnknownFrame: FrameProtocol {
    
 
    public init(identifier: String, key: UUID, contents: Data){
        self.flags = UnknownFrame.defaultFlags
        self.layout = .unknown(self.uuid.uuidString)
        self.contents = contents
        self.frameKey = .unknown(uuid: uuid)
    }

    var contents: Data
    
    private init(layout: FrameLayoutIdentifier, uuid: UUID, contents: Data){
        self.flags = UnknownFrame.defaultFlags
        self.layout = layout
        self.contents = contents
        self.uuid = uuid
        self.frameKey = .unknown(uuid: uuid)
    }

    func encodeContents(version: Version) throws -> Data {
        return self.contents
    }
    
    /// The frame flags property.
    ///
    /// Typically this is two bytes `[0x00, 0x00]`
    /// SwiftTagger does not support altering these flags.
    var flags: Data
    /// The layout property describes the unique structure of a given frame
    var layout: FrameLayoutIdentifier
    /** The frameKey property
     
     Provides a unique identifier to permits duplication of frame types that the ID3 spec allows to be duplicated within a tag. */
    var frameKey: FrameKey
    /** A boolean value indicating whether or not frames of a particular type are permitted to be duplicated in a valid ID3 tag */
    var allowMultipleFrames: Bool = false
    var uuid = UUID()
    
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
    ) throws {
        self.flags = flags
        self.layout = layout
        self.frameKey = .unknown(uuid: self.uuid)
        self.contents = contents
    }
}
