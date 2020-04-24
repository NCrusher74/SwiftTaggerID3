//
//  Frame.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/8/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

/** A type containing methods and variables for querying and handling information from a frame */
public enum Frame {
    
    case stringFrame(StringFrame)
    case partOfTotalFrame(PartOfTotalFrame)
    case localizedFrame(LocalizedFrame)
    case userTextFrame(UserTextFrame)
    case languageFrame(LanguageFrame)
    case creditsListFrame(CreditsListFrame)
    case integerFrame(IntegerFrame)
//    case date(DateFrame)
//    case image(ImageFrame)
    case booleanFrame(BooleanFrame)
    case presetOptionsFrame(PresetOptionsFrame)
    case urlFrame(URLFrame)
    //    case toc(TableOfContentsFrame)
    //    case chapter(ChapterFrame)
    case unknownFrame(UnknownFrame)
    
    init(identifier: String,
         data: inout Data.SubSequence,
         version: Version) throws {
        let layout = FrameLayoutIdentifier(identifier: identifier)
//        print(layout) - known(SwiftTagger_MacOS.KnownFrameLayoutIdentifier.title) (checks)
        switch layout {
            //            case .known(KnownFrameLayoutIdentifier.attachedPicture):
            //                self = .image(try ImageFrame)
            //            case .known(KnownFrameLayoutIdentifier.chapter):
            //                self = .chapter(try ChapterFrame)
            //            case .known(KnownFrameLayoutIdentifier.tableOfContents):
            //                self = .toc(try TableOfContentsFrame)
            case .known(KnownFrameLayoutIdentifier.compilation):
                self = .booleanFrame(try BooleanFrame(
                    decodingFromStartOf: &data,
                    version: version,
                    layout: layout))
            case .known(KnownFrameLayoutIdentifier.genre),
                 .known(KnownFrameLayoutIdentifier.mediaType):
                self = .presetOptionsFrame(try PresetOptionsFrame(
                    decodingFromStartOf: &data,
                    version: version,
                    layout: layout))
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
                self = .creditsListFrame(try CreditsListFrame(
                    decodingFromStartOf: &data,
                    version: version,
                    layout: layout))
            case .known(KnownFrameLayoutIdentifier.userDefinedText),
                 .known(KnownFrameLayoutIdentifier.userDefinedWebpage):
                self = .userTextFrame(try UserTextFrame(
                    decodingFromStartOf: &data,
                    version: version,
                    layout: layout))
            case .known(KnownFrameLayoutIdentifier.bpm),
                 .known(KnownFrameLayoutIdentifier.isrc),
                 .known(KnownFrameLayoutIdentifier.length),
                 .known(KnownFrameLayoutIdentifier.movementCount),
                 .known(KnownFrameLayoutIdentifier.movementNumber),
                 .known(KnownFrameLayoutIdentifier.playlistDelay):
                self = .integerFrame(try IntegerFrame(
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
                self = .urlFrame(try URLFrame(
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
            case .unknown(identifier):
                self = .unknownFrame(try UnknownFrame(
                    decodingFromStartOf: &data,
                    version: version,
                    layout: layout))
            default:
                self = .stringFrame( try StringFrame(
                    decodingFromStartOf: &data,
                    version: version,
                    layout: layout))
        }
    }
    
    var frameKey: FrameKey {
        switch self {
            case .localizedFrame(let localizedFrame):
                return localizedFrame.frameKey
            case .languageFrame(let languageFrame):
                return languageFrame.frameKey
            case .creditsListFrame(let creditsListFrame):
                return creditsListFrame.frameKey
            case .presetOptionsFrame(let presetOptionsFrame):
                return presetOptionsFrame.frameKey
            case .stringFrame(let stringFrame):
                return stringFrame.frameKey
            case .integerFrame(let integerFrame):
                return integerFrame.frameKey
            case .booleanFrame(let booleanFrame):
                return booleanFrame.frameKey
            case .partOfTotalFrame(let partOfTotalFrame):
                return partOfTotalFrame.frameKey
            case .userTextFrame(let userTextFrame):
                return userTextFrame.frameKey
            case .urlFrame(let urlFrame):
                return urlFrame.frameKey
            case .unknownFrame(let unknownFrame):
                return unknownFrame.frameKey
        }
    }
}
