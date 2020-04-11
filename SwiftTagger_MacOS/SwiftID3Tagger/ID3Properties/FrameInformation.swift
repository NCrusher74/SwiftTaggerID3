//
//  FrameName.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/8/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

/** A type containing methods and variables for querying and handling information from a frame */
struct FrameInformation {
    
    var frameName: FrameName

    ///  - parameter frameName: an enum used to determine how a frame is handled
    init(frameName: FrameName) {
        self.frameName = frameName
    }
    
    // Checks if the frame as a Description field
    private var hasDescription: Bool {
        switch self.frameName {
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
        switch self.frameName {
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
        switch self.frameName {
            case .involvedPeopleList,
                 .musicianCreditsList:
                return true
            default: return false
        }
    }
    
    /** the key used to refer to a particular frame. Usually this is the rawValue of the `FrameName`, but in cases where a frame may be duplicated, will derive from information contained in the frame, such as a description field */
    public var frameKey: String {
        if self.hasDescription /* && count for that ID3 Frame return > 1 */ {
            return "\(self.frameName.rawValue): description" // placeholder
        } else if self.hasLanguage /* && count for that ID3 Frame return > 1 */ {
            return "Language += 1" // placeholder
        } else {
            return self.frameName.rawValue
        }
    }
    
    // MARK: Frame Type
    /* Determines the way the data in the frame will be presented from the API.
     In some cases, this means a frame containing a string with specific data, such as integers or integer arrays, will be converted from a string to an integer/array */
    public var frameType: FrameType {
        switch self.frameName {
            
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
        }
    }
    
    // MARK: Parser Type
    /* Determines the parser used to parse the frame data */
    internal var parserType: ParserType {
        switch self.frameName {
            
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
        }
    }
    
    // MARK: ID3Identifier
    // The ID3 code for the frame
    // 3 bytes for ID3v2.2
    // 4 bytes for ID3v2.3 and ID3v2.4
    /* If ID3 identfier is `nil` the frame will be handled as a TXX/TXXX frame, unless it's a frame associated with date handling, in which case it will be handled depending on version. Musician Credits for ID3v2.2 and ID3v2.3 will be handled as InvolvedPeople */
    public func id3Identifier(version: Version) -> String? {
        switch self.frameName {
            
            case .album:
                switch version {
                    case .v2_2: return "TAL"
                    case .v2_3: return "TALB"
                    case .v2_4: return "TALB"
            }
            case .albumSort:
                switch version {
                    case .v2_2: return "TSA"
                    case .v2_3: return "TSOA"
                    case .v2_4: return "TSOA"
            }
            case .albumArtist:
                switch version {
                    case .v2_2: return "TP2"
                    case .v2_3: return "TPE2"
                    case .v2_4: return "TPE2"
            }
            case .albumArtistSort:
                switch version {
                    case .v2_2: return "TS2"
                    case .v2_3: return "TSO2"
                    case .v2_4: return "TSO2"
            }
            case .arranger:
                switch version {
                    case .v2_2: return "TP4"
                    case .v2_3: return "TPE4"
                    case .v2_4: return "TPE4"
            }
            case .artist:
                switch version {
                    case .v2_2: return "TP1"
                    case .v2_3: return "TPE1"
                    case .v2_4: return "TPE1"
            }
            case .artistSort:
                switch version {
                    case .v2_2: return "TSP"
                    case .v2_3: return "TSOP"
                    case .v2_4: return "TSOP"
            }
            case .artistWebpage:
                switch version {
                    case .v2_2: return "WAR"
                    case .v2_3: return "WOAR"
                    case .v2_4: return "WOAR"
            }
            case .attachedPicture:
                switch version {
                    case .v2_2: return "PIC"
                    case .v2_3: return "APIC"
                    case .v2_4: return "APIC"
            }
            case .audioFileWebpage:
                switch version {
                    case .v2_2: return "WAF"
                    case .v2_3: return "WOAF"
                    case .v2_4: return "WOAF"
            }
            case .audioSourceWebpage:
                switch version {
                    case .v2_2: return "WAS"
                    case .v2_3: return "WOAS"
                    case .v2_4: return "WOAS"
            }
            case .bpm:
                switch version {
                    case .v2_2: return "TBP"
                    case .v2_3: return "TBPM"
                    case .v2_4: return "TBPM"
            }
            case .chapter:
                switch version {
                    case .v2_2: return nil
                    case .v2_3: return "CHAP"
                    case .v2_4: return "CHAP"
            }
            case .comments:
                switch version {
                    case .v2_2: return "COM"
                    case .v2_3: return "COMM"
                    case .v2_4: return "COMM"
            }
            case .compilation:
                switch version {
                    case .v2_2: return "TCP"
                    case .v2_3: return "TCMP"
                    case .v2_4: return "TCMP"
            }
            case .composer:
                switch version {
                    case .v2_2: return "TCM"
                    case .v2_3: return "TCOM"
                    case .v2_4: return "TCOM"
            }
            case .composerSort:
                switch version {
                    case .v2_2: return "TSC"
                    case .v2_3: return "TSOC"
                    case .v2_4: return "TSOC"
            }
            case .conductor:
                switch version {
                    case .v2_2: return "TP3"
                    case .v2_3: return "TPE3"
                    case .v2_4: return "TPE3"
            }
            case .contentGroup:
                switch version {
                    case .v2_2: return "TT1"
                    case .v2_3: return "TIT1"
                    case .v2_4: return "TIT1"
            }
            case .copyright:
                switch version {
                    case .v2_2: return "TCR"
                    case .v2_3: return "TCOP"
                    case .v2_4: return "TCOP"
            }
            case .copyrightWebpage:
                switch version {
                    case .v2_2: return "WCP"
                    case .v2_3: return "WCOP"
                    case .v2_4: return "WCOP"
            }
            case .date:
                switch version {
                    case .v2_2: return "TDA"
                    case .v2_3: return "TDAT"
                    case .v2_4: return nil
            }
            case .discNumber:
                switch version {
                    case .v2_2: return "TPA"
                    case .v2_3: return "TPOS"
                    case .v2_4: return "TPOS"
            }
            case .encodingTime:
                switch version {
                    case .v2_2: return nil
                    case .v2_3: return nil
                    case .v2_4: return "TDEN"
            }
            case .encodedBy:
                switch version {
                    case .v2_2: return "TEN"
                    case .v2_3: return "TENC"
                    case .v2_4: return "TENC"
            }
            case .encodingSettings:
                switch version {
                    case .v2_2: return "TSS"
                    case .v2_3: return "TSSE"
                    case .v2_4: return "TSSE"
            }
            case .fileType:
                switch version {
                    case .v2_2: return "TFT"
                    case .v2_3: return "TFLT"
                    case .v2_4: return "TFLT"
            }
            case .fileOwner:
                switch version {
                    case .v2_2: return nil
                    case .v2_3: return "TOWN"
                    case .v2_4: return "TOWN"
            }
            case .genre:
                switch version {
                    case .v2_2: return "TCO"
                    case .v2_3: return "TCON"
                    case .v2_4: return "TCON"
            }
            case .grouping:
                switch version {
                    case .v2_2: return nil
                    case .v2_3: return "GRP1"
                    case .v2_4: return "GRP1"
            }
            case .initialKey:
                switch version {
                    case .v2_2: return "TKE"
                    case .v2_3: return "TKEY"
                    case .v2_4: return "TKEY"
            }
            case .involvedPeopleList:
                switch version {
                    case .v2_2: return "IPL"
                    case .v2_3: return "IPLS"
                    case .v2_4: return "TIPL"
            }
            case .isrc:
                switch version {
                    case .v2_2: return "TRC"
                    case .v2_3: return "TSRC"
                    case .v2_4: return "TSRC"
            }
            case .languages:
                switch version {
                    case .v2_2: return "TLA"
                    case .v2_3: return "TLAN"
                    case .v2_4: return "TLAN"
            }
            case .length:
                switch version {
                    case .v2_2: return "TLE"
                    case .v2_3: return "TLEN"
                    case .v2_4: return "TLEN"
            }
            case .lyricist:
                switch version {
                    case .v2_2: return "TXT"
                    case .v2_3: return "TEXT"
                    case .v2_4: return "TEXT"
            }
            case .mediaType:
                switch version {
                    case .v2_2: return "TMT"
                    case .v2_3: return "TMED"
                    case .v2_4: return "TMED"
            }
            case .mood:
                switch version {
                    case .v2_2: return nil
                    case .v2_3: return nil
                    case .v2_4: return "TMOO"
            }
            case .movementCount:
                switch version {
                    case .v2_2: return nil
                    case .v2_3: return "MVCN"
                    case .v2_4: return "MVCN"
            }
            
            case .movementName:
                switch version {
                    case .v2_2: return nil
                    case .v2_3: return "MVNM"
                    case .v2_4: return "MVNM"
            }
            case .movementNumber:
                switch version {
                    case .v2_2: return nil
                    case .v2_3: return "MVIN"
                    case .v2_4: return "MVIN"
            }
            case .musicianCreditsList:
                switch version {
                    case .v2_2: return nil
                    case .v2_3: return nil
                    case .v2_4: return "TMCL"
            }
            case .originalAlbum:
                switch version {
                    case .v2_2: return "TOT"
                    case .v2_3: return "TOAL"
                    case .v2_4: return "TOAL"
            }
            case .originalArtist:
                switch version {
                    case .v2_2: return "TOP"
                    case .v2_3: return "TOPE"
                    case .v2_4: return "TOPE"
            }
            case .originalFilename:
                switch version {
                    case .v2_2: return "TOF"
                    case .v2_3: return "TOFN"
                    case .v2_4: return "TOFN"
            }
            case .originalLyricist:
                switch version {
                    case .v2_2: return "TOL"
                    case .v2_3: return "TOLY"
                    case .v2_4: return "TOLY"
            }
            case .originalReleaseTime:
                switch version {
                    case .v2_2: return "TOY"
                    case .v2_3: return "TORY"
                    case .v2_4: return "TDOR"
            }
            case .paymentWebpage:
                switch version {
                    case .v2_2: return nil
                    case .v2_3: return "WPAY"
                    case .v2_4: return "WPAY"
            }
            case .playlistDelay:
                switch version {
                    case .v2_2: return "TDY"
                    case .v2_3: return "TDLY"
                    case .v2_4: return "TDLY"
            }
            case .podcastCategory:
                switch version {
                    case .v2_2: return nil
                    case .v2_3: return "TCAT"
                    case .v2_4: return "TCAT"
            }
            case .podcastDescription:
                switch version {
                    case .v2_2: return nil
                    case .v2_3: return "TDES"
                    case .v2_4: return "TDES"
            }
            case .podcastID:
                switch version {
                    case .v2_2: return nil
                    case .v2_3: return "TGID"
                    case .v2_4: return "TGID"
            }
            case .podcastKeywords:
                switch version {
                    case .v2_2: return nil
                    case .v2_3: return "TKWD"
                    case .v2_4: return "TKWD"
            }
            case .podcastFeedLink:
                switch version {
                    case .v2_2: return nil
                    case .v2_3: return "WFED"
                    case .v2_4: return "WFED"
            }
            case .producedNotice:
                switch version {
                    case .v2_2: return nil
                    case .v2_3: return nil
                    case .v2_4: return "TPRO"
            }
            case .publisher:
                switch version {
                    case .v2_2: return "TPB"
                    case .v2_3: return "TPUB"
                    case .v2_4: return "TPUB"
            }
            case .publisherWebpage:
                switch version {
                    case .v2_2: return "WPB"
                    case .v2_3: return "WPUB"
                    case .v2_4: return "WPUB"
            }
            case .radioStation:
                switch version {
                    case .v2_2: return "TRS"
                    case .v2_3: return "TRSN"
                    case .v2_4: return "TRSN"
            }
            case .radioStationOwner:
                switch version {
                    case .v2_2: return "TRO"
                    case .v2_3: return "TRSO"
                    case .v2_4: return "TRSO"
            }
            case .radioStationWebpage:
                switch version {
                    case .v2_2: return "WRS"
                    case .v2_3: return "WORS"
                    case .v2_4: return "WORS"
            }
            case .recordingDate:
                switch version {
                    case .v2_2: return "TRD"
                    case .v2_3: return "TRDA"
                    case .v2_4: return "TDRC"
            }
            case .releaseTime:
                switch version {
                    case .v2_2: return nil
                    case .v2_3: return nil
                    case .v2_4: return "TDRL"
            }
            case .setSubtitle:
                switch version {
                    case .v2_2: return nil
                    case .v2_3: return "TSST"
                    case .v2_4: return "TSST"
            }
            case .subtitle:
                switch version {
                    case .v2_2: return "TT3"
                    case .v2_3: return "TIT3"
                    case .v2_4: return "TIT3"
            }
            case .tableOfContents:
                switch version {
                    case .v2_2: return nil
                    case .v2_3: return "CTOC"
                    case .v2_4: return "CTOC"
            }
            case .taggingTime:
                switch version {
                    case .v2_2: return nil
                    case .v2_3: return nil
                    case .v2_4: return "TDTG"
            }
            case .time:
                switch version {
                    case .v2_2: return "TIM"
                    case .v2_3: return "TIME"
                    case .v2_4: return nil
            }
            case .title:
                switch version {
                    case .v2_2: return "TT2"
                    case .v2_3: return "TIT2"
                    case .v2_4: return "TIT2"
            }
            case .titleSort:
                switch version {
                    case .v2_2: return "TST"
                    case .v2_3: return "TSOT"
                    case .v2_4: return "TSOT"
            }
            case .trackNumber:
                switch version {
                    case .v2_2: return "TRK"
                    case .v2_3: return "TRCK"
                    case .v2_4: return "TRCK"
            }
            case .unsynchronizedLyrics:
                switch version {
                    case .v2_2: return "ULT"
                    case .v2_3: return "USLT"
                    case .v2_4: return "USLT"
            }
            case .userDefinedText:
                switch version {
                    case .v2_2: return "TXX"
                    case .v2_3: return "TXXX"
                    case .v2_4: return "TXXX"
            }
            case .userDefinedWebpage:
                switch version {
                    case .v2_2: return "WXX"
                    case .v2_3: return "WXXX"
                    case .v2_4: return "WXXX"
            }
            case .year:
                switch version {
                    case .v2_2: return "TYE"
                    case .v2_3: return "TYER"
                    case .v2_4: return nil
            }
        }
    }
    
}
