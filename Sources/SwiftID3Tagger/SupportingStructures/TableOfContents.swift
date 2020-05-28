//
//  TableOfContents.swift
//  
//
//  Created by Nolaine Crusher on 5/24/20.
//

import Foundation

/// a public-facing type for handling the TableOfContents frame in a more intuitive manner
struct TableOfContents {
    
    /// a dictionary of chapter frames within the tag.
    /// `Int`: the chapter start time
    var chapters: [Int: Chapter]
    init(chapters: [Int : Chapter]) {
        self.chapters = chapters
    }
    
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
                            chapter = TableOfContents.Chapter(title: "Chapter Title")
                        }
                        chapters[startTime] = chapter
                    }
                }
            }
            return TableOfContents(chapters: chapters)
        }
        set {
            // wipe the existing chapter frames and TOC so they can be replaced
            if let tocFrame = self.toc {
                let oldElementIDs = tocFrame.childElementIDs
                for id in oldElementIDs {
                    self.frames.removeValue(forKey: .chapter(byElementID: id))
                }
            }
            self.toc = nil
            
            // initialize an empty `childElementIDs` array
            var childElementIDs: [String] = []
            // store the new chapters array to avoid resorting every time we call it
            let newChapters = newValue.sortedChapters()
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
                let titleFrame = StringFrame(.known(.title), contentString: chapter.chapter.chapterTitle ?? "Chapter Title")
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
    
    public func getChapters() -> [Int: String] {
        var dict: [Int: String] = [:]
        let chapters = self.tableOfContents.sortedChapters()
        for chapter in chapters {
            dict[chapter.startTime] = chapter.chapter.chapterTitle
        }
        return dict
    }
    
    public mutating func addChapter(at startTime: Int, title: String) {
        var toc = self.tableOfContents.chapters
        toc.updateValue(TableOfContents.Chapter(title: title), forKey: startTime)
        self.tableOfContents.chapters = toc
    }
    
    public mutating func removeChapter(at startTime: Int) {
        self.tableOfContents.chapters[startTime] = nil
    }
    
    public mutating func removeAllChapters() {
        self.tableOfContents.chapters = [:]
    }
}
