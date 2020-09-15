/*

 ChapterFrame.swift
 SwiftTaggerID3

 Copyright ©2020 Nolaine Crusher. All rights reserved.

 */

import Foundation

/**
 A type representing an ID3 chapter frame. There may be multiple chapter frames in a tag, but the `elementID` must be unique. Therefore, the `elementID` will serve as the `FrameKey`
 */
@available(OSX 10.12, *)
public struct ChapterFrame: FrameProtocol, CustomStringConvertible {
    public var description: String {
        if let title = self.embeddedSubframesTag?.title {
            return """
            \(self.frameKey) : (\(title) @ \(self.startTime))
            """
        } else {
            return """
            \(self.frameKey) : UntitledChapter @ \(self.startTime))
            """
        }
    }
    
    // MARK: - Properties
    var flags: Data
    var layout: FrameLayoutIdentifier
    var frameKey: FrameKey

    /** The Element ID uniquely identifies the frame. It is not intended to be human readable and should not be presented to the end user. Null terminated */
    public var elementID: String
    
    /** The Start and End times are a count in milliseconds from the beginning of the file to the start and end of the chapter respectively. */
    public var startTime: Int
    public var endTime: Int
    
    /** A sequence of optional frames that are embedded within the “CHAP” frame and which describe the content of the chapter (e.g. a “TIT2” frame representing the chapter name) or provide related material such as URLs and images. These sub-frames are contained within the bounds of the “CHAP” frame as signalled by the size field in the “CHAP” frame header. If a parser does not recognise “CHAP” frames it can skip them using the size field in the frame header. When it does this it will skip any embedded sub-frames carried within the frame. */
    public var embeddedSubframesTag: Tag?
    
    // MARK: - Frame parsing
    init(decodingContents contents: Data.SubSequence,
         version: Version,
         layout: FrameLayoutIdentifier,
         flags: Data) throws {
        self.flags = flags
        self.layout = layout
        
        var parsing = contents
        
        // extract the elementID string
        let elementID = parsing.extractPrefixAsStringUntilNullTermination(.isoLatin1)
        // initialize the elementID property from the string
        self.elementID = elementID ?? UUID().uuidString
        self.frameKey = .chapter(byElementID: self.elementID)

        // extract and convert integer properties to integers
        self.startTime = parsing.extractToInt(4)
        self.endTime = parsing.extractToInt(4)

        /* The Start offset is a zero-based count of bytes from the beginning of the file to the first byte of the first audio frame in the chapter. If these bytes are all set to 0xFF then the value should be ignored and the start time value should be utilized.*/
        /* The End offset is a zero-based count of bytes from the beginning of the file to the first byte of the audio frame following the end of the chapter. If these bytes are all set to 0xFF then the value should be ignored and the end time value should be utilized.*/
        /// SwiftTagger uses start and end times, these will be set to 0xFF by default
        parsing = parsing.dropFirst(4) // start byte offset, unused
        parsing = parsing.dropFirst(4) // end byte offset, unused
        
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

    // MARK: - Frame building
    /**
     - parameter elementID: the elementID of the frame. Null terminated.
     - parameter startTime: integer indicating the beginning of the chapter, in milliseconds
     - parameter endTime: integer indicating the end of the chapter, in milliseconds
     - parameter startByteOffset: integer indicating the byte offset for the start of the chapter.
     - parameter endByteOffset: integer indicating the byte offset for the end of the chapter
     - parameter embeddedSubFrames: the (optional) frames containing title and descriptor text for the CHAP frame. A title is recommended at the least.
     */
    init(_ layout: FrameLayoutIdentifier,
                 elementID: String,
                 startTime: Int,
                 endTime: Int,
                 embeddedSubframesTag: Tag?) {
        self.elementID = elementID
        self.startTime = startTime
        self.endTime = endTime
        self.embeddedSubframesTag = embeddedSubframesTag ?? Tag(subframes: [:])
        self.flags = ChapterFrame.defaultFlags
        self.layout = layout
        self.frameKey = .chapter(byElementID: elementID)
    }
    
    // encodes the contents of the frame and returns Data that can be added to the Tag instance to write to the file
    func encodeContents(version: Version) throws -> Data {
        guard version != .v2_2 else {
            throw Mp3File.Error.FrameNotValidForVersion
        }
        var frameData = Data()
        // there is no encoding byte for Chapter frames
        // encode and append ElementID string, adding null terminator
        frameData.append(self.elementID.encoded(withNullTermination: true))

        // convert integers to UInt32 and then to Data and append
        frameData.append(self.startTime.uInt32.beData)
        frameData.append(self.endTime.uInt32.beData)
        
        // add in start and end offset bytes to satisfy spec
        // since SwiftTagger uses start and end times, these are unused by default
        /* The Start offset/End offset is a zero-based count of bytes from the beginning of the file to the first byte of the first audio frame in the chapter. If these bytes are all set to 0xFF then the value should be ignored and the start time value should be utilized. */
        let offsetBytes: [UInt8] = [0xFF, 0xFF, 0xFF, 0xFF]
        frameData.append(contentsOf: offsetBytes) // start byte offset
        frameData.append(contentsOf: offsetBytes) // end byte offset

        // encode and append the subframes to data
        var encodedSubframes = Data()
        for subframe in self.embeddedSubframesTag?.frames ?? [:] {
            let subframeAsFrameProtocol = subframe.value.asFrameProtocol
            encodedSubframes.append(
                try encodeSubframes(
                    subframe: subframeAsFrameProtocol,
                    version: version))
        }
        frameData.append(encodedSubframes)
        return frameData
    }
 
    // use FrameProtocol `encodeContents` method to encode subframes
    func encodeSubframes(subframe: FrameProtocol, version: Version) throws -> Data {
        return try subframe.encode(version: version)
    }

    init?() {
        return nil
    }
}

// MARK: - Tag extension
extension Tag {

    mutating func removeChapterFrame(with elementID: String) {
        self.frames[.chapter(byElementID: elementID)] = nil
    }
}
