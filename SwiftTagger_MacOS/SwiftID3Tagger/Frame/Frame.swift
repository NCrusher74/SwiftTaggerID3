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
    case dateFrame(DateFrame)
    //    case image(ImageFrame)
    case booleanFrame(BooleanFrame)
    case presetOptionsFrame(PresetOptionsFrame)
    case urlFrame(URLFrame)
    //    case toc(TableOfContentsFrame)
    case chapter(ChapterFrame)
    case unknownFrame(UnknownFrame)
    
    init(identifier: String,
         data: inout Data.SubSequence,
         version: Version) throws {
        let layout = FrameLayoutIdentifier(identifier: identifier)
        //        print(layout) - known(SwiftTagger_MacOS.title) (checks)
        switch layout {
            //            case .known(.attachedPicture):
            //                self = .image(try ImageFrame)
            case .known(.chapter):
                self = .chapter(try ChapterFrame(
                    decodingFromStartOf: &data,
                    version: version,
                    layout: layout))
            //            case .known(.tableOfContents):
            //                self = .toc(try TableOfContentsFrame)
            case .known(.compilation):
                self = .booleanFrame(try BooleanFrame(
                    decodingFromStartOf: &data,
                    version: version,
                    layout: layout))
            case .known(.genre),
                 .known(.mediaType):
                self = .presetOptionsFrame(try PresetOptionsFrame(
                    decodingFromStartOf: &data,
                    version: version,
                    layout: layout))
            case .known(.languages):
                self = .languageFrame(try LanguageFrame(
                    decodingFromStartOf: &data,
                    version: version,
                    layout: layout))
            case .known(.comments),
                 .known(.unsynchronizedLyrics):
                self = .localizedFrame(try LocalizedFrame(
                    decodingFromStartOf: &data,
                    version: version,
                    layout: layout))
            case .known(.discNumber),
                 .known(.trackNumber):
                self = .partOfTotalFrame(try PartOfTotalFrame(
                    decodingFromStartOf: &data,
                    version: version,
                    layout: layout))
            case .known(.involvedPeopleList),
                 .known(.musicianCreditsList):
                self = .creditsListFrame(try CreditsListFrame(
                    decodingFromStartOf: &data,
                    version: version,
                    layout: layout))
            case .known(.userDefinedText),
                 .known(.userDefinedWebpage):
                self = .userTextFrame(try UserTextFrame(
                    decodingFromStartOf: &data,
                    version: version,
                    layout: layout))
            case .known(.bpm),
                 .known(.isrc),
                 .known(.length),
                 .known(.movementCount),
                 .known(.movementNumber),
                 .known(.playlistDelay):
                self = .integerFrame(try IntegerFrame(
                    decodingFromStartOf: &data,
                    version: version,
                    layout: layout))
            case .known(.artistWebpage),
                 .known(.audioFileWebpage),
                 .known(.audioSourceWebpage),
                 .known(.copyrightWebpage),
                 .known(.paymentWebpage),
                 .known(.publisherWebpage),
                 .known(.radioStationWebpage):
                self = .urlFrame(try URLFrame(
                    decodingFromStartOf: &data,
                    version: version,
                    layout: layout))
            case .known(.date),
                 .known(.encodingTime),
                 .known(.originalReleaseTime),
                 .known(.recordingDate),
                 .known(.releaseTime),
                 .known(.taggingTime),
                 .known(.time),
                 .known(.year):
                self = .dateFrame(try DateFrame(
                    decodingFromStartOf: &data,
                    version: version,
                    layout: layout))
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
            case .dateFrame(let dateFrame):
                return dateFrame.frameKey
            case .chapter(let chapterFrame):
                return chapterFrame.frameKey
        }
    }
}
