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
        init(chapterFrame: ChapterFrame) {
            self.startTime = chapterFrame.startTime
        }
        
    }
    
    /// The chapters in chronological order.
    public func sortedChapters() -> [(startTime: Int, chapter: Chapter)] {
        return chapters.keys.sorted().map { ($0, chapters[$0]!) }
    }
}

extension Tag {
    var tableOfContents: TableOfContents {
        get {
            var chapters: [Int: TableOfContents.Chapter] = [:]
            if let frame = self.frames[.tableOfContents],
                case .tocFrame(let tocFrame) = frame {
                for id in tocFrame.childElementIDs {
                    if let chapter = self.frames[.chapter(byElementID: id)],
                        case .chapterFrame(let chapterFrame) = chapter {
                        chapters[chapterFrame.startTime] = TableOfContents.Chapter(chapterFrame: chapterFrame)
                    }
                }
            }
            return TableOfContents(chapters: chapters)
        }
        set {
            // Assemble a frame based on the new value of your type and overwrite the old frame.
            // You’ll create arbitrary identifiers of your own here whenever needed.
        }
    }
}
