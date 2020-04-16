//
//  TableOfContentsFrame.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/11/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

/**
 A type representing a Table Of Contents frame.

 There may be more than one Table of Contents frame per tag, but only one may have the top-level flag set, and each one must have a unique `elementID`. Therefore, the `elementID` will serve as the `FrameKey`
 */
struct TableOfContentsFrame: FrameProtocol {
    /** A null-terminated string with a unique ID. The Element ID uniquely identifies the frame. It is not intended to be human readable and should not be presented to the end-user. */
    public var elementID: String
    
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
    public var embeddedSubFrames: [FrameKey: Frame]
    
    
    /**
     - parameter elementID: the elementID of the frame. Null terminated.
     - parameter topLevelFlag: boolean indicating if this CTOC frame has any children (or parent) CTOC frame(s)
     - parameter orderedFlag: boolean indicating whether any child elementIDs are ordered or not
     - parameter entryCount: the number of child ElementIDs.
     - parameter childElementID: the array of child elementIDs. Must not be empty. Each entry is null terminated.
     - parameter embeddedSubFrames: the (optional) frames containing title and descriptor text for the CTOC frame.
     
     */
    public init(elementID: String,
                topLevelFlag: Bool,
                orderedFlag: Bool,
                entryCount: UInt8,
                childElementIDs: [String],
                embeddedSubFrames: [FrameKey: Frame]) {
        self.elementID = elementID
        self.topLevelFlag = topLevelFlag
        self.orderedFlag = orderedFlag
        self.entryCount = entryCount
        self.childElementIDs = childElementIDs
        self.embeddedSubFrames = embeddedSubFrames
    }

    
    //    func encodeContents(version: Version) throws -> Data {
    //        
    //    }
    
    var flags: Data
    var layout: FrameLayoutIdentifier
    
    init(decodingContents contents: Data.SubSequence,
         version: Version,
         layout: FrameLayoutIdentifier,
         flags: Data) throws {
        self.flags = TableOfContentsFrame.defaultFlags(version: version)
        self.layout = layout
    }
    

}
