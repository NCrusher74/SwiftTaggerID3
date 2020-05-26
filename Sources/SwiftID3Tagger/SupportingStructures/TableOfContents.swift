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
        // arbitrarily assigned elementID
        var elementID: UUID
        /// the start time in miliseconds
        public var startTime: Int
        // derived from the start time of the next chapter
        var endTime: Int
        /// an optional title for the chapter
        /// (will initialize a `TIT2` (title) subframe)
        public var chapterTitle: String?
        /// an optional description for the chapter
        /// (will initialize an `COMM` (comment) subframe)
        public var chapterDescription: String?
        /// an optional image for the chapter
        /// (will initialize a `APIC` (attached picture) subframe)
        public var chapterImage: Data?
        
        
        
    }

    /// The chapters in chronological order.
    public func sortedChapters() -> [(startTime: Int, chapter: Chapter)] {
        return chapters.keys.sorted().map { ($0, chapters[$0]!) }
    }
}

extension Tag {
    var tableOfContents: TableOfContents {
        get {
            // Find the frame and assemble an instance of your more intuitive type to return.
        }
        set {
            // Assemble a frame based on the new value of your type and overwrite the old frame.
            // You’ll create arbitrary identifiers of your own here whenever needed.
        }
    }
}
