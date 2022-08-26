/*
 
 FrameIdentifier.swift
 SwiftTaggerID3
 
 Copyright ©2020 Nolaine Crusher. All rights reserved.
 
 */

import Foundation
import SwiftLanguageAndLocaleCodes

/// An enumeration of ID3 standard--or iTunes compliant but non-standard--frames
enum FrameIdentifier: String, CaseIterable {    
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
    case encodingDateTime
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
    case originalReleaseDateTime
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
    case recordingDateTime
    case releaseDateTime
    case setSubtitle
    case subtitle
    case tableOfContents
    case taggingDateTime
    case time
    case title
    case titleSort
    case trackNumber
    case unsynchronizedLyrics
    case userDefinedText
    case userDefinedWebpage
    case year
    case passThrough
    
    init(idString: String) {
        if let identifier = FrameIdentifier.stringToIDMapping[idString] {
            self = identifier
        } else {
            self = .passThrough
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
    
    // MARK: FrameKey functions
    // these functions provide a way to access a frame's frameKey if its identifier and key information is known.
    func frameKey(startTime: Int) -> FrameKey {
        switch self {
            case .chapter: return .chapter(startTime: startTime)
            default: fatalError("Wrong frame key for identifier \(self.rawValue)")
        }
    }
    
    func frameKey(idString: String, uuid: UUID) -> FrameKey {
        switch self {
            case .passThrough: return .passThrough(idString: idString, uuid: uuid)
            default: fatalError("Wrong frame key for identifier \(self.rawValue)")
        }
    }
    
    func frameKey(imageType: ImageType) -> FrameKey {
        switch self {
            case .attachedPicture: return .attachedPicture(imageType: imageType)
            default: fatalError("Wrong frame key for identifier \(self.rawValue)")
        }
    }
    
    func frameKey(language: ISO6392Code?, description: String?) -> FrameKey {
        let language = language ?? .und
        let description = description ?? ""
        switch self {
            case .comments: return .comments(language: language, description: description)
            case .unsynchronizedLyrics: return .unsynchronizedLyrics(language: language, description: description)
            default: fatalError("Wrong frame key for identifier \(self.rawValue)")
        }
    }
    
    func frameKey(_ description: String?) -> FrameKey {
        let description = description ?? ""
        switch self {
            case .userDefinedText: return .userDefinedText(description)
            case .userDefinedWebpage: return .userDefinedWebpage(description)
            default: fatalError("Wrong frame key for identifier \(self.rawValue)")
        }
    }
    
    var frameKey: FrameKey {
        switch self {
            case .album: return .album
            case .albumSort: return .albumSort
            case .albumArtist: return .albumArtist
            case .albumArtistSort: return .albumArtistSort
            case .arranger: return .arranger
            case .artist: return .artist
            case .artistSort: return .artistSort
            case .artistWebpage: return .artistWebpage
            case .audioFileWebpage: return .audioFileWebpage
            case .audioSourceWebpage: return .audioSourceWebpage
            case .bpm: return .bpm
            case .compilation: return .compilation
            case .composer: return .composer
            case .composerSort: return .composerSort
            case .conductor: return .conductor
            case .contentGroup: return .contentGroup
            case .copyright: return .copyright
            case .copyrightWebpage: return .copyrightWebpage
            case .date: return .date
            case .discNumber: return .discNumber
            case .encodingDateTime: return .encodingDateTime
            case .encodedBy: return .encodedBy
            case .encodingSettings: return .encodingSettings
            case .fileType: return .fileType
            case .fileOwner: return .fileOwner
            case .genre: return .genre
            case .grouping: return .grouping
            case .initialKey: return .initialKey
            case .involvedPeopleList: return .involvedPeopleList
            case .isrc: return .isrc
            case .languages: return .languages
            case .length: return .length
            case .lyricist: return .lyricist
            case .mediaType: return .mediaType
            case .mood: return .mood
            case .movementCount: return .movementCount
            case .movement: return .movement
            case .movementNumber: return .movementNumber
            case .musicianCreditsList: return .musicianCreditsList
            case .originalAlbum: return .originalAlbum
            case .originalArtist: return .originalArtist
            case .originalFilename: return .originalFilename
            case .originalLyricist: return .originalLyricist
            case .originalReleaseDateTime: return .originalReleaseDateTime
            case .paymentWebpage: return .paymentWebpage
            case .playlistDelay: return .playlistDelay
            case .podcastCategory: return .podcastCategory
            case .podcastDescription: return .podcastDescription
            case .podcastID: return .podcastID
            case .podcastKeywords: return .podcastKeywords
            case .podcastFeed: return .podcastFeed
            case .producedNotice: return .producedNotice
            case .publisher: return .publisher
            case .publisherWebpage: return .publisherWebpage
            case .radioStation: return .radioStation
            case .radioStationOwner: return .radioStationOwner
            case .radioStationWebpage: return .radioStationWebpage
            case .recordingDateTime: return .recordingDateTime
            case .releaseDateTime: return .releaseDateTime
            case .setSubtitle: return .setSubtitle
            case .subtitle: return .subtitle
            case .tableOfContents: return .tableOfContents
            case .taggingDateTime: return .taggingDateTime
            case .time: return .time
            case .title: return .title
            case .titleSort: return .titleSort
            case .trackNumber: return .trackNumber
            case .year: return .year
            default: fatalError("Wrong frame key for identifier \(self.rawValue)")
        }
    }
    
    init(frameKey: FrameKey) {
        switch frameKey {
            case .album: self = .album
            case .albumArtist: self = .albumArtist
            case .albumArtistSort: self = .albumArtistSort
            case .albumSort: self = .albumSort
            case .arranger: self = .arranger
            case .artist: self = .artist
            case .artistSort: self = .artistSort
            case .artistWebpage: self = .artistWebpage
            case .attachedPicture(imageType: _): self = .attachedPicture
            case .audioFileWebpage: self = .audioFileWebpage
            case .audioSourceWebpage: self = .audioSourceWebpage
            case .bpm: self = .bpm
            case .chapter(startTime: _): self = .chapter
            case .comments(language: _, description: _): self = .comments
            case .compilation: self = .compilation
            case .composer: self = .composer
            case .composerSort: self = .composerSort
            case .conductor: self = .conductor
            case .contentGroup: self = .contentGroup
            case .copyright: self = .copyright
            case .copyrightWebpage: self = .copyrightWebpage
            case .date: self = .date
            case .discNumber: self = .discNumber
            case .encodingDateTime: self = .encodingDateTime
            case .encodedBy: self = .encodedBy
            case .encodingSettings: self = .encodingSettings
            case .fileType: self = .fileType
            case .fileOwner: self = .fileOwner
            case .genre: self = .genre
            case .grouping: self = .grouping
            case .initialKey: self = .initialKey
            case .involvedPeopleList: self = .involvedPeopleList
            case .isrc: self = .isrc
            case .languages: self = .languages
            case .length: self = .length
            case .lyricist: self = .lyricist
            case .mediaType: self = .mediaType
            case .mood: self = .mood
            case .movementCount: self = .movementCount
            case .movement: self = .movement
            case .movementNumber: self = .movementNumber
            case .musicianCreditsList: self = .musicianCreditsList
            case .originalAlbum: self = .originalAlbum
            case .originalArtist: self = .originalArtist
            case .originalFilename: self = .originalFilename
            case .originalLyricist: self = .originalLyricist
            case .originalReleaseDateTime: self = .originalReleaseDateTime
            case .paymentWebpage: self = .paymentWebpage
            case .playlistDelay: self = .playlistDelay
            case .podcastCategory: self = .podcastCategory
            case .podcastDescription: self = .podcastDescription
            case .podcastID: self = .podcastID
            case .podcastKeywords: self = .podcastKeywords
            case .podcastFeed: self = .podcastFeed
            case .producedNotice: self = .producedNotice
            case .publisher: self = .publisher
            case .publisherWebpage: self = .publisherWebpage
            case .radioStation: self = .radioStation
            case .radioStationOwner: self = .radioStationOwner
            case .radioStationWebpage: self = .radioStationWebpage
            case .recordingDateTime: self = .recordingDateTime
            case .releaseDateTime: self = .releaseDateTime
            case .setSubtitle: self = .setSubtitle
            case .subtitle: self = .subtitle
            case .tableOfContents: self = .tableOfContents
            case .taggingDateTime: self = .taggingDateTime
            case .time: self = .time
            case .title: self = .title
            case .titleSort: self = .titleSort
            case .trackNumber: self = .trackNumber
            case .unsynchronizedLyrics(language: _, description: _): self = .unsynchronizedLyrics
            case .userDefinedText(_): self = .userDefinedText
            case .userDefinedWebpage(_): self = .userDefinedWebpage
            case .passThrough(idString: _, uuid: _): self = .passThrough
            case .year: self = .year
        }
    }
    
    var parseAs: FrameParser {
        switch self {
            case .passThrough:
                return .passThrough
            case .compilation:
                return .boolean
            case .attachedPicture:
                return .image
            case .chapter:
                return .chapter
            case .tableOfContents:
                return .tableOfContents
            case .discNumber, .trackNumber:
                return .tuple
            case .involvedPeopleList, .musicianCreditsList:
                return .credits
            case .comments, .unsynchronizedLyrics:
                return .localized
            case .userDefinedText, .userDefinedWebpage:
                return .userDefined
            case .genre, .mediaType, .fileType:
                return .complex
            case .bpm, .length, .movementCount, .movementNumber, .playlistDelay:
                return .integer
            case .artistWebpage, .audioFileWebpage, .audioSourceWebpage, .copyrightWebpage, .paymentWebpage, .publisherWebpage, .radioStationWebpage:
                return .url
            case .date, .encodingDateTime, .originalReleaseDateTime, .recordingDateTime, .releaseDateTime, .taggingDateTime, .time, .year:
                return .date
            default: return .string
        }
    }
    
    
    @available(OSX 10.12, iOS 12.0, *)
    func parse(version: Version,
               size: Int,
               flags: Data,
               payload: Data,
               idString: String) throws -> Frame {
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
                return try CreditsFrame(identifier: self,
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
            case .passThrough:
                return PassThroughFrame(identifier: self,
                                        version: version,
                                        size: size,
                                        flags: flags,
                                        payload: payload,
                                        idString: idString)
        }
    }
    
    private static let stringToIDMapping: [String: FrameIdentifier] = {
        var mapping: [String: FrameIdentifier] = [:]
        for id in FrameIdentifier.allCases {
            for version in Version.allCases {
                if let idString = id.idString(version: version) {
                    mapping[idString] = id
                }
            }
        }
        return mapping
    }()
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
    case passThrough
}

