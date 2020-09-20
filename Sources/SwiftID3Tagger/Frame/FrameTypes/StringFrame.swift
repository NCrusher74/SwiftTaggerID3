/*
 
 StringFrame.swift
 SwiftTaggerID3
 
 Copyright ©2020 Nolaine Crusher. All rights reserved.
 
 */

/*
 The text information frames are often the most important frames,
 containing information like artist, album and more. There may only be
 one text information frame of its kind in an tag. All text
 information frames supports multiple strings, stored as a null
 separated list, where null is reperesented by the termination code
 for the charater encoding. All text frame identifiers begin with "T".
 Only text frame identifiers begin with "T", with the exception of the
 "TXXX" frame. All the text information frames have the following
 format:
 
 <Header for 'Text information frame', ID: "T000" - "TZZZ",
 excluding "TXXX" described in 4.2.6.>
 Text encoding                $xx
 Information                  <text string(s) according to encoding>
 */

import Foundation
import SwiftLanguageAndLocaleCodes
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
        } else {
            let encoding = try data.extractEncoding()
            if identifier.parseAs == .boolean {
                // since the compilation frame is technically a string frame, it may contain a "boolean-esque" string, like "true" or "yes". We will attempt to catch those cases as well.
                self.stringValue = try data.extractAndDecodeStringFromBoolean(encoding: encoding)
            } else {
                // everything else is handled as a string (or numeric string)
                self.stringValue = try data.extractAndDecodeString(encoding: encoding)
            }
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

        let size: Int
        if identifier.parseAs == .url {
            size = stringValue.encodedASCII.count
        } else {
            size = stringValue.encodedISOLatin1.count + 1 // encoding byte
        }

        // use the default flags
        let flags = version.defaultFlags
        super.init(identifier: identifier,
                   version: version,
                   size: size,
                   flags: flags)
    }
}

// MARK: - Tag extension
/* get and set functions for `StringFrame` frame types. Each individual frame of this type will have its own get-set property that will call these functions using its `FrameKey` property and relevant data */
extension Tag {

    /// Instantiates parsing operation to retrieve a frame's contents from a `Tag`
    /// Parameter frameKey: The unique identifier of the frame
    /// Returns: The frame's contents as a human-readable, unterminated string
    func get(_ identifier: FrameIdentifier) -> String? {
        // check that the frame is a String Frame
        if let frame = self.frames[identifier.frameKey(nil)] as? StringFrame {
            // get the contentString from the frame data
            return frame.stringValue
        } else {
            return nil
        }
    }

    /// Adds the contents of a frame to a `Tag` instance
    /// Parameters:
    ///   layout: The frame's layout identifier, necessary to initialize the frame
    ///   frameKey: The frame's unique identifier
    ///   string: The string content input by the user
    mutating func set(_ identifier: FrameIdentifier,
                               stringValue: String?) {
        let frameKey = identifier.frameKey(nil)
        if let stringValue = stringValue {
            let frame = StringFrame(identifier,
                                    version: self.version,
                                    stringValue: stringValue)
            self.frames[frameKey] = frame
        } else {
            self.frames[frameKey] = nil
        }
    }

    /// Album frame getter-setter. ID3 Identifier: `TAL`/`TALB`
    public var album: String? {
        get { get(.known(.album)) }
        set {
            if let new = newValue {
                set(.known(.album), stringValue: new)
            } else {
                set(.known(.album), stringValue: nil)
            }
        }
    }

    ///  AlbumArtist frame getter-setter. ID3 Identifier: `TP2`/`TPE2`
    public var albumArtist: String? {
        get { get(.known(.albumArtist)) }
        set {
            if let new = newValue {
                set(.known(.albumArtist), stringValue: new)
            } else {
                set(.known(.albumArtist), stringValue: nil)
            }
        }
    }

    /// AlbumSort frame getter-setter. ID3 Identifier: `TSA`/`TSOA`
    public var albumSort: String? {
        get { get(.known(.albumSort)) }
        set {
            if let new = newValue {
                set(.known(.albumSort), stringValue: new)
            } else {
                set(.known(.albumSort), stringValue: nil)
            }
        }
    }

    /// AlbumArtistSort frame getter-setter. ID3 Identifier: `TS2`/`TSO2`
    public var albumArtistSort: String? {
        get { get(.known(.albumArtistSort)) }
        set {
            if let new = newValue {
                set(.known(.albumArtistSort), stringValue: new)
            } else {
                set(.known(.albumArtistSort), stringValue: nil)
            }
        }
    }

    /// Arranger/Remixer/InterpretedBy getter-setter. ID3 Identifier: `TP4`/`TPE4`.
    ///
    /// If another frame of this type already exists, only one will be written.
    public var arranger: String? {
        get { get(.known(.arranger)) }
        set {
            if let new = newValue {
                set(.known(.arranger), stringValue: new)
            } else {
                set(.known(.arranger), stringValue: nil)
            }
        }
    }

    /// Artist getter-setter. ID3 Identifier: `TP1`/`TPE1`
    public var artist: String? {
        get { get(.known(.artist)) }
        set {
            if let new = newValue {
                set(.known(.artist), stringValue: new)
            } else {
                set(.known(.artist), stringValue: nil)
            }
        }
    }

    /// ArtistSort getter-setter. ID3 Identifier: `TSP`/`TSOP`
    public var artistSort: String? {
        get { get(.known(.artistSort)) }
        set {
            if let new = newValue {
                set(.known(.artistSort), stringValue: new)
            } else {
                set(.known(.artistSort), stringValue: nil)
            }
        }
    }

    /// Composer getter-setter. ID3 Identifier: `TCM`/`TCOM`
    public var composer: String? {
        get { get(.known(.composer)) }
        set {
            if let new = newValue {
                set(.known(.composer), stringValue: new)
            } else {
                set(.known(.composer), stringValue: nil)
            }
        }
    }

    /// ComposerSort getter-setter. ID3 Identifier: `TSC`/`TSOC`
    public var composerSort: String? {
        get { get(.known(.composerSort)) }
        set {
            if let new = newValue {
                set(.known(.composerSort), stringValue: new)
            } else {
                set(.known(.composerSort), stringValue: nil)
            }
        }
    }

    /// Author getter-setter.
    ///
    /// Writes to `artist` frame, ID3 Identifier: `TP1`/`TPE1`
    ///
    /// If another frame of this type already exists, only one will be written.
    public var author: String? {
        get { get(.known(.artist)) }
        set {
            if let new = newValue {
                set(.known(.artist), stringValue: new)
            } else {
                set(.known(.artist), stringValue: nil)
            }
        }
    }
    
    /// AuthorSort getter-setter.
    ///
    /// Writes to `artistSort` frame, ID3 Identifier: `TSP`/`TSOP`
    ///
    /// If another frame of this type already exists, only one will be written.
    public var authorSort: String? {
        get { get(.known(.artistSort)) }
        set {
            if let new = newValue {
                set(.known(.artistSort), stringValue: new)
            } else {
                set(.known(.artistSort), stringValue: nil)
            }
        }
    }
    
    /// narrator getter-setter.
    ///
    /// Writes to `composer` frame, ID3 Identifier: `TCM`/`TCOM`
    ///
    /// If another frame of this type already exists, only one will be written.
    public var narrator: String? {
        get { get(.known(.composer)) }
        set {
            if let new = newValue {
                set(.known(.composer), stringValue: new)
            } else {
                set(.known(.composer), stringValue: nil)
            }
        }
    }
    
    /// narratorSort getter-setter.
    ///
    /// Writes to `composerSort` frame, ID3 Identifier: `TSC`/`TSOC`
    ///
    /// If another frame of this type already exists, only one will be written.
    public var narratorSort: String? {
        get { get(.known(.composerSort)) }
        set {
            if let new = newValue {
                set(.known(.composerSort), stringValue: new)
            } else {
                set(.known(.composerSort), stringValue: nil)
            }
        }
    }

    /// Conductor getter-setter. ID3 Identifier: `TP3`/`TPE3`
    public var conductor: String? {
        get { get(.known(.conductor)) }
        set {
            if let new = newValue {
                set(.known(.conductor), stringValue: new)
            } else {
                set(.known(.conductor), stringValue: nil)
            }
        }
    }

    /// ContentGroup getter-setter. ID3 Identifier: `TT1`/`TIT1`
    public var contentGroup: String? {
        get { get(.known(.contentGroup)) }
        set {
            if let new = newValue {
                set(.known(.contentGroup), stringValue: new)
            } else {
                set(.known(.contentGroup), stringValue: nil)
            }
        }
    }

    /// WorkName getter-setter.
    ///
    /// Writes to `ContentGroup` frame, ID3 Identifier: `TT1`/`TIT1`.
    ///
    /// If another frame of this type already exists, only one will be written.
    public var work: String? {
        get { get(.known(.contentGroup)) }
        set {
            if let new = newValue {
                set(.known(.contentGroup), stringValue: new)
            } else {
                set(.known(.contentGroup), stringValue: nil)
            }
        }
    }

    /// Series getter-setter.
    ///
    /// Writes to `ContentGroup` frame, ID3 Identifier: `TT1`/`TIT1`.
    ///
    /// If another frame of this type already exists, only one will be written.
    public var series: String? {
        get { get(.known(.contentGroup)) }
        set {
            if let new = newValue {
                set(.known(.contentGroup), stringValue: new)
            } else {
                set(.known(.contentGroup), stringValue: nil)
            }
        }
    }

    /// Copyright getter-setter. ID3 Identifier: `TCR`/`TCOP`
    public var copyright: String? {
        get { get(.known(.copyright)) }
        set {
            if let new = newValue {
                set(.known(.copyright), stringValue: new)
            } else {
                set(.known(.copyright), stringValue: nil)
            }
        }
    }

    /// EncodedBy getter-setter. ID3 Identifier: `TEN`/`TENC`
    public var encodedBy: String? {
        get { get(.known(.encodedBy)) }
        set {
            if let new = newValue {
                set(.known(.encodedBy), stringValue: new)
            } else {
                set(.known(.encodedBy), stringValue: nil)
            }
        }
    }

    /// EncodingSettings getter-setter. ID3 Identifier: `TSS`/`TSSE`
    public var encodingSettings: String? {
        get { get(.known(.encodingSettings)) }
        set {
            if let new = newValue {
                set(.known(.encodingSettings), stringValue: new)
            } else {
                set(.known(.encodingSettings), stringValue: nil)
            }
        }
    }

    /// FileOwner getter-setter. ID3 Identifier: `TOWN`. Valid only for tag versions 2.3/2.4
    public var fileOwner: String? {
        get { get(.known(.fileOwner)) }
        set {
            if let new = newValue {
                set(.known(.fileOwner), stringValue: new)
            } else {
                set(.known(.fileOwner), stringValue: nil)
            }
        }
    }

    /// Grouping getter-setter. This is a non-standard, iTunes compliant frame.
    /// ID3 Identifier: `GRP1`
    public var grouping: String? {
        get { get(.known(.grouping)) }
        set {
            if let new = newValue {
                set(.known(.grouping), stringValue: new)
            } else {
                set(.known(.grouping), stringValue: nil)
            }
        }
    }

    /// InitialKey getter-setter. ID3 Identifier: `TKE`/`TKEY`
    public var initialKey: KeySignature? {
        get {
            if let string = get(.known(.initialKey)) {
                if let key = KeySignature(rawValue: string) {
                    return key
                } else {
                    return nil
                }
            } else {
                return nil
            }
        }
        set {
            if let new = newValue {
                let string = new.rawValue
                set(.known(.initialKey), stringValue: string)
            } else {
                set(.known(.initialKey), stringValue: nil)
            }
        }
    }

    /// Lyricist getter-setter. ID3 Identifier: `TXT`/`TEXT`
    public var lyricist: String? {
        get { get(.known(.lyricist)) }
        set {
            if let new = newValue {
                set(.known(.lyricist), stringValue: new)
            } else {
                set(.known(.lyricist), stringValue: nil)
            }
        }
    }

    /// Mood getter-setter. ID3 Identifier: `TMOO`. Valid only for tag version 2.4
    public var mood: String? {
        get { get(.known(.mood)) }
        set {
            if let new = newValue {
                set(.known(.mood), stringValue: new)
            } else {
                set(.known(.mood), stringValue: nil)
            }
        }
    }

    /// MovementName getter-setter. This is a non-standard, iTunes compliant frame
    /// ID3 Identifier: `MVNM`.
    public var movement: String? {
        get { get(.known(.movement)) }
        set {
            if let new = newValue {
                set(.known(.movement), stringValue: new)
            } else {
                set(.known(.movement), stringValue: nil)
            }
        }
    }

    /// OriginalAlbum getter-setter. ID3 Identifier: `TOT`/`TOAL`.
    public var originalAlbum: String? {
        get { get(.known(.originalAlbum)) }
        set {
            if let new = newValue {
                set(.known(.originalAlbum), stringValue: new)
            } else {
                set(.known(.originalAlbum), stringValue: nil)
            }
        }
    }

    /// OriginalArtist getter-setter. ID3 Identifier: `TOP`/`TOPE`.
    public var originalArtist: String? {
        get { get(.known(.originalArtist)) }
        set {
            if let new = newValue {
                set(.known(.originalArtist), stringValue: new)
            } else {
                set(.known(.originalArtist), stringValue: nil)
            }
        }
    }

    /// OriginalFilename getter-setter. ID3 Identifier: `TOF`/`TOFN`.
    public var originalFilename: String? {
        get { get(.known(.originalFilename)) }
        set {
            if let new = newValue {
                set(.known(.originalFilename), stringValue: new)
            } else {
                set(.known(.originalFilename), stringValue: nil)
            }
        }
    }

    /// OriginalLyricist getter-setter. ID3 Identifier: `TOL`/`TOLY`.
    public var originalLyricist: String? {
        get { get(.known(.originalLyricist)) }
        set {
            if let new = newValue {
                set(.known(.originalLyricist), stringValue: new)
            } else {
                set(.known(.originalLyricist), stringValue: nil)
            }
        }
    }

    /// PodcastCategory getter-setter. This is a non-standard, iTunes compliant frame
    /// ID3 Identifier: `TCAT`.
    public var podcastCategory: String? {
        get { get(.known(.podcastCategory)) }
        set {
            if let new = newValue {
                set(.known(.podcastCategory), stringValue: new)
            } else {
                set(.known(.podcastCategory), stringValue: nil)
            }
        }
    }

    /// PodcastDescription getter-setter. This is a non-standard, iTunes compliant frame
    /// ID3 Identifier: `TDES`.
    public var podcastDescription: String? {
        get { get(.known(.podcastDescription)) }
        set {
            if let new = newValue {
                set(.known(.podcastDescription), stringValue: new)
            } else {
                set(.known(.podcastDescription), stringValue: nil)
            }
        }
    }

    /// PodcastID getter-setter. This is a non-standard, iTunes compliant frame
    /// ID3 Identifier: `TGID`.
    public var podcastID: String? {
        get { get(.known(.podcastID)) }
        set {
            if let new = newValue {
                set(.known(.podcastID), stringValue: new)
            } else {
                set(.known(.podcastID), stringValue: nil)
            }
        }
    }

    /// PodcastKeywords getter-setter. This is a non-standard, iTunes compliant frame
    /// ID3 Identifier: `TKWD`.
    public var podcastKeywords: [String] {
        get {
            if let string = get(.known(.podcastKeywords)) {
                return string.toArray
            } else {
                return []
            }
        }
        set {
            if !newValue.isEmpty {
                set(.known(.podcastKeywords), stringValue: newValue.toString)
            } else {
                set(.known(.podcastKeywords), stringValue: nil)
            }
        }
    }

    public var languages: [ISO6392Code] {
        get {
            if let string = get(.known(.languages)) {
                let array = string.toArray
                var languages = [ISO6392Code]()
                for item in array {
                    if let code = ISO6392Code(rawValue: item) {
                        languages.append(code)
                    }
                }
                return languages
            } else {
                return []
            }
        }
        set {
            if !newValue.isEmpty {
                var strings = [String]()
                for item in newValue {
                    let string = item.rawValue
                    strings.append(string)
                }
                let stringValue = strings.toString
                set(.known(.languages), stringValue: stringValue)
            } else {
                set(.known(.languages), stringValue: nil)
            }
        }
    }
    
    /// PodcastFeedLink getter-setter. This is a non-standard, iTunes compliant frame
    /// ID3 Identifier: `WFED`.
    public var podcastFeed: String? {
        get { get(.known(.podcastFeed)) }
        set {
            if let new = newValue {
                set(.known(.podcastFeed), stringValue: new)
            } else {
                set(.known(.podcastFeed), stringValue: nil)
            }
        }
    }

    /// ProducedNotice getter-setter. ID3 Identifier: `TPRO`.
    public var producedNotice: String? {
        get { get(.known(.producedNotice)) }
        set {
            if let new = newValue {
                set(.known(.producedNotice), stringValue: new)
            } else {
                set(.known(.producedNotice), stringValue: nil)
            }
        }
    }

    /// Publisher getter-setter. ID3 Identifier: `TPB`/`TPUB`.
    public var publisher: String? {
        get { get(.known(.publisher)) }
        set {
            if let new = newValue {
                set(.known(.publisher), stringValue: new)
            } else {
                set(.known(.publisher), stringValue: nil)
            }
        }
    }

    /// Label getter-setter. Writes to `Publisher` frame,
    /// ID3 Identifier: `TPB`/`TPUB`.
    ///
    /// If another frame of this type already exists, only one will be written.
    public var label: String? {
        get { get(.known(.publisher)) }
        set {
            if let new = newValue {
                set(.known(.publisher), stringValue: new)
            } else {
                set(.known(.publisher), stringValue: nil)
            }
        }
    }

    /// RecordCompany getter-setter. Writes to `Publisher` frame,
    /// ID3 Identifier: `TPB`/`TPUB`.
    ///
    /// If another frame of this type already exists, only one will be written.
    public var recordCompany: String? {
        get { get(.known(.publisher)) }
        set {
            if let new = newValue {
                set(.known(.publisher), stringValue: new)
            } else {
                set(.known(.publisher), stringValue: nil)
            }
        }
    }

    /// Studio getter-setter. Writes to `Publisher` frame,
    /// ID3 Identifier: `TPB`/`TPUB`.
    ///
    /// If another frame of this type already exists, only one will be written.
    public var studio: String? {
        get { get(.known(.publisher)) }
        set {
            if let new = newValue {
                set(.known(.publisher), stringValue: new)
            } else {
                set(.known(.publisher), stringValue: nil)
            }
        }
    }

    /// (Internet)RadioStation getter-setter. ID3 Identifier: `TRS`/`TRSN`.
    public var radioStation: String? {
        get { get(.known(.radioStation)) }
        set {
            if let new = newValue {
                set(.known(.radioStation), stringValue: new)
            } else {
                set(.known(.radioStation), stringValue: nil)
            }
        }
    }

    /// (Internet)RadioStationOwner getter-setter. ID3 Identifier: `TRO`/`TRSO`.
    public var radioStationOwner: String? {
        get { get(.known(.radioStationOwner)) }
        set {
            if let new = newValue {
                set(.known(.radioStationOwner), stringValue: new)
            } else {
                set(.known(.radioStationOwner), stringValue: nil)
            }
        }
   }

    /// SetSubtitle getter-setter. ID3 Identifier: `TSST`.
    public var setSubtitle: String? {
        get { get(.known(.setSubtitle)) }
        set {
            if let new = newValue {
                set(.known(.setSubtitle), stringValue: new)
            } else {
                set(.known(.setSubtitle), stringValue: nil)
            }
        }
    }

    /// Subtitle getter-setter. ID3 Identifier: `TT3`/`TIT3`
    public var subtitle: String? {
        get { get(.known(.subtitle)) }
        set {
            if let new = newValue {
                set(.known(.subtitle), stringValue: new)
            } else {
                set(.known(.subtitle), stringValue: nil)
            }
        }
    }

    /// Title getter-setter. ID3 Identifier: `TT2`/`TIT2`
    public var title: String? {
        get { get(.known(.title)) }
        set {
            if let new = newValue {
                set(.known(.title), stringValue: new)
            } else {
                set(.known(.title), stringValue: nil)
            }
        }
    }

    /// TitleSort getter-setter. ID3 Identifier: `TST`/`TSOT`
    public var titleSort: String? {
        get { get(.known(.titleSort)) }
        set {
            if let new = newValue {
                set(.known(.titleSort), stringValue: new)
            } else {
                set(.known(.titleSort), stringValue: nil)
            }
        }
    }
    
    /// ArtistWebpage getter-setter. ID3 Identifier: `WAR`/`WOAR`
    public var artistWebpage: String? {
        get { get(.known(.artistWebpage)) }
        set {
            if let new = newValue {
                set(.known(.artistWebpage), stringValue: new)
            } else {
                set(.known(.artistWebpage), stringValue: nil)
            }
        }
    }

    /// (Official)AudioFileWebpage getter-setter. ID3 Identifier: `WAF`/`WOAF`
    public var audioFileWebpage: String? {
        get { get(.known(.audioFileWebpage)) }
        set {
            if let new = newValue {
                set(.known(.audioFileWebpage), stringValue: new)
            } else {
                set(.known(.audioFileWebpage), stringValue: nil)
            }
        }
    }

    /// (Official)AudioSourceWebpage getter-setter. ID3 Identifier: `WAS`/`WOAS`
    public var audioSourceWebpage: String? {
        get { get(.known(.audioSourceWebpage)) }
        set {
            if let new = newValue {
                set(.known(.audioSourceWebpage), stringValue: new)
            } else {
                set(.known(.audioSourceWebpage), stringValue: nil)
            }
        }
    }

    /// Copyright/Legal Information Webpage getter-setter. ID3 Identifier: `WCP`/`WCOP`
    public var copyrightWebpage: String? {
        get { get(.known(.copyrightWebpage)) }
        set {
            if let new = newValue {
                set(.known(.copyrightWebpage), stringValue: new)
            } else {
                set(.known(.copyrightWebpage), stringValue: nil)
            }
        }
    }

    /// PaymentWebpage getter-setter. ID3 Identifier: `WPAY`
    public var paymentWebpage: String? {
        get { get(.known(.paymentWebpage)) }
        set {
            if let new = newValue {
                set(.known(.paymentWebpage), stringValue: new)
            } else {
                set(.known(.paymentWebpage), stringValue: nil)
            }
        }
    }

    /// PublisherWebpage getter-setter. ID3 Identifier: `WPB`/`WPUB`
    public var publisherWebpage: String? {
        get { get(.known(.publisherWebpage)) }
        set {
            if let new = newValue {
                set(.known(.publisherWebpage), stringValue: new)
            } else {
                set(.known(.publisherWebpage), stringValue: nil)
            }
        }
   }

    /// (Official Internet)RadioStationWebpage getter-setter. ID3 Identifier: `WRS`/`WORS`
    public var radioStationWebpage: String? {
        get { get(.known(.radioStationWebpage)) }
        set {
            if let new = newValue {
                set(.known(.radioStationWebpage), stringValue: new)
            } else {
                set(.known(.radioStationWebpage), stringValue: nil)
            }
        }
   }

    /// BeatsPerMinute getter-setter. ID3 Identifier: `TBP`/`TBPM`
    public var bpm: Int? {
        get {
            if let string = get(.known(.bpm)) {
                if let int = Int(string) {
                    return int
                } else {
                    return nil
                }
            } else {
                return nil
            }
        }
        set {
            if let new = newValue {
                let string = String(new)
                set(.known(.bpm), stringValue: string)
            } else {
                set(.known(.bpm), stringValue: nil)
            }
        }
    }

    /// IRSC getter-setter. ID3 Identifier: `TRC`/`TSRC`
    public var isrc: String? {
        get { get(.known(.isrc)) }
        set {
            if let new = newValue {
                set(.known(.isrc), stringValue: new)
            } else {
                set(.known(.isrc), stringValue: nil)
            }
        }
    }

    /// Length getter. ID3 Identifier: `TLE`/`TLEN`
    ///
    /// This value is derived from the file data, and since SwiftTagger doesn't support editing anything other than metadata, it cannot be set to another value.
    public var length: Int {
        get {
            if let string = get(.known(.length)) {
                if let int = Int(string) {
                    return int
                } else {
                    return Tag.duration
                }
            } else {
                return Tag.duration
            }
        }
        set {
            let int = Tag.duration
            set(.known(.length), stringValue: String(int))
        }
    }

    /// TotalMovements getter-setter. This is a non-standard, iTunes non-standard frame
    /// ID3 Identifier: `MVCN`.
    public var movementCount: Int? {
        get {
            if let string = get(.known(.movementCount)) {
                if let int = Int(string) {
                    return int
                } else {
                    return nil
                }
            } else {
                return nil
            }
        }
        set {
            if let new = newValue {
                let string = String(new)
                set(.known(.movementCount), stringValue: string)
            } else {
                set(.known(.movementCount), stringValue: nil)
            }
        }
    }

    /// MovementNumber getter-setter. This is a non-standard, iTunes non-standard frame
    /// ID3 Identifier: `MVIN`.
    public var movementNumber: Int? {
        get {
            if let string = get(.known(.movementNumber)) {
                if let int = Int(string) {
                    return int
                } else {
                    return nil
                }
            } else {
                return nil
            }
        }
        set {
            if let new = newValue {
                let string = String(new)
                set(.known(.movementNumber), stringValue: string)
            } else {
                set(.known(.movementNumber), stringValue: nil)
            }
        }
    }

    /// Gapless Playback getter-setter. If true, sets `playlistDelay` to zero.
    ///
    /// ID3 Identifier: `TDY`/`TDLY`
    public var gaplessPlayback: Bool? {
        get {
            let bool: Bool
            if let string = get(.known(.playlistDelay)) {
                if let int = Int(string), int == 1 {
                    bool = true
                } else {
                    bool = false
                }
            } else {
                bool = false
            }
            return bool
        }
        set {
            if let new = newValue, new == true {
                self.playlistDelay = 0
            }
        }
    }

    /// PlaylistDelay getter-setter. ID3 Identifier: `TDY`/`TDLY`
    public var playlistDelay: Int? {
        get {
            if let string = get(.known(.playlistDelay)) {
                if let int = Int(string) {
                    return int
                } else {
                    return nil
                }
            } else {
                return nil
            }
        }
        set {
            if let new = newValue {
                let string = String(new)
                set(.known(.playlistDelay), stringValue: string)
            } else {
                set(.known(.playlistDelay), stringValue: nil)
            }
        }
    }

    /// Compilation (flag) getter-setter. ID3 identifier: `TCP`/`TCMP`. iTunes non-standard frame
    public var compilation: Bool? {
        get {
            let bool: Bool
            if let string = get(.known(.compilation)) {
                if let int = Int(string), int == 1 {
                    bool = true
                } else {
                    bool = false
                }
                return bool
            } else {
                return nil
            }
        }
        set {
            if let new = newValue, new == true {
                let string = "1"
                set(.known(.compilation), stringValue: string)
            } else if let new = newValue, new == false {
                let string = "0"
                set(.known(.compilation), stringValue: string)
            } else {
                set(.known(.compilation), stringValue: nil)
            }
        }
    }
}
