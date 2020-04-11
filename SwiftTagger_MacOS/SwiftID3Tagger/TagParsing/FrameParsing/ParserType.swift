//
//  ParserType.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/9/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

/** ParserType describes the parser type used in reading and parsing the data in the frame */
enum ParserType {
    
    /// the frame will be parsed by the `ChapterFrameParser` type
    case chapterParser
    /// the frame will be parsed by the `CommentFrameParser` type
    case commentParser
    /// the frame will be parsed by the `CreditsFrameParser` type
    case creditsParser
    /// the frame will be parsed by the `DateFrameParser` type
    case dateParser
    /// the frame will be parsed by the `GenreFrameParser` type
    case genreParser
    /// the frame will be parsed by the `ImageFrameParser` type
    case imageParser
    /// the frame will be parsed by the `URLFrameParser` type
    case urlParser
    /// the frame will be parsed by the `StringFrameParser` type
    case stringParser
    /// the frame will be parsed by the `TocFrameParser` type
    case tocParser
    /// the frame will be parsed by the `UserTextFrameParser` type
    case userTextParser
    
}
