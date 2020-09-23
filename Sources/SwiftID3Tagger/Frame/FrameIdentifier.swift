/*

 FrameLayoutIdentifier.swift
 SwiftTaggerID3

 Copyright ©2020 Nolaine Crusher. All rights reserved.

 */

import Foundation

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
    
    var parseAs: FrameParser {
        switch self {
            case .passThrough: return .passThrough
            case .compilation: return .boolean
            case .attachedPicture: return .image
            case .chapter: return .chapter
            case .tableOfContents: return .tableOfContents
            case .discNumber,
                 .trackNumber: return .tuple
            case .involvedPeopleList,
                 .musicianCreditsList: return .credits
            case .comments,
                 .unsynchronizedLyrics: return .localized
            case .userDefinedText,
                 .userDefinedWebpage: return .userDefined
            case .genre,
                 .mediaType,
                 .fileType: return .complex
            case .bpm,
                 .length,
                 .movementCount,
                 .movementNumber,
                 .playlistDelay: return .integer
            case .artistWebpage,
                 .audioFileWebpage,
                 .audioSourceWebpage,
                 .copyrightWebpage,
                 .paymentWebpage,
                 .publisherWebpage,
                 .radioStationWebpage: return .url
            case .date,
                 .encodingTime,
                 .originalReleaseTime,
                 .recordingDate,
                 .releaseTime,
                 .taggingTime,
                 .time,
                 .year: return .date
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
            case .passThrough:
                return PassThroughFrame(identifier: self,
                                    version: version,
                                    size: size,
                                    flags: flags,
                                    payload: payload,
                                    idString: idString)
        }
    }
    
    func warnings(version: Version) -> String? {
        switch self {
            case .albumSort, .artistSort, .titleSort, .encodingTime, .taggingTime, .musicianCreditsList, .producedNotice, .setSubtitle, .mood:
                switch version {
                    case .v2_2, .v2_3:
                        return "WARNING: The '\(self)' frame is not supported by ID3 \(version). SwiftTaggerID3 is creating this frame with the identifier '\(idString(version: version)!)' but this is a non-standard frame and may not be recognized by other apps."
                    default: return nil
                }
            case .fileOwner, .radioStation, .radioStationOwner, .radioStationWebpage, .paymentWebpage:
                switch version {
                    case .v2_2: return "WARNING: The '\(self)' frame is not supported by ID3 \(version). SwiftTaggerID3 is creating this frame with the identifier '\(idString(version: version)!)' but this is a non-standard frame and may not be recognized by other apps."
                    default: return nil
                }
            case .composerSort, .albumArtistSort, .grouping, .movementCount, .movementNumber, .movement, .compilation, .podcastID, .podcastFeed, .podcastCategory, .podcastKeywords, .podcastDescription:
                return "WARNING: The '\(self)' frame is an iTunes non-standard frame. SwiftTaggerID3 is creating this frame with the identifier '\(idString(version: version)!)' but it may not be recognized by other apps, particularly in ID3 version 2.2."
            default: return nil
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

