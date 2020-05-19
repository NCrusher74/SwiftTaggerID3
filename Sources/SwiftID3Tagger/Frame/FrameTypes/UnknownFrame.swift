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
    
    private init(_ layout: FrameLayoutIdentifier,
                 uuid: UUID,
                 contents: Data){
        self.flags = UnknownFrame.defaultFlags
        self.layout = layout
        self.contents = contents
        self.uuid = uuid
        self.frameKey = .unknown(uuid: uuid)
    }

    func encodeContents(version: Version) throws -> Data {
        return self.contents
    }
    
    // MARK: Properties
    var flags: Data
    var layout: FrameLayoutIdentifier
    var frameKey: FrameKey
    var allowMultipleFrames: Bool = false
    var uuid = UUID()
    
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
