/*

 TableOfContentsFrame.swift
 SwiftTaggerID3

 Copyright ©2020 Nolaine Crusher. All rights reserved.

 */

import Foundation
/**
 A type representing a Table Of Contents frame.
 
 There may be more than one Table of Contents frame per tag, but only one may have the top-level flag set, and each one must have a unique `elementID`. Therefore, the `elementID` will serve as the `FrameKey`
 */
public struct TableOfContentsFrame: FrameProtocol, CustomStringConvertible {
    public var description: String {
        return """
        ElementID: \(elementID),
        TOCisTopLevel: \(topLevelFlag),
        ChildElementsAreOrdered: \(orderedFlag),
        ChildElementIDs: \(childElementIDs),
        EmbeddedSubframes:
        \(embeddedSubframesTag.frames.values.description)
        """
    }

    // MARK: Properties
    var flags: Data
    var layout: FrameLayoutIdentifier
    var frameKey: FrameKey
    var allowMultipleFrames: Bool = true
    
    /** A null-terminated string with a unique ID. The Element ID uniquely identifies the frame. It is not intended to be human readable and should not be presented to the end-user. */
    var elementID: String
    
    /** Flag a - Top-level bit
     This is set to 1 to identify the top-level "CTOC" frame. This frame is the root of the Table of Contents tree and is not a child of any other "CTOC" frame. Only one "CTOC" frame in an ID3v2 tag can have this bit set to 1. In all other "CTOC" frames this bit shall be set to 0.*/
    public var topLevelFlag: Bool
    
    /** Flag b - Ordered bit
     This should be set to 1 if the entries in the Child Element ID list are ordered or set to 0 if they not are ordered. This provides a hint as to whether the elements should be played as a continuous ordered sequence or played individually. */
    public var orderedFlag: Bool
    
    /** the list of all child CTOC and/or CHAP frames,
     each entry is null-terminated */
    public var childElementIDs: [String]
    
    /** A sequence of optional frames that are embedded within the “CTOC” frame and which describe this element of the table of contents (e.g. a “TIT2” frame representing the name of the element) or provide related material such as URLs and images. These sub-frames are contained within the bounds of the “CTOC” frame as signalled by the size field in the “CTOC” frame header.*/
    public var embeddedSubframesTag: Tag = Tag(subframes: [:])
    
    // MARK: Frame parsing initializer
    init(decodingContents contents: Data.SubSequence,
         version: Version,
         layout: FrameLayoutIdentifier,
         flags: Data) throws {
        self.flags = flags
        self.layout = layout
        
        // get the elementID from the frame, using a uuid as default if none exists
        var parsing = contents
        let elementID = parsing.extractPrefixAsStringUntilNullTermination(.isoLatin1)
        self.elementID = elementID ?? UUID().uuidString
        self.frameKey = .tableOfContents(elementID: elementID ?? UUID().uuidString)
        
        // parse the flags byte and interpret boolean values
        let flagsByteData = parsing.extractFirst(1)
        guard let flagsByte = flagsByteData.first else {
            throw Mp3File.Error.InvalidTagData
        }
        let flagA: UInt8 = 0b00000010
        let flagB: UInt8 = 0b00000001
        
        if flagsByte & flagA == flagA {
            self.topLevelFlag = true
        } else {
            self.topLevelFlag = false
        }
        if flagsByte & flagB == flagB {
            self.orderedFlag = true
        } else {
            self.orderedFlag = false
        }
        
        // parse the entry-count byte to derive integer value
        let childIDByte = parsing.extractFirst(1)
        let entryCountUInt32 = UInt32(parsing: childIDByte, .bigEndian)
        var childIDCount = Int(entryCountUInt32)
        
        var childIDArray: [String] = []
        while childIDCount > 0 {
            childIDArray.append(parsing.extractPrefixAsStringUntilNullTermination(.isoLatin1) ?? "")
            childIDCount -= 1
        }
        self.childElementIDs = childIDArray

        // parse the subframes and add them to the embedded subframes tag
        var subframes: [FrameKey:Frame] = [:]
        while !parsing.isEmpty {
            let embeddedSubframeIdentifierData = parsing.extractFirst(version.identifierLength)
            guard embeddedSubframeIdentifierData.first != 0x00  else { break }
            let subframeIdentifier = try String(ascii: embeddedSubframeIdentifierData)
            let subframe = try Frame(
                identifier: subframeIdentifier,
                data: &parsing,
                version: version)
            
            let subframeFrameKey = subframe.frameKey
            subframes[subframeFrameKey] = subframe
        }
        self.embeddedSubframesTag = Tag(subframes: subframes)
    }

    // MARK: Frame building initializer
    /// Initialize a table of contents for adding to a tag
    /// - Parameters:
    ///   - layout: the frame layout
    ///   - elementID: the elementID of the frame. Null terminated.
    ///   - topLevelFlag: boolean indicating if this CTOC frame has any children (or parent) CTOC frame(s)
    ///   - orderedFlag: boolean indicating whether any child elementIDs are ordered or not
    ///   - entryCount: the number of child ElementIDs.
    ///   - childElementIDs: the array of child elementIDs. Must not be empty. Each entry is null terminated.
    ///   - embeddedSubframesTag: a pseudo-tag instance holding the (optional) frames containing title and descriptor text for the CTOC frame.
    init(_ layout: FrameLayoutIdentifier,
                 elementID: String,
                 topLevelFlag: Bool,
                 orderedFlag: Bool,
                 childElementIDs: [String],
                 embeddedSubframesTag: Tag?) {
        self.elementID = elementID
        self.topLevelFlag = topLevelFlag
        self.orderedFlag = orderedFlag
        self.childElementIDs = childElementIDs
        self.embeddedSubframesTag = embeddedSubframesTag ?? Tag(subframes: [:])
        self.flags = TableOfContentsFrame.defaultFlags
        self.layout = layout
        self.frameKey = .tableOfContents(elementID: elementID)
    }
    
    // encode the contents of the frame to add to an ID3 tag
    func encodeContents(version: Version) throws -> Data {
        guard version != .v2_2 else {
            throw Mp3File.Error.FrameNotValidForVersion
        }
        var frameData = Data()
        // there is no encoding byte for TOC frames
        // encode and append the elementID, adding a null terminator
        frameData.append(self.elementID.encoded(withNullTermination: true))
        
        frameData.append(encodedFlagByte)

        // encode and append the entry count
        let entryCount = self.childElementIDs.count
        // a valid TOC frame needs at least 1 child element
        guard entryCount > 0 else {
            throw Mp3File.Error.InvalidTOCFrame
        }
        let entryCountUInt8 = UInt8(entryCount)
        frameData.append(entryCountUInt8)

        // encode and append the array of child element IDs, adding null terminator
        var idArray = Data()
        for id in self.childElementIDs {
            idArray.append(id.encoded(withNullTermination: true))
        }
        frameData.append(idArray)

        // encode and append the subframes to data
        var encodedSubframes = Data()
        for subframe in self.embeddedSubframesTag.frames {
            let subframeAsFrameProtocol = subframe.value.asFrameProtocol
            encodedSubframes.append(
                try encodeSubframes(
                    subframe: subframeAsFrameProtocol,
                    version: version))
        }
        frameData.append(encodedSubframes)
        return frameData
    }
    
    // convert the boolean flags to a single byte of data
    var encodedFlagByte: Data {
        let flagByteBinaryInt: [UInt8]
        switch self.topLevelFlag {
            case true:
                switch self.orderedFlag {
                    case true:
                        flagByteBinaryInt = [0b00000011]
                    case false:
                        flagByteBinaryInt = [0b00000010]
            }
            case false:
                switch self.orderedFlag {
                    case true:
                        flagByteBinaryInt = [0b00000001]
                    case false:
                        flagByteBinaryInt = [0b00000000]
            }
        }
        return Data(flagByteBinaryInt)
    }
 
    // use FrameProtocol `encodeContents` method to encode subframes
    func encodeSubframes(subframe: FrameProtocol, version: Version) throws -> Data {
        return try subframe.encode(version: version)
    }
}

// MARK: Tag Extension
extension Tag {
    
    // the elementID is used to differentiate potential multiple toc frames
    public subscript(tableOfContents elementID: String) -> TableOfContentsFrame? {
        get {
            if let frame = self.frames[.tableOfContents(elementID: elementID)],
                case .tocFrame(let tocFrame) = frame {
                return tocFrame
            } else {
                return .init(.known(.tableOfContents),
                                   elementID: "",
                                   topLevelFlag: true,
                                   orderedFlag: true,
                                   childElementIDs: [],
                                   embeddedSubframesTag: Tag(subframes: [:]))
            }
        }
        set {
            let key: FrameKey = .tableOfContents(elementID: elementID)
            let frame = TableOfContentsFrame(
                .known(.tableOfContents),
                elementID: elementID,
                topLevelFlag: newValue?.topLevelFlag ?? true,
                orderedFlag: newValue?.orderedFlag ?? true,
                childElementIDs: newValue?.childElementIDs ?? [],
                embeddedSubframesTag: newValue?.embeddedSubframesTag)
            self.frames[key] = .tocFrame(frame)
        }
    }
    
    public mutating func removeTOCFrame(withElementID: String) {
        self.frames[.tableOfContents(elementID: withElementID)] = nil
    }
    
}
