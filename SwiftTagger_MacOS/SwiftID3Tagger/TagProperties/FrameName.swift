//
//  FrameName.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/8/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

enum FrameName: String {
    
    case album = "Album"
    case albumSort = "Sort Album"
    case albumArtist = "Album Artist"
    case albumArtistSort = "Sort Album Artist"
    case arranger = "Arranger, or Remixer"
    case artist = "Artist"
    case artistSort = "Sort Artist"
    case artistWebpage = "Artist Webpage"
    case attachedPicture = "Attached Picture"
    case audioFileWebpage = "Audio File Webpage"
    case audioSourceWebpage = "Audio Source Webpage"
    case bpm = "BPM"
    case chapter = "CHAP"
    case comments = "Comments"
    case compilation = "Compilation"
    case composer = "Composer"
    case composerSort = "Sort Composer"
    case conductor = "Conductor"
    case contentGroup = "Work or Content Group"
    case copyright = "Copyright"
    case copyrightWebpage = "Copyright Info Webpage"
    case date = "Date"
    case discNumber = "Disc Number (of Total)"
    case encodingTime = "Encoding Time"
    case encodedBy = "encoded By"
    case encodingSettings = "Encoder Settings"
    case fileType = "File Type"
    case fileOwner = "File Owner"
    case genre = "Genre"
    case grouping = "Grouping"
    case initialKey = "Initial Key"
    case involvedPeopleList = "Involved People List"
    case isrc = "ISRC"
    case languages = "Language"
    case length = "Length"
    case lyricist = "Lyricist"
    case mediaType = "Media Type"
    case mood = "Mood"
    case movementCount = "Movement Count"
    case movementName = "Movement Name"
    case movementNumber = "Movement Number"
    case musicianCreditsList = "Musician Credits List"
    case originalAlbum = "Original Album"
    case originalArtist = "Original Artist"
    case originalFilename = "Original Filename"
    case originalLyricist = "Original Lyricist"
    case originalReleaseTime = "Original Release Time"
    case paymentWebpage = "Payment Webpage"
    case playlistDelay = "Playlist Delay"
    case podcastCategory = "Podcast Category"
    case podcastDescription = "Podcast Description"
    case podcastID = "Podcast ID"
    case podcastKeywords = "Podcast Keywords"
    case podcastFeedLink = "Podcast Link"
    case producedNotice = "Produced Notice"
    case publisher = "Publisher"
    case publisherWebpage = "Publisher Webpage"
    case radioStation = "Internet Radio Station Name"
    case radioStationOwner = "Internet Radio Station Owner"
    case radioStationWebpage = "Internet Radio Station Webpage"
    case recordingDate = "Recording Date"
    case releaseTime = "Release Time"
    case setSubtitle = "Set Subtitle"
    case subtitle = "Subtitle"
    case tableOfContents = "Table of Contents"
    case taggingTime = "Tagging Time"
    case time = "Time"
    case title = "Title"
    case titleSort = "Sort Title"
    case trackNumber = "Track Number (of Total)"
    case unsynchronizedLyrics = "Unsynced Lyrics"
    case userDefinedText = "User Defined Text Information"
    case userDefinedWebpage = "User Defined Webpage"
    case year = "Year"
    
    
    func id3Frame(version: Version) -> String? {
        switch self {
            
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
