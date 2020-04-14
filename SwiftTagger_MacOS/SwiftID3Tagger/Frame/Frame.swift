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
    
    case chapter(ChapterFrame)
    case localizedFrame(LocalizedFrame)
    case languageFrame(LanguageFrame)
    case creditsList(CreditsListFrame)
    case date(DateFrame)
    case genre(GenreFrame)
    case image(ImageFrame)
    case string(StringFrame)
    case integer(IntegerFrame)
    case boolean(BooleanFrame)
    case partOfTotalFrame(PartOfTotalFrame)
    case toc(TableOfContentsFrame)
    case userText(UserTextFrame)
    case url(URLFrame)
//    /// will most likely be handled as a `UserTextFrame` unless it can't be for some reason
////    case unknownFrame(UnknownFrame)
    
    internal var handling: KnownFrameLayoutIdentifier {
        switch self {

            case .chapter(_):
                return .chapter
            case .localizedFrame(_):
                return .comments, .
            case .languageFrame(_):
            <#code#>
            case .creditsList(_):
            <#code#>
            case .date(_):
            <#code#>
            case .genre(_):
            <#code#>
            case .image(_):
            <#code#>
            case .string(_):
            <#code#>
            case .integer(_):
            <#code#>
            case .boolean(_):
            <#code#>
            case .partOfTotalFrame(_):
            <#code#>
            case .toc(_):
            <#code#>
            case .userText(_):
            <#code#>
            case .url(_):
            <#code#>
        }
    }
    
}
