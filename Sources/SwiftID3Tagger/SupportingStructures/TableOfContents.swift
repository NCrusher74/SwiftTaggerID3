//
//  TableOfContents.swift
//  
//
//  Created by Nolaine Crusher on 5/24/20.
//

import Foundation

/// a public-facing type for handling the TableOfContents frame in a more intuitive manner
public struct TableOfContents {
    
    /// a dictionary of chapter frames within the tag.
    /// `Int`: the chapter start time
    public var chapters: [Int: Chapter]
    
    /// a public-facing type for handling the Chapter frame in a more intuitive manner
    public struct Chapter {
        /// the start time in miliseconds
        public var startTime: Int
        
        // initialize a Chapter instance using a chapter start time
        init(startTime: Int) {
            self.startTime = startTime
        }
    }
    
    /// The chapters in chronological order.
    public func sortedChapters() -> [(startTime: Int, chapter: Chapter)] {
        return chapters.keys.sorted().map { ($0, chapters[$0]!) }
    }
}

extension Tag {
    public var tableOfContents: TableOfContents {
        get {
            // initialize a chapter instance by the start time
            var chapters: [Int: TableOfContents.Chapter] = [:]
            // get the TOC frame
            if let tocFrame = self.toc {
                let childElementIDs = tocFrame.childElementIDs
                for id in childElementIDs {
                    if let chapterFrame = self[chapterFrom: id] {
                        chapters[chapterFrame.startTime] = TableOfContents.Chapter(startTime: chapterFrame.startTime)
                    }
                }
            }
            return TableOfContents(chapters: chapters)
        }
        
        set {
            // build the chapter frames from the start times in the TOC
            var childElementIDs: [String] = []
            var chapterNumber: Int = 0
            // get the endTime for the current chapter from the startTime of the next chapter
            var endTime: Int = 0
            for (index, _) in newValue.sortedChapters() {
                // will this go out of bounds at the end?
                let nextIndex = index + 1
                let nextChapter = newValue.chapters[nextIndex]
                let nextStartTime = nextChapter?.startTime
                endTime = nextStartTime ?? 0
            }
            // initialize a chapter frame deriving elementID from the chapter
            for chapter in newValue.sortedChapters() {
                // create an elementID from the chapter's index
                let elementID = "ch\(chapterNumber)"
                childElementIDs.append(elementID)
                let startTime = chapter.startTime

                var chapterFrame = ChapterFrame()
                chapterFrame.elementID = elementID
                chapterFrame.endTime = endTime
                chapterFrame.embeddedSubframesTag = 
                chapterNumber += 1
                self[chapterFrom: startTime] = chapterFrame
            }
            
            var toc = TableOfContentsFrame()
            toc.childElementIDs = childElementIDs
            self.toc = toc
        }
    }
    
}
