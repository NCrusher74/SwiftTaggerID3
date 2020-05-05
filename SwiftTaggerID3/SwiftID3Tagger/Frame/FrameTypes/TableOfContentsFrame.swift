//
//  TableOfContentsFrame.swift
//  SwiftTaggerID3
//
//  Created by Nolaine Crusher on 4/11/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation


/**
 A type representing a Table Of Contents frame.
 
 There may be more than one Table of Contents frame per tag, but only one may have the top-level flag set, and each one must have a unique `elementID`. Therefore, the `elementID` will serve as the `FrameKey`
 */
public struct TableOfContentsFrame: FrameProtocol {
    
    /** A null-terminated string with a unique ID. The Element ID uniquely identifies the frame. It is not intended to be human readable and should not be presented to the end-user. */
    var elementID: String
    
    /** Flag a - Top-level bit
     This is set to 1 to identify the top-level “CTOC” frame. This frame is the root of the Table of Contents tree and is not a child of any other “CTOC” frame. Only one “CTOC” frame in an ID3v2 tag can have this bit set to 1. In all other “CTOC” frames this bit shall be set to 0.*/
    public var topLevelFlag: Bool
    
    /** Flag b - Ordered bit
     This should be set to 1 if the entries in the Child Element ID list are ordered or set to 0 if they not are ordered. This provides a hint as to whether the elements should be played as a continuous ordered sequence or played individually.
     Note: The Bool flags are documented as being paired in a 2-byte unit: https://mutagen-specs.readthedocs.io/en/latest/_images/CTOCFrame-1.0.png ` */
    public var orderedFlag: Bool
    
    /**The Entry count is the number of entries in the Child Element ID list that follows and must be greater than zero. Each entry in the list consists of the ElementID of any "child" CTOC or CHAP frames.*/
    public var entryCount: UInt8
    
    /** the list of all child CTOC and/or CHAP frames,
     each entry is null-terminated */
    public var childElementIDs: [String]
    
    /** A sequence of optional frames that are embedded within the “CTOC” frame and which describe this element of the table of contents (e.g. a “TIT2” frame representing the name of the element) or provide related material such as URLs and images. These sub-frames are contained within the bounds of the “CTOC” frame as signalled by the size field in the “CTOC” frame header.*/
    var embeddedSubframes: [FrameKey: Frame] = [:]
    
    
    /**
     - parameter elementID: the elementID of the frame. Null terminated.
     - parameter topLevelFlag: boolean indicating if this CTOC frame has any children (or parent) CTOC frame(s)
     - parameter orderedFlag: boolean indicating whether any child elementIDs are ordered or not
     - parameter entryCount: the number of child ElementIDs.
     - parameter childElementIDs: the array of child elementIDs. Must not be empty. Each entry is null terminated.
     - parameter embeddedSubFrames: the (optional) frames containing title and descriptor text for the CTOC frame.
     */
    private init(layout: FrameLayoutIdentifier,
                 elementID: String,
                 topLevelFlag: Bool,
                 orderedFlag: Bool,
                 entryCount: UInt8,
                 childElementIDs: [String],
                 embeddedSubframes: [FrameKey: Frame]) {
        self.elementID = elementID
        self.topLevelFlag = topLevelFlag
        self.orderedFlag = orderedFlag
        self.entryCount = entryCount
        self.childElementIDs = childElementIDs
        self.embeddedSubframes = embeddedSubframes
        self.flags = TableOfContentsFrame.defaultFlags
        self.layout = layout
        self.frameKey = .tableOfContents(elementID: elementID)
    }
    
    // encode the contents of the frame to add to an ID3 tag
    func encodeContents(version: Version) throws -> Data {
        var frameData = Data()
        // encode and append the elementID
        frameData.append(self.elementID.encoded(withNullTermination: true))
        // encode and append the entry count
        frameData.append(contentsOf: [self.entryCount])
        // encode and append the array of child element IDs
        var idArray = Data()
        for id in self.childElementIDs {
            idArray.append(id.encoded(withNullTermination: true))
        }
        frameData.append(idArray)
        // encode and append the subframes to data
        var encodedSubframes = Data()
        for subframe in self.embeddedSubframes {
            encodedSubframes.append(try encodeSubframes(subframe: subframe.value.asFrameProtocol, version: version))
        }
        frameData.append(encodedSubframes)
        return frameData
    }
    
    // convert the boolean flags to a single byte of data
    var encodedFlagByte: Data {
        switch self.topLevelFlag {
            case true:
                switch self.orderedFlag {
                    case true:
                        let flagByteBinaryInt = 0b00000011
                        return flagByteBinaryInt.truncatedUInt32.bigEndianData
                    case false:
                        let flagByteBinaryInt = 0b00000010
                        return flagByteBinaryInt.truncatedUInt32.bigEndianData
            }
            case false:
                switch self.orderedFlag {
                    case true:
                        let flagByteBinaryInt = 0b00000001
                        return flagByteBinaryInt.truncatedUInt32.bigEndianData
                    case false:
                        let flagByteBinaryInt = 0b00000000
                        return flagByteBinaryInt.truncatedUInt32.bigEndianData
            }
        }
    }
 
    // use FrameProtocol `encodeContents` method to encode subframes
    func encodeSubframes(subframe: FrameProtocol, version: Version) throws -> Data {
        return try subframe.encodeContents(version: version)
    }

    // MARK: Properties
    var flags: Data
    var layout: FrameLayoutIdentifier
    var frameKey: FrameKey
    var allowMultipleFrames: Bool = false

    init(decodingContents contents: Data.SubSequence,
                  version: Version,
                  layout: FrameLayoutIdentifier,
                  flags: Data) throws {
        self.flags = flags
        self.layout = layout
        
        // get the elementID from the frame, using a uuid as default if none exists
        var parsing = contents
        let uuid = UUID()
        let elementID = parsing.extractPrefixAsStringUntilNullTermination(.isoLatin1)
        self.elementID = elementID ?? uuid.uuidString
        self.frameKey = .tableOfContents(elementID: elementID ?? uuid.uuidString)

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
        self.entryCount = childIDByte.uint8

        let entryCountUInt32 = UInt32(parsing: childIDByte, .bigEndian)
        var childIDCount = Int(entryCountUInt32)
        var childIDArray: [String] = []
        
        while childIDCount > 0 {
            childIDArray.append(parsing.extractPrefixAsStringUntilNullTermination(.isoLatin1) ?? "")
            childIDCount -= 1
        }
        self.childElementIDs = childIDArray
        
        // parse the subframes and add them to the embedded subframes dictionary
        var subframes: [FrameKey: Frame] = [:]
        while !parsing.isEmpty {
            let embeddedSubframeIdentifierData = parsing.extractFirst(version.identifierLength)
            if embeddedSubframeIdentifierData.first == 0x00 { break } // Padding, not a frame.
            let subframeIdentifier = try String(ascii: embeddedSubframeIdentifierData)
            let subframe = try Frame(
                identifier: subframeIdentifier,
                data: &parsing,
                version: version)
            
            let subframeFrameKey = subframe.frameKey
            subframes[subframeFrameKey] = subframe
        }
        self.embeddedSubframes = subframes
    }
    
    // public initializer requiring only the boolean flags, the child element IDs, and the embedded subframes
    init(isTopTOC: Bool,
         elementsAreOrdered: Bool,
         childElementIDs: [String],
         embeddedSubframes: [FrameKey: Frame]?) {
        let uuid = UUID()
        let elementID = uuid.uuidString
        self.init(layout: .known(.tableOfContents),
                  elementID: elementID,
                  topLevelFlag: isTopTOC,
                  orderedFlag: elementsAreOrdered,
                  entryCount: UInt8(childElementIDs.count),
                  childElementIDs: childElementIDs,
                  embeddedSubframes: embeddedSubframes ?? [:])
    }
}

public extension Tag {
    /// - TableOfContents frame getter-setter. Valid for tag versions 2.3 and 2.4 only.
    /// ID3 Identifier `CTOC`
    subscript(tableOfContents tocElementID: String) -> TableOfContentsFrame? {
        get {
            if let frame = self.frames[.tableOfContents(elementID: tocElementID)],
                case .tocFrame(let tocFrame) = frame {
                return tocFrame
            } else {
                return nil
            }
        }
        set {
            let key = FrameKey.tableOfContents(elementID: tocElementID)
            if let new = newValue {
                self.frames[key] = Frame.tocFrame(.init(
                    isTopTOC: new.topLevelFlag,
                    elementsAreOrdered: new.orderedFlag,
                    childElementIDs: new.childElementIDs,
                    embeddedSubframes: new.embeddedSubframes))
            } else {
                self.frames[key] = nil
            }
        }
    }
}
