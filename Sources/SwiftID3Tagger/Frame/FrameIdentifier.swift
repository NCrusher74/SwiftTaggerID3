/*
 
 FrameLayoutIdentifier.swift
 SwiftTaggerID3
 
 Copyright ©2020 Nolaine Crusher. All rights reserved.
 
 */

import Foundation
import SwiftLanguageAndLocaleCodes

/** An enumeration of ID3 standard--or iTunes compliant but non-standard--frames*/
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
            case .attachedPicture: return .attachedPicture(description: description)
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
            case .encodingTime: return .encodingTime
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
            case .originalReleaseTime: return .originalReleaseTime
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
            case .recordingDate: return .recordingDate
            case .releaseTime: return .releaseTime
            case .setSubtitle: return .setSubtitle
            case .subtitle: return .subtitle
            case .tableOfContents: return .tableOfContents
            case .taggingTime: return .taggingTime
            case .time: return .time
            case .title: return .title
            case .titleSort: return .titleSort
            case .trackNumber: return .trackNumber
            case .year: return .year
            default: fatalError("Wrong frame key for identifier \(self.rawValue)")
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
            case .date, .encodingTime, .originalReleaseTime, .recordingDate, .releaseTime, .taggingTime, .time, .year:
                return .date
            default: return .string
        }
    }
    
    @available(OSX 10.12, *)
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
    
//    func warnings(version: Version) -> String? {
//        switch self {
//            case .albumSort, .artistSort, .titleSort, .encodingTime, .taggingTime, .musicianCreditsList, .producedNotice, .setSubtitle, .mood:
//                switch version {
//                    case .v2_2, .v2_3:
//                        return "WARNING: The '\(self)' frame is not supported by ID3 \(version). SwiftTaggerID3 is creating this frame with the identifier '\(idString(version: version)!)' but this is a non-standard frame and may not be recognized by other apps."
//                    default: return nil
//                }
//            case .fileOwner, .radioStation, .radioStationOwner, .radioStationWebpage, .paymentWebpage:
//                switch version {
//                    case .v2_2: return "WARNING: The '\(self)' frame is not supported by ID3 \(version). SwiftTaggerID3 is creating this frame with the identifier '\(idString(version: version)!)' but this is a non-standard frame and may not be recognized by other apps."
//                    default: return nil
//                }
//            case .composerSort, .albumArtistSort, .grouping, .movementCount, .movementNumber, .movement, .compilation, .podcastID, .podcastFeed, .podcastCategory, .podcastKeywords, .podcastDescription:
//                return "WARNING: The '\(self)' frame is an iTunes non-standard frame. SwiftTaggerID3 is creating this frame with the identifier '\(idString(version: version)!)' but it may not be recognized by other apps, particularly in ID3 version 2.2."
//            default: return nil
//        }
//    }
    
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

