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

            if identifier == .languages {
                self.stringValue = data.extractNullTerminatedString(encoding) ?? "und"
            } else {
                if identifier.parseAs == .boolean {
                    // since the compilation frame is technically a string frame, it may contain a "boolean-esque" string, like "true" or "yes". We will attempt to catch those cases as well.
                    self.stringValue = data.decodeBooleanString(encoding)
                } else {
                    // everything else is handled as a string (or numeric string)
                    self.stringValue = data.decodeString(encoding)
                }
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
            data.append(stringValue.encodedISOLatin1)
        } else {
            let encoding = String.Encoding(string: stringValue)
            data.append(encoding.encodingByte)
            if self.identifier == .languages {
                let array = stringValue.toArray
                for language in array {
                    data.append(language.attemptTerminatedStringEncoding(encoding))
                }
            } else {
                data.append(stringValue.attemptStringEncoding(encoding))
            }
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
            size = stringValue.encodedISOLatin1.count
        } else {
            let encoding = String.Encoding(string: stringValue)
            size = (stringValue.attemptStringEncoding(encoding).count) + 1 // encoding byte
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
/// get and set functions for `StringFrame` frame types. Each individual frame of this type will have its own get-set property that will call these functions using its `FrameKey` property and relevant data
extension Tag {

    /// Instantiates parsing operation to retrieve a frame's contents from a `Tag`
    /// Parameter frameKey: The unique identifier of the frame
    /// Returns: The frame's contents as a human-readable, unterminated string
    func get(_ identifier: FrameIdentifier) -> String? {
        // check that the frame is a String Frame
        if let frame = self.frames[identifier.frameKey] as? StringFrame {
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
        let frameKey = identifier.frameKey
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
        get { get(.album) }
        set {
            if let new = newValue {
                set(.album, stringValue: new)
            } else {
                set(.album, stringValue: nil)
            }
        }
    }

    ///  AlbumArtist frame getter-setter. ID3 Identifier: `TP2`/`TPE2`
    public var albumArtist: String? {
        get { get(.albumArtist) }
        set {
            if let new = newValue {
                set(.albumArtist, stringValue: new)
            } else {
                set(.albumArtist, stringValue: nil)
            }
        }
    }

    /// AlbumSort frame getter-setter. ID3 Identifier: `TSA`/`TSOA`
    public var albumSort: String? {
        get { get(.albumSort) }
        set {
            if let new = newValue {
                set(.albumSort, stringValue: new)
            } else {
                set(.albumSort, stringValue: nil)
            }
        }
    }

    /// AlbumArtistSort frame getter-setter. ID3 Identifier: `TS2`/`TSO2`
    public var albumArtistSort: String? {
        get { get(.albumArtistSort) }
        set {
            if let new = newValue {
                set(.albumArtistSort, stringValue: new)
            } else {
                set(.albumArtistSort, stringValue: nil)
            }
        }
    }

    /// Arranger/Remixer/InterpretedBy getter-setter. ID3 Identifier: `TP4`/`TPE4`.
    ///
    /// If another frame of this type already exists, only one will be written.
    public var arranger: String? {
        get { get(.arranger) }
        set {
            if let new = newValue {
                set(.arranger, stringValue: new)
            } else {
                set(.arranger, stringValue: nil)
            }
        }
    }

    /// Artist getter-setter. ID3 Identifier: `TP1`/`TPE1`
    public var artist: String? {
        get { get(.artist) }
        set {
            if let new = newValue {
                set(.artist, stringValue: new)
            } else {
                set(.artist, stringValue: nil)
            }
        }
    }

    /// ArtistSort getter-setter. ID3 Identifier: `TSP`/`TSOP`
    public var artistSort: String? {
        get { get(.artistSort) }
        set {
            if let new = newValue {
                set(.artistSort, stringValue: new)
            } else {
                set(.artistSort, stringValue: nil)
            }
        }
    }

    /// Composer getter-setter. ID3 Identifier: `TCM`/`TCOM`
    public var composer: String? {
        get { get(.composer) }
        set {
            if let new = newValue {
                set(.composer, stringValue: new)
            } else {
                set(.composer, stringValue: nil)
            }
        }
    }

    /// ComposerSort getter-setter. ID3 Identifier: `TSC`/`TSOC`
    public var composerSort: String? {
        get { get(.composerSort) }
        set {
            if let new = newValue {
                set(.composerSort, stringValue: new)
            } else {
                set(.composerSort, stringValue: nil)
            }
        }
    }

    /// Conductor getter-setter. ID3 Identifier: `TP3`/`TPE3`
    public var conductor: String? {
        get { get(.conductor) }
        set {
            if let new = newValue {
                set(.conductor, stringValue: new)
            } else {
                set(.conductor, stringValue: nil)
            }
        }
    }

    /// ContentGroup getter-setter. ID3 Identifier: `TT1`/`TIT1`
    public var contentGroup: String? {
        get { get(.contentGroup) }
        set {
            if let new = newValue {
                set(.contentGroup, stringValue: new)
            } else {
                set(.contentGroup, stringValue: nil)
            }
        }
    }

    /// WorkName getter-setter.
    ///
    /// Writes to `ContentGroup` frame, ID3 Identifier: `TT1`/`TIT1`.
    ///
    /// If another frame of this type already exists, only one will be written.
    public var work: String? {
        get { get(.contentGroup) }
        set {
            if let new = newValue {
                set(.contentGroup, stringValue: new)
            } else {
                set(.contentGroup, stringValue: nil)
            }
        }
    }

    /// Copyright getter-setter. ID3 Identifier: `TCR`/`TCOP`
    public var copyright: String? {
        get { get(.copyright) }
        set {
            if let new = newValue {
                set(.copyright, stringValue: new)
            } else {
                set(.copyright, stringValue: nil)
            }
        }
    }

    /// EncodedBy getter-setter. ID3 Identifier: `TEN`/`TENC`
    public var encodedBy: String? {
        get { get(.encodedBy) }
        set {
            if let new = newValue {
                set(.encodedBy, stringValue: new)
            } else {
                set(.encodedBy, stringValue: nil)
            }
        }
    }

    /// EncodingSettings getter-setter. ID3 Identifier: `TSS`/`TSSE`
    public var encodingSettings: String? {
        get { get(.encodingSettings) }
        set {
            if let new = newValue {
                set(.encodingSettings, stringValue: new)
            } else {
                set(.encodingSettings, stringValue: nil)
            }
        }
    }

    /// FileOwner getter-setter. ID3 Identifier: `TOWN`. Valid only for tag versions 2.3/2.4
    public var fileOwner: String? {
        get { get(.fileOwner) }
        set {
            if let new = newValue {
                set(.fileOwner, stringValue: new)
            } else {
                set(.fileOwner, stringValue: nil)
            }
        }
    }

    /// Grouping getter-setter. This is a non-standard, iTunes compliant frame.
    /// ID3 Identifier: `GRP1`
    public var grouping: String? {
        get { get(.grouping) }
        set {
            if let new = newValue {
                set(.grouping, stringValue: new)
            } else {
                set(.grouping, stringValue: nil)
            }
        }
    }

    /// InitialKey getter-setter. ID3 Identifier: `TKE`/`TKEY`
    public var initialKey: KeySignature? {
        get {
            if let string = get(.initialKey) {
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
                set(.initialKey, stringValue: string)
            } else {
                set(.initialKey, stringValue: nil)
            }
        }
    }

    /// Lyricist getter-setter. ID3 Identifier: `TXT`/`TEXT`
    public var lyricist: String? {
        get { get(.lyricist) }
        set {
            if let new = newValue {
                set(.lyricist, stringValue: new)
            } else {
                set(.lyricist, stringValue: nil)
            }
        }
    }

    /// Mood getter-setter. ID3 Identifier: `TMOO`. Valid only for tag version 2.4
    public var mood: String? {
        get { get(.mood) }
        set {
            if let new = newValue {
                set(.mood, stringValue: new)
            } else {
                set(.mood, stringValue: nil)
            }
        }
    }

    /// MovementName getter-setter. This is a non-standard, iTunes compliant frame
    /// ID3 Identifier: `MVNM`.
    public var movement: String? {
        get { get(.movement) }
        set {
            if let new = newValue {
                set(.movement, stringValue: new)
            } else {
                set(.movement, stringValue: nil)
            }
        }
    }

    /// OriginalAlbum getter-setter. ID3 Identifier: `TOT`/`TOAL`.
    public var originalAlbum: String? {
        get { get(.originalAlbum) }
        set {
            if let new = newValue {
                set(.originalAlbum, stringValue: new)
            } else {
                set(.originalAlbum, stringValue: nil)
            }
        }
    }

    /// OriginalArtist getter-setter. ID3 Identifier: `TOP`/`TOPE`.
    public var originalArtist: String? {
        get { get(.originalArtist) }
        set {
            if let new = newValue {
                set(.originalArtist, stringValue: new)
            } else {
                set(.originalArtist, stringValue: nil)
            }
        }
    }

    /// OriginalFilename getter-setter. ID3 Identifier: `TOF`/`TOFN`.
    public var originalFilename: String? {
        get { get(.originalFilename) }
        set {
            if let new = newValue {
                set(.originalFilename, stringValue: new)
            } else {
                set(.originalFilename, stringValue: nil)
            }
        }
    }

    /// OriginalLyricist getter-setter. ID3 Identifier: `TOL`/`TOLY`.
    public var originalLyricist: String? {
        get { get(.originalLyricist) }
        set {
            if let new = newValue {
                set(.originalLyricist, stringValue: new)
            } else {
                set(.originalLyricist, stringValue: nil)
            }
        }
    }

    /// PodcastCategory getter-setter. This is a non-standard, iTunes compliant frame
    /// ID3 Identifier: `TCAT`.
    public var podcastCategory: String? {
        get { get(.podcastCategory) }
        set {
            if let new = newValue {
                set(.podcastCategory, stringValue: new)
            } else {
                set(.podcastCategory, stringValue: nil)
            }
        }
    }

    /// PodcastDescription getter-setter. This is a non-standard, iTunes compliant frame
    /// ID3 Identifier: `TDES`.
    public var podcastDescription: String? {
        get { get(.podcastDescription) }
        set {
            if let new = newValue {
                set(.podcastDescription, stringValue: new)
            } else {
                set(.podcastDescription, stringValue: nil)
            }
        }
    }

    /// PodcastID getter-setter. This is a non-standard, iTunes compliant frame
    /// ID3 Identifier: `TGID`.
    public var podcastID: String? {
        get { get(.podcastID) }
        set {
            if let new = newValue {
                set(.podcastID, stringValue: new)
            } else {
                set(.podcastID, stringValue: nil)
            }
        }
    }

    /// PodcastKeywords getter-setter. This is a non-standard, iTunes compliant frame
    /// ID3 Identifier: `TKWD`.
    public var podcastKeywords: [String] {
        get {
            if let string = get(.podcastKeywords) {
                return string.toArray
            } else {
                return []
            }
        }
        set {
            if !newValue.isEmpty {
                set(.podcastKeywords, stringValue: newValue.toString)
            } else {
                set(.podcastKeywords, stringValue: nil)
            }
        }
    }

    public var languages: [Language] {
        get {
            if let string = get(.languages) {
                let array = string.toArray
                var languages = [Language]()
                for item in array {
                    if let code = ISO6392Code(rawValue: item) {
                        let language = code.language
                        languages.append(language)
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
                    let string = item.iso6392Code.rawValue
                    strings.append(string)
                }
                let stringValue = strings.toString
                set(.languages, stringValue: stringValue)
            } else {
                set(.languages, stringValue: nil)
            }
        }
    }
    
    /// PodcastFeedLink getter-setter. This is a non-standard, iTunes compliant frame
    /// ID3 Identifier: `WFED`.
    public var podcastFeed: String? {
        get { get(.podcastFeed) }
        set {
            if let new = newValue {
                set(.podcastFeed, stringValue: new)
            } else {
                set(.podcastFeed, stringValue: nil)
            }
        }
    }

    /// ProducedNotice getter-setter. ID3 Identifier: `TPRO`.
    public var producedNotice: String? {
        get { get(.producedNotice) }
        set {
            if let new = newValue {
                set(.producedNotice, stringValue: new)
            } else {
                set(.producedNotice, stringValue: nil)
            }
        }
    }

    /// Publisher getter-setter. ID3 Identifier: `TPB`/`TPUB`.
    public var publisher: String? {
        get { get(.publisher) }
        set {
            if let new = newValue {
                set(.publisher, stringValue: new)
            } else {
                set(.publisher, stringValue: nil)
            }
        }
    }

    /// (Internet)RadioStation getter-setter. ID3 Identifier: `TRS`/`TRSN`.
    public var radioStation: String? {
        get { get(.radioStation) }
        set {
            if let new = newValue {
                set(.radioStation, stringValue: new)
            } else {
                set(.radioStation, stringValue: nil)
            }
        }
    }

    /// (Internet)RadioStationOwner getter-setter. ID3 Identifier: `TRO`/`TRSO`.
    public var radioStationOwner: String? {
        get { get(.radioStationOwner) }
        set {
            if let new = newValue {
                set(.radioStationOwner, stringValue: new)
            } else {
                set(.radioStationOwner, stringValue: nil)
            }
        }
   }

    /// SetSubtitle getter-setter. ID3 Identifier: `TSST`.
    public var setSubtitle: String? {
        get { get(.setSubtitle) }
        set {
            if let new = newValue {
                set(.setSubtitle, stringValue: new)
            } else {
                set(.setSubtitle, stringValue: nil)
            }
        }
    }

    /// Subtitle getter-setter. ID3 Identifier: `TT3`/`TIT3`
    public var subtitle: String? {
        get { get(.subtitle) }
        set {
            if let new = newValue {
                set(.subtitle, stringValue: new)
            } else {
                set(.subtitle, stringValue: nil)
            }
        }
    }

    /// Title getter-setter. ID3 Identifier: `TT2`/`TIT2`
    public var title: String? {
        get { get(.title) }
        set {
            if let new = newValue {
                set(.title, stringValue: new)
            } else {
                set(.title, stringValue: nil)
            }
        }
    }

    /// TitleSort getter-setter. ID3 Identifier: `TST`/`TSOT`
    public var titleSort: String? {
        get { get(.titleSort) }
        set {
            if let new = newValue {
                set(.titleSort, stringValue: new)
            } else {
                set(.titleSort, stringValue: nil)
            }
        }
    }
    
    /// ArtistWebpage getter-setter. ID3 Identifier: `WAR`/`WOAR`
    public var artistWebpage: String? {
        get { get(.artistWebpage) }
        set {
            if let new = newValue {
                set(.artistWebpage, stringValue: new)
            } else {
                set(.artistWebpage, stringValue: nil)
            }
        }
    }

    /// (Official)AudioFileWebpage getter-setter. ID3 Identifier: `WAF`/`WOAF`
    public var audioFileWebpage: String? {
        get { get(.audioFileWebpage) }
        set {
            if let new = newValue {
                set(.audioFileWebpage, stringValue: new)
            } else {
                set(.audioFileWebpage, stringValue: nil)
            }
        }
    }

    /// (Official)AudioSourceWebpage getter-setter. ID3 Identifier: `WAS`/`WOAS`
    public var audioSourceWebpage: String? {
        get { get(.audioSourceWebpage) }
        set {
            if let new = newValue {
                set(.audioSourceWebpage, stringValue: new)
            } else {
                set(.audioSourceWebpage, stringValue: nil)
            }
        }
    }

    /// Copyright/Legal Information Webpage getter-setter. ID3 Identifier: `WCP`/`WCOP`
    public var copyrightWebpage: String? {
        get { get(.copyrightWebpage) }
        set {
            if let new = newValue {
                set(.copyrightWebpage, stringValue: new)
            } else {
                set(.copyrightWebpage, stringValue: nil)
            }
        }
    }

    /// PaymentWebpage getter-setter. ID3 Identifier: `WPAY`
    public var paymentWebpage: String? {
        get { get(.paymentWebpage) }
        set {
            if let new = newValue {
                set(.paymentWebpage, stringValue: new)
            } else {
                set(.paymentWebpage, stringValue: nil)
            }
        }
    }

    /// PublisherWebpage getter-setter. ID3 Identifier: `WPB`/`WPUB`
    public var publisherWebpage: String? {
        get { get(.publisherWebpage) }
        set {
            if let new = newValue {
                set(.publisherWebpage, stringValue: new)
            } else {
                set(.publisherWebpage, stringValue: nil)
            }
        }
   }

    /// (Official Internet)RadioStationWebpage getter-setter. ID3 Identifier: `WRS`/`WORS`
    public var radioStationWebpage: String? {
        get { get(.radioStationWebpage) }
        set {
            if let new = newValue {
                set(.radioStationWebpage, stringValue: new)
            } else {
                set(.radioStationWebpage, stringValue: nil)
            }
        }
   }

    /// BeatsPerMinute getter-setter. ID3 Identifier: `TBP`/`TBPM`
    public var bpm: Int? {
        get {
            if let string = get(.bpm) {
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
                set(.bpm, stringValue: string)
            } else {
                set(.bpm, stringValue: nil)
            }
        }
    }

    /// IRSC getter-setter. ID3 Identifier: `TRC`/`TSRC`
    public var isrc: String? {
        get { get(.isrc) }
        set {
            if let new = newValue {
                set(.isrc, stringValue: new)
            } else {
                set(.isrc, stringValue: nil)
            }
        }
    }

    /// READ ONLY FRAME. ID3 Identifier: `TLE`/`TLEN`
    ///
    /// This value is derived from the file data, and since SwiftTagger doesn't support editing anything other than metadata, it cannot be set to another value.
    public var length: Int {
        return Tag.duration
    }

    /// TotalMovements getter-setter. This is a non-standard, iTunes non-standard frame
    /// ID3 Identifier: `MVCN`.
    public var movementCount: Int? {
        get {
            if let string = get(.movementCount) {
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
                set(.movementCount, stringValue: string)
            } else {
                set(.movementCount, stringValue: nil)
            }
        }
    }

    /// MovementNumber getter-setter. This is a non-standard, iTunes non-standard frame
    /// ID3 Identifier: `MVIN`.
    public var movementNumber: Int? {
        get {
            if let string = get(.movementNumber) {
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
                set(.movementNumber, stringValue: string)
            } else {
                set(.movementNumber, stringValue: nil)
            }
        }
    }

    /// Gapless Playback getter-setter. If true, sets `playlistDelay` to zero.
    ///
    /// ID3 Identifier: `TDY`/`TDLY`
    public var gaplessPlayback: Bool? {
        get {
            let bool: Bool
            if let string = get(.playlistDelay) {
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
            if let string = get(.playlistDelay) {
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
                set(.playlistDelay, stringValue: string)
            } else {
                set(.playlistDelay, stringValue: nil)
            }
        }
    }

    /// Compilation (flag) getter-setter. ID3 identifier: `TCP`/`TCMP`. iTunes non-standard frame
    public var compilation: Bool? {
        get {
            let bool: Bool
            if let string = get(.compilation) {
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
                set(.compilation, stringValue: string)
            } else if let new = newValue, new == false {
                let string = "0"
                set(.compilation, stringValue: string)
            } else {
                set(.compilation, stringValue: nil)
            }
        }
    }
}
