/*
 
 Version.swift
 SwiftTaggerID3
 
 Copyright ©2020 Nolaine Crusher. All rights reserved.
 
 */

import Foundation

/// An enum determining ID3 version and housing variables and methods are that dependent upon ID3 version
public enum Version: UInt8, CaseIterable {
    /// ID3 v2.2
    case v2_2 = 0x02
    /// ID3 v2.3
    case v2_3 = 0x03
    /// ID3 v2.4
    case v2_4 = 0x04
    
    /// Initialize ID3 version from the data representatoin of the version bytes
    init(data: Data) {
        guard data.count == 5 else {
            fatalError(Mp3FileError.InvalidVersionData.localizedDescription)
        }
        let fourthByte = UInt8(data[data.index(data.startIndex, offsetBy: 3)])
        guard fourthByte == 0x02 ||
                fourthByte == 0x03 ||
                fourthByte == 0x04 else {
            fatalError(Mp3FileError.InvalidVersionData.localizedDescription)
        }
        self.init(rawValue: fourthByte)!
    }
    
    var versionBytes: Data {
        var bytes: [UInt8] = [0x49, 0x44, 0x33]
        bytes.append(self.rawValue)
        bytes.append(0x00)
        return Data(bytes)
    }
}

extension Version {
    // MARK: - Frame component sizes.
    /// The known version-dependent byte-count of the ID3 identifier string
    var idLength: Int {
        switch self {
            case .v2_2:
                return 3
            case .v2_3, .v2_4:
                return 4
        }
    }
    
    /// The known version-dependent byte-count of the frame size declaration
    var sizeLength: Int {
        switch self {
            case .v2_2:
                return 3
            case .v2_3, .v2_4:
                return 4
        }
    }
    
    /// The known version-dependent byte-count of the frame flags
    var flagsLength: Int {
        switch self {
            case .v2_2:
                return 0
            case .v2_3, .v2_4:
                return 2
        }
    }
    
    /// The version-dependent size of the frame header, in bytes
    var headerLength: Int {
        return idLength + sizeLength + flagsLength
    }
    
    // MARK: - Frame component offsets:
    /// The known byte offset of the frame identifier from start of frame data
    var idOffset: Data.Index {
        return 0
    }
    
    /// The byte offset of the frame size declaration
    var sizeOffset: Data.Index {
        return idOffset  + idLength
    }
    
    /// The byte offset of the frame flags
    var flagsOffset: Data.Index {
        return sizeOffset + sizeLength
    }
    
    /// The version-dependent position of the encoding byte
    var encodingByteOffset: Data.Index {
        return headerLength
    }
    
    // MARK: - Other properties
    var defaultFlags: Data {
        switch self {
            case .v2_2: return Data()
            case .v2_3, .v2_4: return Data([0x00, 0x00])
        }
    }
    
    func idString(_ id: FrameIdentifier) -> String? {
        switch id {
            case .album:
                switch self {
                    case .v2_2: return "TAL"
                    case .v2_3, .v2_4: return "TALB"
                }
            case .albumSort:
                switch self {
                    case .v2_2: return "TSA"
                    case .v2_3, .v2_4: return "TSOA"
                }
            case .albumArtist:
                switch self {
                    case .v2_2: return "TP2"
                    case .v2_3, .v2_4: return "TPE2"
                }
            case .albumArtistSort:
                switch self {
                    case .v2_2: return "TS2"
                    case .v2_3, .v2_4: return "TSO2"
                }
            case .arranger:
                switch self {
                    case .v2_2: return "TP4"
                    case .v2_3, .v2_4: return "TPE4"
                }
            case .artist:
                switch self {
                    case .v2_2: return "TP1"
                    case .v2_3, .v2_4: return "TPE1"
                }
            case .artistSort:
                switch self {
                    case .v2_2: return "TSP"
                    case .v2_3, .v2_4: return "TSOP"
                }
            case .artistWebpage:
                switch self {
                    case .v2_2: return "WAR"
                    case .v2_3, .v2_4: return "WOAR"
                }
            case .attachedPicture:
                switch self {
                    case .v2_2: return "PIC"
                    case .v2_3, .v2_4: return "APIC"
                }
            case .audioFileWebpage:
                switch self {
                    case .v2_2: return "WAF"
                    case .v2_3, .v2_4: return "WOAF"
                }
            case .audioSourceWebpage:
                switch self {
                    case .v2_2: return "WAS"
                    case .v2_3, .v2_4: return "WOAS"
                }
            case .bpm:
                switch self {
                    case .v2_2: return "TBP"
                    case .v2_3, .v2_4: return "TBPM"
                }
            case .chapter:
                switch self {
                    case .v2_2: return nil
                    case .v2_3, .v2_4: return "CHAP"
                }
            case .comments:
                switch self {
                    case .v2_2: return "COM"
                    case .v2_3, .v2_4: return "COMM"
                }
            case .compilation:
                switch self {
                    case .v2_2: return "TCP"
                    case .v2_3, .v2_4: return "TCMP"
                }
            case .composer:
                switch self {
                    case .v2_2: return "TCM"
                    case .v2_3, .v2_4: return "TCOM"
                }
            case .composerSort:
                switch self {
                    case .v2_2: return "TSC"
                    case .v2_3, .v2_4: return "TSOC"
                }
            case .conductor:
                switch self {
                    case .v2_2: return "TP3"
                    case .v2_3, .v2_4: return "TPE3"
                }
            case .contentGroup:
                switch self {
                    case .v2_2: return "TT1"
                    case .v2_3, .v2_4: return "TIT1"
                }
            case .copyright:
                switch self {
                    case .v2_2: return "TCR"
                    case .v2_3, .v2_4: return "TCOP"
                }
            case .copyrightWebpage:
                switch self {
                    case .v2_2: return "WCP"
                    case .v2_3, .v2_4: return "WCOP"
                }
            case .date:
                switch self {
                    case .v2_2: return "TDA"
                    case .v2_3: return "TDAT"
                    case .v2_4: return nil
                }
            case .discNumber:
                switch self {
                    case .v2_2: return "TPA"
                    case .v2_3, .v2_4: return "TPOS"
                }
            case .encodingTime:
                switch self {
                    case .v2_2: return "TDN"
                    case .v2_3, .v2_4: return "TDEN"
                }
            case .encodedBy:
                switch self {
                    case .v2_2: return "TEN"
                    case .v2_3, .v2_4: return "TENC"
                }
            case .encodingSettings:
                switch self {
                    case .v2_2: return "TSS"
                    case .v2_3, .v2_4: return "TSSE"
                }
            case .fileType:
                switch self {
                    case .v2_2: return "TFT"
                    case .v2_3, .v2_4: return "TFLT"
                }
            case .fileOwner:
                switch self {
                    case .v2_2: return "TWN"
                    case .v2_3, .v2_4: return "TOWN"
                }
            case .genre:
                switch self {
                    case .v2_2: return "TCO"
                    case .v2_3, .v2_4: return "TCON"
                }
            case .grouping:
                switch self {
                    case .v2_2: return "GP1"
                    case .v2_3, .v2_4: return "GRP1"
                }
            case .initialKey:
                switch self {
                    case .v2_2: return "TKE"
                    case .v2_3, .v2_4: return "TKEY"
                }
            case .involvedPeopleList:
                switch self {
                    case .v2_2: return "IPL"
                    case .v2_3: return "IPLS"
                    case .v2_4: return "TIPL"
                }
            case .isrc:
                switch self {
                    case .v2_2: return "TRC"
                    case .v2_3, .v2_4: return "TSRC"
                }
            case .languages:
                switch self {
                    case .v2_2: return "TLA"
                    case .v2_3, .v2_4: return "TLAN"
                }
            case .length:
                switch self {
                    case .v2_2: return "TLE"
                    case .v2_3, .v2_4: return "TLEN"
                }
            case .lyricist:
                switch self {
                    case .v2_2: return "TXT"
                    case .v2_3, .v2_4: return "TEXT"
                }
            case .mediaType:
                switch self {
                    case .v2_2: return "TMT"
                    case .v2_3, .v2_4: return "TMED"
                }
            case .mood:
                switch self {
                    case .v2_2: return "TMO" // non-standard
                    case .v2_3, .v2_4: return "TMOO" // non-standard in version 2.3
                }
            case .movementCount:
                switch self {
                    case .v2_2: return "MVC"
                    case .v2_3, .v2_4: return "MVCN"
                }
            case .movement:
                switch self {
                    case .v2_2: return "MVN"
                    case .v2_3, .v2_4: return "MVNM"
                }
            case .movementNumber:
                switch self {
                    case .v2_2: return "MVI"
                    case .v2_3, .v2_4: return "MVIN"
                }
            case .musicianCreditsList:
                switch self {
                    case .v2_2: return "TMC" // non-standard
                    case .v2_3, .v2_4: return "TMCL" // non-standard for version 2.3
                }
            case .originalAlbum:
                switch self {
                    case .v2_2: return "TOT"
                    case .v2_3, .v2_4: return "TOAL"
                }
            case .originalArtist:
                switch self {
                    case .v2_2: return "TOP"
                    case .v2_3, .v2_4: return "TOPE"
                }
            case .originalFilename:
                switch self {
                    case .v2_2: return "TOF"
                    case .v2_3, .v2_4: return "TOFN"
                }
            case .originalLyricist:
                switch self {
                    case .v2_2: return "TOL"
                    case .v2_3, .v2_4: return "TOLY"
                }
            case .originalReleaseTime:
                switch self {
                    case .v2_2: return "TOY"
                    case .v2_3: return "TORY"
                    case .v2_4: return "TDOR"
                }
            case .paymentWebpage:
                switch self {
                    case .v2_2: return "WPY" // non-standard
                    case .v2_3, .v2_4: return "WPAY"
                }
            case .playlistDelay:
                switch self {
                    case .v2_2: return "TDY"
                    case .v2_3, .v2_4: return "TDLY"
                }
            case .podcastCategory:
                switch self {
                    case .v2_2: return "TCT"
                    case .v2_3, .v2_4: return "TCAT"
                }
            case .podcastDescription:
                switch self {
                    case .v2_2: return "TDS"
                    case .v2_3, .v2_4: return "TDES"
                }
            case .podcastID:
                switch self {
                    case .v2_2: return "TID"
                    case .v2_3, .v2_4: return "TGID"
                }
            case .podcastKeywords:
                switch self {
                    case .v2_2: return "TKW"
                    case .v2_3, .v2_4: return "TKWD"
                }
            case .podcastFeed:
                switch self {
                    case .v2_2: return "WFD"
                    case .v2_3, .v2_4: return "WFED"
                }
            case .producedNotice:
                switch self {
                    case .v2_2: return "TPR" // non-standard
                    case .v2_3, .v2_4: return "TPRO" // non-standard for version 2.3
                }
            case .publisher:
                switch self {
                    case .v2_2: return "TPB"
                    case .v2_3, .v2_4: return "TPUB"
                }
            case .publisherWebpage:
                switch self {
                    case .v2_2: return "WPB"
                    case .v2_3, .v2_4: return "WPUB"
                }
            case .radioStation:
                switch self {
                    case .v2_2: return "TRS"
                    case .v2_3, .v2_4: return "TRSN"
                }
            case .radioStationOwner:
                switch self {
                    case .v2_2: return "TRO"
                    case .v2_3, .v2_4: return "TRSO"
                }
            case .radioStationWebpage:
                switch self {
                    case .v2_2: return "WRS"
                    case .v2_3, .v2_4: return "WORS"
                }
            case .recordingDate:
                switch self {
                    case .v2_2: return "TRD"
                    case .v2_3: return "TRDA"
                    case .v2_4: return "TDRC"
                }
            case .releaseTime:
                switch self {
                    case .v2_2, .v2_3: return nil
                    case .v2_4: return "TDRL"
                }
            case .setSubtitle:
                switch self {
                    case .v2_2: return "TTT" // non-standard
                    case .v2_3, .v2_4: return "TSST" // non-standard for version 2.3
                }
            case .subtitle:
                switch self {
                    case .v2_2: return "TT3"
                    case .v2_3, .v2_4: return "TIT3"
                }
            case .tableOfContents:
                switch self {
                    case .v2_2: return nil
                    case .v2_3, .v2_4: return "CTOC"
                }
            case .taggingTime:
                switch self {
                    case .v2_2: return "TTG"
                    case .v2_3, .v2_4: return "TDTG"
                }
            case .time:
                switch self {
                    case .v2_2: return "TIM"
                    case .v2_3: return "TIME"
                    case .v2_4: return nil
                }
            case .title:
                switch self {
                    case .v2_2: return "TT2"
                    case .v2_3, .v2_4: return "TIT2"
                }
            case .titleSort:
                switch self {
                    case .v2_2: return "TST"
                    case .v2_3, .v2_4: return "TSOT"
                }
            case .trackNumber:
                switch self {
                    case .v2_2: return "TRK"
                    case .v2_3, .v2_4: return "TRCK"
                }
            case .unsynchronizedLyrics:
                switch self {
                    case .v2_2: return "ULT"
                    case .v2_3, .v2_4: return "USLT"
                }
            case .userDefinedText:
                switch self {
                    case .v2_2: return "TXX"
                    case .v2_3, .v2_4: return "TXXX"
                }
            case .userDefinedWebpage:
                switch self {
                    case .v2_2: return "WXX"
                    case .v2_3, .v2_4: return "WXXX"
                }
            case .year:
                switch self {
                    case .v2_2: return "TYE"
                    case .v2_3: return "TYER"
                    case .v2_4: return nil
                }
            case .passThrough: return nil
        }
    }
}
