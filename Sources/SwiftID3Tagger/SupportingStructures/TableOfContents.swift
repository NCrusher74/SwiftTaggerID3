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
        init(from chapterFrame: ChapterFrame) {
            self.subframes = chapterFrame.embeddedSubframesTag
        }
        public var subframes: Tag?
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
                for elementID in childElementIDs {
                    let frameKey: FrameKey = .chapter(byElementID: elementID)
                    if let frame = self.frames[frameKey],
                        case .chapterFrame(let chapterFrame) = frame {
                        let startTime = chapterFrame.startTime
                        let chapter = TableOfContents.Chapter(from: chapterFrame)
                        chapters[startTime] = chapter
                    }
                }
            }
            return TableOfContents(chapters: chapters)
        }
        set {
            // get the endTime for the current chapter from the startTime of the next chapter
            var endTime: Int = 0
            for (index, _) in newValue.sortedChapters().enumerated() {
                if index < newValue.sortedChapters().count {
                    let nextChapter = newValue.sortedChapters()[index + 1]
                    endTime = nextChapter.startTime
                } else {
                    endTime = self.mp3Duration ?? 0
                }
            }
            
            var childElementIDs: [String] = []

            // assign an arbitary elementID to the chapter
            var chapterNumber: Int = 0
            let elementID = "ch\(chapterNumber)"

            // build the chapter frames
            for chapter in newValue.sortedChapters() {
                var chapterFrame = ChapterFrame()
                // populate the empty frame with all the new data
                chapterFrame.startTime = chapter.startTime
                chapterFrame.endTime = endTime
                chapterFrame.elementID = elementID
                // append the elementID to the array for the TOC while we're here
                childElementIDs.append(elementID)
                chapterFrame.embeddedSubframesTag = chapter.chapter.subframes
                self[chapterFrom: chapter.startTime] = chapterFrame
                chapterNumber += 1
            }
            
            // initialize an empty CTOC frame and populate it with the child element IDs array
            var toc = TableOfContentsFrame()
            toc.childElementIDs = childElementIDs
            self.toc = toc
        }
    }    
}
