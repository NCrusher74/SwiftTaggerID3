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
//        print(self.layout.id3Identifier(version: version)) // prints as expected
        self.frameKey = .unknown(uuid: self.uuid)
        self.contents = contents
    }

    init(identifier: String, key: UUID, contents: Data){
        self.flags = UnknownFrame.defaultFlags
        self.layout = .unknown(identifier)
//        print(self.layout)
        self.contents = contents
        self.frameKey = .unknown(uuid: uuid)
    }

    func encodeContents(version: Version) throws -> Data {
        return self.contents
    }
}
