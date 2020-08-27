/*

 TableOfContents.swift
 SwiftTaggerID3

 Copyright ©2020 Nolaine Crusher. All rights reserved.

 */

import Foundation

/// a public-facing type for handling the TableOfContents frame in a more intuitive manner
struct TableOfContents {
    
    /// a dictionary of chapter frames within the tag.
    /// `Int`: the chapter start time
    var chapters: [Int: Chapter]
    
    /// a public-facing type for handling the Chapter frame in a more intuitive manner
    struct Chapter {
        var chapterTitle: String?
        init(title: String?) {
            self.chapterTitle = title
        }
    }
    
    /// The chapters in chronological order.
    func sortedChapters() -> [(startTime: Int, chapter: Chapter)] {
        return chapters.keys.sorted().map { ($0, chapters[$0]!) }
    }
}



extension Tag {
    @available(OSX 10.12, *)
    var tableOfContents: TableOfContents {
        get {
            // initialize a chapter instance by the start time
            var chapters: [Int: TableOfContents.Chapter] = [:]
            
            // get the TOC frame
            if let tocFrame = self.toc {
                // the TOC frame has an array of elementIDs for the chapters
                let childElementIDs = tocFrame.childElementIDs
                // use those to initialize and decode a chapter frame
                for elementID in childElementIDs {
                    let frameKey: FrameKey = .chapter(byElementID: elementID)
                    if let frame = self.frames[frameKey],
                        case .chapterFrame(let chapterFrame) = frame {
                        let startTime = chapterFrame.startTime
                        let chapter: TableOfContents.Chapter
                        if let title = chapterFrame.embeddedSubframesTag?.title {
                            chapter = TableOfContents.Chapter(title: title)
                        } else {
                            chapter = TableOfContents.Chapter(title: "")
                        }
                        chapters[startTime] = chapter
                    }
                }
            }
            return TableOfContents(chapters: chapters)
        }
        set {
            // store the new chapters array to avoid resorting every time we call it
            let newChapters = newValue.sortedChapters()
            // wipe the existing chapter frames and TOC so they can be replaced
            if let tocFrame = self.toc {
                let oldElementIDs = tocFrame.childElementIDs
                for id in oldElementIDs {
                    self.removeChapterFrame(with: id)
                }
            }
            self.removeTableOfContents()
            
            // initialize an empty `childElementIDs` array
            var childElementIDs: [String] = []
            // for each index in the chapters array...
            for index in newChapters.indices {
                // get the current chapter
                let chapter = newChapters[index]
                // get the endTime for the current chapter from the startTime of the next chapter
                let endTime: Int
                // get the index of the next chapter
                let nextIndex = newChapters.index(after: index)
                if nextIndex < newChapters.endIndex {
                    let nextChapter = newChapters[nextIndex]
                    // get the start time of the next chapter for the end time of the current chapter
                    endTime = nextChapter.startTime
                } else {
                    // unless it's the last chapter, in which case the end time is the end of the file
                    endTime = self.mp3Duration ?? 0
                }
                // assign an arbitary elementID to the chapter
                let elementID = "ch\(index)"
                // build a title subframe
                let titleFrame = StringFrame(.known(.title), contentString: chapter.chapter.chapterTitle ?? "")
                let titleFrameKey: FrameKey = .title
                let subframe = Frame.stringFrame(titleFrame)
                let subframesTag = Tag(subframes: [titleFrameKey : subframe])
                
                // initialize a ChapterFrame instance for the chapter
                // using all the elements we just constructed
                let frame = ChapterFrame(.known(.chapter),
                                         elementID: elementID,
                                         startTime: chapter.startTime,
                                         endTime: endTime,
                                         embeddedSubframesTag: subframesTag)
                self.frames[.chapter(byElementID: elementID)] = .chapterFrame(frame)
                // add the elementID to the childElementIDs array for the TOC frame
                childElementIDs.append(elementID)
            }
            // initialize a CTOC frame and populate it with the child element IDs array
            let frame = TableOfContentsFrame(.known(.tableOfContents),
                                             childElementIDs: childElementIDs,
                                             embeddedSubframesTag: nil)
            self.frames[.tableOfContents] = .tocFrame(frame)
        }
    }
    
    /// Retrieves an array of chapters by start time (in milliseconds) and title.
    @available(OSX 10.12, *)
    public var chapterList: [(startTime: Int, title: String)] {
        var chaptersArray: [(Int, String)] = []
        let chapters = self.tableOfContents.sortedChapters()
        for chapter in chapters {
            let startTime = chapter.startTime
            let title = chapter.chapter.chapterTitle ?? ""
            chaptersArray.append((startTime, title))
        }
        return chaptersArray
    }
    
    /// Adds a chapter at the specified start time (in milliseconds) with the specified title.
    /// If a chapter exists at the specified start time, it will be overwritten.
    /// To edit a chapter title, simply overwrite the existing chapter with a new one
    @available(OSX 10.12, *)
    public mutating func addChapter(at startTime: Int, title: String) {
        var tocChapters = self.tableOfContents.chapters
        tocChapters.updateValue(TableOfContents.Chapter(title: title), forKey: startTime)
        self.tableOfContents.chapters = tocChapters
    }
    
    /// Removes the chapter at the specified start time.
    @available(OSX 10.12, *)
    public mutating func removeChapter(at startTime: Int) {
        self.tableOfContents.chapters[startTime] = nil
    }
    
    /// Removes all chapters.
    @available(OSX 10.12, *)
    public mutating func removeAllChapters() {
        self.tableOfContents.chapters = [:]
        self.removeTableOfContents()
    }
}
