//
//  FrameLayoutIdentifier.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/8/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

/** `FrameLayoutIdentifier` describes how SwiftTagger refers to the frame type internally.
 All information for handling a frame, such as ParserType and FrameType, are determined by `FrameLayoutIdentifier` */
internal enum FrameLayoutIdentifier {
    
    case album
    case albumSort
    case albumArtist
    case albumArtistSort
    case arranger
    case artist
    case artistSort
    case artistWebpage
    case attachedPicture
    case audioFileWebpage
    case audioSourceWebpage
    case bpm
    case chapter
    case comments
    case compilation
    case composer
    case composerSort
    case conductor
    case contentGroup
    case copyright
    case copyrightWebpage
    case date
    case discNumber
    case encodingTime
    case encodedBy
    case encodingSettings
    case fileType
    case fileOwner
    case genre
    case grouping
    case initialKey
    case involvedPeopleList
    case isrc
    case languages
    case length
    case lyricist
    case mediaType
    case mood
    case movementCount
    case movementName
    case movementNumber
    case musicianCreditsList
    case originalAlbum
    case originalArtist
    case originalFilename
    case originalLyricist
    case originalReleaseTime
    case paymentWebpage
    case playlistDelay
    case podcastCategory
    case podcastDescription
    case podcastID
    case podcastKeywords
    case podcastFeedLink
    case producedNotice
    case publisher
    case publisherWebpage
    case radioStation
    case radioStationOwner
    case radioStationWebpage
    case recordingDate
    case releaseTime
    case setSubtitle
    case subtitle
    case tableOfContents
    case taggingTime
    case time
    case title
    case titleSort
    case trackNumber
    case unsynchronizedLyrics
    case userDefinedText
    case userDefinedWebpage
    case year
    case unknown(name: String)

    /** Uses the identifier string parsed out of a frame to initialize the `FrameLayoutIdentifier`*/
    internal init(identifier: String) {
        if identifier == "TAL" || identifier == "TALB" {
            self = .album
        }
        if identifier == "TSA" || identifier == "TSOA" {
            self = .albumSort
        }
        if identifier == "TP2" || identifier == "TPE2" {
            self = .albumArtist
        }
        if identifier == "TS2" || identifier == "TSO2" {
            self = .albumArtistSort
        }
        if identifier == "TP4" || identifier == "TPE4" {
            self = .arranger
        }
        if identifier == "TP1" || identifier == "TPE1" {
            self = .artist
        }
        if identifier == "TSP" || identifier == "TSOP" {
            self = .artistSort
        }
        if identifier == "WAR" || identifier == "WOAR" {
            self = .artistWebpage
        }
        if identifier == "PIC" || identifier == "APIC" {
            self = .attachedPicture
        }
        if identifier == "WAF" || identifier == "WOAF" {
            self = .audioFileWebpage
        }
        if identifier == "WAS" || identifier == "WOAS" {
            self = .audioSourceWebpage
        }
        if identifier == "TBP" || identifier == "TBPM" {
            self = .bpm
        }
        if identifier == "CHAP" {
            self = .chapter
        }
        if identifier == "COM" || identifier == "COMMENTS" {
            self = .comments
        }
        if identifier == "TCP" || identifier == "TCMP" {
            self = .compilation
        }
        if identifier == "TCM" || identifier == "TCOM" {
            self = .composer
        }
        if identifier == "TSC" || identifier == "TSOC" {
            self = .composerSort
        }
        if identifier == "TP3" || identifier == "TPE3" {
            self = .conductor
        }
        if identifier == "TT1" || identifier == "TIT1" {
            self = .contentGroup
        }
        if identifier == "TCR" || identifier == "TCOP" {
            self = .copyright
        }
        if identifier == "WCP" || identifier == "WCOP" {
            self = .copyrightWebpage
        }
        if identifier == "TDA" || identifier == "TDAT" {
            self = .date
        }
        if identifier == "TPA" || identifier == "TPOS" {
            self = .discNumber
        }
        if identifier == "TEN" || identifier == "TENC" {
            self = .encodedBy
        }
        if identifier == "TSS" || identifier == "TSSE" {
            self = .encodingSettings
        }
        if identifier == "TDEN" {
            self = .encodingTime
        }
        if identifier == "TOWN" {
            self = .fileOwner
        }
        if identifier == "TFT" || identifier == "TFLT" {
            self = .fileType
        }
        if identifier == "TCO" || identifier == "TCON" {
            self = .genre
        }
        if identifier == "GRP1" {
            self = .grouping
        }
        if identifier == "TKE" || identifier == "TKEY" {
            self = .initialKey
        }
        if identifier == "IPL" || identifier == "IPLS" || identifier == "TIPL" {
            self = .involvedPeopleList
        }
        if identifier == "TRC" || identifier == "TSRC" {
            self = .isrc
        }
        if identifier == "TLA" || identifier == "TLAN" {
            self = .languages
        }
        if identifier == "TLE" || identifier == "TLEN" {
            self = .length
        }
        if identifier == "TXT" || identifier == "TEXT" {
            self = .lyricist
        }
        if identifier == "TMT" || identifier == "TMED" {
            self = .mediaType
        }
        if identifier == "TMOO" {
            self = .mood
        }
        if identifier == "MVCN" {
            self = .movementCount
        }
        if identifier == "MVNM" {
            self = .movementName
        }
        if identifier == "MVIN" {
            self = .movementNumber
        }
        if identifier == "TMCL" {
            self = .musicianCreditsList
        }
        if identifier == "TOT" || identifier == "TOAL" {
            self = .originalAlbum
        }
        if identifier == "TOP" || identifier == "TOPE" {
            self = .originalArtist
        }
        if identifier == "TOF" || identifier == "TPFN" {
            self = .originalFilename
        }
        if identifier == "TOL" || identifier == "TOLY" {
            self = .originalLyricist
        }
        if identifier == "TOY" || identifier == "TORY" || identifier == "TDOR" {
            self = .originalReleaseTime
        }
        if identifier == "WPAY" {
            self = .paymentWebpage
        }
        if identifier == "TDY" || identifier == "TDLY" {
            self = .playlistDelay
        }
        if identifier == "TGID" {
            self = .podcastID
        }
        if identifier == "TCAT" {
            self = .podcastCategory
        }
        if identifier == "TDES" {
            self = .podcastDescription
        }
        if identifier == "TKWD" {
            self = .podcastKeywords
        }
        if identifier == "WFED" {
            self = .podcastFeedLink
        }
        if identifier == "TPRO" {
            self = .producedNotice
        }
        if identifier == "TPB" || identifier == "TPUB" {
            self = .publisher
        }
        if identifier == "WPB" || identifier == "WPUB" {
            self = .publisherWebpage
        }
        if identifier == "TRS" || identifier == "TRSN" {
            self = .radioStation
        }
        if identifier == "TRO" || identifier == "TRSO" {
            self = .radioStationOwner
        }
        if identifier == "WRS" || identifier == "WORS" {
            self = .radioStationWebpage
        }
        if identifier == "TRD" || identifier == "TRDA" || identifier == "TDRC" {
            self = .recordingDate
        }
        if identifier == "TDRL" {
            self = .releaseTime
        }
        if identifier == "TSST" {
            self = .setSubtitle
        }
        if identifier == "TT3" || identifier == "TIT3" {
            self = .subtitle
        }
        if identifier == "CTOC" {
            self = .tableOfContents
        }
        if identifier == "TDTG" {
            self = .taggingTime
        }
        if identifier == "TIM" || identifier == "TIME" {
            self = .time
        }
        if identifier == "TT2" || identifier == "TIT2" {
            self = .title
        }
        if identifier == "TST" || identifier == "TSOT" {
            self = .titleSort
        }
        if identifier == "TRK" || identifier == "TRCK" {
            self = .trackNumber
        }
        if identifier == "ULT" || identifier == "USLT" {
            self = .unsynchronizedLyrics
        }
        if identifier == "TXX" || identifier == "TXXX" {
            self = .userDefinedText
        }
        if identifier == "WXX" || identifier == "WXXX" {
            self = .userDefinedWebpage
        }
        if identifier == "TYE" || identifier == "TYER" {
            self = .year
        } else {
            self = .userDefinedText
        }
    }
    
    // Checks if the frame as a Description field
    private var hasDescription: Bool {
        switch self {
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
        switch self {
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
        switch self {
            case .involvedPeopleList,
                 .musicianCreditsList:
                return true
            default: return false
        }
    }
    
    // MARK: ID3Identifier
    // The ID3 code for the frame
    // 3 bytes for ID3v2.2
    // 4 bytes for ID3v2.3 and ID3v2.4
    /* If ID3 identfier is `nil` the frame will be handled as a TXX/TXXX frame, unless it's a frame associated with date handling, in which case it will be handled depending on version. Musician Credits for ID3v2.2 and ID3v2.3 will be handled as InvolvedPeople */
    internal func id3Identifier(version: Version) -> String? {
        switch self {
            
            case .album:
                switch version {
                    case .v2_2: return "TAL"
                    case .v2_3, .v2_4: return "TALB"
            }
            case .albumSort:
                switch version {
                    case .v2_2: return "TSA"
                    case .v2_3, .v2_4: return "TSOA"
            }
            case .albumArtist:
                switch version {
                    case .v2_2: return "TP2"
                    case .v2_3, .v2_4: return "TPE2"
            }
            case .albumArtistSort:
                switch version {
                    case .v2_2: return "TS2"
                    case .v2_3, .v2_4: return "TSO2"
            }
            case .arranger:
                switch version {
                    case .v2_2: return "TP4"
                    case .v2_3, .v2_4: return "TPE4"
            }
            case .artist:
                switch version {
                    case .v2_2: return "TP1"
                    case .v2_3, .v2_4: return "TPE1"
            }
            case .artistSort:
                switch version {
                    case .v2_2: return "TSP"
                    case .v2_3, .v2_4: return "TSOP"
            }
            case .artistWebpage:
                switch version {
                    case .v2_2: return "WAR"
                    case .v2_3, .v2_4: return "WOAR"
            }
            case .attachedPicture:
                switch version {
                    case .v2_2: return "PIC"
                    case .v2_3, .v2_4: return "APIC"
            }
            case .audioFileWebpage:
                switch version {
                    case .v2_2: return "WAF"
                    case .v2_3, .v2_4: return "WOAF"
            }
            case .audioSourceWebpage:
                switch version {
                    case .v2_2: return "WAS"
                    case .v2_3, .v2_4: return "WOAS"
            }
            case .bpm:
                switch version {
                    case .v2_2: return "TBP"
                    case .v2_3, .v2_4: return "TBPM"
            }
            case .chapter:
                switch version {
                    case .v2_2: return nil
                    case .v2_3, .v2_4: return "CHAP"
            }
            case .comments:
                switch version {
                    case .v2_2: return "COM"
                    case .v2_3, .v2_4: return "COMM"
            }
            case .compilation:
                switch version {
                    case .v2_2: return "TCP"
                    case .v2_3, .v2_4: return "TCMP"
            }
            case .composer:
                switch version {
                    case .v2_2: return "TCM"
                    case .v2_3, .v2_4: return "TCOM"
            }
            case .composerSort:
                switch version {
                    case .v2_2: return "TSC"
                    case .v2_3, .v2_4: return "TSOC"
            }
            case .conductor:
                switch version {
                    case .v2_2: return "TP3"
                    case .v2_3, .v2_4: return "TPE3"
            }
            case .contentGroup:
                switch version {
                    case .v2_2: return "TT1"
                    case .v2_3, .v2_4: return "TIT1"
            }
            case .copyright:
                switch version {
                    case .v2_2: return "TCR"
                    case .v2_3, .v2_4: return "TCOP"
            }
            case .copyrightWebpage:
                switch version {
                    case .v2_2: return "WCP"
                    case .v2_3, .v2_4: return "WCOP"
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
                    case .v2_3, .v2_4: return "TPOS"
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
                    case .v2_3, .v2_4: return "TENC"
            }
            case .encodingSettings:
                switch version {
                    case .v2_2: return "TSS"
                    case .v2_3, .v2_4: return "TSSE"
            }
            case .fileType:
                switch version {
                    case .v2_2: return "TFT"
                    case .v2_3, .v2_4: return "TFLT"
            }
            case .fileOwner:
                switch version {
                    case .v2_2: return nil
                    case .v2_3, .v2_4: return "TOWN"
            }
            case .genre:
                switch version {
                    case .v2_2: return "TCO"
                    case .v2_3, .v2_4: return "TCON"
            }
            case .grouping:
                switch version {
                    case .v2_2: return nil
                    case .v2_3, .v2_4: return "GRP1"
            }
            case .initialKey:
                switch version {
                    case .v2_2: return "TKE"
                    case .v2_3, .v2_4: return "TKEY"
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
                    case .v2_3, .v2_4: return "TSRC"
            }
            case .languages:
                switch version {
                    case .v2_2: return "TLA"
                    case .v2_3, .v2_4: return "TLAN"
            }
            case .length:
                switch version {
                    case .v2_2: return "TLE"
                    case .v2_3, .v2_4: return "TLEN"
            }
            case .lyricist:
                switch version {
                    case .v2_2: return "TXT"
                    case .v2_3, .v2_4: return "TEXT"
            }
            case .mediaType:
                switch version {
                    case .v2_2: return "TMT"
                    case .v2_3, .v2_4: return "TMED"
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
                    case .v2_3, .v2_4: return "MVCN"
            }
            
            case .movementName:
                switch version {
                    case .v2_2: return nil
                    case .v2_3, .v2_4: return "MVNM"
            }
            case .movementNumber:
                switch version {
                    case .v2_2: return nil
                    case .v2_3, .v2_4: return "MVIN"
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
                    case .v2_3, .v2_4: return "TOAL"
            }
            case .originalArtist:
                switch version {
                    case .v2_2: return "TOP"
                    case .v2_3, .v2_4: return "TOPE"
            }
            case .originalFilename:
                switch version {
                    case .v2_2: return "TOF"
                    case .v2_3, .v2_4: return "TOFN"
            }
            case .originalLyricist:
                switch version {
                    case .v2_2: return "TOL"
                    case .v2_3, .v2_4: return "TOLY"
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
                    case .v2_3, .v2_4: return "WPAY"
            }
            case .playlistDelay:
                switch version {
                    case .v2_2: return "TDY"
                    case .v2_3, .v2_4: return "TDLY"
            }
            case .podcastCategory:
                switch version {
                    case .v2_2: return nil
                    case .v2_3, .v2_4: return "TCAT"
            }
            case .podcastDescription:
                switch version {
                    case .v2_2: return nil
                    case .v2_3, .v2_4: return "TDES"
            }
            case .podcastID:
                switch version {
                    case .v2_2: return nil
                    case .v2_3, .v2_4: return "TGID"
            }
            case .podcastKeywords:
                switch version {
                    case .v2_2: return nil
                    case .v2_3, .v2_4: return "TKWD"
            }
            case .podcastFeedLink:
                switch version {
                    case .v2_2: return nil
                    case .v2_3, .v2_4: return "WFED"
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
                    case .v2_3, .v2_4: return "TPUB"
            }
            case .publisherWebpage:
                switch version {
                    case .v2_2: return "WPB"
                    case .v2_3, .v2_4: return "WPUB"
            }
            case .radioStation:
                switch version {
                    case .v2_2: return "TRS"
                    case .v2_3, .v2_4: return "TRSN"
            }
            case .radioStationOwner:
                switch version {
                    case .v2_2: return "TRO"
                    case .v2_3, .v2_4: return "TRSO"
            }
            case .radioStationWebpage:
                switch version {
                    case .v2_2: return "WRS"
                    case .v2_3, .v2_4: return "WORS"
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
                    case .v2_3, .v2_4: return "TSST"
            }
            case .subtitle:
                switch version {
                    case .v2_2: return "TT3"
                    case .v2_3, .v2_4: return "TIT3"
            }
            case .tableOfContents:
                switch version {
                    case .v2_2: return nil
                    case .v2_3, .v2_4: return "CTOC"
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
                    case .v2_3, .v2_4: return "TIT2"
            }
            case .titleSort:
                switch version {
                    case .v2_2: return "TST"
                    case .v2_3, .v2_4: return "TSOT"
            }
            case .trackNumber:
                switch version {
                    case .v2_2: return "TRK"
                    case .v2_3, .v2_4: return "TRCK"
            }
            case .unsynchronizedLyrics:
                switch version {
                    case .v2_2: return "ULT"
                    case .v2_3, .v2_4: return "USLT"
            }
            case .userDefinedText:
                switch version {
                    case .v2_2: return "TXX"
                    case .v2_3, .v2_4: return "TXXX"
            }
            case .userDefinedWebpage:
                switch version {
                    case .v2_2: return "WXX"
                    case .v2_3, .v2_4: return "WXXX"
            }
            case .year:
                switch version {
                    case .v2_2: return "TYE"
                    case .v2_3: return "TYER"
                    case .v2_4: return nil
            }
            case .unknown(name: _):
                switch version {
                    case .v2_2: return "TXX"
                    case .v2_3, .v2_4: return "TXXX"
            }
        }
    }
}
