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
    
//    case chapter(ChapterFrame)
    case localizedFrame(LocalizedFrame)
    case languageFrame(LanguageFrame)
    case creditsListFrame(CreditsListFrame)
//    case date(DateFrame)
    case presetOptionsFrame(PresetOptionsFrame)
//    case image(ImageFrame)
    case stringFrame(StringFrame)
    case integerFrame(IntegerFrame)
    case booleanFrame(BooleanFrame)
    case partOfTotalFrame(PartOfTotalFrame)
//    case toc(TableOfContentsFrame)
    case userTextFrame(UserTextFrame)
    case urlFrame(URLFrame)
    case unknownFrame(UnknownFrame)
    
    init(identifier: String,
         data: inout Data.SubSequence,
         version: Version) throws {
        let layout = FrameLayoutIdentifier(identifier: identifier)
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
    
    func getFrameKeyForFrame(data: Data.SubSequence,
                             version: Version,
                             layout: FrameLayoutIdentifier,
                             identifier: String,
                             flags: Data) throws -> FrameKey {
        switch self {
            case .localizedFrame(_):
                let frame = try LocalizedFrame(
                    decodingContents: data,
                    version: version,
                    layout: layout,
                    flags: flags)
                return frame.frameKey(version: version) ?? .userDefinedText(description: "")
            case .languageFrame(_):
                let frame = try LanguageFrame(
                    decodingContents: data,
                    version: version,
                    layout: layout,
                    flags: flags)
                return frame.frameKey(version: version) ?? .userDefinedText(description: "")
            case .creditsListFrame(_):
                let frame = try CreditsListFrame(
                    decodingContents: data,
                    version: version,
                    layout: layout,
                    flags: flags)
                return frame.frameKey(version: version) ?? .userDefinedText(description: "")
            case .presetOptionsFrame(_):
                let frame = try PresetOptionsFrame(
                    decodingContents: data,
                    version: version,
                    layout: layout,
                    flags: flags)
                return frame.frameKey(version: version) ?? .userDefinedText(description: "")
            case .stringFrame(_):
                let frame = try StringFrame(
                    decodingContents: data,
                    version: version,
                    layout: layout,
                    flags: flags)
                return frame.frameKey(version: version) ?? .userDefinedText(description: "")
            case .integerFrame(_):
                let frame = try IntegerFrame(
                    decodingContents: data,
                    version: version,
                    layout: layout,
                    flags: flags)
                return frame.frameKey(version: version) ?? .userDefinedText(description: "")
            case .booleanFrame(_):
                let frame = try BooleanFrame(
                    decodingContents: data,
                    version: version,
                    layout: layout,
                    flags: flags)
                return frame.frameKey(version: version) ?? .userDefinedText(description: "")
            case .partOfTotalFrame(_):
                let frame = try PartOfTotalFrame(
                    decodingContents: data,
                    version: version,
                    layout: layout,
                    flags: flags)
                return frame.frameKey(version: version) ?? .userDefinedText(description: "")
            case .userTextFrame(_):
                let frame = try UserTextFrame(
                    decodingContents: data,
                    version: version,
                    layout: layout,
                    flags: flags)
                return frame.frameKey(version: version) ?? .userDefinedText(description: "")
            case .urlFrame(_):
                let frame = try URLFrame(
                    decodingContents: data,
                    version: version,
                    layout: layout,
                    flags: flags)
                return frame.frameKey(version: version) ?? .userDefinedText(description: "")
            case .unknownFrame(_):
                let frame = try UnknownFrame(
                    decodingContents: data,
                    version: version,
                    layout: layout,
                    flags: flags)
                return frame.frameKey(version: version,
                                      identifier: identifier) ?? .userDefinedText(description: "")
        }
    }
}
