//
//  Tag.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/10/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

public struct Tag {
    
    public var frames: [FrameKey : Frame]
    
    // handles the parsing of an ID3 tag
    init(readFrom file: Mp3File) throws {
        let properties = TagProperties()
        let fileData: Data = file.data
        var remainder: Data.SubSequence = fileData[fileData.startIndex..<fileData.endIndex]
        var tagSize: Data.Index = 0
        var version: Version = .v2_4
        // validate file
        if file.location.pathExtension.lowercased() != "mp3" {
            throw Mp3File.Error.InvalidFileFormat
        } else {
            // parse version from tag header
            // the first five bytes of a valid ID3 Tag are "ID3"+ the version number in UInt8
            let versionData = remainder.extractFirst(properties.versionDeclarationLength)
            version = try properties.version(data: versionData)
            // parse flags from tag header
            _ = remainder.extractFirst(properties.tagFlagsLength)
            // parse size from tag header
            let tagSizeData = remainder.extractFirst(properties.tagSizeDeclarationLength)
            tagSize = try properties.size(data: tagSizeData)
            print(tagSize)
        }
        
        let tagDataRange = remainder.startIndex ..< remainder.startIndex + tagSize
        remainder = remainder.subdata(in: tagDataRange)
        
        var frames: [FrameKey : Frame] = [:]
        while !remainder.isEmpty  {
            let identifierBytes = remainder.extractFirst(version.identifierLength)
            if identifierBytes.first == 0x00 { break } // Padding, not a frame.
            let identifier = try String(ascii: identifierBytes)
            let frame = try Frame(
                identifier: identifier,
                data: &remainder,
                version: version)
            
            let frameKey = frame.frameKey
            frames[frameKey] = frame
        }
        self.frames = frames
    }
    
    var incrementalChapterID: String {
        var chapterNumber: Int = 1
        return "ch\(chapterNumber += 1)"
    }
    
    var incrementalTocID: String {
        var tocNumber: Int = 1
        return "toc\(tocNumber += 1)"
    }

}

public extension Tag {
    
    var album: String? {
        get {
            if let frame = self.frames[.album],
                case .stringFrame(let stringFrame) = frame {
                return stringFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let frame = StringFrame(album: newValue ?? "")
            frames[.album] = .stringFrame(frame)
        }
    }
    
    var albumArtist: String? {
        get {
            if let frame = self.frames[.albumArtist],
                case .stringFrame(let stringFrame) = frame {
                return stringFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let frame = StringFrame(albumArtist: newValue ?? "")
            frames[.albumArtist] = .stringFrame(frame)
        }
    }
    
    var albumSort: String? {
        get {
            if let frame = self.frames[.albumSort],
                case .stringFrame(let stringFrame) = frame {
                return stringFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let frame = StringFrame(albumSort: newValue ?? "")
            frames[.albumSort] = .stringFrame(frame)
        }
    }
    
    var albumArtistSort: String? {
        get {
            if let frame = self.frames[.albumArtistSort],
                case .stringFrame(let stringFrame) = frame {
                return stringFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let frame = StringFrame(albumArtistSort: newValue ?? "")
            frames[.albumArtistSort] = .stringFrame(frame)
        }
    }
    
    var arranger: String? {
        get {
            if let frame = self.frames[.arranger],
                case .stringFrame(let stringFrame) = frame {
                return stringFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let frame = StringFrame(arranger: newValue ?? "")
            frames[.arranger] = .stringFrame(frame)
        }
    }
    
    var remixer: String? {
        get {
            if let frame = self.frames[.remixer],
                case .stringFrame(let stringFrame) = frame {
                return stringFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let frame = StringFrame(remixer: newValue ?? "")
            frames[.remixer] = .stringFrame(frame)
        }
    }
    
    var interpretedBy: String? {
        get {
            if let frame = self.frames[.interpretedBy],
                case .stringFrame(let stringFrame) = frame {
                return stringFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let frame = StringFrame(interpretedBy: newValue ?? "")
            frames[.interpretedBy] = .stringFrame(frame)
        }
    }
    
    var artist: String? {
        get {
            if let frame = self.frames[.artist],
                case .stringFrame(let stringFrame) = frame {
                return stringFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let frame = StringFrame(artist: newValue ?? "")
            frames[.artist] = .stringFrame(frame)
        }
    }
    
    var artistSort: String? {
        get {
            if let frame = self.frames[.artistSort],
                case .stringFrame(let stringFrame) = frame {
                return stringFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let frame = StringFrame(artistSort: newValue ?? "")
            frames[.artistSort] = .stringFrame(frame)
        }
    }
    
    var author: String? {
        get {
            if let frame = self.frames[.author],
                case .stringFrame(let stringFrame) = frame {
                return stringFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let frame = StringFrame(author: newValue ?? "")
            frames[.author] = .stringFrame(frame)
        }
    }
    
    var authorSort: String? {
        get {
            if let frame = self.frames[.authorSort],
                case .stringFrame(let stringFrame) = frame {
                return stringFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let frame = StringFrame(authorSort: newValue ?? "")
            frames[.authorSort] = .stringFrame(frame)
        }
    }
    
    var composer: String? {
        get {
            if let frame = self.frames[.composer],
                case .stringFrame(let stringFrame) = frame {
                return stringFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let frame = StringFrame(composer: newValue ?? "")
            frames[.composer] = .stringFrame(frame)
        }
    }
    
    var composerSort: String? {
        get {
            if let frame = self.frames[.composerSort],
                case .stringFrame(let stringFrame) = frame {
                return stringFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let frame = StringFrame(composerSort: newValue ?? "")
            frames[.composerSort] = .stringFrame(frame)
        }
    }
    
    var narrator: String? {
        get {
            if let frame = self.frames[.narrator],
                case .stringFrame(let stringFrame) = frame {
                return stringFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let frame = StringFrame(narrator: newValue ?? "")
            frames[.narrator] = .stringFrame(frame)
        }
    }
    
    var narratorSort: String? {
        get {
            if let frame = self.frames[.narratorSort],
                case .stringFrame(let stringFrame) = frame {
                return stringFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let frame = StringFrame(narratorSort: newValue ?? "")
            frames[.narratorSort] = .stringFrame(frame)
        }
    }
    
    var conductor: String? {
        get {
            if let frame = self.frames[.conductor],
                case .stringFrame(let stringFrame) = frame {
                return stringFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let frame = StringFrame(conductor: newValue ?? "")
            frames[.conductor] = .stringFrame(frame)
        }
    }
    
    var contentGroup: String? {
        get {
            if let frame = self.frames[.contentGroup],
                case .stringFrame(let stringFrame) = frame {
                return stringFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let frame = StringFrame(contentGroup: newValue ?? "")
            frames[.contentGroup] = .stringFrame(frame)
        }
    }
    
    var work: String? {
        get {
            if let frame = self.frames[.work],
                case .stringFrame(let stringFrame) = frame {
                return stringFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let frame = StringFrame(work: newValue ?? "")
            frames[.work] = .stringFrame(frame)
        }
    }
    
    var copyright: String? {
        get {
            if let frame = self.frames[.copyright],
                case .stringFrame(let stringFrame) = frame {
                return stringFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let frame = StringFrame(copyright: newValue ?? "")
            frames[.copyright] = .stringFrame(frame)
        }
    }
    
    var encodedBy: String? {
        get {
            if let frame = self.frames[.encodedBy],
                case .stringFrame(let stringFrame) = frame {
                return stringFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let frame = StringFrame(encodedBy: newValue ?? "")
            frames[.encodedBy] = .stringFrame(frame)
        }
    }
    
    var encodingSettings: String? {
        get {
            if let frame = self.frames[.encodingSettings],
                case .stringFrame(let stringFrame) = frame {
                return stringFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let frame = StringFrame(encodingSettings: newValue ?? "")
            frames[.encodingSettings] = .stringFrame(frame)
        }
    }
    
    var fileOwner: String? {
        get {
            if let frame = self.frames[.fileOwner],
                case .stringFrame(let stringFrame) = frame {
                return stringFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let frame = StringFrame(fileOwner: newValue ?? "")
            frames[.fileOwner] = .stringFrame(frame)
        }
    }
    
    var grouping: String? {
        get {
            if let frame = self.frames[.grouping],
                case .stringFrame(let stringFrame) = frame {
                return stringFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let frame = StringFrame(grouping: newValue ?? "")
            frames[.grouping] = .stringFrame(frame)
        }
    }
    
    var initialKey: String? {
        get {
            if let frame = self.frames[.initialKey],
                case .stringFrame(let stringFrame) = frame {
                return stringFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let frame = StringFrame(initialKey: newValue ?? "")
            frames[.initialKey] = .stringFrame(frame)
        }
    }
    
    var lyricist: String? {
        get {
            if let frame = self.frames[.lyricist],
                case .stringFrame(let stringFrame) = frame {
                return stringFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let frame = StringFrame(lyricist: newValue ?? "")
            frames[.lyricist] = .stringFrame(frame)
        }
    }
    
    var mood: String? {
        get {
            if let frame = self.frames[.mood],
                case .stringFrame(let stringFrame) = frame {
                return stringFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let frame = StringFrame(mood: newValue ?? "")
            frames[.mood] = .stringFrame(frame)
        }
    }
    
    var movementName: String? {
        get {
            if let frame = self.frames[.movementName],
                case .stringFrame(let stringFrame) = frame {
                return stringFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let frame = StringFrame(movementName: newValue ?? "")
            frames[.movementName] = .stringFrame(frame)
        }
    }
    
    var originalAlbum: String? {
        get {
            if let frame = self.frames[.originalAlbum],
                case .stringFrame(let stringFrame) = frame {
                return stringFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let frame = StringFrame(originalAlbum: newValue ?? "")
            frames[.originalAlbum] = .stringFrame(frame)
        }
    }
    
    var originalArtist: String? {
        get {
            if let frame = self.frames[.originalArtist],
                case .stringFrame(let stringFrame) = frame {
                return stringFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let frame = StringFrame(originalArtist: newValue ?? "")
            frames[.originalArtist] = .stringFrame(frame)
        }
    }
    
    var originalFilename: String? {
        get {
            if let frame = self.frames[.originalFilename],
                case .stringFrame(let stringFrame) = frame {
                return stringFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let frame = StringFrame(originalFilename: newValue ?? "")
            frames[.originalFilename] = .stringFrame(frame)
        }
    }
    
    var originalLyricist: String? {
        get {
            if let frame = self.frames[.originalLyricist],
                case .stringFrame(let stringFrame) = frame {
                return stringFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let frame = StringFrame(originalLyricist: newValue ?? "")
            frames[.originalLyricist] = .stringFrame(frame)
        }
    }
    
    var podcastCategory: String? {
        get {
            if let frame = self.frames[.podcastCategory],
                case .stringFrame(let stringFrame) = frame {
                return stringFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let frame = StringFrame(podcastCategory: newValue ?? "")
            frames[.podcastCategory] = .stringFrame(frame)
        }
    }
    
    var podcastDescription: String? {
        get {
            if let frame = self.frames[.podcastDescription],
                case .stringFrame(let stringFrame) = frame {
                return stringFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let frame = StringFrame(podcastDescription: newValue ?? "")
            frames[.podcastDescription] = .stringFrame(frame)
        }
    }
    
    var podcastID: String? {
        get {
            if let frame = self.frames[.podcastID],
                case .stringFrame(let stringFrame) = frame {
                return stringFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let frame = StringFrame(podcastID: newValue ?? "")
            frames[.podcastID] = .stringFrame(frame)
        }
    }
    
    var podcastKeywords: String? {
        get {
            if let frame = self.frames[.podcastKeywords],
                case .stringFrame(let stringFrame) = frame {
                return stringFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let frame = StringFrame(podcastKeywords: newValue ?? "")
            frames[.podcastKeywords] = .stringFrame(frame)
        }
    }
    
    var podcastFeedLink: String? {
        get {
            if let frame = self.frames[.podcastFeedLink],
                case .stringFrame(let stringFrame) = frame {
                return stringFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let frame = StringFrame(podcastFeedLink: newValue ?? "")
            frames[.podcastFeedLink] = .stringFrame(frame)
        }
    }
    
    var producedNotice: String? {
        get {
            if let frame = self.frames[.producedNotice],
                case .stringFrame(let stringFrame) = frame {
                return stringFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let frame = StringFrame(producedNotice: newValue ?? "")
            frames[.producedNotice] = .stringFrame(frame)
        }
    }
    
    var publisher: String? {
        get {
            if let frame = self.frames[.publisher],
                case .stringFrame(let stringFrame) = frame {
                return stringFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let frame = StringFrame(publisher: newValue ?? "")
            frames[.publisher] = .stringFrame(frame)
        }
    }
    
    var label: String? {
        get {
            if let frame = self.frames[.label],
                case .stringFrame(let stringFrame) = frame {
                return stringFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let frame = StringFrame(label: newValue ?? "")
            frames[.label] = .stringFrame(frame)
        }
    }
    
    var recordCompany: String? {
        get {
            if let frame = self.frames[.recordCompany],
                case .stringFrame(let stringFrame) = frame {
                return stringFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let frame = StringFrame(recordCompany: newValue ?? "")
            frames[.recordCompany] = .stringFrame(frame)
        }
    }
    
    var studio: String? {
        get {
            if let frame = self.frames[.studio],
                case .stringFrame(let stringFrame) = frame {
                return stringFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let frame = StringFrame(studio: newValue ?? "")
            frames[.studio] = .stringFrame(frame)
        }
    }
    
    var radioStation: String? {
        get {
            if let frame = self.frames[.radioStation],
                case .stringFrame(let stringFrame) = frame {
                return stringFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let frame = StringFrame(radioStation: newValue ?? "")
            frames[.radioStation] = .stringFrame(frame)
        }
    }
    
    var radioStationOwner: String? {
        get {
            if let frame = self.frames[.radioStationOwner],
                case .stringFrame(let stringFrame) = frame {
                return stringFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let frame = StringFrame(radioStationOwner: newValue ?? "")
            frames[.radioStationOwner] = .stringFrame(frame)
        }
    }
    
    var setSubtitle: String? {
        get {
            if let frame = self.frames[.setSubtitle],
                case .stringFrame(let stringFrame) = frame {
                return stringFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let frame = StringFrame(setSubtitle: newValue ?? "")
            frames[.setSubtitle] = .stringFrame(frame)
        }
    }
    
    var subtitle: String? {
        get {
            if let frame = self.frames[.subtitle],
                case .stringFrame(let stringFrame) = frame {
                return stringFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let frame = StringFrame(subtitle: newValue ?? "")
            frames[.subtitle] = .stringFrame(frame)
        }
    }
    
    var title: String? {
        get {
            if let frame = self.frames[.title],
                case .stringFrame(let stringFrame) = frame {
                return stringFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let frame = StringFrame(title: newValue ?? "")
            frames[.title] = .stringFrame(frame)
        }
    }
    
    var titleSort: String? {
        get {
            if let frame = self.frames[.titleSort],
                case .stringFrame(let stringFrame) = frame {
                return stringFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let frame = StringFrame(titleSort: newValue ?? "")
            frames[.titleSort] = .stringFrame(frame)
        }
    }
    
    var artistWebpage: String? {
        get {
            if let frame = self.frames[.artistWebpage],
                case .urlFrame(let urlFrame) = frame {
                return urlFrame.urlString
            } else {
                return nil
            }
        }
        set {
            let frame = URLFrame(artistWebsiteUrl: newValue ?? "")
            frames[.artistWebpage] = .urlFrame(frame)
        }
    }
    
    var audioFileWebpage: String? {
        get {
            if let frame = self.frames[.audioFileWebpage],
                case .urlFrame(let urlFrame) = frame {
                return urlFrame.urlString
            } else {
                return nil
            }
        }
        set {
            let frame = URLFrame(officialAudioFileWebsiteUrl: newValue ?? "")
            frames[.audioFileWebpage] = .urlFrame(frame)
        }
    }
    
    var audioSourceWebpage: String? {
        get {
            if let frame = self.frames[.audioSourceWebpage],
                case .urlFrame(let urlFrame) = frame {
                return urlFrame.urlString
            } else {
                return nil
            }
        }
        set {
            let frame = URLFrame(officialAudioSourceWebsiteUrl: newValue ?? "")
            frames[.audioSourceWebpage] = .urlFrame(frame)
        }
    }
    
    var copyrightWebpage: String? {
        get {
            if let frame = self.frames[.copyrightWebpage],
                case .urlFrame(let urlFrame) = frame {
                return urlFrame.urlString
            } else {
                return nil
            }
        }
        set {
            let frame = URLFrame(copyrightWebsiteUrl: newValue ?? "")
            frames[.copyrightWebpage] = .urlFrame(frame)
        }
    }
    
    var paymentWebpage: String? {
        get {
            if let frame = self.frames[.paymentWebpage],
                case .urlFrame(let urlFrame) = frame {
                return urlFrame.urlString
            } else {
                return nil
            }
        }
        set {
            let frame = URLFrame(paymentWebsiteUrl: newValue ?? "")
            frames[.paymentWebpage] = .urlFrame(frame)
        }
    }
    
    var publisherWebpage: String? {
        get {
            if let frame = self.frames[.publisherWebpage],
                case .urlFrame(let urlFrame) = frame {
                return urlFrame.urlString
            } else {
                return nil
            }
        }
        set {
            let frame = URLFrame(publisherWebsiteUrl: newValue ?? "")
            frames[.publisherWebpage] = .urlFrame(frame)
        }
    }
    
    var radioStationWebpage: String? {
        get {
            if let frame = self.frames[.radioStationWebpage],
                case .urlFrame(let urlFrame) = frame {
                return urlFrame.urlString
            } else {
                return nil
            }
        }
        set {
            let frame = URLFrame(internetRadioStationWebsiteUrl: newValue ?? "")
            frames[.radioStationWebpage] = .urlFrame(frame)
        }
    }
    
    var bpm: Int? {
        get {
            if let frame = self.frames[.bpm],
                case .integerFrame(let integerFrame) = frame {
                return integerFrame.value
            } else {
                return nil
            }
        }
        set {
            let frame = IntegerFrame(bpm: newValue ?? 0)
            frames[.bpm] = .integerFrame(frame)
        }
    }
    
    var isrc: Int? {
        get {
            if let frame = self.frames[.isrc],
                case .integerFrame(let integerFrame) = frame {
                return integerFrame.value
            } else {
                return nil
            }
        }
        set {
            let frame = IntegerFrame(isrc: newValue ?? 0)
            frames[.isrc] = .integerFrame(frame)
        }
    }
    
    var length: Int? {
        get {
            if let frame = self.frames[.length],
                case .integerFrame(let integerFrame) = frame {
                return integerFrame.value
            } else {
                return nil
            }
        }
        set {
            let frame = IntegerFrame(length: newValue ?? 0)
            frames[.length] = .integerFrame(frame)
        }
    }
    
    var movementCount: Int? {
        get {
            if let frame = self.frames[.movementCount],
                case .integerFrame(let integerFrame) = frame {
                return integerFrame.value
            } else {
                return nil
            }
        }
        set {
            let frame = IntegerFrame(totalMovements: newValue ?? 0)
            frames[.movementCount] = .integerFrame(frame)
        }
    }
    
    var movementNumber: Int? {
        get {
            if let frame = self.frames[.movementNumber],
                case .integerFrame(let integerFrame) = frame {
                return integerFrame.value
            } else {
                return nil
            }
        }
        set {
            let frame = IntegerFrame(movementNumber: newValue ?? 0)
            frames[.movementNumber] = .integerFrame(frame)
        }
    }
    
    var playlistDelay: Int? {
        get {
            if let frame = self.frames[.playlistDelay],
                case .integerFrame(let integerFrame) = frame {
                return integerFrame.value
            } else {
                return nil
            }
        }
        set {
            let frame = IntegerFrame(playlistDelay: newValue ?? 0)
            frames[.playlistDelay] = .integerFrame(frame)
        }
    }
    
    var compliation: Bool? {
        get {
            if let frame = self.frames[.compilation],
                case .booleanFrame(let booleanFrame) = frame {
                return booleanFrame.value
            } else {
                return nil
            }
        }
        set {
            let frame = BooleanFrame(value: newValue ?? false)
            frames[.compilation] = .booleanFrame(frame)
        }
    }
    
    var discNumber: (disc: Int, totalDiscs: Int?) {
        get {
            if let frame = self.frames[.discNumber],
                case .partOfTotalFrame(let partOfTotalFrame) = frame {
                return (partOfTotalFrame.part, partOfTotalFrame.total)
            } else {
                return (0,0)
            }
        }
        set {
            let frame = PartOfTotalFrame(disc: newValue.0, totalDiscs: newValue.1)
            frames[.discNumber] = .partOfTotalFrame(frame)
        }
    }
    
    var trackNumber: (track: Int, totalTracks: Int?) {
        get {
            if let frame = self.frames[.trackNumber],
                case .partOfTotalFrame(let partOfTotalFrame) = frame {
                return (partOfTotalFrame.part, partOfTotalFrame.total)
            } else {
                return (0,0)
            }
        }
        set {
            let frame = PartOfTotalFrame(track: newValue.0, totalTracks: newValue.1)
            frames[.trackNumber] = .partOfTotalFrame(frame)
        }
    }
    
    var languages: [String] {
        get {
            if let frame = self.frames[.languages],
                case .languageFrame(let languageFrame) = frame {
                return languageFrame.languages
            } else {
                return []
            }
        }
        set {
            let frame = LanguageFrame(languages: newValue )
            frames[.languages] = .languageFrame(frame)
        }
    }
    
    var userDefinedText: (description: String?, content: String) {
        get {
            if let frame = self.frames[.userDefinedText(description: "")],
                case .userTextFrame(let userTextFrame) = frame {
                return (userTextFrame.descriptionString, userTextFrame.contentString)
            } else {
                return ("","")
            }
        }
        set {
            let frame = UserTextFrame(description: newValue.description ?? "", content: newValue.content)
            frames[.userDefinedText(description: newValue.description ?? "")] = .userTextFrame(frame)
        }
    }
    
    var userDefinedWebpage: (description: String?, content: String) {
        get {
            if let frame = self.frames[.userDefinedWebpage(description: "")],
                case .userTextFrame(let userTextFrame) = frame {
                return (userTextFrame.descriptionString, userTextFrame.contentString)
            } else {
                return ("","")
            }
        }
        set {
            let frame = UserTextFrame(description: newValue.description ?? "", webpage: newValue.content)
            frames[.userDefinedText(description: newValue.description ?? "")] = .userTextFrame(frame)
        }
    }
    
    var acknowledgment: String? {
        get {
            if let frame = self.frames[.userDefinedText(description: "Acknowledgment")],
                case .userTextFrame(let userTextFrame) = frame {
                return userTextFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let frame = UserTextFrame(description: "Acknowledgment", content: newValue ?? "")
            frames[.userDefinedText(description: "Acknowledgment")] = .userTextFrame(frame)
        }
    }
    
    var thanks: String? {
        get {
            if let frame = self.frames[.userDefinedText(description: "Thanks")],
                case .userTextFrame(let userTextFrame) = frame {
                return userTextFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let frame = UserTextFrame(description: "Thanks", content: newValue ?? "")
            frames[.userDefinedText(description: "Thanks")] = .userTextFrame(frame)
        }
    }
    
    var sourceCredit: String? {
        get {
            if let frame = self.frames[.userDefinedText(description: "Source Credit")],
                case .userTextFrame(let userTextFrame) = frame {
                return userTextFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let frame = UserTextFrame(description: "Source Credit", content: newValue ?? "")
            frames[.userDefinedText(description: "Source Credit")] = .userTextFrame(frame)
        }
    }
    
    var genre: (genreName: String?, genreDescription: String?) {
        get {
            if let frame = self.frames[.genre],
                case .presetOptionsFrame(let presetOptionsFrame) = frame {
                return (presetOptionsFrame.presetName, presetOptionsFrame.refinementDescription)
            } else {
                return ("","")
            }
        }
        set {
            let frame = PresetOptionsFrame(genreName: newValue.genreName ?? "", genreDescription: newValue.genreDescription ?? "")
            frames[.genre] = .presetOptionsFrame(frame)
        }
    }
    
    var mediaType: (mediaType: String?, additionalMediaInfo: String?, mediaTypeDescription: String?) {
        get {
            if let frame = self.frames[.mediaType],
                case .presetOptionsFrame(let presetOptionsFrame) = frame {
                return (presetOptionsFrame.presetName, presetOptionsFrame.presetRefinement, presetOptionsFrame.refinementDescription)
            } else {
                return ("","","")
            }
        }
        set {
            let frame = PresetOptionsFrame(
                mediaType: newValue.mediaType ?? "",
                additionalMediaInfo: newValue.additionalMediaInfo,
                mediaTypeDescription: newValue.mediaTypeDescription ?? "")
            frames[.mediaType] = .presetOptionsFrame(frame)
        }
    }
    
    var comments: (language: String?, description: String?, comment: String) {
        get {
            if let frame = self.frames[.comments(description: "")],
                case .localizedFrame(let localizedFrame) = frame {
                return (language: localizedFrame.languageString,
                        description: localizedFrame.descriptionString,
                        comment: localizedFrame.contentString)
            } else {
                return (language: "und", description: "", comment: "")
            }
        }
        set {
            let frame = LocalizedFrame(language: newValue.language,
                                       description: newValue.description,
                                       comments: newValue.comment)
            frames[.comments(description: newValue.description ?? "")] = .localizedFrame(frame)
        }
    }
    
    var lyrics: (language: String?, description: String?, lyrics: String) {
        get {
            if let frame = self.frames[.unsynchronizedLyrics(description: "")],
                case .localizedFrame(let localizedFrame) = frame {
                return (language: localizedFrame.languageString,
                        description: localizedFrame.descriptionString,
                        lyrics: localizedFrame.contentString)
            } else {
                return (language: "und", description: "", lyrics: "")
            }
        }
        set {
            let frame = LocalizedFrame(language: newValue.language,
                                       description: newValue.description,
                                       comments: newValue.lyrics)
            frames[.unsynchronizedLyrics(description: newValue.description ?? "")] = .localizedFrame(frame)
        }
    }
    
    var description: (language: String?, contentDescription: String) {
        get {
            if let frame = self.frames[.comments(description: "Description")],
                case .localizedFrame(let localizedFrame) = frame {
                return (language: localizedFrame.languageString,
                        contentDescription: localizedFrame.contentString)
            } else {
                return (language: "und", contentDescription: "")
            }
        }
        set {
            let frame = LocalizedFrame(language: newValue.language,
                                       description: "Description",
                                       comments: newValue.contentDescription)
            frames[.comments(description: "Description")] = .localizedFrame(frame)
        }
    }
    
    var shortDescription: (language: String?, shortDescription: String) {
        get {
            if let frame = self.frames[.comments(description: "Short Description")],
                case .localizedFrame(let localizedFrame) = frame {
                return (language: localizedFrame.languageString,
                        shortDescription: localizedFrame.contentString)
            } else {
                return (language: "und", shortDescription: "")
            }
        }
        set {
            let frame = LocalizedFrame(language: newValue.language,
                                       description: "Short Description",
                                       comments: newValue.shortDescription)
            frames[.comments(description: "Short Description")] = .localizedFrame(frame)
        }
    }
    
    var longDescription: (language: String?, longDescription: String) {
        get {
            if let frame = self.frames[.comments(description: "Long Description")],
                case .localizedFrame(let localizedFrame) = frame {
                return (language: localizedFrame.languageString,
                        longDescription: localizedFrame.contentString)
            } else {
                return (language: "und", longDescription: "")
            }
        }
        set {
            let frame = LocalizedFrame(language: newValue.language,
                                       description: "Long Description",
                                       comments: newValue.longDescription)
            frames[.comments(description: "Long Description")] = .localizedFrame(frame)
        }
    }
    
    var linerNotes: (language: String?, linerNotes: String) {
        get {
            if let frame = self.frames[.comments(description: "Liner Notes")],
                case .localizedFrame(let localizedFrame) = frame {
                return (language: localizedFrame.languageString,
                        linerNotes: localizedFrame.contentString)
            } else {
                return (language: "und", linerNotes: "")
            }
        }
        set {
            let frame = LocalizedFrame(language: newValue.language,
                                       description: "Liner Notes",
                                       comments: newValue.linerNotes)
            frames[.comments(description: "Liner Notes")] = .localizedFrame(frame)
        }
    }
    
    var songDescription: (language: String?, songDescription: String) {
        get {
            if let frame = self.frames[.comments(description: "Song Description")],
                case .localizedFrame(let localizedFrame) = frame {
                return (language: localizedFrame.languageString,
                        songDescription: localizedFrame.contentString)
            } else {
                return (language: "und", songDescription: "")
            }
        }
        set {
            let frame = LocalizedFrame(language: newValue.language,
                                       description: "Song Description",
                                       comments: newValue.songDescription)
            frames[.comments(description: "Song Description")] = .localizedFrame(frame)
        }
    }
    
    var seriesDescription: (language: String?, seriesDescription: String) {
        get {
            if let frame = self.frames[.comments(description: "Series Description")],
                case .localizedFrame(let localizedFrame) = frame {
                return (language: localizedFrame.languageString,
                        seriesDescription: localizedFrame.contentString)
            } else {
                return (language: "und", seriesDescription: "")
            }
        }
        set {
            let frame = LocalizedFrame(language: newValue.language,
                                       description: "Series Description",
                                       comments: newValue.seriesDescription)
            frames[.comments(description: "Series Description")] = .localizedFrame(frame)
        }
    }
    
    var musicianCreditList: [(role: String, person: String)] {
        get {
            if let frame = self.frames[.musicianCreditsList],
                case .creditsListFrame(let creditsListFrame) = frame {
                return creditsListFrame.entries
            } else {
                return []
            }
        }
        set {
            let frame = CreditsListFrame(layout: .known(.musicianCreditsList), entries: newValue)
            frames[.musicianCreditsList] = .creditsListFrame(frame)
        }
    }
    
    var involvedPeopleList: [(role: String, person: String)] {
        get {
            if let frame = self.frames[.involvedPeopleList],
                case .creditsListFrame(let creditsListFrame) = frame {
                return creditsListFrame.entries
            } else {
                return []
            }
        }
        set {
            let frame = CreditsListFrame(layout: .known(.involvedPeopleList), entries: newValue)
            frames[.involvedPeopleList] = .creditsListFrame(frame)
        }
    }
    
    var date: String? {
        get {
            if let frame = self.frames[.date],
                case .dateFrame(let dateFrame) = frame {
                return dateFrame.timeStampString
            } else {
                return nil
            }
        }
        set {
            let frame = DateFrame(layout: .known(.date), timeStampString: newValue ?? "")
            frames[.date] = .dateFrame(frame)
        }
    }
    
    var time: String? {
        get {
            if let frame = self.frames[.time],
                case .dateFrame(let dateFrame) = frame {
                return dateFrame.timeStampString
            } else {
                return nil
            }
        }
        set {
            let frame = DateFrame(layout: .known(.time), timeStampString: newValue ?? "")
            frames[.time] = .dateFrame(frame)
        }
    }
    
    var year: String? {
        get {
            if let frame = self.frames[.year],
                case .dateFrame(let dateFrame) = frame {
                return dateFrame.timeStampString
            } else {
                return nil
            }
        }
        set {
            let frame = DateFrame(layout: .known(.year), timeStampString: newValue ?? "")
            frames[.year] = .dateFrame(frame)
        }
    }
    
    var releaseDateTime: String? {
        get {
            if let frame = self.frames[.releaseTime],
                case .dateFrame(let dateFrame) = frame {
                return dateFrame.timeStampString
            } else {
                return nil
            }
        }
        set {
            let frame = DateFrame(layout: .known(.releaseTime), timeStampString: newValue ?? "")
            frames[.releaseTime] = .dateFrame(frame)
        }
    }
    
    var encodingDateTime: String? {
        get {
            if let frame = self.frames[.encodingTime],
                case .dateFrame(let dateFrame) = frame {
                return dateFrame.timeStampString
            } else {
                return nil
            }
        }
        set {
            let frame = DateFrame(layout: .known(.encodingTime), timeStampString: newValue ?? "")
            frames[.encodingTime] = .dateFrame(frame)
        }
    }
    
    var originalReleaseDate: String? {
        get {
            if let frame = self.frames[.originalReleaseTime],
                case .dateFrame(let dateFrame) = frame {
                return dateFrame.timeStampString
            } else {
                return nil
            }
        }
        set {
            let frame = DateFrame(layout: .known(.originalReleaseTime), timeStampString: newValue ?? "")
            frames[.originalReleaseTime] = .dateFrame(frame)
        }
    }
    
    var recordingDateTime: String? {
        get {
            if let frame = self.frames[.recordingDate],
                case .dateFrame(let dateFrame) = frame {
                return dateFrame.timeStampString
            } else {
                return nil
            }
        }
        set {
            let frame = DateFrame(layout: .known(.recordingDate), timeStampString: newValue ?? "")
            frames[.recordingDate] = .dateFrame(frame)
        }
    }
    
    var taggingDateTime: String? {
        get {
            if let frame = self.frames[.taggingTime],
                case .dateFrame(let dateFrame) = frame {
                return dateFrame.timeStampString
            } else {
                return nil
            }
        }
        set {
            let frame = DateFrame(layout: .known(.taggingTime), timeStampString: newValue ?? "")
            frames[.taggingTime] = .dateFrame(frame)
        }
    }
    
    
}
