/*
 
 StringFrame.swift
 SwiftTaggerID3
 
 Copyright ©2020 Nolaine Crusher. All rights reserved.
 
 */

import Foundation

/// A type representing an ID3 frame that holds a single string, such as Artist, Title, Album, etc
///
/// In ID3 tags, most data is stored as a string, so single integers are actually integerStrings, a boolean is a string of "0" or "1", etc. This type will handle all but the most complex of these frames.
///
/// Therefore, this frame also handles simple, single-value integer and boolean frames
class StringFrame: Frame {
    /// The contents of the frame, consisting of a single, unterminated string without new lines
    /// This sting may be a URL for an external webpage, or a numeric string for integer and boolean values
    var stringValue: String
    
    // MARK: - Frame Parsing
    init(identifier: FrameIdentifier,
         version: Version,
         size: Int,
         flags: Data,
         payload: Data
    ) throws {
        var data = payload
        // Since url frames do not use an encoding byte, we will parse without one for those
        if identifier.parseAs == .url {
            self.stringValue = try String(ascii: payload)
        } else if identifier.parseAs == .boolean {
            // since the compilation frame is technically a string frame, it may contain a "boolean-esque" string, like "true" or "yes". We will attempt to catch those cases as well.
            self.stringValue = try data.extractAndDecodeStringFromBoolean()
        } else {
            // everything else is handled as a string (or numeric string)
            self.stringValue = try data.extractAndDecodeString()
        }
        super.init(identifier: identifier,
                   version: version,
                   size: size,
                   flags: flags)
    }
    
    /// Encodes the contents of the frame, without any header data
    /// Returns: The frame's contents as `data`
    override var contentData: Data {
        var data = Data()
        if self.identifier.parseAs == .url {
            data.append(stringValue.encodedASCII)
        } else {
            let encoding = String.Encoding.isoLatin1
            data.append(encoding.encodingByte)
            data.append(stringValue.encodedISOLatin1)
        }
        return data
    }
    
    /// Returns the frame's unique identifier
    override func frameKey(version: Version) throws -> String {
        return try self.identifier.frameKey(additionalID: nil)
    }
    
    // MARK: - Frame creation
    /// Instantiate a `StringFrame` from its content
    /// - Parameters:
    ///   - identifier: The frame's four-character identifier
    ///   - version: the ID3 version of the frame
    ///   - stringValue: the frame's payload/content
    init(_ identifier: FrameIdentifier,
         version: Version,
         stringValue: String) {
        // initialize the contentString property
        self.stringValue = stringValue
        // use the default flags
        let flags = version.defaultFlags
        var size = Int()
        if identifier.parseAs == .url {
            size = stringValue.encodedASCII.count
        } else {
            size = stringValue.encodedISOLatin1.count + 1 // encoding byte
        }
        super.init(identifier: identifier,
                   version: version,
                   size: size,
                   flags: flags)
    }
}
//
//// MARK: - Tag extension
///* get and set functions for `StringFrame` frame types. Each individual frame of this type will have its own get-set property that will call these functions using its `FrameKey` property and relevant data */
//extension Tag {
//
//    /// Instantiates parsing operation to retrieve a frame's contents from a `Tag`
//    /// Parameter frameKey: The unique identifier of the frame
//    /// Returns: The frame's contents as a human-readable, unterminated string
//    internal func get(forStringFrame frameKey: FrameKey) -> String? {
//        // check that the frame is a String Frame
//        if let frame = self.frames[frameKey],
//           case .stringFrame(let stringFrame) = frame {
//            // get the contentString from the frame data
//            return stringFrame.contentString
//        } else {
//            return nil
//        }
//    }
//
//    internal func get(forIntFrame frameKey: FrameKey) -> Int? {
//        if let frame = self.frames[frameKey],
//           case .stringFrame(let stringFrame) = frame {
//            // get the contentString from the frame data and convert it to an Int
//            let contentString = stringFrame.contentString
//            return Int(contentString)
//        } else {
//            return nil
//        }
//    }
//
//    /// Adds the contents of a frame to a `Tag` instance
//    /// Parameters:
//    ///   layout: The frame's layout identifier, necessary to initialize the frame
//    ///   frameKey: The frame's unique identifier
//    ///   string: The string content input by the user
//    internal mutating func set(_ layout: FrameLayoutIdentifier,
//                               _ frameKey: FrameKey,
//                               to string: String?) {
//        // call the StringFrame initializer
//        if let stringValue = string {
//            let frame = StringFrame(
//                layout,
//                contentString: stringValue)
//            self.frames[frameKey] = .stringFrame(frame)
//        } else {
//            self.frames[frameKey] = nil
//        }
//    }
//
//    /// Series title getter-setter. Writes to `ContentGroup` frame,
//    /// ID3 Identifier: `TT1`/`TIT1`.
//    ///
//    /// If another frame of this type already exists, only one will be written.
//    public var series: String? {
//        get { get(forStringFrame: .series) }
//        set {
//            if let new = newValue {
//                set(.known(.contentGroup), .series, to: new)
//            } else {
//                set(.known(.contentGroup), .series, to: nil)
//            }
//        }
//    }
//
//    /// Album frame getter-setter. ID3 Identifier: `TAL`/`TALB`
//    public var album: String? {
//        get { get(forStringFrame: .album) }
//        set {
//            if let new = newValue {
//                set(.known(.album), .album, to: new)
//            } else {
//                set(.known(.album), .album, to: nil) }
//        }
//    }
//
//    ///  AlbumArtist frame getter-setter. ID3 Identifier: `TP2`/`TPE2`
//    public var albumArtist: String? {
//        get { get(forStringFrame: .albumArtist) }
//        set {
//            if let new = newValue {
//                set(.known(.albumArtist), .albumArtist, to: new)
//            } else {
//                set(.known(.albumArtist), .albumArtist, to: nil) }
//        }
//    }
//
//    /// AlbumSort frame getter-setter. ID3 Identifier: `TSA`/`TSOA`
//    public var albumSort: String? {
//        get { get(forStringFrame: .albumSort) }
//        set {
//            if let new = newValue {
//                set(.known(.albumSort), .albumSort, to: new)
//            } else {
//                set(.known(.albumSort), .albumSort, to: nil) }
//        }
//    }
//
//    /// AlbumArtistSort frame getter-setter. ID3 Identifier: `TS2`/`TSO2`
//    public var albumArtistSort: String? {
//        get { get(forStringFrame: .albumArtistSort) }
//        set {
//            if let new = newValue {
//                set(.known(.albumArtistSort), .albumArtistSort, to: new)
//            } else {
//                set(.known(.albumArtistSort), .albumArtistSort, to: nil) }
//        }
//    }
//
//    /// Arranger/Remixer/InterpretedBy getter-setter. ID3 Identifier: `TP4`/`TPE4`.
//    ///
//    /// If another frame of this type already exists, only one will be written.
//    public var arranger: String? {
//        get { get(forStringFrame: .arranger) }
//        set {
//            if let new = newValue {
//                set(.known(.arranger), .arranger, to: new)
//            } else {
//                set(.known(.arranger), .arranger, to: nil)
//            }
//        }
//    }
//
//    /// Arranger/Remixer/InterpretedBy getter-setter. ID3 Identifier: `TP4`/`TPE4`
//    ///
//    /// If another frame of this type already exists, only one will be written.
//    public var remixer: String? {
//        get { get(forStringFrame: .remixer) }
//        set {
//            if let new = newValue {
//                set(.known(.arranger), .remixer, to: new)
//            } else {
//                set(.known(.arranger), .remixer, to: nil)
//            }
//        }
//    }
//
//    /// Arranger/Remixer/InterpretedBy getter-setter. ID3 Identifier: `TP4`/`TPE4`
//    ///
//    /// If another frame of this type already exists, only one will be written.
//    public var interpretedBy: String? {
//        get { get(forStringFrame: .interpretedBy) }
//        set {
//            if let new = newValue {
//                set(.known(.arranger), .interpretedBy, to: new)
//            } else {
//                set(.known(.arranger), .interpretedBy, to: nil) }
//        }
//    }
//
//    /// Artist getter-setter. ID3 Identifier: `TP1`/`TPE1`
//    public var artist: String? {
//        get { get(forStringFrame: .artist) }
//        set {
//            if let new = newValue {
//                set(.known(.artist), .artist, to: new)
//            } else {
//                set(.known(.artist), .artist, to: nil)
//            }
//        }
//    }
//
//    /// ArtistSort getter-setter. ID3 Identifier: `TSP`/`TSOP`
//    public var artistSort: String? {
//        get { get(forStringFrame: .artistSort) }
//        set {
//            if let new = newValue {
//                set(.known(.artistSort), .artistSort, to: new)
//            } else {
//                set(.known(.artistSort), .artistSort, to: nil)
//            }
//        }
//    }
//
//    /// Author getter-setter. Writes to `Artist` frame, ID3 Identifier: `TP1`/`TPE1`.
//    ///
//    /// If another frame of this type already exists, only one will be written.
//    public var author: String? {
//        get { get(forStringFrame: .author) }
//        set {
//            if let new = newValue {
//                set(.known(.artist), .author, to: new)
//            } else {
//                set(.known(.artist), .author, to: nil)
//            }
//        }
//    }
//
//    /// AuthorSort getter-setter. Writes to `ArtistSort` frame, ID3 Identifier: `TSP`/`TSOP`.
//    ///
//    /// If another frame of this type already exists, only one will be written.
//    public var authorSort: String? {
//        get { get(forStringFrame: .authorSort) }
//        set {
//            if let new = newValue {
//                set(.known(.artistSort), .authorSort, to: new)
//            } else {
//                set(.known(.artistSort), .authorSort, to: nil)
//            }
//        }
//    }
//
//    /// Composer getter-setter. ID3 Identifier: `TCM`/`TCOM`
//    public var composer: String? {
//        get { get(forStringFrame: .composer) }
//        set {
//            if let new = newValue {
//                set(.known(.composer), .composer, to: new)
//            } else {
//                set(.known(.composer), .composer, to: nil)
//            }
//        }
//    }
//
//    /// ComposerSort getter-setter. ID3 Identifier: `TSC`/`TSOC`
//    public var composerSort: String? {
//        get { get(forStringFrame: .composerSort) }
//        set {
//            if let new = newValue {
//                set(.known(.composerSort), .composerSort, to: new)
//            } else {
//                set(.known(.composerSort), .composerSort, to: nil) }
//        }
//    }
//
//    /// Narrator getter-setter. Writes to `Composer` frame, ID3 Identifier: `TCM`/`TCOM`.
//    ///
//    /// If another frame of this type already exists, only one will be written.
//    public var narrator: String? {
//        get { get(forStringFrame: .narrator) }
//        set {
//            if let new = newValue {
//                set(.known(.composer), .narrator, to: new)
//            } else {
//                set(.known(.composer), .narrator, to: nil)
//            }
//        }
//    }
//
//    /// NarratorSort getter-setter. Writes to `ComposerSort` frame,
//    /// ID3 Identifier: `TSC`/`TSOC`.
//    ///
//    /// If another frame of this type already exists, only one will be written.
//    public var narratorSort: String? {
//        get { get(forStringFrame: .narratorSort) }
//        set {
//            if let new = newValue {
//                set(.known(.composerSort), .narratorSort, to: new)
//            } else {
//                set(.known(.composerSort), .narratorSort, to: nil) }
//        }
//    }
//
//    /// Conductor getter-setter. ID3 Identifier: `TP3`/`TPE3`
//    public var conductor: String? {
//        get { get(forStringFrame: .conductor) }
//        set {
//            if let new = newValue {
//                set(.known(.conductor), .conductor, to: new)
//            } else {
//                set(.known(.conductor), .conductor, to: nil)
//            }
//        }
//    }
//
//    /// ContentGroup getter-setter. ID3 Identifier: `TT1`/`TIT1`
//    public var contentGroup: String? {
//        get { get(forStringFrame: .contentGroup) }
//        set {
//            if let new = newValue {
//                set(.known(.contentGroup), .contentGroup, to: new)
//            } else {
//                set(.known(.contentGroup), .contentGroup, to: nil) }
//        }
//    }
//
//    /// WorkName getter-setter. Writes to `ContentGroup` frame,
//    /// ID3 Identifier: `TT1`/`TIT1`.
//    ///
//    /// If another frame of this type already exists, only one will be written.
//    public var work: String? {
//        get { get(forStringFrame: .work) }
//        set {
//            if let new = newValue {
//                set(.known(.contentGroup), .work, to: new)
//            } else {
//                set(.known(.contentGroup), .work, to: nil) }
//        }
//    }
//
//    /// Copyright getter-setter. ID3 Identifier: `TCR`/`TCOP`
//    public var copyright: String? {
//        get { get(forStringFrame: .copyright) }
//        set {
//            if let new = newValue {
//                set(.known(.copyright), .copyright, to: new)
//            } else {
//                set(.known(.copyright), .copyright, to: nil) }
//        }
//    }
//
//    /// EncodedBy getter-setter. ID3 Identifier: `TEN`/`TENC`
//    public var encodedBy: String? {
//        get { get(forStringFrame: .encodedBy) }
//        set {
//            if let new = newValue {
//                set(.known(.encodedBy), .encodedBy, to: new)
//            } else {
//                set(.known(.encodedBy), .encodedBy, to: nil) }
//        }
//    }
//
//    /// EncodingSettings getter-setter. ID3 Identifier: `TSS`/`TSSE`
//    public var encodingSettings: String? {
//        get { get(forStringFrame: .encodingSettings) }
//        set {
//            if let new = newValue {
//                set(.known(.encodingSettings), .encodingSettings, to: new)
//            } else {
//                set(.known(.encodingSettings), .encodingSettings, to: nil) }
//        }
//    }
//
//    /// FileOwner getter-setter. ID3 Identifier: `TOWN`. Valid only for tag versions 2.3/2.4
//    public var fileOwner: String? {
//        get { get(forStringFrame: .fileOwner) }
//        set {
//            if let new = newValue {
//                set(.known(.fileOwner), .fileOwner, to: new)
//            } else {
//                set(.known(.fileOwner), .fileOwner, to: nil) }
//        }
//    }
//
//    /// Grouping getter-setter. This is a non-standard, iTunes compliant frame.
//    /// ID3 Identifier: `GRP1`
//    public var grouping: String? {
//        get { get(forStringFrame: .grouping) }
//        set {
//            if let new = newValue {
//                set(.known(.grouping), .grouping, to: new)
//            } else {
//                set(.known(.grouping), .grouping, to: nil) }
//        }
//    }
//
//    /// InitialKey getter-setter. ID3 Identifier: `TKE`/`TKEY`
//    public var initialKey: KeySignature? {
//        get { return KeySignature(rawValue: get(forStringFrame: .initialKey) ?? "") ?? .unknown
//        }
//        set { set(.known(.initialKey), .initialKey, to: newValue?.rawValue ?? "")
//        }
//    }
//
//    /// Lyricist getter-setter. ID3 Identifier: `TXT`/`TEXT`
//    public var lyricist: String? {
//        get { get(forStringFrame: .lyricist) }
//        set {
//            if let new = newValue {
//                set(.known(.lyricist), .lyricist, to: new)
//            } else {
//                set(.known(.lyricist), .lyricist, to: nil)
//            }
//        }
//    }
//
//    /// Mood getter-setter. ID3 Identifier: `TMOO`. Valid only for tag version 2.4
//    public var mood: String? {
//        get { get(forStringFrame: .mood) }
//        set {
//            if let new = newValue {
//                set(.known(.mood), .mood, to: new)
//            } else {
//                set(.known(.mood), .mood, to: nil) }
//        }
//    }
//
//    /// MovementName getter-setter. This is a non-standard, iTunes compliant frame
//    /// ID3 Identifier: `MVNM`.
//    public var movementName: String? {
//        get { get(forStringFrame: .movementName) }
//        set {
//            if let new = newValue {
//                set(.known(.movementName), .movementName, to: new)
//            } else {
//                set(.known(.movementName), .movementName, to: nil) }
//        }
//    }
//
//    /// OriginalAlbum getter-setter. ID3 Identifier: `TOT`/`TOAL`.
//    public var originalAlbum: String? {
//        get { get(forStringFrame: .originalAlbum) }
//        set {
//            if let new = newValue {
//                set(.known(.originalAlbum), .originalAlbum, to: new)
//            } else {
//                set(.known(.originalAlbum), .originalAlbum, to: nil) }
//        }
//    }
//
//    /// OriginalArtist getter-setter. ID3 Identifier: `TOP`/`TOPE`.
//    public var originalArtist: String? {
//        get { get(forStringFrame: .originalArtist) }
//        set {
//            if let new = newValue {
//                set(.known(.originalArtist), .originalArtist, to: new)
//            } else {
//                set(.known(.originalArtist), .originalArtist, to: nil) }
//        }
//    }
//
//    /// OriginalFilename getter-setter. ID3 Identifier: `TOF`/`TOFN`.
//    public var originalFilename: String? {
//        get { get(forStringFrame: .originalFilename) }
//        set {
//            if let new = newValue {
//                set(.known(.originalFilename), .originalFilename, to: new)
//            } else {
//                set(.known(.originalFilename), .originalFilename, to: nil) }
//        }
//    }
//
//    /// OriginalLyricist getter-setter. ID3 Identifier: `TOL`/`TOLY`.
//    public var originalLyricist: String? {
//        get { get(forStringFrame: .originalLyricist) }
//        set {
//            if let new = newValue {
//                set(.known(.originalLyricist), .originalLyricist, to: new)
//            } else {
//                set(.known(.originalLyricist), .originalLyricist, to: nil) }
//        }
//    }
//
//    /// PodcastCategory getter-setter. This is a non-standard, iTunes compliant frame
//    /// ID3 Identifier: `TCAT`.
//    public var podcastCategory: String? {
//        get { get(forStringFrame: .podcastCategory) }
//        set {
//            if let new = newValue {
//                set(.known(.podcastCategory), .podcastCategory, to: new)
//            } else {
//                set(.known(.podcastCategory), .podcastCategory, to: nil) }
//        }
//    }
//
//    /// PodcastDescription getter-setter. This is a non-standard, iTunes compliant frame
//    /// ID3 Identifier: `TDES`.
//    public var podcastDescription: String? {
//        get { get(forStringFrame: .podcastDescription) }
//        set {
//            if let new = newValue {
//                set(.known(.podcastDescription), .podcastDescription, to: new)
//            } else {
//                set(.known(.podcastDescription), .podcastDescription, to: nil) }
//        }
//    }
//
//    /// PodcastID getter-setter. This is a non-standard, iTunes compliant frame
//    /// ID3 Identifier: `TGID`.
//    public var podcastID: String? {
//        get { get(forStringFrame: .podcastID) }
//        set {
//            if let new = newValue {
//                set(.known(.podcastID), .podcastID, to: new)
//            } else {
//                set(.known(.podcastID), .podcastID, to: nil) }
//        }
//    }
//
//    /// PodcastKeywords getter-setter. This is a non-standard, iTunes compliant frame
//    /// ID3 Identifier: `TKWD`.
//    public var podcastKeywords: String? {
//        get { get(forStringFrame: .podcastKeywords) }
//        set {
//            if let new = newValue {
//                set(.known(.podcastKeywords), .podcastKeywords, to: new)
//            } else {
//                set(.known(.podcastKeywords), .podcastKeywords, to: nil) }
//        }
//    }
//
//    /// PodcastFeedLink getter-setter. This is a non-standard, iTunes compliant frame
//    /// ID3 Identifier: `WFED`.
//    public var podcastFeedLink: String? {
//        get { get(forStringFrame: .podcastFeedLink) }
//        set {
//            if let new = newValue {
//                set(.known(.podcastFeedLink), .podcastFeedLink, to: new)
//            } else {
//                set(.known(.podcastFeedLink), .podcastFeedLink, to: nil) }
//        }
//    }
//
//    /// ProducedNotice getter-setter. ID3 Identifier: `TPRO`.
//    public var producedNotice: String? {
//        get { get(forStringFrame: .producedNotice) }
//        set {
//            if let new = newValue {
//                set(.known(.producedNotice), .producedNotice, to: new)
//            } else {
//                set(.known(.producedNotice), .producedNotice, to: nil) }
//        }
//    }
//
//    /// Publisher getter-setter. ID3 Identifier: `TPB`/`TPUB`.
//    public var publisher: String? {
//        get { get(forStringFrame: .publisher) }
//        set {
//            if let new = newValue {
//                set(.known(.publisher), .publisher, to: new)
//            } else {
//                set(.known(.publisher), .publisher, to: nil)
//            }
//        }
//    }
//
//    /// Label getter-setter. Writes to `Publisher` frame,
//    /// ID3 Identifier: `TPB`/`TPUB`.
//    ///
//    /// If another frame of this type already exists, only one will be written.
//    public var label: String? {
//        get { get(forStringFrame: .label) }
//        set {
//            if let new = newValue {
//                set(.known(.publisher), .label, to: new)
//            } else {
//                set(.known(.publisher), .label, to: nil) }
//        }
//    }
//
//    /// RecordCompany getter-setter. Writes to `Publisher` frame,
//    /// ID3 Identifier: `TPB`/`TPUB`.
//    ///
//    /// If another frame of this type already exists, only one will be written.
//    public var recordCompany: String? {
//        get { get(forStringFrame: .recordCompany) }
//        set {
//            if let new = newValue {
//                set(.known(.publisher), .recordCompany, to: new)
//            } else {
//                set(.known(.publisher), .recordCompany, to: nil) }
//        }
//    }
//
//    /// Studio getter-setter. Writes to `Publisher` frame,
//    /// ID3 Identifier: `TPB`/`TPUB`.
//    ///
//    /// If another frame of this type already exists, only one will be written.
//    public var studio: String? {
//        get { get(forStringFrame: .studio) }
//        set {
//            if let new = newValue {
//                set(.known(.publisher), .studio, to: new)
//            } else {
//                set(.known(.publisher), .studio, to: nil) }
//        }
//    }
//
//    /// (Internet)RadioStation getter-setter. ID3 Identifier: `TRS`/`TRSN`.
//    public var radioStation: String? {
//        get { get(forStringFrame: .radioStation) }
//        set {
//            if let new = newValue {
//                set(.known(.radioStation), .radioStation, to: new)
//            } else {
//                set(.known(.radioStation), .radioStation, to: nil) }
//        }
//    }
//
//    /// (Internet)RadioStationOwner getter-setter. ID3 Identifier: `TRO`/`TRSO`.
//    public var radioStationOwner: String? {
//        get { get(forStringFrame: .radioStationOwner) }
//        set {
//            if let new = newValue {
//                set(.known(.radioStationOwner), .radioStationOwner, to: new)
//            } else {
//                set(.known(.radioStationOwner), .radioStationOwner, to: nil) }
//        }
//    }
//
//    /// SetSubtitle getter-setter. ID3 Identifier: `TSST`.
//    public var setSubtitle: String? {
//        get { get(forStringFrame: .setSubtitle) }
//        set {
//            if let new = newValue {
//                set(.known(.setSubtitle), .setSubtitle, to: new)
//            } else {
//                set(.known(.setSubtitle), .setSubtitle, to: nil) }
//        }
//    }
//
//    /// Subtitle getter-setter. ID3 Identifier: `TT3`/`TIT3`
//    public var subtitle: String? {
//        get { get(forStringFrame: .subtitle) }
//        set {
//            if let new = newValue {
//                set(.known(.subtitle), .subtitle, to: new)
//            } else {
//                set(.known(.subtitle), .subtitle, to: nil) }
//        }
//    }
//
//    /// Title getter-setter. ID3 Identifier: `TT2`/`TIT2`
//    public var title: String? {
//        get { get(forStringFrame: .title) }
//        set {
//            if let new = newValue {
//                set(.known(.title), .title, to: new)
//            } else {
//                set(.known(.title), .title, to: nil) }
//        }
//    }
//
//    /// TitleSort getter-setter. ID3 Identifier: `TST`/`TSOT`
//    public var titleSort: String? {
//        get { get(forStringFrame: .titleSort) }
//        set {
//            if let new = newValue {
//                set(.known(.titleSort), .titleSort, to: new)
//            } else {
//                set(.known(.titleSort), .titleSort, to: nil) }
//        }
//    }
//    /// ArtistWebpage getter-setter. ID3 Identifier: `WAR`/`WOAR`
//    public var artistWebpage: String? {
//        get { get(forStringFrame: .artistWebpage) }
//        set {
//            if let new = newValue {
//                set(.known(.artistWebpage), .artistWebpage, to: new)
//            } else {
//                set(.known(.artistWebpage), .artistWebpage, to: nil)
//            }
//        }
//    }
//
//    /// (Official)AudioFileWebpage getter-setter. ID3 Identifier: `WAF`/`WOAF`
//    public var audioFileWebpage: String? {
//        get { get(forStringFrame: .audioFileWebpage) }
//        set {
//            if let new = newValue {
//                set(.known(.audioFileWebpage), .audioFileWebpage, to: new)
//            } else {
//                set(.known(.audioFileWebpage), .audioFileWebpage, to: nil)
//            }
//        }
//    }
//
//    /// (Official)AudioSourceWebpage getter-setter. ID3 Identifier: `WAS`/`WOAS`
//    public var audioSourceWebpage: String? {
//        get { get(forStringFrame: .audioSourceWebpage) }
//        set {
//            if let new = newValue {
//                set(.known(.audioSourceWebpage), .audioSourceWebpage, to: new)
//            } else {
//                set(.known(.audioSourceWebpage), .audioSourceWebpage, to: nil)
//            }
//        }
//    }
//
//    /// Copyright/Legal Information Webpage getter-setter. ID3 Identifier: `WCP`/`WCOP`
//    public var copyrightWebpage: String? {
//        get { get(forStringFrame: .copyrightWebpage) }
//        set {
//            if let new = newValue {
//                set(.known(.copyrightWebpage), .copyrightWebpage, to: new)
//            } else {
//                set(.known(.copyrightWebpage), .copyrightWebpage, to: nil)
//            }
//        }
//    }
//
//    /// PaymentWebpage getter-setter. ID3 Identifier: `WPAY`
//    public var paymentWebpage: String? {
//        get { get(forStringFrame: .paymentWebpage) }
//        set {
//            if let new = newValue {
//                set(.known(.paymentWebpage), .paymentWebpage, to: new)
//            } else {
//                set(.known(.paymentWebpage), .paymentWebpage, to: nil)
//            }
//        }
//    }
//
//    /// PublisherWebpage getter-setter. ID3 Identifier: `WPB`/`WPUB`
//    public var publisherWebpage: String? {
//        get { get(forStringFrame: .publisherWebpage) }
//        set {
//            if let new = newValue {
//                set(.known(.publisherWebpage), .publisherWebpage, to: new)
//            } else {
//                set(.known(.publisherWebpage), .publisherWebpage, to: nil)
//            }
//        }
//    }
//
//    /// (Official Internet)RadioStationWebpage getter-setter. ID3 Identifier: `WRS`/`WORS`
//    public var radioStationWebpage: String? {
//        get { get(forStringFrame: .radioStationWebpage) }
//        set {
//            if let new = newValue {
//                set(.known(.radioStationWebpage), .radioStationWebpage, to: new)
//            } else {
//                set(.known(.radioStationWebpage), .radioStationWebpage, to: nil)
//            }
//        }
//    }
//
//    /// BeatsPerMinute getter-setter. ID3 Identifier: `TBP`/`TBPM`
//    public var bpm: Int? {
//        get { get(forIntFrame: .bpm) }
//        set {
//            if let new = newValue {
//                set(.known(.bpm), .bpm, to: String(new))
//            } else {
//                set(.known(.bpm), .bpm, to: nil)
//            }
//        }
//
//    }
//
//    /// IRSC getter-setter. ID3 Identifier: `TRC`/`TSRC`
//    public var isrc: String? {
//        get { get(forStringFrame: .isrc) }
//        set {
//            if let new = newValue {
//                set(.known(.isrc), .isrc, to: new)
//            } else {
//                set(.known(.isrc), .isrc, to: nil)
//            }
//        }
//    }
//
//    /// Length getter-setter. ID3 Identifier: `TLE`/`TLEN`
//    public var length: Int? {
//        get { self.mp3Duration }
//        set { set(.known(.length), .length, to: String(self.mp3Duration ?? 0)) }
//    }
//
//    /// TotalMovements getter-setter. This is a non-standard, iTunes non-standard frame
//    /// ID3 Identifier: `MVCN`.
//    public var totalMovements: Int? {
//        get { get(forIntFrame: .movementCount) }
//        set {
//            if let new = newValue {
//                set(.known(.movementCount), .movementCount, to: String(new))
//            } else {
//                set(.known(.movementCount), .movementCount, to: nil)
//            }
//        }
//
//    }
//
//    /// MovementNumber getter-setter. This is a non-standard, iTunes non-standard frame
//    /// ID3 Identifier: `MVIN`.
//    public var movementNumber: Int? {
//        get { get(forIntFrame: .movementNumber) }
//        set {
//            if let new = newValue {
//                set(.known(.movementNumber), .movementNumber, to: String(new))
//            } else {
//                set(.known(.movementNumber), .movementNumber, to: nil)
//            }
//        }
//    }
//
//    /// PlaylistDelay getter-setter. ID3 Identifier: `TDY`/`TDLY`
//    public var playlistDelay: Int? {
//        get { get(forIntFrame: .playlistDelay) }
//        set {
//            if let new = newValue {
//                set(.known(.playlistDelay), .playlistDelay, to: String(new))
//            } else {
//                set(.known(.playlistDelay), .playlistDelay, to: nil)
//            }
//        }
//    }
//
//    /// Compilation (flag) getter-setter. ID3 identifier: `TCP`/`TCMP`. iTunes non-standard frame
//    public var compilation: Bool? {
//        get {
//            let intValue = get(forIntFrame: .compilation)
//            if intValue == 1 {
//                return true
//            } else if intValue == 0 {
//                return false
//            } else {
//                return nil
//            }
//        }
//        set {
//            if newValue == true {
//                set(.known(.compilation), .compilation, to: "1")
//            } else if newValue == false {
//                set(.known(.compilation), .compilation, to: "0")
//            } else {
//                set(.known(.compilation), .compilation, to: nil)
//            }
//        }
//    }
//}
