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
struct ChapterFrame: FrameProtocol {
    
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
        self.flags = ChapterFrame.defaultFlags()
        self.layout = layout
    }
    
    func encodeContents(version: Version) throws -> Data {
        
    }
    
    internal var flags: Data
    internal var layout: FrameLayoutIdentifier
    
    internal init(decodingContents contents: Data.SubSequence,
                  version: Version,
                  layout: FrameLayoutIdentifier,
                  flags: Data) throws {
        self.flags = flags
        self.layout = layout
    }
    
    
    init(startTime: Int,
         endTime: Int,
         embeddedSubframes: [FrameKey: Frame]) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.chapter),
                  elementID: elementID,
                  startTime: startTime,
                  endTime: endTime,
                  startByteOffset: nil,
                  endByteOffset: nil,
                  embeddedSubframes: embeddedSubframes)
    }
    
}
