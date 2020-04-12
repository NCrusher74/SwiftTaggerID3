//
//  Frame.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/8/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

/** A type containing methods and variables for querying and handling information from a frame */
internal enum Frame {
    
    /// the frame will be parsed by the `ChapterFrameParser` type
    case chapter(ChapterFrame)
    /// the frame will be parsed by the `CommentFrameParser` type
    case localizedFrame(LocalizedFrame)
    /// the frame will be parsed by the `LanguageFrameParser` type
    case languageFrame(LanguageFrame)
    /// the frame will be parsed by the `CreditsFrameParser` type
    case creditsList(CreditsListFrame)
    /// the frame will be parsed by the `DateFrameParser` type
    case date(DateFrame)
    /// the frame will be parsed by the `GenreFrameParser` type
    case genre(GenreFrame)
    /// the frame will be parsed by the `ImageFrameParser` type
    case image(ImageFrame)
    /// the frame will be parsed by the `StringFrameParser` type
    case string(StringFrame)
    /// the frame will be parsed by the `IntegerFrameParser` type
    case integer(IntegerFrame)
    /// the frame will be parsed by the `BooleanFrameParser` type
    case boolean(BooleanFrame)
    /// the frame will be parsed by the `PartOfTotalParser` type
    case partOfTotalFrame(PartOfTotalFrame)
    /// the frame will be parsed by the `TocFrameParser` type
    case toc(TableOfContentsFrame)
    /// the frame will be parsed by the `UserTextFrameParser` type
    case userText(UserTextFrame)
    /// will most likely be handled as a `UserTextFrame` unless it can't be for some reason
//    case unknownFrame(UnknownFrame)
}
