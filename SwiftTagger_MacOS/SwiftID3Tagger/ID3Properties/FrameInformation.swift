//
//  FrameName.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/8/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

struct FrameInformation {
    
    var frameName: FrameName
    
    init(frameName: FrameName) {
        self.frameName = frameName
    }
    
    // Checks if the frame as a Description field
    private var hasDescription: Bool {
        switch self.frameName {
            case .comments,
                 .genre,
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
    
    //
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
    /* Determines the way the data in the frame will be presented to the user.
     In some cases, this means a frame containing a string with specific data, such as integers or integer arrays, will be converted from a string to an integer/array */
    public var frameType: FrameType {
        switch self.frameName {
            
            case .album: return FrameType.string
            case .albumSort: return FrameType.string
            case .albumArtist: return FrameType.string
            case .albumArtistSort: return FrameType.string
            case .arranger: return FrameType.string
            case .artist: return FrameType.string
            case .artistSort: return FrameType.string
            case .artistWebpage: return FrameType.url
            case .attachedPicture: return FrameType.image
            case .audioFileWebpage: return FrameType.url
            case .audioSourceWebpage: return FrameType.url
            case .bpm: return FrameType.integer
            case .chapter: return FrameType.complex
            case .comments: return FrameType.stringArray
            case .compilation: return FrameType.bool
            case .composer: return FrameType.string
            case .composerSort: return FrameType.string
            case .conductor: return FrameType.string
            case .contentGroup: return FrameType.string
            case .copyright: return FrameType.string
            case .copyrightWebpage: return FrameType.url
            case .date: return FrameType.date
            case .discNumber: return FrameType.integerArray
            case .encodingTime: return FrameType.integerArray
            case .encodedBy: return FrameType.string
            case .encodingSettings: return FrameType.string
            case .fileType: return FrameType.string
            case .fileOwner: return FrameType.string
            case .genre: return FrameType.complex
            case .grouping: return FrameType.string
            case .initialKey: return FrameType.string
            case .involvedPeopleList: return FrameType.tupleArray
            case .isrc: return FrameType.integer
            case .languages: return FrameType.stringArray
            case .length: return FrameType.integer
            case .lyricist: return FrameType.string
            case .mediaType: return FrameType.string
            case .mood: return FrameType.string
            case .movementCount: return FrameType.integer
            case .movementName: return FrameType.string
            case .movementNumber: return FrameType.integer
            case .musicianCreditsList: return FrameType.tupleArray
            case .originalAlbum: return FrameType.string
            case .originalArtist: return FrameType.string
            case .originalFilename: return FrameType.string
            case .originalLyricist: return FrameType.string
            case .originalReleaseTime: return FrameType.date
            case .paymentWebpage: return FrameType.url
            case .playlistDelay: return FrameType.integer
            case .podcastCategory: return FrameType.string
            case .podcastDescription: return FrameType.string
            case .podcastID: return FrameType.string
            case .podcastKeywords: return FrameType.string
            case .podcastFeedLink: return FrameType.string
            case .producedNotice: return FrameType.string
            case .publisher: return FrameType.string
            case .publisherWebpage: return FrameType.url
            case .radioStation: return FrameType.string
            case .radioStationOwner: return FrameType.string
            case .radioStationWebpage: return FrameType.url
            case .recordingDate: return FrameType.date
            case .releaseTime: return FrameType.date
            case .setSubtitle: return FrameType.string
            case .subtitle: return FrameType.string
            case .tableOfContents: return FrameType.complex
            case .taggingTime: return FrameType.date
            case .time: return FrameType.date
            case .title: return FrameType.string
            case .titleSort: return FrameType.string
            case .trackNumber: return FrameType.integerArray
            case .unsynchronizedLyrics: return FrameType.stringArray
            case .userDefinedText: return FrameType.stringArray
            case .userDefinedWebpage: return FrameType.url
            case .year: return FrameType.integer
        }
    }
    
    // MARK: Parser Type
    /* Determines the method used to parse the frame data */
    public var parser: ParserType {
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
    public func id3identifier(version: ID3Version) -> String? {
        switch self.frameName {
            
            case .album:
                switch version {
                    case .version22: return "TAL"
                    case .version23: return "TALB"
                    case .version24: return "TALB"
            }
            case .albumSort:
                switch version {
                    case .version22: return "TSA"
                    case .version23: return "TSOA"
                    case .version24: return "TSOA"
            }
            case .albumArtist:
                switch version {
                    case .version22: return "TP2"
                    case .version23: return "TPE2"
                    case .version24: return "TPE2"
            }
            case .albumArtistSort:
                switch version {
                    case .version22: return "TS2"
                    case .version23: return "TSO2"
                    case .version24: return "TSO2"
            }
            case .arranger:
                switch version {
                    case .version22: return "TP4"
                    case .version23: return "TPE4"
                    case .version24: return "TPE4"
            }
            case .artist:
                switch version {
                    case .version22: return "TP1"
                    case .version23: return "TPE1"
                    case .version24: return "TPE1"
            }
            case .artistSort:
                switch version {
                    case .version22: return "TSP"
                    case .version23: return "TSOP"
                    case .version24: return "TSOP"
            }
            case .artistWebpage:
                switch version {
                    case .version22: return "WAR"
                    case .version23: return "WOAR"
                    case .version24: return "WOAR"
            }
            case .attachedPicture:
                switch version {
                    case .version22: return "PIC"
                    case .version23: return "APIC"
                    case .version24: return "APIC"
            }
            case .audioFileWebpage:
                switch version {
                    case .version22: return "WAF"
                    case .version23: return "WOAF"
                    case .version24: return "WOAF"
            }
            case .audioSourceWebpage:
                switch version {
                    case .version22: return "WAS"
                    case .version23: return "WOAS"
                    case .version24: return "WOAS"
            }
            case .bpm:
                switch version {
                    case .version22: return "TBP"
                    case .version23: return "TBPM"
                    case .version24: return "TBPM"
            }
            case .chapter:
                switch version {
                    case .version22: return nil
                    case .version23: return "CHAP"
                    case .version24: return "CHAP"
            }
            case .comments:
                switch version {
                    case .version22: return "COM"
                    case .version23: return "COMM"
                    case .version24: return "COMM"
            }
            case .compilation:
                switch version {
                    case .version22: return "TCP"
                    case .version23: return "TCMP"
                    case .version24: return "TCMP"
            }
            case .composer:
                switch version {
                    case .version22: return "TCM"
                    case .version23: return "TCOM"
                    case .version24: return "TCOM"
            }
            case .composerSort:
                switch version {
                    case .version22: return "TSC"
                    case .version23: return "TSOC"
                    case .version24: return "TSOC"
            }
            case .conductor:
                switch version {
                    case .version22: return "TP3"
                    case .version23: return "TPE3"
                    case .version24: return "TPE3"
            }
            case .contentGroup:
                switch version {
                    case .version22: return "TT1"
                    case .version23: return "TIT1"
                    case .version24: return "TIT1"
            }
            case .copyright:
                switch version {
                    case .version22: return "TCR"
                    case .version23: return "TCOP"
                    case .version24: return "TCOP"
            }
            case .copyrightWebpage:
                switch version {
                    case .version22: return "WCP"
                    case .version23: return "WCOP"
                    case .version24: return "WCOP"
            }
            case .date:
                switch version {
                    case .version22: return "TDA"
                    case .version23: return "TDAT"
                    case .version24: return "TDRC"
            }
            case .discNumber:
                switch version {
                    case .version22: return "TPA"
                    case .version23: return "TPOS"
                    case .version24: return "TPOS"
            }
            case .encodingTime:
                switch version {
                    case .version22: return nil
                    case .version23: return nil
                    case .version24: return "TDEN"
            }
            case .encodedBy:
                switch version {
                    case .version22: return "TEN"
                    case .version23: return "TENC"
                    case .version24: return "TENC"
            }
            case .encodingSettings:
                switch version {
                    case .version22: return "TSS"
                    case .version23: return "TSSE"
                    case .version24: return "TSSE"
            }
            case .fileType:
                switch version {
                    case .version22: return "TFT"
                    case .version23: return "TFLT"
                    case .version24: return "TFLT"
            }
            case .fileOwner:
                switch version {
                    case .version22: return nil
                    case .version23: return "TOWN"
                    case .version24: return "TOWN"
            }
            case .genre:
                switch version {
                    case .version22: return "TCO"
                    case .version23: return "TCON"
                    case .version24: return "TCON"
            }
            case .grouping:
                switch version {
                    case .version22: return nil
                    case .version23: return "GRP1"
                    case .version24: return "GRP1"
            }
            case .initialKey:
                switch version {
                    case .version22: return "TKE"
                    case .version23: return "TKEY"
                    case .version24: return "TKEY"
            }
            case .involvedPeopleList:
                switch version {
                    case .version22: return "IPL"
                    case .version23: return "IPLS"
                    case .version24: return "TIPL"
            }
            case .isrc:
                switch version {
                    case .version22: return "TRC"
                    case .version23: return "TSRC"
                    case .version24: return "TSRC"
            }
            case .languages:
                switch version {
                    case .version22: return "TLA"
                    case .version23: return "TLAN"
                    case .version24: return "TLAN"
            }
            case .length:
                switch version {
                    case .version22: return "TLE"
                    case .version23: return "TLEN"
                    case .version24: return "TLEN"
            }
            case .lyricist:
                switch version {
                    case .version22: return "TXT"
                    case .version23: return "TEXT"
                    case .version24: return "TEXT"
            }
            case .mediaType:
                switch version {
                    case .version22: return "TMT"
                    case .version23: return "TMED"
                    case .version24: return "TMED"
            }
            case .mood:
                switch version {
                    case .version22: return nil
                    case .version23: return nil
                    case .version24: return "TMOO"
            }
            case .movementCount:
                switch version {
                    case .version22: return nil
                    case .version23: return "MVCN"
                    case .version24: return "MVCN"
            }
            
            case .movementName:
                switch version {
                    case .version22: return nil
                    case .version23: return "MVNM"
                    case .version24: return "MVNM"
            }
            case .movementNumber:
                switch version {
                    case .version22: return nil
                    case .version23: return "MVIN"
                    case .version24: return "MVIN"
            }
            case .musicianCreditsList:
                switch version {
                    case .version22: return nil
                    case .version23: return nil
                    case .version24: return "TMCL"
            }
            case .originalAlbum:
                switch version {
                    case .version22: return "TOT"
                    case .version23: return "TOAL"
                    case .version24: return "TOAL"
            }
            case .originalArtist:
                switch version {
                    case .version22: return "TOP"
                    case .version23: return "TOPE"
                    case .version24: return "TOPE"
            }
            case .originalFilename:
                switch version {
                    case .version22: return "TOF"
                    case .version23: return "TOFN"
                    case .version24: return "TOFN"
            }
            case .originalLyricist:
                switch version {
                    case .version22: return "TOL"
                    case .version23: return "TOLY"
                    case .version24: return "TOLY"
            }
            case .originalReleaseTime:
                switch version {
                    case .version22: return "TOY"
                    case .version23: return "TORY"
                    case .version24: return "TDOR"
            }
            case .paymentWebpage:
                switch version {
                    case .version22: return nil
                    case .version23: return "WPAY"
                    case .version24: return "WPAY"
            }
            case .playlistDelay:
                switch version {
                    case .version22: return "TDY"
                    case .version23: return "TDLY"
                    case .version24: return "TDLY"
            }
            case .podcastCategory:
                switch version {
                    case .version22: return nil
                    case .version23: return "TCAT"
                    case .version24: return "TCAT"
            }
            case .podcastDescription:
                switch version {
                    case .version22: return nil
                    case .version23: return "TDES"
                    case .version24: return "TDES"
            }
            case .podcastID:
                switch version {
                    case .version22: return nil
                    case .version23: return "TGID"
                    case .version24: return "TGID"
            }
            case .podcastKeywords:
                switch version {
                    case .version22: return nil
                    case .version23: return "TKWD"
                    case .version24: return "TKWD"
            }
            case .podcastFeedLink:
                switch version {
                    case .version22: return nil
                    case .version23: return "WFED"
                    case .version24: return "WFED"
            }
            case .producedNotice:
                switch version {
                    case .version22: return nil
                    case .version23: return nil
                    case .version24: return "TPRO"
            }
            case .publisher:
                switch version {
                    case .version22: return "TPB"
                    case .version23: return "TPUB"
                    case .version24: return "TPUB"
            }
            case .publisherWebpage:
                switch version {
                    case .version22: return "WPB"
                    case .version23: return "WPUB"
                    case .version24: return "WPUB"
            }
            case .radioStation:
                switch version {
                    case .version22: return "TRS"
                    case .version23: return "TRSN"
                    case .version24: return "TRSN"
            }
            case .radioStationOwner:
                switch version {
                    case .version22: return "TRO"
                    case .version23: return "TRSO"
                    case .version24: return "TRSO"
            }
            case .radioStationWebpage:
                switch version {
                    case .version22: return "WRS"
                    case .version23: return "WORS"
                    case .version24: return "WORS"
            }
            case .recordingDate:
                switch version {
                    case .version22: return "TRD"
                    case .version23: return "TRDA"
                    case .version24: return nil
            }
            case .releaseTime:
                switch version {
                    case .version22: return nil
                    case .version23: return nil
                    case .version24: return "TDLR"
            }
            case .setSubtitle:
                switch version {
                    case .version22: return nil
                    case .version23: return "TSST"
                    case .version24: return "TSST"
            }
            case .subtitle:
                switch version {
                    case .version22: return "TT3"
                    case .version23: return "TIT3"
                    case .version24: return "TIT3"
            }
            case .tableOfContents:
                switch version {
                    case .version22: return nil
                    case .version23: return "CTOC"
                    case .version24: return "CTOC"
            }
            case .taggingTime:
                switch version {
                    case .version22: return nil
                    case .version23: return nil
                    case .version24: return "TDTG"
            }
            case .time:
                switch version {
                    case .version22: return "TIM"
                    case .version23: return "TIME"
                    case .version24: return nil
            }
            case .title:
                switch version {
                    case .version22: return "TT2"
                    case .version23: return "TIT2"
                    case .version24: return "TIT2"
            }
            case .titleSort:
                switch version {
                    case .version22: return "TST"
                    case .version23: return "TSOT"
                    case .version24: return "TSOT"
            }
            case .trackNumber:
                switch version {
                    case .version22: return "TRK"
                    case .version23: return "TRCK"
                    case .version24: return "TRCK"
            }
            case .unsynchronizedLyrics:
                switch version {
                    case .version22: return "ULT"
                    case .version23: return "USLT"
                    case .version24: return "USLT"
            }
            case .userDefinedText:
                switch version {
                    case .version22: return "TXX"
                    case .version23: return "TXXX"
                    case .version24: return "TXXX"
            }
            case .userDefinedWebpage:
                switch version {
                    case .version22: return "WXX"
                    case .version23: return "WXXX"
                    case .version24: return "WXXX"
            }
            case .year:
                switch version {
                    case .version22: return "TYE"
                    case .version23: return "TYER"
                    case .version24: return nil
            }
        }
    }
    

    
}
