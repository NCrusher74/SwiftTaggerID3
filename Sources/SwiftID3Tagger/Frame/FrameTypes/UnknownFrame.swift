/*

 UnknownFrame.swift
 SwiftTaggerID3

 Copyright ©2020 Nolaine Crusher. All rights reserved.

 */

import Foundation

/** a type that passes through any unrecognized or unhandled frame content as-is */
public struct UnknownFrame: FrameProtocol, CustomStringConvertible {
    public var description: String {
        let data = self.contents
        let components = data.hexadecimal().components(separatedBy: " ")
        var array = [String]()
        for component in components {
            let newComponent = "0x\(component)"
            array.append(newComponent)
        }
        let string = array.joined(separator: " ")

        
        return """
        \(self.frameKey): \(string)
        """
    }

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

        let entry = (self.frameKey, self.uuid.uuidString, self.contents.hexadecimal())
        Tag.metadataWithDifferentiatingElement.removeAll(where: {$0.frameKey == self.frameKey})
        Tag.metadataWithDifferentiatingElement.append(entry)
    }

    init(identifier: String, key: UUID, contents: Data){
        self.flags = UnknownFrame.defaultFlags
        self.layout = .unknown(identifier)
        self.contents = contents
        self.frameKey = .unknown(uuid: uuid)

        let entry = (self.frameKey, self.uuid.uuidString, self.contents.hexadecimal())
        Tag.metadataWithDifferentiatingElement.removeAll(where: {$0.frameKey == self.frameKey})
        Tag.metadataWithDifferentiatingElement.append(entry)
    }

    func encodeContents(version: Version) throws -> Data {
        return self.contents
    }
}
