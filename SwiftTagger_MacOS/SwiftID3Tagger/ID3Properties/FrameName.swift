//
//  FrameName.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/8/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

/** FrameName describes how SwiftTagger refers to the frame type internally. All information, such as ParserType, FrameType, the ID3FrameIdentifier, */
enum FrameName: String {
    
    case album = "Album"
    case albumSort = "SortAlbum"
    case albumArtist = "AlbumArtist"
    case albumArtistSort = "SortAlbumArtist"
    case arranger = "Arranger"
    case artist = "Artist"
    case artistSort = "SortArtist"
    case artistWebpage = "ArtistWebpage"
    case attachedPicture = "AttachedPicture"
    case audioFileWebpage = "AudioFileWebpage"
    case audioSourceWebpage = "AudioSourceWebpage"
    case bpm = "BPM"
    case chapter = "Chapter"
    case comments = "Comments"
    case compilation = "Compilation"
    case composer = "Composer"
    case composerSort = "SortComposer"
    case conductor = "Conductor"
    case contentGroup = "Work"
    case copyright = "Copyright"
    case copyrightWebpage = "CopyrightInfoWebpage"
    case date = "Date"
    case discNumber = "DiscNumberOfTotal"
    case encodingTime = "EncodingTime"
    case encodedBy = "encoded By"
    case encodingSettings = "EncoderSettings"
    case fileType = "FileType"
    case fileOwner = "FileOwner"
    case genre = "Genre"
    case grouping = "Grouping"
    case initialKey = "InitialKey"
    case involvedPeopleList = "InvolvedPeopleList"
    case isrc = "ISRC"
    case languages = "Language"
    case length = "Length"
    case lyricist = "Lyricist"
    case mediaType = "MediaType"
    case mood = "Mood"
    case movementCount = "MovementCount"
    case movementName = "MovementName"
    case movementNumber = "MovementNumber"
    case musicianCreditsList = "MusicianCreditsList"
    case originalAlbum = "OriginalAlbum"
    case originalArtist = "OriginalArtist"
    case originalFilename = "OriginalFilename"
    case originalLyricist = "OriginalLyricist"
    case originalReleaseTime = "OriginalReleaseTime"
    case paymentWebpage = "PaymentWebpage"
    case playlistDelay = "PlaylistDelay"
    case podcastCategory = "PodcastCategory"
    case podcastDescription = "PodcastDescription"
    case podcastID = "PodcastID"
    case podcastKeywords = "PodcastKeywords"
    case podcastFeedLink = "PodcastLink"
    case producedNotice = "ProducedNotice"
    case publisher = "Publisher"
    case publisherWebpage = "PublisherWebpage"
    case radioStation = "InternetRadioStationName"
    case radioStationOwner = "InternetRadioStationOwner"
    case radioStationWebpage = "InternetRadioStationWebpage"
    case recordingDate = "RecordingDate"
    case releaseTime = "ReleaseTime"
    case setSubtitle = "SetSubtitle"
    case subtitle = "Subtitle"
    case tableOfContents = "TableOfContents"
    case taggingTime = "TaggingTime"
    case time = "Time"
    case title = "Title"
    case titleSort = "SortTitle"
    case trackNumber = "TrackNumberOfTotal"
    case unsynchronizedLyrics = "UnsyncedLyrics"
    case userDefinedText = "UserDefinedTextInformation"
    case userDefinedWebpage = "UserDefinedWebpage"
    case year = "Year"

    init(identifier: String) {
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
}
