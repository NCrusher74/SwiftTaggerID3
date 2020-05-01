//
//  Frame.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/8/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

/** An enum containing methods and variables for querying and handling information from a frame */
enum Frame {
    
    /// a frame type containing a single, unterminated string of content
    case stringFrame(StringFrame)
    /** a frame type containing the index of the track or disc in the collection, with an optional addition of the total number of tracks or discs */
    case partOfTotalFrame(PartOfTotalFrame)
    /** a frame type containing contents for `Comment` or `UnsynchronizedLyrics`frames. Composed of a language code string, an optional terminated description string, and a single string of content that is permitted to contain new line characters */
    case localizedFrame(LocalizedFrame)
    /** a frame type containing the user customized information or URLs */
    case userTextFrame(UserTextFrame)
    /** a frame type containing an array of ISO-639-2 language codes */
    case languageFrame(LanguageFrame)
    /** a frame type containing an array of `role:person` tuples */
    case creditsListFrame(CreditsListFrame)
    /// a frame type containing an integer value that will be encoded and stored as an integer string
    case integerFrame(IntegerFrame)
    /// a frame type containing an date value that will be encoded and stored as a timestamp string
    case dateFrame(DateFrame)
    /// a frame type containing an attached image pertaining to the audio media
    case imageFrame(ImageFrame)
    /** a frame type containing a boolean value that will be interpreted as a 1 or 0 and written to the file as an integer string */
    case booleanFrame(BooleanFrame)
    /** a frame type consisting of optional strings from an enumeration of preset values, an optional string of preset refinement values, and an optional string of freeform refinements or information */
    case presetOptionsFrame(PresetOptionsFrame)
    /// a frame type containing a single, unterminated string of content in the form of a URL
    case urlFrame(URLFrame)
    /// a frame type containing a table of contents frame
    case tocFrame(TableOfContentsFrame)
    /// a frame type containing a chapter frame
    case chapterFrame(ChapterFrame)
    /// allows unsupported frames to pass through and be returned unpaarsed
    case unknownFrame(UnknownFrame)
    
    // instantiates a frame handler based upon the `identifier` string
    init(identifier: String,
         data: inout Data.SubSequence,
         version: Version) throws {
        let layout = FrameLayoutIdentifier(identifier: identifier)
        switch layout {
            case .known(.attachedPicture):
                self = .imageFrame(try ImageFrame(
                    decodingFromStartOf: &data,
                    version: version,
                    layout: layout))
            case .known(.chapter):
                self = .chapterFrame(try ChapterFrame(
                    decodingFromStartOf: &data,
                    version: version,
                    layout: layout))
            case .known(.tableOfContents):
                self = .tocFrame(try TableOfContentsFrame(
                    decodingFromStartOf: &data,
                    version: version,
                    layout: layout))
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
            case .chapterFrame(let chapterFrame):
                return chapterFrame.frameKey
            case .tocFrame(let tableOfContentsFrame):
                return tableOfContentsFrame.frameKey
            case .imageFrame(let imageFrame):
                return imageFrame.frameKey
        }
    }
}

extension Frame {
    var asFrameProtocol: FrameProtocol {
        switch self {
            case .stringFrame(let stringFrame):
                return stringFrame
            case .partOfTotalFrame(let partOfTotalFrame):
                return partOfTotalFrame
            case .localizedFrame(let localizedFrame):
                return localizedFrame
            case .userTextFrame(let userTextFrame):
                return userTextFrame
            case .languageFrame(let languageFrame):
                return languageFrame
            case .creditsListFrame(let creditsListFrame):
                return creditsListFrame
            case .integerFrame(let integerFrame):
                return integerFrame
            case .dateFrame(let dateFrame):
                return dateFrame
            case .booleanFrame(let booleanFrame):
                return booleanFrame
            case .presetOptionsFrame(let presetOptionsFrame):
                return presetOptionsFrame
            case .urlFrame(let urlFrame):
                return urlFrame
            case .tocFrame(let tocFrame):
                return tocFrame
            case .chapterFrame(let chapterFrame):
                return chapterFrame
            case .unknownFrame(let unknownFrame):
                return unknownFrame
            case .imageFrame(let imageFrame):
                return imageFrame
        }
    }
}
