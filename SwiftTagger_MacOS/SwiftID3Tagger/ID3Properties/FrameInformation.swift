//
//  FrameLayoutIdentifier.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/8/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

/** A type containing methods and variables for querying and handling information from a frame */
struct FrameInformation {
    
    var frameLayoutIdentifier: FrameLayoutIdentifier

    ///  - parameter frameLayoutIdentifier: an enum used to determine how a frame is handled
    init(frameLayoutIdentifier: FrameLayoutIdentifier) {
        self.frameLayoutIdentifier = frameLayoutIdentifier
    }
    
    // Checks if the frame as a Description field
    private var hasDescription: Bool {
        switch self.frameLayoutIdentifier {
            case .comments,
                 .unsynchronizedLyrics,
                 .userDefinedText,
                 .userDefinedWebpage:
                return true
            default: return false
        }
    }
    
    // Checks if the frame has a Language field
    private var hasLanguage: Bool {
        switch self.frameLayoutIdentifier {
            case .comments,
                 .languages,
                 .unsynchronizedLyrics,
                 .userDefinedText,
                 .userDefinedWebpage:
                return true
            default: return false
        }
    }
    
    // Checks if the frame is a CreditsList type
    private var hasCreditRole: Bool {
        switch self.frameLayoutIdentifier {
            case .involvedPeopleList,
                 .musicianCreditsList:
                return true
            default: return false
        }
    }
    
    // MARK: Frame Type
    /* Determines the way the data in the frame will be presented from the API.
     In some cases, this means a frame containing a string with specific data, such as integers or integer arrays, will be converted from a string to an integer/array */
    public var frameType: FrameType {
        switch self.frameLayoutIdentifier {
            
            case .album: return FrameType.stringFrame
            case .albumSort: return FrameType.stringFrame
            case .albumArtist: return FrameType.stringFrame
            case .albumArtistSort: return FrameType.stringFrame
            case .arranger: return FrameType.stringFrame
            case .artist: return FrameType.stringFrame
            case .artistSort: return FrameType.stringFrame
            case .artistWebpage: return FrameType.urlFrame
            case .attachedPicture: return FrameType.imageFrame
            case .audioFileWebpage: return FrameType.urlFrame
            case .audioSourceWebpage: return FrameType.urlFrame
            case .bpm: return FrameType.integerFrame
            case .chapter: return FrameType.chapterFrame
            case .comments: return FrameType.stringArrayFrame
            case .compilation: return FrameType.boolFrame
            case .composer: return FrameType.stringFrame
            case .composerSort: return FrameType.stringFrame
            case .conductor: return FrameType.stringFrame
            case .contentGroup: return FrameType.stringFrame
            case .copyright: return FrameType.stringFrame
            case .copyrightWebpage: return FrameType.urlFrame
            case .date: return FrameType.dateFrame
            case .discNumber: return FrameType.integerArrayFrame
            case .encodingTime: return FrameType.integerArrayFrame
            case .encodedBy: return FrameType.stringFrame
            case .encodingSettings: return FrameType.stringFrame
            case .fileType: return FrameType.stringFrame
            case .fileOwner: return FrameType.stringFrame
            case .genre: return FrameType.genreFrame
            case .grouping: return FrameType.stringFrame
            case .initialKey: return FrameType.stringFrame
            case .involvedPeopleList: return FrameType.tupleArrayFrame
            case .isrc: return FrameType.integerFrame
            case .languages: return FrameType.stringArrayFrame
            case .length: return FrameType.integerFrame
            case .lyricist: return FrameType.stringFrame
            case .mediaType: return FrameType.stringFrame
            case .mood: return FrameType.stringFrame
            case .movementCount: return FrameType.integerFrame
            case .movementName: return FrameType.stringFrame
            case .movementNumber: return FrameType.integerFrame
            case .musicianCreditsList: return FrameType.tupleArrayFrame
            case .originalAlbum: return FrameType.stringFrame
            case .originalArtist: return FrameType.stringFrame
            case .originalFilename: return FrameType.stringFrame
            case .originalLyricist: return FrameType.stringFrame
            case .originalReleaseTime: return FrameType.dateFrame
            case .paymentWebpage: return FrameType.urlFrame
            case .playlistDelay: return FrameType.integerFrame
            case .podcastCategory: return FrameType.stringFrame
            case .podcastDescription: return FrameType.stringFrame
            case .podcastID: return FrameType.stringFrame
            case .podcastKeywords: return FrameType.stringFrame
            case .podcastFeedLink: return FrameType.stringFrame
            case .producedNotice: return FrameType.stringFrame
            case .publisher: return FrameType.stringFrame
            case .publisherWebpage: return FrameType.urlFrame
            case .radioStation: return FrameType.stringFrame
            case .radioStationOwner: return FrameType.stringFrame
            case .radioStationWebpage: return FrameType.urlFrame
            case .recordingDate: return FrameType.dateFrame
            case .releaseTime: return FrameType.dateFrame
            case .setSubtitle: return FrameType.stringFrame
            case .subtitle: return FrameType.stringFrame
            case .tableOfContents: return FrameType.tocFrame
            case .taggingTime: return FrameType.dateFrame
            case .time: return FrameType.dateFrame
            case .title: return FrameType.stringFrame
            case .titleSort: return FrameType.stringFrame
            case .trackNumber: return FrameType.integerArrayFrame
            case .unsynchronizedLyrics: return FrameType.stringArrayFrame
            case .userDefinedText: return FrameType.stringArrayFrame
            case .userDefinedWebpage: return FrameType.urlFrame
            case .year: return FrameType.integerFrame
            case .unknown(name: _): return FrameType.stringArrayFrame
        }
    }
    
    // MARK: Parser Type
    /* Determines the parser used to parse the frame data */
    internal var parserType: ParserType {
        switch self.frameLayoutIdentifier {
            
            case .album: return ParserType.stringParser
            case .albumSort: return ParserType.stringParser
            case .albumArtist: return ParserType.stringParser
            case .albumArtistSort: return ParserType.stringParser
            case .arranger: return ParserType.stringParser
            case .artist: return ParserType.stringParser
            case .artistSort: return ParserType.stringParser
            case .artistWebpage: return ParserType.urlParser
            case .attachedPicture: return ParserType.imageParser
            case .audioFileWebpage: return ParserType.urlParser
            case .audioSourceWebpage: return ParserType.urlParser
            case .bpm: return ParserType.stringParser
            case .chapter: return ParserType.chapterParser
            case .comments: return ParserType.commentParser
            case .compilation: return ParserType.stringParser
            case .composer: return ParserType.stringParser
            case .composerSort: return ParserType.stringParser
            case .conductor: return ParserType.stringParser
            case .contentGroup: return ParserType.stringParser
            case .copyright: return ParserType.stringParser
            case .copyrightWebpage: return ParserType.urlParser
            case .date: return ParserType.dateParser
            case .discNumber: return ParserType.stringParser
            case .encodingTime: return ParserType.dateParser
            case .encodedBy: return ParserType.stringParser
            case .encodingSettings: return ParserType.stringParser
            case .fileType: return ParserType.stringParser
            case .fileOwner: return ParserType.stringParser
            case .genre: return ParserType.genreParser
            case .grouping: return ParserType.stringParser
            case .initialKey: return ParserType.stringParser
            case .involvedPeopleList: return ParserType.creditsParser
            case .isrc: return ParserType.stringParser
            case .languages: return ParserType.stringParser
            case .length: return ParserType.stringParser
            case .lyricist: return ParserType.stringParser
            case .mediaType: return ParserType.stringParser
            case .mood: return ParserType.stringParser
            case .movementCount: return ParserType.stringParser
            case .movementName: return ParserType.stringParser
            case .movementNumber: return ParserType.stringParser
            case .musicianCreditsList: return ParserType.creditsParser
            case .originalAlbum: return ParserType.stringParser
            case .originalArtist: return ParserType.stringParser
            case .originalFilename: return ParserType.stringParser
            case .originalLyricist: return ParserType.stringParser
            case .originalReleaseTime: return ParserType.dateParser
            case .paymentWebpage: return ParserType.urlParser
            case .playlistDelay: return ParserType.stringParser
            case .podcastCategory: return ParserType.stringParser
            case .podcastDescription: return ParserType.stringParser
            case .podcastID: return ParserType.stringParser
            case .podcastKeywords: return ParserType.stringParser
            case .podcastFeedLink: return ParserType.stringParser
            case .producedNotice: return ParserType.stringParser
            case .publisher: return ParserType.stringParser
            case .publisherWebpage: return ParserType.urlParser
            case .radioStation: return ParserType.stringParser
            case .radioStationOwner: return ParserType.stringParser
            case .radioStationWebpage: return ParserType.urlParser
            case .recordingDate: return ParserType.dateParser
            case .releaseTime: return ParserType.dateParser
            case .setSubtitle: return ParserType.stringParser
            case .subtitle: return ParserType.stringParser
            case .tableOfContents: return ParserType.tocParser
            case .taggingTime: return ParserType.dateParser
            case .time: return ParserType.dateParser
            case .title: return ParserType.stringParser
            case .titleSort: return ParserType.stringParser
            case .trackNumber: return ParserType.stringParser
            case .unsynchronizedLyrics: return ParserType.commentParser
            case .userDefinedText: return ParserType.userTextParser
            case .userDefinedWebpage: return ParserType.userTextParser
            case .year: return ParserType.dateParser
            case .unknown(name: _): return ParserType.userTextParser
        }
    }
}
