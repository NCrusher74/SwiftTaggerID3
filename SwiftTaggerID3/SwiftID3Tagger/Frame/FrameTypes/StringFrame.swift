//
//  StringFrame.swift
//  SwiftTaggerID3
//
//  Created by Nolaine Crusher on 4/11/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

/**
 A type representing an ID3 frame that holds a single string, such as Artist, Title, Album, etc
 */
struct StringFrame: FrameProtocol {
    
    // MARK: Properties
    /// The frame flags property.
    ///
    /// Typically this is two bytes `[0x00, 0x00]`
    /// SwiftTagger does not support altering these flags.
    var flags: Data
    /// The layout property describes the unique structure of a given frame
    var layout: FrameLayoutIdentifier
    /** The frameKey property
     
        Provides a unique identifier to permits duplication of frame types that the ID3 spec allows to be duplicated within a tag. */
    var frameKey: FrameKey
    /** A boolean value indicating whether or not frames of a particular type are permitted to be duplicated in a valid ID3 tag */
    var allowMultipleFrames: Bool = false
    
    /// The contents of the frame, consisting of a single, unterminated string without new lines
    var contentString: String
    
    // MARK: Frame parsing
    /// Initialize a frame parsing operation
    /// - Parameters:
    ///   - contents: the slice of data containing the frame
    ///   - version: the ID3 version of the tag
    ///   - layout: the frame's FrameLayoutIdentifier
    ///   - flags: (current unsupported by SwiftTagger) [0x00, 0x00]
    /// - Throws: The caller will determine how any errors are handled
    init(decodingContents contents: Data.SubSequence,
         version: Version,
         layout: FrameLayoutIdentifier,
         flags: Data
    ) throws {
        // initialize flags property
        self.flags = flags
        // initialize layout property
        self.layout = layout
        
        // initialize frame key property based on the layout
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
        // parse contents
        var parsing = contents
        // extract and decode the encoding byte
        let encoding = try StringFrame.extractEncoding(data: &parsing, version: version)
        // extract and initialize the contentString property
        // decode the string content according to encoding as specified by encoding byte
        self.contentString = parsing.extractPrefixAsStringUntilNullTermination(encoding) ?? ""
    }
    
    // MARK: Frame creation
    /**
     Initialize a frame with only string content, presented as a single string WITHOUT new line characters.
     - Parameters:
       - layout: the frame's layout according to its identifier
       - contentString: the content of the frame.
     */
    init(layout: FrameLayoutIdentifier, contentString: String) {
        // initialize the contentString property
        self.contentString = contentString
        // initialize the flags property using the default flags
        self.flags = StringFrame.defaultFlags
        // initialize the layout property
        self.layout = layout
        
        // initialize the frameKey property based on the layout
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
    
    /// Encodes the contents of the frame, without any header data
    /// - Parameter version: The version of the ID3 tag
    /// - Throws: Caller will determine how to handle any errors
    /// - Returns: The frame's contents as `data`
    func encodeContents(version: Version) throws -> Data {
        // initialize an empty data array
        var frameData = Data()
        // append encoding byte to frameData
        frameData.append(
            StringEncoding.preferred.rawValue.encoding(
                endianness: .bigEndian))
        // convert and append contentString to frameData
        frameData.append(self.contentString.encoded(
            withNullTermination: false))
        return frameData
    }
}

// MARK: Tag extension - Internal
/* get and set functions for `StringFrame` frame types. Each individual frame of this type will have its own get-set property that will call these functions using its `FrameKey` property and relevant data */
extension Tag {

    /// Instantiates parsing operation to retrieve a frame's contents from a `Tag`
    /// - Parameter frameKey: The unique identifier of the frame
    /// - Returns: The frame's contents as a human-readable, unterminated string
    internal func string(for frameKey: FrameKey) -> String? {
        // check that the frame is a String Frame
        if let frame = self.frames[frameKey],
            case .stringFrame(let stringFrame) = frame {
            // get the contentString from the frame data
            return stringFrame.contentString
        } else {
            return nil
        }
    }
    
    /// Adds the contents of a frame to a `Tag` instance
    /// - Parameters:
    ///   - layout: The frame's layout identifier, necessary to initialize the frame
    ///   - frameKey: The frame's unique identifier
    ///   - string: The string content input by the user
    internal mutating func set(_ layout: FrameLayoutIdentifier,
                      _ frameKey: FrameKey,
                      to string: String) {
        // call the StringFrame initializer
        let frame = StringFrame(
            layout: layout,
            contentString: string)
        self.frames[frameKey] = .stringFrame(frame)
    }

    // MARK: Tag extension - Public
    /// Series title getter-setter. Writes to `ContentGroup` frame,
    /// ID3 Identifier: `TT1`/`TIT1`.
    ///
    /// If another frame of this type already exists, this will write as a
    /// `TXX`/`TXXX` frame with a description of `Work`
    public var series: String {
        get { string(for: .series) ?? "" }
        set { set(.known(.contentGroup), .series, to: newValue) }
    }
    
    /// Album frame getter-setter. ID3 Identifier: `TAL`/`TALB`
    public var album: String {
        get { string(for: .album) ?? "" }
        set { set(.known(.album), .album, to: newValue) }
    }
    
    ///  AlbumArtist frame getter-setter. ID3 Identifier: `TP2`/`TPE2`
    public var albumArtist: String {
        get { string(for: .albumArtist) ?? "" }
        set { set(.known(.albumArtist), .albumArtist, to: newValue) }
    }
    
    /// AlbumSort frame getter-setter. ID3 Identifier: `TSA`/`TSOA`
    public var albumSort: String {
        get { string(for: .albumSort) ?? "" }
        set { set(.known(.albumSort), .albumSort, to: newValue) }
    }
    
    /// AlbumArtistSort frame getter-setter. ID3 Identifier: `TS2`/`TSO2`
    public var albumArtistSort: String {
        get { string(for: .albumArtistSort) ?? "" }
        set { set(.known(.albumArtistSort), .albumArtistSort, to: newValue) }
    }
    
    /// Arranger/Remixer/InterpretedBy getter-setter. ID3 Identifier: `TP4`/`TPE4`.
    ///
    /// If another frame of this type already exists, this will write as a
    /// `TXX`/`TXXX` frame with a description of `Arranger`
    public var arranger: String {
        get { string(for: .arranger) ?? "" }
        set { set(.known(.arranger), .arranger, to: newValue) }
    }
    
    /// Arranger/Remixer/InterpretedBy getter-setter. ID3 Identifier: `TP4`/`TPE4`
    ///
    /// If a `TP4`/`TPE4` frame already exists, this will write as a
    /// `TXX`/`TXXX` frame with a description of `Remixer`
    public var remixer: String {
        get { string(for: .remixer) ?? "" }
        set { set(.known(.arranger), .remixer, to: newValue) }
    }
    
    /// Arranger/Remixer/InterpretedBy getter-setter. ID3 Identifier: `TP4`/`TPE4`
    ///
    /// If a `TP4`/`TPE4` frame already exists, this will write as a
    /// `TXX`/`TXXX` frame with a description of `InterpretedBy`
    public var interpretedBy: String {
        get { string(for: .interpretedBy) ?? "" }
        set { set(.known(.arranger), .interpretedBy, to: newValue) }
    }
    
    /// Artist getter-setter. ID3 Identifier: `TP1`/`TPE1`
    public var artist: String {
        get { string(for: .artist) ?? "" }
        set { set(.known(.artist), .artist, to: newValue) }
    }
    
    /// ArtistSort getter-setter. ID3 Identifier: `TSP`/`TSOP`
    public var artistSort: String {
        get { string(for: .artistSort) ?? "" }
        set { set(.known(.artistSort), .artistSort, to: newValue) }
    }
    
    /// Author getter-setter. Writes to `Artist` frame, ID3 Identifier: `TP1`/`TPE1`.
    ///
    /// If another frame of this type already exists, this will write as a
    /// `TXX`/`TXXX` frame with a description of `Author`
    public var author: String {
        get { string(for: .author) ?? "" }
        set { set(.known(.artist), .author, to: newValue) }
    }
    
    /// AuthorSort getter-setter. Writes to `ArtistSort` frame, ID3 Identifier: `TSP`/`TSOP`.
    ///
    /// If another frame of this type already exists, this will write as a
    /// `TXX`/`TXXX` frame with a description of `AuthorSort`
    public var authorSort: String {
        get { string(for: .authorSort) ?? "" }
        set { set(.known(.artistSort), .authorSort, to: newValue) }
    }
    
    /// Composer getter-setter. ID3 Identifier: `TCM`/`TCOM`
    public var composer: String {
        get { string(for: .composer) ?? "" }
        set { set(.known(.composer), .composer, to: newValue) }
    }
    
    /// ComposerSort getter-setter. ID3 Identifier: `TSC`/`TSOC`
    public var composerSort: String {
        get { string(for: .composerSort) ?? "" }
        set { set(.known(.composerSort), .composerSort, to: newValue) }
    }
    
    /// Narrator getter-setter. Writes to `Composer` frame, ID3 Identifier: `TCM`/`TCOM`.
    ///
    /// If another frame of this type already exists, this will write as a
    /// `TXX`/`TXXX` frame with a description of `Narrator`
    public var narrator: String {
        get { string(for: .narrator) ?? "" }
        set { set(.known(.composer), .narrator, to: newValue) }
    }
    
    /// NarratorSort getter-setter. Writes to `ComposerSort` frame,
    /// ID3 Identifier: `TSC`/`TSOC`.
    ///
    /// If another frame of this type already exists, this will write as a
    /// `TXX`/`TXXX` frame with a description of `NarratorSort`
    public var narratorSort: String {
        get { string(for: .narratorSort) ?? "" }
        set { set(.known(.composerSort), .narrator, to: newValue) }
    }
    
    /// Conductor getter-setter. ID3 Identifier: `TP3`/`TPE3`
    public var conductor: String {
        get { string(for: .conductor) ?? "" }
        set { set(.known(.conductor), .conductor, to: newValue) }
    }
    
    /// ContentGroup getter-setter. ID3 Identifier: `TT1`/`TIT1`
    public var contentGroup: String {
        get { string(for: .contentGroup) ?? "" }
        set { set(.known(.contentGroup), .contentGroup, to: newValue) }
    }
    
    /// WorkName getter-setter. Writes to `ContentGroup` frame,
    /// ID3 Identifier: `TT1`/`TIT1`.
    ///
    /// If another frame of this type already exists, this will write as a
    /// `TXX`/`TXXX` frame with a description of `Work`
    public var work: String {
        get { string(for: .work) ?? "" }
        set { set(.known(.contentGroup), .work, to: newValue) }
    }
    
    /// Copyright getter-setter. ID3 Identifier: `TCR`/`TCOP`
    public var copyright: String {
        get { string(for: .copyright) ?? "" }
        set { set(.known(.copyright), .copyright, to: newValue) }
    }
    
    /// EncodedBy getter-setter. ID3 Identifier: `TEN`/`TENC`
    public var encodedBy: String {
        get { string(for: .encodedBy) ?? "" }
        set { set(.known(.encodedBy), .encodedBy, to: newValue) }
    }
    
    /// EncodingSettings getter-setter. ID3 Identifier: `TSS`/`TSSE`
    public var encodingSettings: String {
        get { string(for: .encodingSettings) ?? "" }
        set { set(.known(.encodingSettings), .encodingSettings, to: newValue) }
    }
    
    /// FileOwner getter-setter. ID3 Identifier: `TOWN`. Valid only for tag versions 2.3/2.4
    public var fileOwner: String {
        get { string(for: .fileOwner) ?? "" }
        set { set(.known(.fileOwner), .fileOwner, to: newValue) }
    }
    
    /// Grouping getter-setter. This is a non-standard, iTunes compliant frame.
    /// ID3 Identifier: `GRP1`
    ///
    /// Valid only for tag versions 2.3/2.4
    public var grouping: String {
        get { string(for: .grouping) ?? "" }
        set { set(.known(.grouping), .grouping, to: newValue) }
    }
    
    /// InitialKey getter-setter. ID3 Identifier: `TKE`/`TKEY`
    public var initialKey: KeySignature {
        get { return KeySignature(rawValue: string(for: .initialKey) ?? "") ?? .unknown
        }
        set { set(.known(.initialKey), .initialKey, to: newValue.rawValue)
        }
    }
    
    /// Lyricist getter-setter. ID3 Identifier: `TXT`/`TEXT`
    public var lyricist: String {
        get { string(for: .lyricist) ?? "" }
        set { set(.known(.lyricist), .lyricist, to: newValue) }
    }
    
    /// Mood getter-setter. ID3 Identifier: `TMOO`. Valid only for tag version 2.4
    public var mood: String {
        get { string(for: .mood) ?? "" }
        set { set(.known(.mood), .mood, to: newValue) }
    }
    
    /// MovementName getter-setter. This is a non-standard, iTunes compliant frame
    /// ID3 Identifier: `MVNM`.
    ///
    /// Valid only for tag versions 2.3/2.4
    public var movementName: String {
        get { string(for: .movementName) ?? "" }
        set { set(.known(.movementName), .movementName, to: newValue) }
    }
    
    /// OriginalAlbum getter-setter. ID3 Identifier: `TOT`/`TOAL`.
    public var originalAlbum: String {
        get { string(for: .originalAlbum) ?? "" }
        set { set(.known(.originalAlbum), .originalAlbum, to: newValue) }
    }
    
    /// OriginalArtist getter-setter. ID3 Identifier: `TOP`/`TOPE`.
    public var originalArtist: String {
        get { string(for: .originalArtist) ?? "" }
        set { set(.known(.originalArtist), .originalArtist, to: newValue) }
    }
    
    /// OriginalFilename getter-setter. ID3 Identifier: `TOF`/`TOFN`.
    public var originalFilename: String {
        get { string(for: .originalFilename) ?? "" }
        set { set(.known(.originalFilename), .originalFilename, to: newValue) }
    }
    
    /// OriginalLyricist getter-setter. ID3 Identifier: `TOL`/`TOLY`.
    public var originalLyricist: String {
        get { string(for: .originalLyricist) ?? "" }
        set { set(.known(.originalLyricist), .originalLyricist, to: newValue) }
    }
    
    /// PodcastCategory getter-setter. This is a non-standard, iTunes compliant frame
    /// ID3 Identifier: `TCAT`.
    ///
    /// Valid only for tag versions 2.3/2.4
    public var podcastCategory: String {
        get { string(for: .podcastCategory) ?? "" }
        set { set(.known(.podcastCategory), .podcastCategory, to: newValue) }
    }
    
    /// PodcastDescription getter-setter. This is a non-standard, iTunes compliant frame
    /// ID3 Identifier: `TDES`.
    ///
    /// Valid only for tag versions 2.3/2.4
    public var podcastDescription: String {
        get { string(for: .podcastDescription) ?? "" }
        set { set(.known(.podcastDescription), .podcastDescription, to: newValue) }
    }
    
    /// PodcastID getter-setter. This is a non-standard, iTunes compliant frame
    /// ID3 Identifier: `TGID`.
    ///
    /// Valid only for tag versions 2.3/2.4
    public var podcastID: String {
        get { string(for: .podcastID) ?? "" }
        set { set(.known(.podcastID), .podcastID, to: newValue) }
    }
    
    /// PodcastKeywords getter-setter. This is a non-standard, iTunes compliant frame
    /// ID3 Identifier: `TKWD`.
    ///
    /// Valid only for tag versions 2.3/2.4
    public var podcastKeywords: String {
        get { string(for: .podcastKeywords) ?? "" }
        set { set(.known(.podcastKeywords), .podcastKeywords, to: newValue) }
    }
    
    /// PodcastFeedLink getter-setter. This is a non-standard, iTunes compliant frame
    /// ID3 Identifier: `WFED`.
    ///
    /// Valid only for tag versions 2.3/2.4
    public var podcastFeedLink: String {
        get { string(for: .podcastFeedLink) ?? "" }
        set { set(.known(.podcastFeedLink), .podcastFeedLink, to: newValue) }
    }
    
    /// ProducedNotice getter-setter. ID3 Identifier: `TPRO`.
    ///
    /// Valid for tag version 2.4 only
    public var producedNotice: String {
        get { string(for: .producedNotice) ?? "" }
        set { set(.known(.producedNotice), .producedNotice, to: newValue) }
    }
    
    /// Publisher getter-setter. ID3 Identifier: `TPB`/`TPUB`.
    public var publisher: String {
        get { string(for: .publisher) ?? "" }
        set { set(.known(.publisher), .publisher, to: newValue) }
    }
    
    /// Label getter-setter. Writes to `Publisher` frame,
    /// ID3 Identifier: `TPB`/`TPUB`.
    ///
    /// If another frame of this type already exists, this will write as a
    /// `TXX`/`TXXX` frame with a description of `Label`
    public var label: String {
        get { string(for: .label) ?? "" }
        set { set(.known(.publisher), .label, to: newValue) }
    }
    
    /// RecordCompany getter-setter. Writes to `Publisher` frame,
    /// ID3 Identifier: `TPB`/`TPUB`.
    ///
    /// If another frame of this type already exists, this will write as a
    /// `TXX`/`TXXX` frame with a description of `RecordCompany`
    public var recordCompany: String {
        get { string(for: .recordCompany) ?? "" }
        set { set(.known(.publisher), .recordCompany, to: newValue) }
    }
    
    /// Studio getter-setter. Writes to `Publisher` frame,
    /// ID3 Identifier: `TPB`/`TPUB`.
    /// 
    /// If another frame of this type already exists, this will write as a
    /// `TXX`/`TXXX` frame with a description of `Studio`
    public var studio: String {
        get { string(for: .studio) ?? "" }
        set { set(.known(.publisher), .studio, to: newValue) }
    }
    
    /// (Internet)RadioStation getter-setter. ID3 Identifier: `TRS`/`TRSN`.
    public var radioStation: String {
        get { string(for: .radioStation) ?? "" }
        set { set(.known(.radioStation), .radioStation, to: newValue) }
    }
    
    /// (Internet)RadioStationOwner getter-setter. ID3 Identifier: `TRO`/`TRSO`.
    public var radioStationOwner: String {
        get { string(for: .radioStationOwner) ?? "" }
        set { set(.known(.radioStationOwner), .radioStationOwner, to: newValue) }
    }
    
    /// SetSubtitle getter-setter. ID3 Identifier: `TSST`. Valid for tag version 2.4 only.
    public var setSubtitle: String {
        get { string(for: .setSubtitle) ?? "" }
        set { set(.known(.setSubtitle), .setSubtitle, to: newValue) }
    }
    
    /// Subtitle getter-setter. ID3 Identifier: `TT3`/`TIT3`
    public var subtitle: String {
        get { string(for: .subtitle) ?? "" }
        set { set(.known(.subtitle), .subtitle, to: newValue) }
    }
    
    /// Title getter-setter. ID3 Identifier: `TT2`/`TIT2`
    public var title: String {
        get { string(for: .title) ?? "" }
        set { set(.known(.title), .title, to: newValue) }
    }
    
    /// TitleSort getter-setter. ID3 Identifier: `TST`/`TSOT`
    public var titleSort: String {
        get { string(for: .titleSort) ?? "" }
        set { set(.known(.titleSort), .titleSort, to: newValue) }
    }
}
