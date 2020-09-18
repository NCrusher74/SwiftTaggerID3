/*

 FrameLayoutIdentifier.swift
 SwiftTaggerID3

 Copyright ©2020 Nolaine Crusher. All rights reserved.

 */

import Foundation

/** `FrameLayoutIdentifier` describes how SwiftTagger refers to the frame type internally.
 All information for handling a frame are determined by its `FrameIdentifier` */
enum FrameIdentifier: Hashable {
    /// a frame with an identifier recognized and handled by SwiftTagger
    case known(KnownIdentifier)
    /// a frame with an unknown or unhandled identifier
    case unknown(String)
    
    /// Initialize the `FrameLayoutIdentifier`
    /// - Parameter identifier: the unique ID3 identifier string
    init(identifier: String) {
        if let known = KnownIdentifier(identifier: identifier) {
            self = .known(known)
        } else {
            self = .unknown(identifier)
        }
    }
    
    /// Retrieve a frame's ID3 identifier string
    /// - Parameter version: The tag's ID3 `Version`. Different versions may have different identifiers
    /// - Returns: The ID3 identifier string appropriate for the version
    func idString(version: Version) -> String? {
        switch self {
            case .known(let known):
                return known.idString(version: version)
            case .unknown(let identifier):
                return identifier
        }
    }
    
    func frameKey(additionalID: Any?) throws -> String {
        switch self {
            case .known(let known):
                return try known.frameKey(additionalID: additionalID)
            case .unknown(let identifier):
                if let uuid = additionalID as? UUID {
                    return "\(identifier): \(uuid.uuidString)"
                } else if let string = additionalID as? String {
                    return "\(identifier): \(string)"
                } else {
                    throw Mp3FileError.UnableToDetermineUniqueFrameID("\(self)")
                }
        }
    }
    
    var parseAs: FrameParser {
        switch self {
            case .unknown(_): return .unknown
            case .known(.compilation): return .boolean
            case .known(.attachedPicture): return .image
            case .known(.chapter): return .chapter
            case .known(.tableOfContents): return .tableOfContents
            case .known(.discNumber),
                 .known(.trackNumber): return .tuple
            case .known(.involvedPeopleList),
                 .known(.musicianCreditsList): return .credits
            case .known(.comments),
                 .known(.unsynchronizedLyrics): return .localized
            case .known(.userDefinedText),
                 .known(.userDefinedWebpage): return .userDefined
            case .known(.genre),
                 .known(.mediaType),
                 .known(.fileType): return .complex
            case .known(.bpm),
                 .known(.length),
                 .known(.movementCount),
                 .known(.movementNumber),
                 .known(.playlistDelay): return .integer
            case .known(.artistWebpage),
                 .known(.audioFileWebpage),
                 .known(.audioSourceWebpage),
                 .known(.copyrightWebpage),
                 .known(.paymentWebpage),
                 .known(.publisherWebpage),
                 .known(.radioStationWebpage): return .url
            case .known(.date),
                 .known(.encodingTime),
                 .known(.originalReleaseTime),
                 .known(.recordingDate),
                 .known(.releaseTime),
                 .known(.taggingTime),
                 .known(.time),
                 .known(.year): return .date
            default: return .string
        }
    }
    
    @available(OSX 10.12, *)
    func parse(version: Version,
               size: Int,
               flags: Data,
               payload: Data) throws -> Frame {
        switch self.parseAs {
            case .string, .boolean, .integer, .url:
                return try StringFrame(identifier: self,
                                       version: version,
                                       size: size,
                                       flags: flags,
                                       payload: payload)
            case .date:
                return try DateFrame(identifier: self,
                                     version: version,
                                     size: size,
                                     flags: flags,
                                     payload: payload)
            case .localized, .userDefined:
                return try LocalizedFrame(identifier: self,
                                            version: version,
                                            size: size,
                                            flags: flags,
                                            payload: payload)
            case .complex:
                <#code#>
            case .credits:
                return try CreditsListFrame(identifier: self,
                                            version: version,
                                            size: size,
                                            flags: flags,
                                            payload: payload)
            case .tuple:
                return try PartAndTotalFrame(identifier: self,
                                            version: version,
                                            size: size,
                                            flags: flags,
                                            payload: payload)
            case .chapter:
                <#code#>
            case .tableOfContents:
                <#code#>
            case .image:
                <#code#>
            case .unknown:
                return UnknownFrame(identifier: self,
                                    version: version,
                                    size: size,
                                    flags: flags,
                                    payload: payload)
        }
    }
}

enum FrameParser {
    /// A parser type that handles frames with string data. This includes frames with integer and boolean data, as those are stored as numeric strings
    case string
    case url
    case boolean
    case integer
    case date
    case localized
    case userDefined
    case complex
    case credits
    case tuple
    case chapter
    case tableOfContents
    case image
    case unknown
}

/** An enumeration of ID3 standard--or iTunes compliant but non-standard--frames*/
enum KnownIdentifier: CaseIterable {
    
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
    case movement
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
    case podcastFeed
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
        if let layout = KnownIdentifier.stringToLayoutMapping[identifier] {
            self = layout
        } else {
            return nil
        }
    }
         
    // MARK: - ID3Identifier
    /// The ID3 4-character code for the frame
    ///
    /// 3 bytes for ID3v2.2
    ///
    /// 4 bytes for ID3v2.3 and ID3v2.4
    ///
    /// If ID3 identfier is `nil` the frame will be handled as a TXX/TXXX frame, unless it's a frame associated with date handling, in which case it will be handled depending on version. Musician Credits for ID3v2.2 and ID3v2.3 will be handled as InvolvedPeople
    ///
    /// - Parameter version: The ID3 `Version` of the tag
    /// - Returns: A string of the ID3 identifier appropriate for the version
    func idString(version: Version) -> String? {
        return version.idString(self)
    }
    
    func frameKey(additionalID: Any?) throws -> String {
        switch self {
            case .album: return "Album"
            case .albumSort: return "Album Sort"
            case .albumArtist: return "Album Artist"
            case .albumArtistSort: return "Album Artist Sort"
            case .arranger: return "Arranger"
            case .artist: return "Artist"
            case .artistSort: return "Artist Sort"
            case .artistWebpage: return "Artist Webpage"
            case .attachedPicture:
                if let uInt8 = additionalID as? UInt8 {
                    if let type = ImageType(rawValue: uInt8) {
                        return "Attached Picture: \(type.pictureDescription)"
                    } else {
                        throw Mp3FileError.UnableToDetermineUniqueFrameID("\(self)")
                    }
                } else if let string = additionalID as? String {
                    return "Attached Picture: \(string)"
                } else {
                    return "Attached Picture"
                }
            case .audioFileWebpage: return "Audio File Webpage"
            case .audioSourceWebpage: return "Audio Source Webpage"
            case .bpm: return "BPM"
            case .chapter:
                if let elementID = additionalID as? String {
                    return "Chapter: \(elementID)"
                } else {
                    return "Chapter"
                }
            case .comments:
                if let description = additionalID as? String {
                    return "Comments: \(description)"
                } else {
                    return "Comments"
                }
            case .compilation: return "Compilation"
            case .composer: return "Composer"
            case .composerSort: return "Composer Sort"
            case .conductor: return "Conductor"
            case .contentGroup: return "Content Group"
            case .copyright: return "Copyright"
            case .copyrightWebpage: return "Copyright Webpage"
            case .date: return "Date"
            case .discNumber: return "Disc Number"
            case .encodingTime: return "Encoding Time"
            case .encodedBy: return "Encoded By"
            case .encodingSettings: return "Encoding Settings"
            case .fileType: return "File Type"
            case .fileOwner: return "File Owner"
            case .genre: return "Genre"
            case .grouping: return "Grouping"
            case .initialKey: return "Initial Key"
            case .involvedPeopleList: return "Involvement Credits"
            case .isrc: return "ISRC"
            case .languages: return "Languages"
            case .length: return "Length"
            case .lyricist: return "Lyricist"
            case .mediaType: return "Media Type"
            case .mood: return "Mood"
            case .movementCount: return "Movement Count"
            case .movement: return "Movement"
            case .movementNumber: return "Movement Number"
            case .musicianCreditsList: return "Performer Credits"
            case .originalAlbum: return "Original Album"
            case .originalArtist: return "Original Artist"
            case .originalFilename: return "Original Filename"
            case .originalLyricist: return "Original Lyricist"
            case .originalReleaseTime: return "Original Release Time"
            case .paymentWebpage: return "Payment Webpage"
            case .playlistDelay: return "Playlist Delay"
            case .podcastCategory: return "Podcast Category"
            case .podcastDescription: return "Podcast Description"
            case .podcastID: return "PodcastID"
            case .podcastKeywords: return "Podcast Keywords"
            case .podcastFeed: return "Podcast Feed"
            case .producedNotice: return "Produced Notice"
            case .publisher: return "Publisher"
            case .publisherWebpage: return "Publisher Webpage"
            case .radioStation: return "Radio Station"
            case .radioStationOwner: return "Radio Station Owner"
            case .radioStationWebpage: return "Radio Station Webpage"
            case .recordingDate: return "Recording Date"
            case .releaseTime: return "Release Time"
            case .setSubtitle: return "Set Subtitle"
            case .subtitle: return "Subtitle"
            case .tableOfContents:
                if let elementID = additionalID as? String {
                    return "Table Of Contents: \(elementID)"
                } else {
                    return "TOC"
                }
            case .taggingTime: return "Tagging Time"
            case .time: return "Time"
            case .title: return "Title"
            case .titleSort: return "Title Sort"
            case .trackNumber: return "Track Number"
            case .unsynchronizedLyrics:
                if let description = additionalID as? String {
                    return "Lyrics: \(description)"
                } else {
                    return "Lyrics"
                }
            case .userDefinedText:
                if let description = additionalID as? String {
                    return "User-Defined Text: \(description)"
                } else {
                    return "User-Defined Text"
                }
            case .userDefinedWebpage:
                if let description = additionalID as? String {
                    return "User-Defined Webpage: \(description)"
                } else {
                    return "User-Defined Webpage"
                }
            case .year: return "Year"
        }
    }
    
    private static let stringToLayoutMapping: [String: KnownIdentifier] = {
        var mapping: [String: KnownIdentifier] = [:]
        for layout in KnownIdentifier.allCases {
            for version in Version.allCases {
                if let idString = layout.idString(version: version) {
                    mapping[idString] = layout
                }
            }
        }
        return mapping
    }()
}
