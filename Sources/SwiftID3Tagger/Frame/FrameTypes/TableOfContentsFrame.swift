//
//  File.swift
//  
//
//  Created by Nolaine Crusher on 9/18/20.
//

import Foundation

/// A type representing a Table Of Contents frame.
///
/// According to the spec, there may be more than one Table of Contents frame per tag, but only one may have the top-level flag set, and each one must have a unique `elementID`.
///
/// However, SwiftTaggerID only supports a single TOC frame, which is assigned a UUID as the elementID. Because of this, the top-level flag will always be true, and SwiftTaggerID3s handling of this frame will ensure the child elements are always ordered, therefore the orderedFlag is also set to true.
class TableOfContentsFrame: Frame {
    /// the list of all child CTOC and/or CHAP frames, each entry is null-terminated
    public var childElementIDs: [String]
    public var embeddedSubframesTag: Tag?
    
    // MARK: - Frame parsing initializer
    @available(OSX 10.12, *)
    init(identifier: FrameIdentifier,
         version: Version,
         size: Int,
         flags: Data,
         payload: Data) throws {
        var data = payload

        // get the elementID from the frame, using a uuid as default if none exists
        // A null-terminated string with a unique ID. The Element ID uniquely identifies the frame. It is not intended to be human readable and should not be presented to the end-user.
        /// This is unused by SwiftTaggerID3. A TOC frame is assigned a UUID
        _ = data.extractNullTerminatedString(.isoLatin1) // unused
        // parse the flags byte and interpret boolean values
        // Flag a - Top-level bit
        // This is set to 1 to identify the top-level "CTOC" frame. This frame is the root of the Table of Contents tree and is not a child of any other "CTOC" frame. Only one "CTOC" frame in an ID3v2 tag can have this bit set to 1. In all other "CTOC" frames this bit shall be set to 0.
        // Flag b - Ordered bit
        // This should be set to 1 if the entries in the Child Element ID list are ordered or set to 0 if they not are ordered. This provides a hint as to whether the elements should be played as a continuous ordered sequence or played individually. */
        _ = data.extractFirst(1) // unused
        
        // parse the entry-count byte to derive integer value
        var childIDCount = data.extractToInt(1)
        var childIDArray: [String] = []
        while childIDCount > 0 {
            childIDArray.append(data.extractNullTerminatedString(.isoLatin1) ?? "")
            childIDCount -= 1
        }
        self.childElementIDs = childIDArray
        
        // parse the subframes and add them to the embedded subframes tag
        // A sequence of optional frames that are embedded within the “CTOC” frame and which describe this element of the table of contents (e.g. a “TIT2” frame representing the name of the element) or provide related material such as URLs and images. These sub-frames are contained within the bounds of the “CTOC” frame as signalled by the size field in the “CTOC” frame header.*/
        // parse the subframes and add them to the embedded subframes tag
        var subframes: [String : Frame] = [:]
        while !data.isEmpty {
            let subframeIdData = data.extractFirst(version.idLength)
            guard subframeIdData.first != 0x00  else { break }
            if let subframe = try data.extractAndParseToFrame(version) {
                let subframeKey = try subframe.frameKey()
                subframes[subframeKey] = subframe
            }
            self.embeddedSubframesTag = try Tag(subframes: subframes)
        }
    }
    
    @available(OSX 10.12, *)
    override var contentData: Data {
        guard version != .v2_2 else {
            fatalError("TableOfContents frame is not available for ID3 v2.2")
        }
        var data = Data()
        // there is no encoding byte for TOC frames
        // encode and append the elementID, adding a null terminator
        data.append("TOC".encodeNullTerminatedString(.isoLatin1))
        data.append(encodedFlagByte)
        
        // encode and append the entry count
        let entryCount = self.childElementIDs.count
        // a valid TOC frame needs at least 1 child element
        guard entryCount > 0 else {
            fatalError("A valid TableOfContents frame requires at least one entry")
        }
        let entryCountUInt8 = UInt8(entryCount)
        data.append(entryCountUInt8)
        
        // encode and append the array of child element IDs, adding null terminator
        var idArray = Data()
        for id in self.childElementIDs {
            idArray.append(id.encodeNullTerminatedString(.isoLatin1))
        }
        data.append(idArray)
        
        // encode and append the subframes to data
        var encodedSubframes = Data()
        for item in self.embeddedSubframesTag?.frames ?? [:] {
            let subframe = item.value
            encodedSubframes.append(subframe.encode)
        }
        data.append(encodedSubframes)
        return data
    }
    
    // convert the boolean flags to a single byte of data
    // both flags are set to true as SwiftTaggerID3 default
    var encodedFlagByte: Data {
        let flagByteBinaryInt: [UInt8] = [0b00000011]
        return Data(flagByteBinaryInt)
    }
    
    // // MARK: - Frame building initializer
    /// Initialize a table of contents for adding to a tag
    /// - Parameters:
    ///   - layout: the frame layout
    ///   - childElementIDs: the array of child elementIDs. Must not be empty. Each entry is null terminated.
    ///   - embeddedSubframesTag: a pseudo-tag instance holding the (optional) frames containing title and descriptor text for the CTOC frame.
    @available(OSX 10.12, *)
    init(_ identifier: FrameIdentifier,
         version: Version,
         childElementIDs: [String],
         embeddedSubframesTag: Tag?) {
        self.childElementIDs = childElementIDs
        self.embeddedSubframesTag = embeddedSubframesTag

        var size = 2 // +1 for flag byte, +1 for entry count byte
        size += "TOC".encodeNullTerminatedString(.isoLatin1).count
        for id in self.childElementIDs {
            size += id.encodeNullTerminatedString(.isoLatin1).count
        }
        for item in self.embeddedSubframesTag?.frames ?? [:] {
            let subframe = item.value
            size += subframe.encode.count
        }

        let flags = version.defaultFlags
        super.init(identifier: identifier,
                   version: version,
                   size: size,
                   flags: flags)
    }
    
    init?() {
        return nil
    }

}
