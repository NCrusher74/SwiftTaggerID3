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
    
    func frameKey(_ additionalID: Any?) -> String {
        switch self {
            case .known(let known):
                return known.frameKey(additionalID)
            case .unknown(let identifier):
                if let uuid = additionalID as? UUID {
                    return "\(identifier): \(uuid.uuidString)"
                } else if let string = additionalID as? String {
                    return "\(identifier): \(string)"
                } else {
                    fatalError("Unable to determine unique ID for unhandled frame type")
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
                return try ComplexTypesFrame(identifier: self,
                                             version: version,
                                             size: size,
                                             flags: flags,
                                             payload: payload)
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
                return try ChapterFrame(identifier: self,
                                        version: version,
                                        size: size,
                                        flags: flags,
                                        payload: payload)
            case .tableOfContents:
                return try TableOfContentsFrame(identifier: self,
                                                version: version,
                                                size: size,
                                                flags: flags,
                                                payload: payload)
            case .image:
                return try ImageFrame(identifier: self,
                                      version: version,
                                      size: size,
                                      flags: flags,
                                      payload: payload)
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
    
    private var rawValue: String {
        switch self {
            case .album: return "album"
            case .albumSort: return "albumSort"
            case .albumArtist: return "albumArtist"
            case .albumArtistSort: return "albumArtistSort"
            case .arranger: return "arranger"
            case .artist: return "artist"
            case .artistSort: return "artistSort"
            case .artistWebpage: return "artistWebpage"
            case .attachedPicture: return "attachedPicture"
            case .audioFileWebpage: return "audioFileWebpage"
            case .audioSourceWebpage: return "audioSourceWebpage"
            case .bpm: return "bpm"
            case .chapter: return "chapter"
            case .comments: return "comments"
            case .compilation: return "compilation"
            case .composer: return "composer"
            case .composerSort: return "composerSort"
            case .conductor: return "conductor"
            case .contentGroup: return "contentGroup"
            case .copyright: return "copyright"
            case .copyrightWebpage: return "copyrightWebpage"
            case .date: return "date"
            case .discNumber: return "discNumber"
            case .encodingTime: return "encodingTime"
            case .encodedBy: return "encodedBy"
            case .encodingSettings: return "encodingSettings"
            case .fileType: return "fileType"
            case .fileOwner: return "fileOwner"
            case .genre: return "genre"
            case .grouping: return "grouping"
            case .initialKey: return "initialKey"
            case .involvedPeopleList: return "involvedPeopleList"
            case .isrc: return "isrc"
            case .languages: return "languages"
            case .length: return "length"
            case .lyricist: return "lyricist"
            case .mediaType: return "mediaType"
            case .mood: return "mood"
            case .movementCount: return "movementCount"
            case .movement: return "movement"
            case .movementNumber: return "movementNumber"
            case .musicianCreditsList: return "musicianCreditsList"
            case .originalAlbum: return "originalAlbum"
            case .originalArtist: return "originalArtist"
            case .originalFilename: return "originalFilename"
            case .originalLyricist: return "originalLyricist"
            case .originalReleaseTime: return "originalReleaseTime"
            case .paymentWebpage: return "paymentWebpage"
            case .playlistDelay: return "playlistDelay"
            case .podcastCategory: return "podcastCategory"
            case .podcastDescription: return "podcastDescription"
            case .podcastID: return "podcastID"
            case .podcastKeywords: return "podcastKeywords"
            case .podcastFeed: return "podcastFeed"
            case .producedNotice: return "producedNotice"
            case .publisher: return "publisher"
            case .publisherWebpage: return "publisherWebpage"
            case .radioStation: return "radioStation"
            case .radioStationOwner: return "radioStationOwner"
            case .radioStationWebpage: return "radioStationWebpage"
            case .recordingDate: return "recordingDate"
            case .releaseTime: return "releaseTime"
            case .setSubtitle: return "setSubtitle"
            case .subtitle: return "subtitle"
            case .tableOfContents: return "tableOfContents"
            case .taggingTime: return "taggingTime"
            case .time: return "time"
            case .title: return "title"
            case .titleSort: return "titleSort"
            case .trackNumber: return "trackNumber"
            case .unsynchronizedLyrics: return "unsynchronizedLyrics"
            case .userDefinedText: return "userDefinedText"
            case .userDefinedWebpage: return "userDefinedWebpage"
            case .year: return "year"
        }
    }

    func frameKey(_ additionalID: Any?) -> String {
        switch self {
            case .attachedPicture:
                if let uInt8 = additionalID as? UInt8 {
                    if let type = ImageType(rawValue: uInt8) {
                        return self.rawValue + ": \(type.pictureDescription)"
                    } else {
                        fatalError("Unable to determine unique frame ID for image frame")                    }
                } else if let description = additionalID as? String {
                    return self.rawValue + ": \(description)"
                } else {
                    return self.rawValue
                }
            case .chapter:
                if let startTime = additionalID as? Int {
                    return self.rawValue + ": \(startTime)"
                } else {
                    return self.rawValue
                }
            case .comments:
                if let description = additionalID as? String {
                    return self.rawValue + ": \(description)"
                } else {
                    return self.rawValue
                }
            case .unsynchronizedLyrics:
                    if let description = additionalID as? String {
                        return self.rawValue + ": \(description)"
                    } else {
                        return self.rawValue
                    }
            case .userDefinedText:
                if let description = additionalID as? String {
                    return self.rawValue + ": \(description)"
                } else {
                    return self.rawValue
                }
            case .userDefinedWebpage:
                if let description = additionalID as? String {
                    return self.rawValue + ": \(description)"
                } else {
                    return self.rawValue
                }
            default: return self.rawValue
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
