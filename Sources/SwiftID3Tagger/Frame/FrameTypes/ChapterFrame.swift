//
//  File.swift
//  
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

/// A class representing an ID3 chapter frame. There may be multiple chapter frames in a tag, but the `elementID` must be unique. Therefore, the `elementID` will serve as an additional identifier for the `frameKey`
class ChapterFrame: Frame {
    
    /// The Element ID uniquely identifies the frame. It is not intended to be human readable and should not be presented to the end user. Null terminated
    var elementID: String
    
    /// The Start and End times are a count in milliseconds from the beginning of the file to the start and end of the chapter respectively.
    var startTime: Int
    var endTime: Int
    
    var embeddedSubframesTag: Tag?
    
    override var frameKey: String {
        return self.identifier.frameKey(self.startTime)
    }
    
    // MARK: - Frame Parsing
    @available(OSX 10.12, *)
    init(identifier: FrameIdentifier,
         version: Version,
         size: Int,
         flags: Data,
         payload: Data) throws {
        var data = payload
        
        // SwiftTaggerID3 creates a new elementID for the frame
        _ = data.extractNullTerminatedString(.isoLatin1)
        self.startTime = data.extractFirst(4).uInt32BE.toInt
        self.endTime = data.extractFirst(4).uInt32BE.toInt
                
        self.elementID = "ch\(startTime)"
        // SwiftTagger uses start and end times, these will be set to 0xFF by default
        _ = data.extractFirst(4) // start byte offset, unused
        _ = data.extractFirst(4) // end byte offset, unused
        
        // parse the subframes and add them to the embedded subframes tag
        var subframes: [String : Frame] = [:]
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
    
    @available(OSX 10.12, *)
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
    @available(OSX 10.12, *)
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
    @available(OSX 10.12, *)
    /// `Get`: Retrieves chapter frames array from `chapterFrames` and presents the chapters as an array of `(startTime: title)` tuples for easier access.
    /// `Set` creates a `ChapterFrame` instance for every item in `newValue`
    public var chapterList: [(startTime: Int, title: String)] {
        get {
            var chapters = [(startTime: Int, title: String)]()
            var chapterCount = 1
            for chapter in self.chapterFrames {
                let startTime = chapter.startTime
                let chapterTitle: String
                if let title = chapter.embeddedSubframesTag?.title {
                    chapterTitle = title
                    chapterCount += 1
                } else {
                    chapterTitle = "Chapter \(chapterCount)"
                    chapterCount += 1
                }
                let entry = (startTime, chapterTitle)
                chapters.append(entry)
            }
            return chapters
        }
        set {
            do {
                let chapters = newValue.sorted(by: {$0.startTime < $1.startTime})
                // handle all except last
                for (index, chapter) in chapters.dropLast().enumerated() {
                    let next = chapters[chapters.index(after: index)]
                    let endTime = next.startTime
                    try self.setChapterFrame(
                        startTime: chapter.startTime,
                        endTime: endTime,
                        title: chapter.title)
                }
                // handle last
                if let chapter = chapters.last {
                    let endTime = Tag.duration
                    try self.setChapterFrame(
                        startTime: chapter.startTime,
                        endTime: endTime,
                        title: chapter.title)
                }
                setTOC(chapterFrames: self.chapterFrames)
            } catch {
                fatalError("Operation to set chapters failed")
            }
        }
    }
    
    @available(OSX 10.12, *)
    public mutating func addChapter(startTime: Int, title: String) {
        var list = self.chapterList
        for (index, item) in list.enumerated() {
            // if the start time already exists, we want to edit the title and replace the entry
            if item.startTime == startTime {
                list.remove(at: index)
                let newEntry = (startTime, title)
                list.insert(newEntry, at: index)
            } else {
                // if the start time doesn't already exist, we want to see if there are other chapters which should come after the one we're working on when they're in sequence, and insert the new chapter in the proper place
                let entry = (startTime, title)
                if let targetIndex = list.firstIndex(where: {$0.startTime > startTime}) {
                    list.insert(entry, at: targetIndex)
                } else {
                    // otherwise, add the chapter to the end of the list
                    list.append(entry)
                }
            }
        }
        self.chapterList = list
    }
    
    public mutating func removeAllChapters() {
        self.frames = self.frames.filter({$0.value.identifier != .chapter && $0.value.identifier != .tableOfContents})
    }

    public mutating func removeChapter(startTime: Int) {
        let identifier = FrameIdentifier.chapter
        let frameKey = identifier.frameKey(startTime)
        self.frames[frameKey] = nil
    }
    
    // MARK: Private and Internal
    @available(OSX 10.12, *)
    var chapterTitles: [String] {
        var titles = [String]()
        for chapter in chapterList {
            titles.append(chapter.title)
        }
        return titles
    }
    
    @available(OSX 10.12, *)
    var chapterStartTimes: [Int] {
        var starts = [Int]()
        for chapter in chapterList {
            starts.append(chapter.startTime)
        }
        return starts
    }
    
    @available(OSX 10.12, *)
    private mutating func setChapterFrame(startTime: Int,
                                          endTime: Int,
                                          title: String) throws {
        let identifier = FrameIdentifier.chapter
        let frameKey = identifier.frameKey(startTime)
        // remove existing frame at startTime, if it exists
        removeChapter(startTime: startTime)
        
        var subframes = Tag(version: self.version)
        subframes.title = title
        let frame = ChapterFrame(.chapter,
                                 version: self.version,
                                 startTime: startTime,
                                 endTime: endTime,
                                 embeddedSubframesTag: subframes)
        self.frames[frameKey] = frame
    }
    
    /// Retrieves and isolates the chapter frames into an array and sorts them in asending order.
    private var chapterFrames: [ChapterFrame] {
        var array = [ChapterFrame]()
        for (_, frame) in self.frames {
            if frame.identifier == .chapter {
                if let chapterFrame = frame as? ChapterFrame {
                    array.append(chapterFrame)
                }
            }
        }
        let sortedArray = array.sorted(by: {$0.startTime < $1.startTime})
        return sortedArray
    }
}
