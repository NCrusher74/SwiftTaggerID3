//
//  ChapterFrame.swift
//  SwiftTaggerID3
//
//  Created by Nolaine Crusher on 9/18/20.
//

/*
 The purpose of this frame is to describe a single chapter within an audio file. There may be more than one frame of this type in a tag but each must have an Element ID that is unique with respect to any other "CHAP" frame or "CTOC" frame in the tag.
 
 <ID3v2.3 or ID3v2.4 frame header, ID: "CHAP">           (10 bytes)
 Element ID      <text string> $00
 Start time      $xx xx xx xx
 End time        $xx xx xx xx
 Start offset    $xx xx xx xx
 End offset      $xx xx xx xx
 <Optional embedded sub-frames>
 
 The Element ID uniquely identifies the frame. It is not intended to be human readable and should not be presented to the end user. (NOTE: SwiftTaggerID3 uses the startTime for this purpose, so elementID will be "ch\(startTime)", and no two chapters will be allowed to have the same startTime)
 
 The Start and End times are a count in milliseconds from the beginning of the file to the start and end of the chapter respectively.
 
 The Start offset is a zero-based count of bytes from the beginning of the file to the first byte of the first audio frame in the chapter. If these bytes are all set to 0xFF then the value should be ignored and the start time value should be utilized.
 
 The End offset is a zero-based count of bytes from the beginning of the file to the first byte of the audio frame following the end of the chapter. If these bytes are all set to 0xFF then the value should be ignored and the end time value should be utilized.
 
 There then follows a sequence of optional frames that are embedded within the "CHAP" frame and which describe the content of the chapter (e.g. a "TIT2" frame representing the chapter name) or provide related material such as URLs and images. These sub-frames are contained within the bounds of the "CHAP" frame as signalled by the size field in the "CHAP" frame header. If a parser does not recognise "CHAP" frames it can skip them using the size field in the frame header. When it does this it will skip any embedded sub-frames carried within the frame.
 */
import Foundation
import SwiftConvenienceExtensions
/// A class representing an ID3 chapter frame. There may be multiple chapter frames in a tag, but the `elementID` must be unique. Therefore, the `elementID` will serve as an additional identifier for the `frameKey`
public typealias TOC = TableOfContents
public typealias Chapter = TableOfContents.Chapter
class ChapterFrame: Frame {
    
    /// The Element ID uniquely identifies the frame. It is not intended to be human readable and should not be presented to the end user. Null terminated
    var elementID: String
    
    /// The Start and End times are a count in milliseconds from the beginning of the file to the start and end of the chapter respectively.
    var startTime: Int
    var endTime: Int
    
    var embeddedSubframesTag: Tag?
    
    override var frameKey: FrameKey {
        return self.identifier.frameKey(startTime: self.startTime)
    }
    
    // MARK: - Frame Parsing
    
    @available(OSX 10.12, iOS 12.0, *)
    init(identifier: FrameIdentifier,
         version: Version,
         size: Int,
         flags: Data,
         payload: Data) throws {
        var data = payload
        
        // SwiftTaggerID3 creates a new elementID for the frame
        _ = data.extractNullTerminatedString(.isoLatin1)
        self.startTime = data.extractFirst(4).uInt32BE.int
        self.endTime = data.extractFirst(4).uInt32BE.int
                
        self.elementID = "ch\(startTime)"
        // SwiftTagger uses start and end times, these will be set to 0xFF by default
        _ = data.extractFirst(4) // start byte offset, unused
        _ = data.extractFirst(4) // end byte offset, unused
        
        // parse the subframes and add them to the embedded subframes tag
        var subframes: [FrameKey : Frame] = [:]
        while !data.isEmpty {
            guard data.first != 0x00  else { break }
            if let subframe = try data.extractAndParseToFrame(version) {
                let subframeKey = subframe.frameKey
                subframes[subframeKey] = subframe
            }
            self.embeddedSubframesTag = try Tag(version: version, subframes: subframes)
        }
        super.init(identifier: identifier,
                   version: version,
                   size: size,
                   flags: flags)
    }
    
    
    override var contentData: Data {
        guard version != .v2_2 else {
            fatalError("Chapter frame is not available for ID3 v2.2")
        }
        var data = Data()
        // there is no encoding byte for Chapter frames
        // encode and append ElementID string, adding null terminator
        data.append(self.elementID.encodeNullTerminatedString(.isoLatin1))
        
        // convert integers to UInt32 and then to Data and append
        data.append(self.startTime.uInt32.beData)
        data.append(self.endTime.uInt32.beData)
        
        // add in start and end offset bytes to satisfy spec
        // since SwiftTagger uses start and end times, these are unused by default
        let offsetBytes: [UInt8] = [0xFF, 0xFF, 0xFF, 0xFF]
        data.append(contentsOf: offsetBytes) // start byte offset
        data.append(contentsOf: offsetBytes) // end byte offset
        
        // encode and append the subframes to data
        var encodedSubframes = Data()
        for item in self.embeddedSubframesTag?.frames ?? [:] {
            let subframe = item.value
            encodedSubframes.append(subframe.encode)
        }
        data.append(encodedSubframes)
        return data
    }
    
    // MARK: - Frame building
    /// Builds a Chapter frame from content data
    /// - parameter elementID: the elementID of the frame. Null terminated.
    /// - parameter startTime: integer indicating the beginning of the chapter, in milliseconds
    /// - parameter endTime: integer indicating the end of the chapter, in milliseconds
    /// - parameter embeddedSubFrames: the (optional) frames containing title and descriptor text for the CHAP frame. A title is recommended at the least.
    
    init(_ identifier: FrameIdentifier,
         version: Version,
         startTime: Int,
         endTime: Int,
         embeddedSubframesTag: Tag?) {
        self.elementID = "ch\(startTime)"
        self.startTime = startTime
        self.endTime = endTime
        self.embeddedSubframesTag = embeddedSubframesTag
        let flags = version.defaultFlags
        
        guard version != .v2_2 else {
            fatalError("Chapter frame is not available for ID3 v2.2")
        }
        var size = 16 // 16 = start/end times (8) + start/end offsets (8)
        // there is no encoding byte for Chapter frames
        // encode and append ElementID string, adding null terminator
        size += self.elementID.encodeNullTerminatedString(.isoLatin1).count
        // encode and append the subframes to data
        var encodedSubframes = Data()
        for item in self.embeddedSubframesTag?.frames ?? [:] {
            let subframe = item.value
            encodedSubframes.append(subframe.encode)
        }
        size += encodedSubframes.count
        
        super.init(identifier: identifier,
                   version: version,
                   size: size,
                   flags: flags)
    }
    
    init?() {
        return nil
    }
}

extension Tag {
    
    var toc: TableOfContents {
        get {
            var chapters = [Chapter]()
            let chapterFrames = self.frames.values.filter({$0.identifier == .chapter}) as? [ChapterFrame]
            for frame in chapterFrames ?? [] {
                let startTime = frame.startTime
                let title = frame.embeddedSubframesTag?.title ?? "Untitled Chapter @ \(startTime)"
                let chapter = Chapter(startTime: startTime, title: title)
                chapters.append(chapter)
            }
            return TOC(chapters)
        }
        set {
            chapterList = newValue.chapters
        }
    }
    
    
    public var chapterList: [Chapter] {
        get {
            return toc.chapters
        }
        set {
            self.frames = self.frames.filter({$0.value.identifier != .tableOfContents && $0.value.identifier != .chapter})
            if !newValue.isEmpty {
                var elementIDs = [String]()
                // handle all but the last
                for (index, chapter) in newValue.sorted(by: {$0.startTime < $1.startTime}).enumerated().dropLast() {
                    let nextChapter = newValue[newValue.index(after: index)]
                    let currentEndTime = nextChapter.startTime
                    let elementID = "ch\(chapter.startTime)"
                    elementIDs.append(elementID)
                    var embeddedSubFramesTag = Tag(version: self.version)
                    embeddedSubFramesTag.title = chapter.title
                    let chapterFrame = ChapterFrame(
                        .chapter,
                        version: self.version,
                        startTime: chapter.startTime,
                        endTime: currentEndTime,
                        embeddedSubframesTag: embeddedSubFramesTag)
                    let frameKey = FrameKey.chapter(startTime: chapter.startTime)
                    self.frames[frameKey] = chapterFrame
                }
                // handle last
                if let lastChapter = newValue.sorted(by: {$0.startTime < $1.startTime}).last {
                    let endTime = Tag.duration
                    let elementID = "ch\(lastChapter.startTime)"
                    elementIDs.append(elementID)
                    var embeddedSubFramesTag = Tag(version: self.version)
                    embeddedSubFramesTag.title = lastChapter.title
                    let chapterFrame = ChapterFrame(
                        .chapter,
                        version: self.version,
                        startTime: lastChapter.startTime,
                        endTime: endTime,
                        embeddedSubframesTag: embeddedSubFramesTag)
                    let frameKey = FrameKey.chapter(startTime: lastChapter.startTime)
                    self.frames[frameKey] = chapterFrame

                }
                var tocSubframesTag = Tag(version: self.version)
                tocSubframesTag.title = "Table Of Contents"
                let tocFrame = TableOfContentsFrame(
                    .tableOfContents,
                    version: self.version,
                    childElementIDs: elementIDs,
                    embeddedSubframesTag: tocSubframesTag)
                self.frames[.tableOfContents] = tocFrame
            } else {
                self.frames = self.frames.filter({$0.value.identifier != .tableOfContents && $0.value.identifier != .chapter})
            }
        }
    }
    
    
    public mutating func addChapter(startTime: Int, title: String) {
        toc.addChapter(startTime: startTime, title: title)
    }
    
    
    public mutating func removeAllChapters() {
        self.chapterList = []
    }
    
    
    public mutating func removeChapter(startTime: Int) {
        self.chapterList = self.chapterList.filter({$0.startTime != startTime})
    }
}
