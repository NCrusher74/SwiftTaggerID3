/*

 FrameLayoutIdentifier.swift
 SwiftTaggerID3

 Copyright ©2020 Nolaine Crusher. All rights reserved.

 */

import Foundation

/** `FrameLayoutIdentifier` describes how SwiftTagger refers to the frame type internally.
 All information for handling a frame are determined by its `FrameLayoutIdentifier` */
enum FrameLayoutIdentifier: Hashable {
    /// a frame with an identifier recognized and handled by SwiftTagger
    case known(KnownFrameLayoutIdentifier)
    /// a frame with an unknown or unhandled identifier
    case unknown(String)
    
    /// Initialize the `FrameLayoutIdentifier`
    /// - Parameter identifier: the unique ID3 identifier string
    init(identifier: String) {
        if let known = KnownFrameLayoutIdentifier(identifier: identifier) {
            self = .known(known)
        } else {
            self = .unknown(identifier)
        }
    }
    
    /// Retrieve a frame's ID3 identifier string
    /// - Parameter version: The tag's ID3 `Version`. Different versions may have different identifiers
    /// - Returns: The ID3 identifier string appropriate for the version
    func id3Identifier(version: Version) -> String? {
        switch self {
            case .known(let known):
                return known.id3Identifier(version: version)
            case .unknown(let identifier):
                return identifier
        }
    }
    
    func frameKey(additionalIdentifier: String?) -> FrameKey {
        switch self {
            case .known(let known):
                return known.frameKey(additionalIdentifier: additionalIdentifier)
            case .unknown(let uuid):
                return .unknown(uuid: UUID(uuidString: uuid) ?? UUID())
        }
    }
}

/** An enumeration of ID3 standard--or iTunes compliant but non-standard--frames*/
enum KnownFrameLayoutIdentifier: CaseIterable {
    
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
    
    
    init?(identifier: String) {
        self = KnownFrameLayoutIdentifier.stringToLayoutMapping[identifier] ?? .userDefinedText
    }
         
    // MARK: ID3Identifier
    /** The ID3 code for the frame

        3 bytes for ID3v2.2
        4 bytes for ID3v2.3 and ID3v2.4
     
        If ID3 identfier is `nil` the frame will be handled as a TXX/TXXX frame, unless it's a frame associated with date handling, in which case it will be handled depending on version. Musician Credits for ID3v2.2 and ID3v2.3 will be handled as InvolvedPeople
     */
    /// - Parameter version: The ID3 `Version` of the tag
    /// - Returns: A string of the ID3 identifier appropriate for the version
    func id3Identifier(version: Version) -> String? {
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
                    case .v2_2, .v2_3: return nil
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
                    case .v2_2: return "TWN"
                    case .v2_3, .v2_4: return "TOWN"
            }
            case .genre:
                switch version {
                    case .v2_2: return "TCO"
                    case .v2_3, .v2_4: return "TCON"
            }
            case .grouping:
                switch version {
                    case .v2_2: return "GP1"
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
                    case .v2_2: return "TMO" // non-standard
                    case .v2_3, .v2_4: return "TMOO" // non-standard in version 2.3
            }
            case .movementCount:
                switch version {
                    case .v2_2: return "MVC"
                    case .v2_3, .v2_4: return "MVCN"
            }
            
            case .movementName:
                switch version {
                    case .v2_2: return "MVN"
                    case .v2_3, .v2_4: return "MVNM"
            }
            case .movementNumber:
                switch version {
                    case .v2_2: return "MVI"
                    case .v2_3, .v2_4: return "MVIN"
            }
            case .musicianCreditsList:
                switch version {
                    case .v2_2: return "TMC" // non-standard
                    case .v2_3, .v2_4: return "TMCL" // non-standard for version 2.3
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
                    case .v2_2: return "WPY" // non-standard
                    case .v2_3, .v2_4: return "WPAY"
            }
            case .playlistDelay:
                switch version {
                    case .v2_2: return "TDY"
                    case .v2_3, .v2_4: return "TDLY"
            }
            case .podcastCategory:
                switch version {
                    case .v2_2: return "TCT"
                    case .v2_3, .v2_4: return "TCAT"
            }
            case .podcastDescription:
                switch version {
                    case .v2_2: return "TDS"
                    case .v2_3, .v2_4: return "TDES"
            }
            case .podcastID:
                switch version {
                    case .v2_2: return "TID"
                    case .v2_3, .v2_4: return "TGID"
            }
            case .podcastKeywords:
                switch version {
                    case .v2_2: return "TKW"
                    case .v2_3, .v2_4: return "TKWD"
            }
            case .podcastFeedLink:
                switch version {
                    case .v2_2: return "WFD"
                    case .v2_3, .v2_4: return "WFED"
            }
            case .producedNotice:
                switch version {
                    case .v2_2: return "TPR" // non-standard
                    case .v2_3, .v2_4: return "TPRO" // non-standard for version 2.3
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
                    case .v2_2, .v2_3: return nil
                    case .v2_4: return "TDRL"
            }
            case .setSubtitle:
                switch version {
                    case .v2_2: return "TTT" // non-standard
                    case .v2_3, .v2_4: return "TSST" // non-standard for version 2.3
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
                    case .v2_2, .v2_3: return nil
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
        }
    }
    
    func frameKey(additionalIdentifier: String?) -> FrameKey {
        switch self {
            case .album: return .album
            case .albumSort: return .albumSort
            case .albumArtist: return .albumArtist
            case .albumArtistSort: return .albumArtistSort
            case .arranger: return .arranger
            case .artist: return .artist
            case .artistSort: return .artistSort
            case .artistWebpage: return .artistWebpage
            case .attachedPicture: return .attachedPicture(description: additionalIdentifier ?? "Other")
            case .audioFileWebpage: return .audioFileWebpage
            case .audioSourceWebpage: return .audioSourceWebpage
            case .bpm: return .bpm
            case .chapter: return .chapter(byElementID: additionalIdentifier ?? UUID().uuidString)
            case .comments: return .comments(description: additionalIdentifier ?? "")
            case .compilation: return .compilation
            case .composer: return .composer
            case .composerSort: return .composerSort
            case .conductor: return .conductor
            case .contentGroup: return .contentGroup
            case .copyright: return .copyright
            case .copyrightWebpage: return .copyrightWebpage
            case .date: return .date
            case .discNumber: return .discNumber
            case .encodingTime: return .encodingTime
            case .encodedBy: return .encodedBy
            case .encodingSettings: return .encodingSettings
            case .fileType: return .fileType
            case .fileOwner: return .fileOwner
            case .genre: return .genre
            case .grouping: return .grouping
            case .initialKey: return .initialKey
            case .involvedPeopleList: return .involvedPeopleList
            case .isrc: return .isrc
            case .languages: return .languages
            case .length: return .length
            case .lyricist: return .lyricist
            case .mediaType: return .mediaType
            case .mood: return .mood
            case .movementCount: return .movementCount
            case .movementName: return .movementName
            case .movementNumber: return .movementNumber
            case .musicianCreditsList: return .musicianCreditsList
            case .originalAlbum: return .originalAlbum
            case .originalArtist: return .originalArtist
            case .originalFilename: return .originalFilename
            case .originalLyricist: return .originalLyricist
            case .originalReleaseTime: return .originalReleaseTime
            case .paymentWebpage: return .paymentWebpage
            case .playlistDelay: return .playlistDelay
            case .podcastCategory: return .podcastCategory
            case .podcastDescription: return .podcastDescription
            case .podcastID: return .podcastID
            case .podcastKeywords: return .podcastKeywords
            case .podcastFeedLink: return .podcastFeedLink
            case .producedNotice: return .producedNotice
            case .publisher: return .publisher
            case .publisherWebpage: return .publisherWebpage
            case .radioStation: return .radioStation
            case .radioStationOwner: return .radioStationOwner
            case .radioStationWebpage: return .radioStationWebpage
            case .recordingDate: return .recordingDate
            case .releaseTime: return .releaseTime
            case .setSubtitle: return .setSubtitle
            case .subtitle: return .subtitle
            case .tableOfContents: return .tableOfContents
            case .taggingTime: return .taggingTime
            case .time: return .time
            case .title: return .title
            case .titleSort: return .titleSort
            case .trackNumber: return .trackNumber
            case .unsynchronizedLyrics: return .unsynchronizedLyrics(description: additionalIdentifier ?? "")
            case .userDefinedText: return .userDefinedText(description: additionalIdentifier ?? "")
            case .userDefinedWebpage: return .userDefinedWebpage(description: additionalIdentifier ?? "")
            case .year: return .year
        }
    }
    
    private static let stringToLayoutMapping: [String: KnownFrameLayoutIdentifier] = {
        var mapping: [String: KnownFrameLayoutIdentifier] = [:]
        for layout in KnownFrameLayoutIdentifier.allCases {
            for version in Version.allCases {
                if let idString = layout.id3Identifier(version: version) {
                    mapping[idString] = layout
                }
            }
        }
        return mapping
    }()
}
