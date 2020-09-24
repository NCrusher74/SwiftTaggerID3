//
//  File.swift
//  
//
//  Created by Nolaine Crusher on 9/23/20.
//

import Foundation

/// An enum containing methods and variables for querying and building frames with a particular structure
enum FrameType {
        /// A frame type containing a single, unterminated string of content
        ///
        /// Frames of this type MAY NOT be duplicated within a valid ID3 tag
        case stringFrame(StringFrame)
        /// A frame type containing the index of the track or disc in the collection, with an optional addition of the total number of tracks or discs
        ///
        /// Frames of this type MAY NOT be duplicated within a valid ID3 tag
        case partAndTotalFrame(PartAndTotalFrame)
        /// A frame type containing contents for `Comment`,`UnsynchronizedLyrics`, `UserDefinedText`, and `UserDefinedWebpage` frames.
        ///
        /// Composed of an (optional) language code string, an optional terminated description string, and a single string of content that is permitted to contain new line characters (only for `Comment` and `Lyrics` frames. `UserDefinedText` may not contain new lines)
        ///
        /// Frames of this type MAY be duplicated within a valid ID3 tag, but each is required to have a unique description unless the language is different.
        case localizedFrame(LocalizedFrame)
        /// A frame type containing an array of `role:person` tuples
        ///
        /// Frames of this type MAY NOT be duplicated within a valid ID3 tag
        case creditsFrame(CreditsFrame)
        /// A frame type containing an date value that will be encoded and stored as a timestamp string.
        ///
        /// Frames of this type MAY NOT be duplicated within a valid ID3 tag
        @available(OSX 10.12, *)
        case dateFrame(DateFrame)
        /// A frame type containing an attached image pertaining to the audio media.
        ///
        /// Frames of this type MAY be duplicated within a valid ID3 tag, but each must have a unique description string, except for the first and second `ImageType` options, which MAY NOT be duplicated.
        case imageFrame(ImageFrame)
        /// A frame type consisting of optional strings from an enumeration of preset values, an optional string (terminated) of preset refinement values, and an optional string of freeform refinements or information.
        ///
        /// Frames of this type MAY NOT be duplicated within a valid ID3 tag
        case complexTypesFrame(ComplexTypesFrame)
        /// A frame type containing a table of contents frame.
        ///
        /// Frames of this type MAY be duplicated within a valid ID3 tag, providing only one has the top-level flag set, and each has a unique `ElementID` (Note, `SwiftTaggerID3` does not support multiple tocFrames at present)
        @available(OSX 10.12, *)
        case tocFrame(TableOfContentsFrame)
        /// a frame type containing a chapter frame.
        ///
        ///Frames of this type MAY be duplicated within a valid ID3 tag, but each one must have a unique `ElementID`
        @available(OSX 10.12, *)
        case chapterFrame(ChapterFrame)
        /// A type that allows unsupported frames to pass through and be returned intact
        case passThrough(PassThroughFrame)

}
