//
//  ChapterFrame.swift
//  SwiftTaggerID3
//
//  Created by Nolaine Crusher on 4/11/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//


import Foundation

/**
 A type representing an ID3 chapter frame. There may be multiple chapter frames in a tag, but the `elementID` must be unique. Therefore, the `elementID` will serve as the `FrameKey`
 */
public struct ChapterFrame: FrameProtocol {
    
    // MARK: Properties
    var flags: Data
    var layout: FrameLayoutIdentifier
    var frameKey: FrameKey
    var allowMultipleFrames: Bool = false

    /** The Element ID uniquely identifies the frame. It is not intended to be human readable and should not be presented to the end user. Null terminated */
    var elementID: String
    
    /** The Start and End times are a count in milliseconds from the beginning of the file to the start and end of the chapter respectively. */
    public var startTime: Int
    public var endTime: Int
    
    /** The Start offset is a zero-based count of bytes from the beginning of the file to the first byte of the first audio frame in the chapter. If these bytes are all set to 0xFF then the value should be ignored and the start time value should be utilized.*/
    var startByteOffset: Int
    
    /** The End offset is a zero-based count of bytes from the beginning of the file to the first byte of the audio frame following the end of the chapter. If these bytes are all set to 0xFF then the value should be ignored and the end time value should be utilized.*/
    var endByteOffset: Int
    
    /** A sequence of optional frames that are embedded within the “CHAP” frame and which describe the content of the chapter (e.g. a “TIT2” frame representing the chapter name) or provide related material such as URLs and images. These sub-frames are contained within the bounds of the “CHAP” frame as signalled by the size field in the “CHAP” frame header. If a parser does not recognise “CHAP” frames it can skip them using the size field in the frame header. When it does this it will skip any embedded sub-frames carried within the frame. */
    var embeddedSubframes: [FrameKey: Frame]
    
    // MARK: Frame parsing
    init(decodingContents contents: Data.SubSequence,
         version: Version,
         layout: FrameLayoutIdentifier,
         flags: Data) throws {
        self.flags = flags
        self.layout = layout
        
        var parsing = contents
        
        // extract the elementID string
        let uuid = UUID()
        let elementID = parsing.extractPrefixAsStringUntilNullTermination(.isoLatin1)
        // initialize the elementID property from the string
        self.elementID = elementID ?? uuid.uuidString
        // initialize the frameKey property using the elementID
        self.frameKey = .chapter(elementID: elementID ?? uuid.uuidString)
        
        // extract and convert integer properties to integers
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
        
        // extract and parse subframe data
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

    // MARK: Frame building
    /**
     - parameter elementID: the elementID of the frame. Null terminated.
     - parameter startTime: integer indicating the beginning of the chapter, in milliseconds
     - parameter endTime: integer indicating the end of the chapter, in milliseconds
     - parameter startByteOffset: integer indicating the byte offset for the start of the chapter.
     - parameter endByteOffset: integer indicating the byte offset for the end of the chapter
     - parameter embeddedSubFrames: the (optional) frames containing title and descriptor text for the CHAP frame. A title is recommended at the least.
     */
    private init(_ layout: FrameLayoutIdentifier,
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
    
    // encodes the contents of the frame and returns Data that can be added to the Tag instance to write to the file
    func encodeContents(version: Version) throws -> Data {
        var frameData = Data()
        // encode and append ElementID string
        frameData.append(self.elementID.encoded(withNullTermination: true))
        // convert integers to UInt32 and then to Data and append
        frameData.append(self.startTime.truncatedUInt32.bigEndianData)
        frameData.append(self.endTime.truncatedUInt32.bigEndianData)
        frameData.append(self.startByteOffset.truncatedUInt32.bigEndianData)
        frameData.append(self.endByteOffset.truncatedUInt32.bigEndianData)
        // encoded and append the subframes
        var encodedSubframes = Data()
        for subframe in self.embeddedSubframes {
            encodedSubframes.append(try encodeSubframes(subframe: subframe.value.asFrameProtocol, version: version))
        }
        frameData.append(encodedSubframes)
        return frameData
    }
 
    // encodes the subframes of the chapter frame
    private func encodeSubframes(subframe: FrameProtocol, version: Version) throws -> Data {
        return try subframe.encodeContents(version: version)
    }

    /// initialize a new chapter, manually building the embedded subframes
    init(startTime: Int,
                endTime: Int,
                embeddedSubframes: [FrameKey: Frame]) {
        let uuid = UUID()
        self.init(.known(.chapter),
                  elementID: uuid.uuidString,
                  startTime: startTime,
                  endTime: endTime,
                  startByteOffset: nil,
                  endByteOffset: nil,
                  embeddedSubframes: embeddedSubframes)
        self.frameKey = .chapter(elementID: elementID)
    }

    /// initialize a simple chapter frame with only chapter title, start and end times specified, creates the embedded subframe for the title automatically
    init(chapterTitle: String,
                startTime: Int,
                endTime: Int) {
        // create title stringframe as subframe
        let subframeKey = FrameKey.title
        let subframeFrame: Frame = .stringFrame(.init(.known(.title), contentString: chapterTitle))
        let subframe = [subframeKey : subframeFrame]

        let uuid = UUID()
        // initialize chapter frame with subframe in place
        self.init(.known(.chapter),
                  elementID: uuid.uuidString,
                  startTime: startTime,
                  endTime: endTime,
                  startByteOffset: nil,
                  endByteOffset: nil,
                  embeddedSubframes: subframe)
        self.frameKey = .chapter(elementID: uuid.uuidString)
    }
    
    /// initialize a simple chapter frame with embedded chapter image, start and end times specified, creates the embedded subframe for the image automatically
    init(imageUrl: URL,
                startTime: Int,
                endTime: Int) throws {
        var imageFormat: ImageFormat = .jpg
        if imageUrl.pathExtension.lowercased() == "jpeg" || imageUrl.pathExtension.lowercased() == "jpg" {
            imageFormat = .jpg
        } else if imageUrl.pathExtension.lowercased() == "png" {
            imageFormat = .png
        }
        let imageData = try Data(contentsOf: imageUrl)
        let uuid = UUID()
        let imageDescription = "Chapter Image \(uuid.uuidString)"
        let subframeKey = FrameKey.attachedPicture(
            description: imageDescription)
        let subframeFrame: Frame = .imageFrame(.init(
            .known(.attachedPicture),
            imageType: .Illustration,
            imageFormat: imageFormat,
            imageDescription: imageDescription,
            image: imageData))
        let subframe = [subframeKey : subframeFrame]
        self.init(.known(.chapter),
                  elementID: uuid.uuidString,
                  startTime: startTime,
                  endTime: endTime,
                  startByteOffset: nil,
                  endByteOffset: nil,
                  embeddedSubframes: subframe)
        self.frameKey = .chapter(elementID: uuid.uuidString)
    }
}

// MARK: Tag Extension
public extension Tag {
    /// - Chapter frame getter-setter. Valid for tag versions 2.3 and 2.4 only.
    /// ID3 Identifier `CHAP`
    subscript(chapters chapterElementID: String) -> ChapterFrame? {
        get {
            if let frame = self.frames[.chapter(elementID: chapterElementID)],
                case .chapterFrame(let chapterFrame) = frame {
                return chapterFrame
            } else {
                return nil
            }
        }
        set {
            let key = FrameKey.chapter(elementID: chapterElementID)
            if let new = newValue {
                self.frames[key] = Frame.chapterFrame(.init(
                    startTime: new.startTime,
                    endTime: new.endTime,
                    embeddedSubframes: new.embeddedSubframes))
            }
        }
    }
    
    /** creates a "subframe tag" instance to use when accessing data within the embedded subframes of a `CHAP` or `CTOC` frame */
    subscript(embeddedSubframes forParentFrameElementID: String) -> Tag? {
        get {
            var frames: [FrameKey:Frame] = [:]
            if let parentFrame = self[chapters: forParentFrameElementID] {
                frames = parentFrame.embeddedSubframes
            } else if let parentFrame = self[tableOfContents: forParentFrameElementID] {
                frames = parentFrame.embeddedSubframes
            } else {
                return nil
            }
            let subframeTag = Tag(readFromEmbeddedSubframes: frames)
            return subframeTag
        }
    }
}
