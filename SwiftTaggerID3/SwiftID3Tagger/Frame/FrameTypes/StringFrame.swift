//
//  StringFrame.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/11/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

/**
 A type representing an ID3 frame that holds a single string, such as Artist, Title, Album, etc
 */
struct StringFrame: FrameProtocol {
    
    // MARK: Decoding
    // decode incoming data and parse it into a frame
    var flags: Data
    var layout: FrameLayoutIdentifier
    var frameKey: FrameKey
    var allowMultipleFrames: Bool = false
    
    // instantiates a string frame decoding operation
    init(decodingContents contents: Data.SubSequence,
         version: Version,
         layout: FrameLayoutIdentifier,
         flags: Data
    ) throws {
        self.flags = flags
        self.layout = layout
        
        switch layout {
            case .known(.album): self.frameKey = .album
            case .known(.albumSort): self.frameKey = .albumSort
            case .known(.albumArtist): self.frameKey = .albumArtist
            case .known(.albumArtistSort): self.frameKey = .albumArtistSort
            case .known(.arranger): self.frameKey = .arranger
            case .known(.artist): self.frameKey = .artist
            case .known(.artistSort): self.frameKey = .artistSort
            case .known(.composer): self.frameKey = .composer
            case .known(.composerSort): self.frameKey = .composerSort
            case .known(.conductor): self.frameKey = .conductor
            case .known(.contentGroup): self.frameKey = .contentGroup
            case .known(.copyright): self.frameKey = .copyright
            case .known(.encodedBy): self.frameKey = .encodedBy
            case .known(.encodingSettings): self.frameKey = .encodingSettings
            case .known(.fileOwner): self.frameKey = .fileOwner
            case .known(.grouping): self.frameKey = .grouping
            case .known(.initialKey): self.frameKey = .initialKey
            case .known(.lyricist): self.frameKey = .lyricist
            case .known(.mood): self.frameKey = .mood
            case .known(.movementName): self.frameKey = .movementName
            case .known(.originalAlbum): self.frameKey = .originalAlbum
            case .known(.originalArtist): self.frameKey = .originalArtist
            case .known(.originalFilename): self.frameKey = .originalFilename
            case .known(.originalLyricist): self.frameKey = .originalLyricist
            case .known(.podcastCategory): self.frameKey = .podcastCategory
            case .known(.podcastDescription): self.frameKey = .podcastDescription
            case .known(.podcastFeedLink): self.frameKey = .podcastFeedLink
            case .known(.podcastID): self.frameKey = .podcastID
            case .known(.podcastKeywords): self.frameKey = .podcastKeywords
            case .known(.producedNotice): self.frameKey = .producedNotice
            case .known(.publisher): self.frameKey = .publisher
            case .known(.radioStation): self.frameKey = .radioStation
            case .known(.radioStationOwner): self.frameKey = .radioStationOwner
            case .known(.setSubtitle): self.frameKey = .setSubtitle
            case .known(.subtitle): self.frameKey = .subtitle
            case .known(.title): self.frameKey = .title
            case .known(.titleSort): self.frameKey = .titleSort
            default: self.frameKey = .userDefinedText(description: "")
        }
        var parsing = contents
        // extract and decode the encoding byte
        let encoding = try StringFrame.extractEncoding(data: &parsing, version: version)
        // extract and decode the string content according to encoding as specified by encoding byte
        self.contentString = parsing.extractPrefixAsStringUntilNullTermination(encoding) ?? ""
    }

    // MARK: encoding
    var contentString: String
    
    /**
     A frame with only string content, presented as a single string without`(/n)` newline characters.
     - parameter contentString: the content of the frame.
     */
    init(layout: FrameLayoutIdentifier, contentString: String) {
        self.contentString = contentString
        self.flags = StringFrame.defaultFlags
        self.layout = layout
        
        switch layout {
            case .known(.album): self.frameKey = .album
            case .known(.albumSort): self.frameKey = .albumSort
            case .known(.albumArtist): self.frameKey = .albumArtist
            case .known(.albumArtistSort): self.frameKey = .albumArtistSort
            case .known(.arranger): self.frameKey = .arranger
            case .known(.artist): self.frameKey = .artist
            case .known(.artistSort): self.frameKey = .artistSort
            case .known(.composer): self.frameKey = .composer
            case .known(.composerSort): self.frameKey = .composerSort
            case .known(.conductor): self.frameKey = .conductor
            case .known(.contentGroup): self.frameKey = .contentGroup
            case .known(.copyright): self.frameKey = .copyright
            case .known(.encodedBy): self.frameKey = .encodedBy
            case .known(.encodingSettings): self.frameKey = .encodingSettings
            case .known(.fileOwner): self.frameKey = .fileOwner
            case .known(.grouping): self.frameKey = .grouping
            case .known(.initialKey): self.frameKey = .initialKey
            case .known(.lyricist): self.frameKey = .lyricist
            case .known(.mood): self.frameKey = .mood
            case .known(.movementName): self.frameKey = .movementName
            case .known(.originalAlbum): self.frameKey = .originalAlbum
            case .known(.originalArtist): self.frameKey = .originalArtist
            case .known(.originalFilename): self.frameKey = .originalFilename
            case .known(.originalLyricist): self.frameKey = .originalLyricist
            case .known(.podcastCategory): self.frameKey = .podcastCategory
            case .known(.podcastDescription): self.frameKey = .podcastDescription
            case .known(.podcastFeedLink): self.frameKey = .podcastFeedLink
            case .known(.podcastID): self.frameKey = .podcastID
            case .known(.podcastKeywords): self.frameKey = .podcastKeywords
            case .known(.producedNotice): self.frameKey = .producedNotice
            case .known(.publisher): self.frameKey = .publisher
            case .known(.radioStation): self.frameKey = .radioStation
            case .known(.radioStationOwner): self.frameKey = .radioStationOwner
            case .known(.setSubtitle): self.frameKey = .setSubtitle
            case .known(.subtitle): self.frameKey = .subtitle
            case .known(.title): self.frameKey = .title
            case .known(.titleSort): self.frameKey = .titleSort
            default: self.frameKey = .userDefinedText(description: "")
        }

    }
    
    // encode the contents of the frame to be added to a tag instance
    func encodeContents(version: Version) throws -> Data {
        var frameData = Data()
        // append encoding byte
        frameData.append(StringEncoding.preferred.rawValue.encoding(endianness: .bigEndian))
        // convert and append content string
        frameData.append(self.contentString.encoded(withNullTermination: false))
        return frameData
    }
}

public extension Tag {
    /// - Series title getter-setter. Writes to `ContentGroup` frame,
    /// ID3 Identifier: `TT1`/`TIT1`.
    /// If another frame of this type already exists, this will write as a
    /// `TXX`/`TXXX` frame with a description of `Work`
    var series: String {
        get {
            string(for: .series) ?? ""
        }
        set {
            let frame = StringFrame(layout: .known(.contentGroup), contentString: newValue)
            frames[.series] = .stringFrame(frame)
        }
    }
    
    /// - Album frame getter-setter. ID3 Identifier: `TAL`/`TALB`
    var album: String {
        get {
            string(for: .album) ?? ""
        }
        set {
            set(.known(.album), .album, to: newValue)
        }
    }
    
    /// - AlbumArtist frame getter-setter. ID3 Identifier: `TP2`/`TPE2`
    var albumArtist: String {
        get {
            string(for: .albumArtist) ?? ""
        }
        set {
            set(.known(.albumArtist), .albumArtist, to: newValue)
        }
    }
    
    /// - AlbumSort frame getter-setter. ID3 Identifier: `TSA`/`TSOA`
    var albumSort: String {
        get {
            string(for: .albumSort) ?? ""
        }
        set {
            set(.known(.albumSort), .albumSort, to: newValue)
        }
    }
    
    /// - AlbumArtistSort frame getter-setter. ID3 Identifier: `TS2`/`TSO2`
    var albumArtistSort: String {
        get {
            string(for: .albumArtistSort) ?? ""
        }
        set {
            set(.known(.albumArtistSort), .albumArtistSort, to: newValue)
        }
    }
    
    /// - Arranger/Remixer/InterpretedBy getter-setter. ID3 Identifier: `TP4`/`TPE4`.
    /// If another frame of this type already exists, this will write as a
    /// `TXX`/`TXXX` frame with a description of `Arranger`
    var arranger: String {
        get {
            string(for: .arranger) ?? ""
        }
        set {
            set(.known(.arranger), .arranger, to: newValue)
        }
    }
    
    /// - Arranger/Remixer/InterpretedBy getter-setter. ID3 Identifier: `TP4`/`TPE4`
    /// If a `TP4`/`TPE4` frame already exists, this will write as a
    /// `TXX`/`TXXX` frame with a description of `Remixer`
    var remixer: String {
        get {
            string(for: .remixer) ?? ""
        }
        set {
            set(.known(.arranger), .remixer, to: newValue)
        }
    }
    
    /// - Arranger/Remixer/InterpretedBy getter-setter. ID3 Identifier: `TP4`/`TPE4`
    /// If a `TP4`/`TPE4` frame already exists, this will write as a
    /// `TXX`/`TXXX` frame with a description of `InterpretedBy`
    var interpretedBy: String {
        get {
            string(for: .interpretedBy) ?? ""
        }
        set {
            set(.known(.arranger), .interpretedBy, to: newValue)
        }
    }
    
    /// - Artist getter-setter. ID3 Identifier: `TP1`/`TPE1`
    var artist: String {
        get {
            string(for: .artist) ?? ""
        }
        set {
            set(.known(.artist), .artist, to: newValue)
        }
    }
    
    /// - ArtistSort getter-setter. ID3 Identifier: `TSP`/`TSOP`
    var artistSort: String {
        get {
            string(for: .artistSort) ?? ""
        }
        set {
            set(.known(.artistSort), .artistSort, to: newValue)
        }
    }
    
    /// - Author getter-setter. Writes to `Artist` frame, ID3 Identifier: `TP1`/`TPE1`.
    /// If another frame of this type already exists, this will write as a
    /// `TXX`/`TXXX` frame with a description of `Author`
    var author: String {
        get {
            string(for: .author) ?? ""
        }
        set {
            set(.known(.artist), .author, to: newValue)
        }
    }
    
    /// - AuthorSort getter-setter. Writes to `ArtistSort` frame, ID3 Identifier: `TSP`/`TSOP`.
    /// If another frame of this type already exists, this will write as a
    /// `TXX`/`TXXX` frame with a description of `AuthorSort`
    var authorSort: String {
        get {
            string(for: .authorSort) ?? ""
        }
        set {
            set(.known(.artistSort), .authorSort, to: newValue)
        }
    }
    
    /// - Composer getter-setter. ID3 Identifier: `TCM`/`TCOM`
    var composer: String {
        get {
            string(for: .composer) ?? ""
        }
        set {
            set(.known(.composer), .composer, to: newValue)
        }
    }
    
    /// - ComposerSort getter-setter. ID3 Identifier: `TSC`/`TSOC`
    var composerSort: String {
        get {
            string(for: .composerSort) ?? ""
        }
        set {
            set(.known(.composerSort), .composerSort, to: newValue)
        }
    }
    
    /// - Narrator getter-setter. Writes to `Composer` frame, ID3 Identifier: `TCM`/`TCOM`.
    /// If another frame of this type already exists, this will write as a
    /// `TXX`/`TXXX` frame with a description of `Narrator`
    var narrator: String {
        get {
            string(for: .narrator) ?? ""
        }
        set {
            set(.known(.composer), .narrator, to: newValue)
        }
    }
    
    /// - NarratorSort getter-setter. Writes to `ComposerSort` frame,
    /// ID3 Identifier: `TSC`/`TSOC`.
    /// If another frame of this type already exists, this will write as a
    /// `TXX`/`TXXX` frame with a description of `NarratorSort`
    var narratorSort: String {
        get {
            string(for: .narratorSort) ?? ""
        }
        set {
            set(.known(.composerSort), .narrator, to: newValue)
        }
    }
    
    /// - Conductor getter-setter. ID3 Identifier: `TP3`/`TPE3`
    var conductor: String {
        get {
            string(for: .conductor) ?? ""
        }
        set {
            set(.known(.conductor), .conductor, to: newValue)
        }
    }
    
    /// - ContentGroup getter-setter. ID3 Identifier: `TT1`/`TIT1`
    var contentGroup: String {
        get {
            string(for: .contentGroup) ?? ""
        }
        set {
            set(.known(.contentGroup), .contentGroup, to: newValue)
        }
    }
    
    /// - WorkName getter-setter. Writes to `ContentGroup` frame,
    /// ID3 Identifier: `TT1`/`TIT1`.
    /// If another frame of this type already exists, this will write as a
    /// `TXX`/`TXXX` frame with a description of `Work`
    var work: String {
        get {
            string(for: .work) ?? ""
        }
        set {
            set(.known(.contentGroup), .work, to: newValue)
        }
    }
    
    /// - Copyright getter-setter. ID3 Identifier: `TCR`/`TCOP`
    var copyright: String {
        get {
            string(for: .copyright) ?? ""
        }
        set {
            set(.known(.copyright), .copyright, to: newValue)
        }
    }
    
    /// - EncodedBy getter-setter. ID3 Identifier: `TEN`/`TENC`
    var encodedBy: String {
        get {
            string(for: .encodedBy) ?? ""
        }
        set {
            set(.known(.encodedBy), .encodedBy, to: newValue)
        }
    }
    
    /// - EncodingSettings getter-setter. ID3 Identifier: `TSS`/`TSSE`
    var encodingSettings: String {
        get {
            string(for: .encodingSettings) ?? ""
        }
        set {
            set(.known(.encodingSettings), .encodingSettings, to: newValue)
        }
    }
    
    /// - FileOwner getter-setter. ID3 Identifier: `TOWN`. Valid only for tag versions 2.3/2.4
    var fileOwner: String {
        get {
            string(for: .fileOwner) ?? ""
        }
        set {
            set(.known(.fileOwner), .fileOwner, to: newValue)
        }
    }
    
    /// - Grouping getter-setter. This is a non-standard, iTunes compliant frame.
    /// ID3 Identifier: `GRP1`
    /// Valid only for tag versions 2.3/2.4
    var grouping: String {
        get {
            string(for: .grouping) ?? ""
        }
        set {
            set(.known(.grouping), .grouping, to: newValue)
        }
    }
    
    /// - InitialKey getter-setter. ID3 Identifier: `TKE`/`TKEY`
    var initialKey: KeySignature {
        get {
            return KeySignature(rawValue: string(for: .initialKey) ?? "") ?? .unknown
        }
        set {
            set(.known(.initialKey), .initialKey, to: newValue.rawValue)
        }
    }
    
    /// - Lyricist getter-setter. ID3 Identifier: `TXT`/`TEXT`
    var lyricist: String {
        get {
            string(for: .lyricist) ?? ""
        }
        set {
            set(.known(.lyricist), .lyricist, to: newValue)
        }
    }
    
    /// - Mood getter-setter. ID3 Identifier: `TMOO`. Valid only for tag version 2.4
    var mood: String {
        get {
            string(for: .mood) ?? ""
        }
        set {
            set(.known(.mood), .mood, to: newValue)
        }
    }
    
    /// - MovementName getter-setter. This is a non-standard, iTunes compliant frame
    /// ID3 Identifier: `MVNM`. Valid only for tag versions 2.3/2.4
    var movementName: String {
        get {
            string(for: .movementName) ?? ""
        }
        set {
            set(.known(.movementName), .movementName, to: newValue)
        }
    }
    
    /// - OriginalAlbum getter-setter. ID3 Identifier: `TOT`/`TOAL`.
    var originalAlbum: String {
        get {
            string(for: .originalAlbum) ?? ""
        }
        set {
            set(.known(.originalAlbum), .originalAlbum, to: newValue)
        }
    }
    
    /// - OriginalArtist getter-setter. ID3 Identifier: `TOP`/`TOPE`.
    var originalArtist: String {
        get {
            string(for: .originalArtist) ?? ""
        }
        set {
            set(.known(.originalArtist), .originalArtist, to: newValue)
        }
    }
    
    /// - OriginalFilename getter-setter. ID3 Identifier: `TOF`/`TOFN`.
    var originalFilename: String {
        get {
            string(for: .originalFilename) ?? ""
        }
        set {
            set(.known(.originalFilename), .originalFilename, to: newValue)
        }
    }
    
    /// - OriginalLyricist getter-setter. ID3 Identifier: `TOL`/`TOLY`.
    var originalLyricist: String {
        get {
            string(for: .originalLyricist) ?? ""
        }
        set {
            set(.known(.originalLyricist), .originalLyricist, to: newValue)
        }
    }
    
    /// - PodcastCategory getter-setter. This is a non-standard, iTunes compliant frame
    /// ID3 Identifier: `TCAT`. Valid only for tag versions 2.3/2.4
    var podcastCategory: String {
        get {
            string(for: .podcastCategory) ?? ""
        }
        set {
            set(.known(.podcastCategory), .podcastCategory, to: newValue)
        }
    }
    
    /// - PodcastDescription getter-setter. This is a non-standard, iTunes compliant frame
    /// ID3 Identifier: `TDES`. Valid only for tag versions 2.3/2.4
    var podcastDescription: String {
        get {
            string(for: .podcastDescription) ?? ""
        }
        set {
            set(.known(.podcastDescription), .podcastDescription, to: newValue)
        }
    }
    
    /// - PodcastID getter-setter. This is a non-standard, iTunes compliant frame
    /// ID3 Identifier: `TGID`. Valid only for tag versions 2.3/2.4
    var podcastID: String {
        get {
            string(for: .podcastID) ?? ""
        }
        set {
            set(.known(.podcastID), .podcastID, to: newValue)
        }
    }
    
    /// - PodcastKeywords getter-setter. This is a non-standard, iTunes compliant frame
    /// ID3 Identifier: `TKWD`. Valid only for tag versions 2.3/2.4
    var podcastKeywords: String {
        get {
            string(for: .podcastKeywords) ?? ""
        }
        set {
            set(.known(.podcastKeywords), .podcastKeywords, to: newValue)
        }
    }
    
    /// - PodcastFeedLink getter-setter. This is a non-standard, iTunes compliant frame
    /// ID3 Identifier: `WFED`. Valid only for tag versions 2.3/2.4
    var podcastFeedLink: String {
        get {
            string(for: .podcastFeedLink) ?? ""
        }
        set {
            set(.known(.podcastFeedLink), .podcastFeedLink, to: newValue)
        }
    }
    
    /// - ProducedNotice getter-setter. ID3 Identifier: `TPRO`. Valid for tag version 2.4 only
    var producedNotice: String {
        get {
            string(for: .producedNotice) ?? ""
        }
        set {
            set(.known(.producedNotice), .producedNotice, to: newValue)
        }
    }
    
    /// - Publisher getter-setter. ID3 Identifier: `TPB`/`TPUB`.
    var publisher: String {
        get {
            string(for: .publisher) ?? ""
        }
        set {
            set(.known(.publisher), .publisher, to: newValue)
        }
    }
    
    /// - Label getter-setter. Writes to `Publisher` frame,
    /// ID3 Identifier: `TPB`/`TPUB`.
    /// If another frame of this type already exists, this will write as a
    /// `TXX`/`TXXX` frame with a description of `Label`
    var label: String {
        get {
            string(for: .label) ?? ""
        }
        set {
            set(.known(.publisher), .label, to: newValue)
        }
    }
    
    /// - RecordCompany getter-setter. Writes to `Publisher` frame,
    /// ID3 Identifier: `TPB`/`TPUB`.
    /// If another frame of this type already exists, this will write as a
    /// `TXX`/`TXXX` frame with a description of `RecordCompany`
    var recordCompany: String {
        get {
            string(for: .recordCompany) ?? ""
        }
        set {
            set(.known(.publisher), .recordCompany, to: newValue)
        }
    }
    
    /// - Studio getter-setter. Writes to `Publisher` frame,
    /// ID3 Identifier: `TPB`/`TPUB`.
    /// If another frame of this type already exists, this will write as a
    /// `TXX`/`TXXX` frame with a description of `Studio`
    var studio: String {
        get {
            string(for: .studio) ?? ""
        }
        set {
            set(.known(.publisher), .studio, to: newValue)
        }
    }
    
    /// - (Internet)RadioStation getter-setter. ID3 Identifier: `TRS`/`TRSN`.
    var radioStation: String {
        get {
            string(for: .radioStation) ?? ""
        }
        set {
            set(.known(.radioStation), .radioStation, to: newValue)
        }
    }
    
    /// - (Internet)RadioStationOwner getter-setter. ID3 Identifier: `TRO`/`TRSO`.
    var radioStationOwner: String {
        get {
            string(for: .radioStationOwner) ?? ""
        }
        set {
            set(.known(.radioStationOwner), .radioStationOwner, to: newValue)
        }
    }
    
    /// - SetSubtitle getter-setter. ID3 Identifier: `TSST`. Valid for tag version 2.4 only.
    var setSubtitle: String {
        get {
            string(for: .setSubtitle) ?? ""
        }
        set {
            set(.known(.setSubtitle), .setSubtitle, to: newValue)
        }
    }
    
    /// - Subtitle getter-setter. ID3 Identifier: `TT3`/`TIT3`
    var subtitle: String {
        get {
            string(for: .subtitle) ?? ""
        }
        set {
            set(.known(.subtitle), .subtitle, to: newValue)
        }
    }
    
    /// - Title getter-setter. ID3 Identifier: `TT2`/`TIT2`
    var title: String {
        get {
            string(for: .title) ?? ""
        }
        set {
            set(.known(.title), .title, to: newValue)
        }
    }
    
    /// - TitleSort getter-setter. ID3 Identifier: `TST`/`TSOT`
    var titleSort: String {
        get {
            string(for: .titleSort) ?? ""
        }
        set {
            set(.known(.titleSort), .titleSort, to: newValue)
        }
    }
}
