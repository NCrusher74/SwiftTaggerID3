/*

 UnknownFrame.swift
 SwiftTaggerID3

 Copyright ©2020 Nolaine Crusher. All rights reserved.

 */

import Foundation

/** a type that passes through any unrecognized or unhandled frame content as-is */
public struct UnknownFrame: FrameProtocol {
    
    // // MARK: - Properties
    var flags: Data
    var layout: FrameLayoutIdentifier
    var frameKey: FrameKey
    var uuid = UUID()
    var contents: Data
    
    init(decodingContents contents: Data.SubSequence,
         version: Version,
         layout: FrameLayoutIdentifier,
         flags: Data
    ) throws {
        self.flags = flags
        self.layout = layout
        self.frameKey = .unknown(uuid: self.uuid)
        self.contents = contents
        Tag.listMetadata.removeAll(where: {$0.frameKey == self.frameKey})
        Tag.listMetadata.append((self.frameKey, self.contents))
    }

    init(identifier: String, key: UUID, contents: Data){
        self.flags = UnknownFrame.defaultFlags
        self.layout = .unknown(identifier)
        self.contents = contents
        self.frameKey = .unknown(uuid: uuid)
        Tag.listMetadata.removeAll(where: {$0.frameKey == self.frameKey})
        Tag.listMetadata.append((self.frameKey, self.contents))
    }

    func encodeContents(version: Version) throws -> Data {
        return self.contents
    }
}
