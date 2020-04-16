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
    case unknown(UnknownFrame)
    /// will most likely be handled as a `UserTextFrame` unless it can't be for some reason
    //    case unknownFrame(UnknownFrame)
    
    init(layout: FrameLayoutIdentifier,
         data: inout Data.SubSequence,
         version: Version) throws {
        switch layout {
            //            case .known(KnownFrameLayoutIdentifier.attachedPicture):
            //                self = .image(try ImageFrame)
            //            case .known(KnownFrameLayoutIdentifier.chapter):
            //                self = .chapter(try ChapterFrame)
            //            case .known(KnownFrameLayoutIdentifier.tableOfContents):
            //                self = .toc(try TableOfContentsFrame)
            case .known(KnownFrameLayoutIdentifier.compilation):
                self = .boolean(try BooleanFrame(
                    decodingFromStartOf: &data,
                    version: version,
                    layout: layout))
            //            case .known(KnownFrameLayoutIdentifier.genre):
            //                self = .genre(try GenreFrame)
            case .known(KnownFrameLayoutIdentifier.languages):
                self = .languageFrame(try LanguageFrame(
                    decodingFromStartOf: &data,
                    version: version,
                    layout: layout))
            case .known(KnownFrameLayoutIdentifier.comments),
                 .known(KnownFrameLayoutIdentifier.unsynchronizedLyrics):
                self = .localizedFrame(try LocalizedFrame(
                    decodingFromStartOf: &data,
                    version: version,
                    layout: layout))
            case .known(KnownFrameLayoutIdentifier.discNumber),
                 .known(KnownFrameLayoutIdentifier.trackNumber):
                self = .partOfTotalFrame(try PartOfTotalFrame(
                    decodingFromStartOf: &data,
                    version: version,
                    layout: layout))
            case .known(KnownFrameLayoutIdentifier.involvedPeopleList),
                 .known(KnownFrameLayoutIdentifier.musicianCreditsList):
                self = .creditsList(try CreditsListFrame(
                    decodingFromStartOf: &data,
                    version: version,
                    layout: layout))
            case .known(KnownFrameLayoutIdentifier.userDefinedText),
                 .known(KnownFrameLayoutIdentifier.userDefinedWebpage):
                self = .userText(try UserTextFrame(
                    decodingFromStartOf: &data,
                    version: version,
                    layout: layout))
            case .known(KnownFrameLayoutIdentifier.bpm),
                 .known(KnownFrameLayoutIdentifier.isrc),
                 .known(KnownFrameLayoutIdentifier.length),
                 .known(KnownFrameLayoutIdentifier.movementCount),
                 .known(KnownFrameLayoutIdentifier.movementNumber),
                 .known(KnownFrameLayoutIdentifier.playlistDelay):
                self = .integer(try IntegerFrame(
                    decodingFromStartOf: &data,
                    version: version,
                    layout: layout))
            case .known(KnownFrameLayoutIdentifier.artistWebpage),
                 .known(KnownFrameLayoutIdentifier.audioFileWebpage),
                 .known(KnownFrameLayoutIdentifier.audioSourceWebpage),
                 .known(KnownFrameLayoutIdentifier.copyrightWebpage),
                 .known(KnownFrameLayoutIdentifier.paymentWebpage),
                 .known(KnownFrameLayoutIdentifier.publisherWebpage),
                 .known(KnownFrameLayoutIdentifier.radioStationWebpage):
                self = .url(try URLFrame(
                    decodingFromStartOf: &data,
                    version: version,
                    layout: layout))
//            case .known(KnownFrameLayoutIdentifier.date),
//                 .known(KnownFrameLayoutIdentifier.encodingTime),
//                 .known(KnownFrameLayoutIdentifier.originalReleaseTime),
//                 .known(KnownFrameLayoutIdentifier.recordingDate),
//                 .known(KnownFrameLayoutIdentifier.releaseTime),
//                 .known(KnownFrameLayoutIdentifier.taggingTime),
//                 .known(KnownFrameLayoutIdentifier.time),
//                 .known(KnownFrameLayoutIdentifier.year):
//                self = .date(try DataFrame)
            default:
                self = .string(try StringFrame(
                    decodingFromStartOf: &data,
                    version: version,
                    layout: layout))            
        }
    }
}
