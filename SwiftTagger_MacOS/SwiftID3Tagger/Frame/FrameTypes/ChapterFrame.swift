//
//  ChapterFrame.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/11/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//


import Foundation

/**
 A type representing an ID3 chapter frame. There may be multiple chapter frames in a tag, but the `elementID` must be unique. Therefore, the `elementID` will serve as the `FrameKey`
 */
public struct ChapterFrame: FrameProtocol {
    
    /** The Element ID uniquely identifies the frame. It is not intended to be human readable and should not be presented to the end user. Null terminated */
    public var elementID: String
    
    /** The Start and End times are a count in milliseconds from the beginning of the file to the start and end of the chapter respectively. */
    public var startTime: Int
    public var endTime: Int
    
    /** The Start offset is a zero-based count of bytes from the beginning of the file to the first byte of the first audio frame in the chapter. If these bytes are all set to 0xFF then the value should be ignored and the start time value should be utilized.*/
    public var startByteOffset: Int
    
    /** The End offset is a zero-based count of bytes from the beginning of the file to the first byte of the audio frame following the end of the chapter. If these bytes are all set to 0xFF then the value should be ignored and the end time value should be utilized.*/
    public var endByteOffset: Int
    
    /** A sequence of optional frames that are embedded within the “CHAP” frame and which describe the content of the chapter (e.g. a “TIT2” frame representing the chapter name) or provide related material such as URLs and images. These sub-frames are contained within the bounds of the “CHAP” frame as signalled by the size field in the “CHAP” frame header. If a parser does not recognise “CHAP” frames it can skip them using the size field in the frame header. When it does this it will skip any embedded sub-frames carried within the frame. */
    public var embeddedSubframes: [FrameKey: Frame]
    
    
    /**
     - parameter elementID: the elementID of the frame. Null terminated.
     - parameter startTime: integer indicating the beginning of the chapter, in milliseconds
     - parameter endTime: integer indicating the end of the chapter, in milliseconds
     - parameter startByteOffset: integer indicating the byte offset for the start of the chapter.
     - parameter endByteOffset: integer indicating the byte offset for the end of the chapter
     - parameter embeddedSubFrames: the (optional) frames containing title and descriptor text for the CHAP frame. A title is recommended at the least.
     */
    private init(layout: FrameLayoutIdentifier,
                 elementID: String,
                 startTime: Int,
                 endTime: Int,
                 startByteOffset: Int?,
                 endByteOffset: Int?,
                 embeddedSubframes: [FrameKey: Frame]) {
        self.elementID = elementID
        self.startTime = startTime
        self.endTime = endTime
        self.startByteOffset = startByteOffset ?? 0
        self.endByteOffset = endByteOffset ?? 0
        self.embeddedSubframes = embeddedSubframes
        self.flags = ChapterFrame.defaultFlags
        self.layout = layout
        self.frameKey = .chapter(elementID: elementID)
    }
    
    func encodeContents(version: Version) throws -> Data {
        let encodedElementID = self.elementID.encoded(withNullTermination: true)
        let encodedStartTime = self.startTime.truncatedUInt32.bigEndianData
        let encodedEndTime = self.endTime.truncatedUInt32.bigEndianData
        let encodedStartByteOffset = self.startByteOffset.truncatedUInt32.bigEndianData
        let encodedEndByteOffset = self.endByteOffset.truncatedUInt32.bigEndianData

        var encodedSubframes = Data()
        for subframe in self.embeddedSubframes {
            encodedSubframes.append(try encodeSubframes(subframe: subframe as! FrameProtocol, version: version))
        }
        return encodedElementID + encodedStartTime + encodedEndTime + encodedStartByteOffset + encodedEndByteOffset + encodedSubframes
    }
 
    func encodeSubframes(subframe: FrameProtocol, version: Version) throws -> Data {
        return try subframe.encodeContents(version: version)
    }
    
    var flags: Data
    var layout: FrameLayoutIdentifier
    var frameKey: FrameKey
    
    init(decodingContents contents: Data.SubSequence,
         version: Version,
         layout: FrameLayoutIdentifier,
         flags: Data) throws {
        self.flags = flags
        self.layout = layout
        
        var parsing = contents
        let elementID = parsing.extractPrefixAsStringUntilNullTermination(.isoLatin1)
        self.elementID = elementID ?? Tag.incrementalChapterID
        self.frameKey = .chapter(elementID: elementID ?? Tag.incrementalChapterID)
        let startTimeData = parsing.extractFirst(4)
        let startTimeUInt32 = UInt32(parsing: startTimeData, .bigEndian)
        self.startTime = Int(startTimeUInt32)
        
        let endTimeData = parsing.extractFirst(4)
        let endTimeUInt32 = UInt32(parsing: endTimeData, .bigEndian)
        self.endTime = Int(endTimeUInt32)
        
        let startByteOffsetData = parsing.extractFirst(4)
        let startByteOffsetUInt32 = UInt32(parsing: startByteOffsetData, .bigEndian)
        self.startByteOffset = Int(startByteOffsetUInt32)
        
        let endByteOffsetData = parsing.extractFirst(4)
        let endByteOffsetUInt32 = UInt32(parsing: endByteOffsetData, .bigEndian)
        self.endByteOffset = Int(endByteOffsetUInt32)
        
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
    
    
    public init(startTime: Int,
                endTime: Int,
                embeddedSubframes: [FrameKey: Frame]) {
        self.init(layout: .known(.chapter),
                  elementID: Tag.incrementalChapterID,
                  startTime: startTime,
                  endTime: endTime,
                  startByteOffset: nil,
                  endByteOffset: nil,
                  embeddedSubframes: embeddedSubframes)
        self.frameKey = .chapter(elementID: Tag.incrementalChapterID)
    }

//    public convenience init(startTime: Int,
//                endTime: Int,
//                chapterTitle: String) {
//        let subframeKey = FrameKey.title
//        let subframeFrame: Frame = .stringFrame(let stringFrame)
//        let subframe = subframeFrame(stringContent: chapterTitle)
//        self.init(layout: .known(.chapter),
//                  elementID: ChapterFrame.incrementalChapterID,
//                  startTime: startTime,
//                  endTime: endTime,
//                  startByteOffset: nil,
//                  endByteOffset: nil,
//                  embeddedSubframes: embeddedSubframes[subframeKey] = subframeFrame)
//        self.frameKey = .chapter(elementID: ChapterFrame.incrementalChapterID)
//    }
    
//    repeat with attached image rather than chapter title when image is implemented
//    public convenience init(startTime: Int,
//                endTime: Int,
//                chapterTitle: String) {
//        let subframeKey = FrameKey.title
//        let subframeFrame: Frame = .stringFrame(let stringFrame)
//        let subframe = subframeFrame(stringContent: chapterTitle)
//        self.init(layout: .known(.chapter),
//                  elementID: ChapterFrame.incrementalChapterID,
//                  startTime: startTime,
//                  endTime: endTime,
//                  startByteOffset: nil,
//                  endByteOffset: nil,
//                  embeddedSubframes: embeddedSubframes[subframeKey] = subframeFrame)
//        self.frameKey = .chapter(elementID: ChapterFrame.incrementalChapterID)
//    }

}

