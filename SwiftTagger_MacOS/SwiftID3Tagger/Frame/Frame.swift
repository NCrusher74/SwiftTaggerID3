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
    /// will most likely be handled as a `UserTextFrame` unless it can't be for some reason
    //    case unknownFrame(UnknownFrame)
    
    init(layout: KnownFrameLayoutIdentifier,
         data: inout Data.SubSequence,
         version: Version) throws {
        switch layout {
            //            case .attachedPicture:
            //                self = .image(try ImageFrame)
            //            case .chapter:
            //                self = .chapter(try ChapterFrame)
            //            case .tableOfContents:
            //                self = .toc(try TableOfContentsFrame)
            case .compilation:
                self = .boolean(try BooleanFrame(
                    decodingFromStartOf: &data,
                    version: version,
                    frameIdentifier: layout))
            //            case .genre:
            //                self = .genre(try GenreFrame)
            case .languages:
                self = .languageFrame(try LanguageFrame(
                    decodingFromStartOf: &data,
                    version: version,
                    frameIdentifier: layout))
            case .comments,
                 .unsynchronizedLyrics:
                self = .localizedFrame(try LocalizedFrame(
                    decodingFromStartOf: &data,
                    version: version,
                    frameIdentifier: layout))
            case .discNumber,
                 .trackNumber:
                self = .partOfTotalFrame(try PartOfTotalFrame(
                    decodingFromStartOf: &data,
                    version: version,
                    frameIdentifier: layout))
            case .involvedPeopleList,
                 .musicianCreditsList:
                self = .creditsList(try CreditsListFrame(
                    decodingFromStartOf: &data,
                    version: version,
                    frameIdentifier: layout))
            case .userDefinedText,
                 .userDefinedWebpage:
                self = .userText(try UserTextFrame(
                    decodingFromStartOf: &data,
                    version: version,
                    frameIdentifier: layout))
            case .bpm,
                 .isrc,
                 .length,
                 .movementCount,
                 .movementNumber,
                 .playlistDelay:
                self = .integer(try IntegerFrame(
                    decodingFromStartOf: &data,
                    version: version,
                    frameIdentifier: layout))
            case .artistWebpage,
                 .audioFileWebpage,
                 .audioSourceWebpage,
                 .copyrightWebpage,
                 .paymentWebpage,
                 .publisherWebpage,
                 .radioStationWebpage:
                self = .url(try URLFrame(
                    decodingFromStartOf: &data,
                    version: version,
                    frameIdentifier: layout))
//            case .date, .encodingTime, .originalReleaseTime, .recordingDate, .releaseTime, .taggingTime, .time, .year: self = .date(try DataFrame)
            default:
                self = .string(try StringFrame(
                    decodingFromStartOf: &data,
                    version: version,
                    frameIdentifier: layout))            
        }
    }
}
