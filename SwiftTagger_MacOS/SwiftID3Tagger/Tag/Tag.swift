//
//  Tag.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/10/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

/// A type representing an ID3 tag to be read from or written to a file
public struct Tag {
    
    public var frames: [FrameKey : Frame]
    
    /// handles the parsing of an ID3 tag
    init(readFrom file: Mp3File) throws {
        // a type containing tag-level properties and methods for querying tag-level information
        let properties = TagProperties()
        
        // the data derived from the input file
        let fileData: Data = file.data
        
        // the file data as a data subsequence
        var remainder: Data.SubSequence = fileData[fileData.startIndex..<fileData.endIndex]
        
        // initialized variables for tagSize and Version
        var tagSize: Data.Index = 0
        var version: Version = .v2_4
        
        // validate file is an mp3 file
        if file.location.pathExtension.lowercased() != "mp3" {
            throw Mp3File.Error.InvalidFileFormat
        } else {
            // parse version data from tag header
            // the first five bytes of a valid ID3 Tag are "ID3"+ the version number in UInt8
            let versionData = remainder.extractFirst(properties.versionDeclarationLength)
            version = try properties.version(data: versionData)
            // parse flags from tag header. This data is generally unused and use of this data is not supported by SwiftTagger
            _ = remainder.extractFirst(properties.tagFlagsLength)
            // parse size from tag header
            let tagSizeData = remainder.extractFirst(properties.tagSizeDeclarationLength)
            tagSize = try properties.size(data: tagSizeData)
        }
        
        // set range of tag data using tag size as the upper bound
        let tagDataRange = remainder.startIndex ..< remainder.startIndex + tagSize
        remainder = remainder.subdata(in: tagDataRange)
        
        // parse frames from remaining tag data
        var frames: [FrameKey : Frame] = [:]
        while !remainder.isEmpty  {
            // extract frame identifier data
            let identifierBytes = remainder.extractFirst(version.identifierLength)
            // check to be sure the data is a frame
            if identifierBytes.first == 0x00 { break } // Padding, not a frame.
            // convert data to string
            let identifier = try String(ascii: identifierBytes)
            // hand the data over to `Frame` to decide which frame handler it goes to
            let frame = try Frame(
                identifier: identifier,
                data: &remainder,
                version: version)
            
            // used parsed frame data to get frame key
            let frameKey = frame.frameKey
            // add frame and framekey to frames dictionary
            frames[frameKey] = frame
        }
        self.frames = frames
    }
}

public extension Tag {
    
    /// - Album frame getter-setter. ID3 Identifier: `TAL`/`TALB`
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
    
    /// - AlbumArtist frame getter-setter. ID3 Identifier: `TP2`/`TPE2`
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
    
    /// - AlbumSort frame getter-setter. ID3 Identifier: `TSA`/`TSOA`
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
    
    /// AlbumArtistSort frame getter-setter. ID3 Identifier: `TS2`/`TSO2`
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
    
    /// Arranger/Remixer/InterpretedBy getter-setter. ID3 Identifier: `TP4`/`TPE4`.
    /// If another frame of this type already exists, this will write as a
    /// `TXX`/`TXXX` frame with a description of `Arranger`
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
    
    /// Arranger/Remixer/InterpretedBy getter-setter. ID3 Identifier: `TP4`/`TPE4`
    /// If a `TP4`/`TPE4` frame already exists, this will write as a
    /// `TXX`/`TXXX` frame with a description of `Remixer`
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

    /// Arranger/Remixer/InterpretedBy getter-setter. ID3 Identifier: `TP4`/`TPE4`
    /// If a `TP4`/`TPE4` frame already exists, this will write as a
    /// `TXX`/`TXXX` frame with a description of `InterpretedBy`
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

    /// Artist getter-setter. ID3 Identifier: `TP1`/`TPE1`
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
    
    /// ArtistSort getter-setter. ID3 Identifier: `TSP`/`TSOP`
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
    
    /// Author getter-setter. Writes to `Artist` frame, ID3 Identifier: `TP1`/`TPE1`.
    /// If another frame of this type already exists, this will write as a
    /// `TXX`/`TXXX` frame with a description of `Author`
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
    
    /// AuthorSort getter-setter. Writes to `ArtistSort` frame, ID3 Identifier: `TSP`/`TSOP`.
    /// If another frame of this type already exists, this will write as a
    /// `TXX`/`TXXX` frame with a description of `AuthorSort`
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
    
    /// Composer getter-setter. ID3 Identifier: `TCM`/`TCOM`
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
    
    /// ComposerSort getter-setter. ID3 Identifier: `TSC`/`TSOC`
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
    
    /// Narrator getter-setter. Writes to `Composer` frame, ID3 Identifier: `TCM`/`TCOM`.
    /// If another frame of this type already exists, this will write as a
    /// `TXX`/`TXXX` frame with a description of `Narrator`
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
    
    /// NarratorSort getter-setter. Writes to `ComposerSort` frame,
    /// ID3 Identifier: `TSC`/`TSOC`.
    /// If another frame of this type already exists, this will write as a
    /// `TXX`/`TXXX` frame with a description of `NarratorSort`
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
    
    /// Conductor getter-setter. ID3 Identifier: `TP3`/`TPE3`
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
    
    /// ContentGroup getter-setter. ID3 Identifier: `TT1`/`TIT1`
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
    
    /// WorkName getter-setter. Writes to `ContentGroup` frame,
    /// ID3 Identifier: `TT1`/`TIT1`.
    /// If another frame of this type already exists, this will write as a
    /// `TXX`/`TXXX` frame with a description of `Work`
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
    
    /// Copyright getter-setter. ID3 Identifier: `TCR`/`TCOP`
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
    
    /// EncodedBy getter-setter. ID3 Identifier: `TEN`/`TENC`
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
    
    /// EncodingSettings getter-setter. ID3 Identifier: `TSS`/`TSSE`
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
    
    /// FileOwner getter-setter. ID3 Identifier: `TOWN`. Valid only for tag versions 2.3/2.4
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
    
    /// Grouping getter-setter. This is a non-standard, iTunes compliant frame.
    /// ID3 Identifier: `GRP1`
    /// Valid only for tag versions 2.3/2.4
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
    
    /// InitialKey getter-setter. ID3 Identifier: `TKE`/`TKEY`
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
    
    /// Lyricist getter-setter. ID3 Identifier: `TXT`/`TEXT`
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
    
    /// Mood getter-setter. ID3 Identifier: `TMOO`. Valid only for tag version 2.4
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
    
    /// MovementName getter-setter. This is a non-standard, iTunes compliant frame
    /// ID3 Identifier: `MVNM`. Valid only for tag versions 2.3/2.4
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
    
    /// OriginalAlbum getter-setter. ID3 Identifier: `TOT`/`TOAL`.
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
    
    /// OriginalArtist getter-setter. ID3 Identifier: `TOP`/`TOPE`.
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
    
    /// OriginalFilename getter-setter. ID3 Identifier: `TOF`/`TOFN`.
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
    
    /// OriginalLyricist getter-setter. ID3 Identifier: `TOL`/`TOLY`.
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
    
    /// PodcastCategory getter-setter. This is a non-standard, iTunes compliant frame
    /// ID3 Identifier: `TCAT`. Valid only for tag versions 2.3/2.4
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
    
    /// PodcastDescription getter-setter. This is a non-standard, iTunes compliant frame
    /// ID3 Identifier: `TDES`. Valid only for tag versions 2.3/2.4
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
    
    /// PodcastID getter-setter. This is a non-standard, iTunes compliant frame
    /// ID3 Identifier: `TGID`. Valid only for tag versions 2.3/2.4
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
    
    /// PodcastKeywords getter-setter. This is a non-standard, iTunes compliant frame
    /// ID3 Identifier: `TKWD`. Valid only for tag versions 2.3/2.4
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
    
    /// PodcastFeedLink getter-setter. This is a non-standard, iTunes compliant frame
    /// ID3 Identifier: `WFED`. Valid only for tag versions 2.3/2.4
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
    
    /// ProducedNotice getter-setter. ID3 Identifier: `TPRO`. Valid for tag version 2.4 only
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
    
    /// Publisher getter-setter. ID3 Identifier: `TPB`/`TPUB`.
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
    
    /// Label getter-setter. Writes to `Publisher` frame,
    /// ID3 Identifier: `TPB`/`TPUB`.
    /// If another frame of this type already exists, this will write as a
    /// `TXX`/`TXXX` frame with a description of `Label`
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
    
    /// RecordCompany getter-setter. Writes to `Publisher` frame,
    /// ID3 Identifier: `TPB`/`TPUB`.
    /// If another frame of this type already exists, this will write as a
    /// `TXX`/`TXXX` frame with a description of `RecordCompany`
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
    
    /// Studio getter-setter. Writes to `Publisher` frame,
    /// ID3 Identifier: `TPB`/`TPUB`.
    /// If another frame of this type already exists, this will write as a
    /// `TXX`/`TXXX` frame with a description of `Studio`
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
    
    /// (Internet)RadioStation getter-setter. ID3 Identifier: `TRS`/`TRSN`.
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
    
    /// (Internet)RadioStationOwner getter-setter. ID3 Identifier: `TRO`/`TRSO`.
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
    
    /// SetSubtitle getter-setter. ID3 Identifier: `TSST`. Valid for tag version 2.4 only.
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
    
    /// Subtitle getter-setter. ID3 Identifier: `TT3`/`TIT3`
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
    
    /// Title getter-setter. ID3 Identifier: `TT2`/`TIT2`
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
    
    /// TitleSort getter-setter. ID3 Identifier: `TST`/`TSOT`
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
    
    /// ArtistWebpage getter-setter. ID3 Identifier: `WAR`/`WOAR`
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
    
    /// (Official)AudioFileWebpage getter-setter. ID3 Identifier: `WAF`/`WOAF`
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
    
    /// (Official)AudioSourceWebpage getter-setter. ID3 Identifier: `WAS`/`WOAS`
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
    
    /// Copyright/Legal Information Webpage getter-setter. ID3 Identifier: `WCP`/`WCOP`
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
    
    /// PaymentWebpage getter-setter. ID3 Identifier: `WPAY`
    /// Valid for tag versions 2.3/2.4 only
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
    
    /// PublisherWebpage getter-setter. ID3 Identifier: `WPB`/`WPUB`
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
    
    /// (Official Internet)RadioStationWebpage getter-setter. ID3 Identifier: `WRS`/`WORS`
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
    
    /// BeatsPerMinute getter-setter. ID3 Identifier: `TBP`/`TBPM`
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
    
    /// IRSC getter-setter. ID3 Identifier: `TRC`/`TSRC`
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
    
    /// Length getter-setter. ID3 Identifier: `TLE`/`TLEN`
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
    
    /// TotalMovements getter-setter. This is a non-standard, iTunes compliant frame
    /// ID3 Identifier: `MVCN`. Valid only for tag versions 2.3/2.4
    var totalMovements: Int? {
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
    
    /// MovementNumber getter-setter. This is a non-standard, iTunes compliant frame
    /// ID3 Identifier: `MVIN`. Valid only for tag versions 2.3/2.4
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
    
    /// PlaylistDelay getter-setter. ID3 Identifier: `TDY`/`TDLY`
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
    
    /// Compilation flag getter-setter. This is a non-standard, iTunes compliant frame
    /// ID3 Identifier: `TCP`/`TCMP`.
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
    
    /// DiscNumber(/TotalDiscs) getter-setter. ID3 Identifier: `TPA`/`TPOS`
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
    
    /// TrackNumber(/TotalTracks) getter-setter. ID3 Identifier: `TRK`/`TRCK`
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
    
    /// Languages getter-setter. ID3 Identifier: `TLA`/`TLAN`
    var languages: [String]? {
        get {
            if let frame = self.frames[.languages],
                case .languageFrame(let languageFrame) = frame {
                return languageFrame.languages
            } else {
                return []
            }
        }
        set {
            let frame = LanguageFrame(languages: newValue ?? ["und"] )
            frames[.languages] = .languageFrame(frame)
        }
    }
        
    /// Acknowledgment getter-setter. This is a convenience for a custom `TXX`/`TXXX` frame with a description of `Acknowledgment`
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
    
    /// Thanks getter-setter. This is a convenience for a custom `TXX`/`TXXX` frame with a description of `Thanks`
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
    
    /// SourceCredit getter-setter. This is a convenience for a custom `TXX`/`TXXX` frame with a description of `Source Credit`
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
    
    /// Genre getter-setter. ID3 Identifier: `TCO`/`TCON`
    /// The `genreName` parameter refers to specific genre or genres catalogued by numeric codes in the `GenreType` enum.
    /// The `genreDescription` parameter is a freeform field that may be used to refine existing genres or create custom genres
    var genre: (genreName: String?, genreDescription: String?) {
        get {
            if let frame = self.frames[.genre],
                case .presetOptionsFrame(let presetOptionsFrame) = frame {
                return (presetOptionsFrame.presetName, presetOptionsFrame.refinementDescription)
            } else {
                return (nil,nil)
            }
        }
        set {
            let frame = PresetOptionsFrame(genreName: newValue.genreName ?? "", genreDescription: newValue.genreDescription ?? "")
            frames[.genre] = .presetOptionsFrame(frame)
        }
    }
    
    /// MediaType getter-setter. ID3 Identifier: `TMT`/`TMED`
    /// The `mediaType` parameter refers to specific type of media catalogued by codes in the `MediaType` enum.
    /// The `additionalMediaInfo` parameter refers to specific type of refinement pertaining to the `MediaType`, catalogued by codes in the `MediaTypeRefinements` enum
    /// The `mediaTypeDescription` parameter is a freeform field that may be used to refine existing information
    var mediaType: (mediaType: String?, additionalMediaInfo: String?, mediaTypeDescription: String?) {
        get {
            if let frame = self.frames[.mediaType],
                case .presetOptionsFrame(let presetOptionsFrame) = frame {
                return (presetOptionsFrame.presetName, presetOptionsFrame.presetRefinement, presetOptionsFrame.refinementDescription)
            } else {
                return (nil,nil,nil)
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

    /// FileType getter-setter. ID3 Identifier: `TFT`/`TFLT`
    /// The `fileType` parameter refers to specific type of file catalogued by codes in the `FileType` enum.
    /// The `additionalFileTypeInfo` parameter refers to specific type of refinement pertaining to the `FileType`, catalogued by codes in the `FileTypeRefinements` enum
    /// The `fileTypeDescription` parameter is a freeform field that may be used to refine existing information
    var fileType: (fileType: String?, additionalFileTypeInfo: String?, fileTypeDescription: String?) {
        get {
            if let frame = self.frames[.fileType],
                case .presetOptionsFrame(let presetOptionsFrame) = frame {
                return (presetOptionsFrame.presetName, presetOptionsFrame.presetRefinement, presetOptionsFrame.refinementDescription)
            } else {
                return (nil,nil,nil)
            }
        }
        set {
            let frame = PresetOptionsFrame(
                fileType: newValue.fileType ?? "",
                additionalFileTypeInfo: newValue.additionalFileTypeInfo,
                fileTypeDescription: newValue.fileTypeDescription ?? "")
            frames[.fileType] = .presetOptionsFrame(frame)
        }
    }

    /// Description getter-setter. This is a convenience for a custom `COM`/`COMM` frame with a description of `Description`
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
    
    /// ShortDescription getter-setter. This is a convenience for a custom `COM`/`COMM` frame with a description of `Short Description`
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
    
    /// LongDescription getter-setter. This is a convenience for a custom `COM`/`COMM` frame with a description of `Long Description`
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
    
    /// LinerNotes getter-setter. This is a convenience for a custom `COM`/`COMM` frame with a description of `Liner Notes`
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
    
    /// SongDescription getter-setter. This is a convenience for a custom `COM`/`COMM` frame with a description of `Song Description`
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
    
    /// SeriesDescription getter-setter. This is a convenience for a custom `COM`/`COMM` frame with a description of `Series Description`
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
    
    /// MusicianCreditsList frame getter-setter. Valid only for tag version 2.4
    /// ID3 Identifier: `TMCL`
    /// the `role` parameter refers to an instrument, vocal part, or other performance-related task.
    /// the `person` parameter is the name of the person or people performing the `role`
    var musicianCreditList: [(role: String, person: String)]? {
        get {
            if let frame = self.frames[.musicianCreditsList],
                case .creditsListFrame(let creditsListFrame) = frame {
                return creditsListFrame.entries
            } else {
                return []
            }
        }
        set {
            let frame = CreditsListFrame(layout: .known(.musicianCreditsList), entries: newValue ?? [])
            frames[.musicianCreditsList] = .creditsListFrame(frame)
        }
    }
    
    /// InvolvedPeopleList frame getter-setter. ID3 Identifier: `IPL`/`IPLS`/`TIPL`
    /// the `role` parameter refers to a production or support-oriented task (for tag version 2.4)
    /// or to any performance or production related job (for tag versions 2.2 and 2.3)
    /// the `person` parameter is the name of the person or people performing the `role`
    var involvedPeopleList: [(role: String, person: String)]? {
        get {
            if let frame = self.frames[.involvedPeopleList],
                case .creditsListFrame(let creditsListFrame) = frame {
                return creditsListFrame.entries
            } else {
                return []
            }
        }
        set {
            let frame = CreditsListFrame(layout: .known(.involvedPeopleList), entries: newValue ?? [])
            frames[.involvedPeopleList] = .creditsListFrame(frame)
        }
    }
    
    /// (Release) Date frame getter-setter. Valid for versions 2.2 and 2.3 only.
    /// ID3 Identifier: `TDA`/`TDAT`
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
    
    /// (Release) Time frame getter-setter. Valid for versions 2.2 and 2.3 only.
    /// ID3 Identifier: `TIM`/`TIME`
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
    
    /// (Release) Year frame getter-setter. Valid for versions 2.2 and 2.3 only.
    /// ID3 Identifier: `TYE`/`TYER`
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
    
    /// (Release) DateTime frame getter-setter. ID3 Identifier: `TDRL` Valid for version 2.4 only
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
    
    /// EncodingDateTime frame getter-setter. ID3 Identifier: `TDEN`. Valid for Tag Version 2.4 only
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
    
    /// OriginalReleaseDateTime frame getter-setter. ID3 Identifier: `TOY`/`TORY`/`TDOR`
    /// intended to be a year-only field for tag versions 2.2 and 2.3
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
    
    /// RecordingDateTime frame getter-setter. ID3 Identifier: `TRD`/`TRDA`/`TDRC`
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
    
    /// TaggingDateTime frame getter-setter. ID3 Identifier: `TDTG`. Valid for Tag Version 2.4 only
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
 
    /// Comments frame getter-setter. ID3 Identifier `COM`/`COMM`
    subscript(comments language: ISO6392Codes.RawValue, commentsDescription: String) -> String? {
        get {
            if let frame = self.frames[.comments(description: commentsDescription)],
                case .localizedFrame(let localizedFrame) = frame {
                return localizedFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let key = FrameKey.comments(description: commentsDescription)
            if let new = newValue {
                self.frames[key] = Frame.localizedFrame(.init(language: language, description: commentsDescription, comments: new))
            } else {
                self.frames[key] = nil
            }
        }
    }

    /// (Unsynchronized) lyrics frame getter-setter. ID3 Identifier `ULT`/`USLT`
    subscript(lyrics language: ISO6392Codes.RawValue, lyricsDescription: String) -> String? {
        get {
            if let frame = self.frames[.unsynchronizedLyrics(description: lyricsDescription)],
                case .localizedFrame(let localizedFrame) = frame {
                return localizedFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let key = FrameKey.unsynchronizedLyrics(description: lyricsDescription)
            if let new = newValue {
                self.frames[key] = Frame.localizedFrame(.init(language: language, description: lyricsDescription, lyrics: new))
            } else {
                self.frames[key] = nil
            }
        }
    }

    /// UserDefinedText frame getter-setter. ID3 Identifier `TXX`/`TXXX`
    subscript(userDefinedText userTextDescription: String) -> String? {
        get {
            if let frame = self.frames[.userDefinedText(description: userTextDescription)],
                case .userTextFrame(let userTextFrame) = frame {
                return userTextFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let key = FrameKey.userDefinedText(description: userTextDescription)
            if let new = newValue {
                self.frames[key] = Frame.userTextFrame(.init(description: userTextDescription, content: new))
            } else {
                self.frames[key] = nil
            }
        }
    }
    
    /// UserDefinedWebpage frame getter-setter. ID3 Identifier `WXX`/`WXXX`
    subscript(userDefinedUrl userDefinedUrlDescription: String) -> String? {
        get {
            if let frame = self.frames[.userDefinedWebpage(description: userDefinedUrlDescription)],
                case .userTextFrame(let userTextFrame) = frame {
                return userTextFrame.contentString
            } else {
                return nil
            }
        }
        set {
            let key = FrameKey.userDefinedWebpage(description: userDefinedUrlDescription)
            if let new = newValue {
                self.frames[key] = Frame.userTextFrame(.init(description: userDefinedUrlDescription, content: new))
            } else {
                self.frames[key] = nil
            }
        }
    }
    
    /// TableOfContents frame getter-setter. Valid for tag versions 2.3 and 2.4 only.
    /// ID3 Identifier `CTOC`
    subscript(tableOfContents tocElementID: String) -> TableOfContentsFrame? {
        get {
            if let frame = self.frames[.tableOfContents(elementID: tocElementID)],
                case .tocFrame(let tocFrame) = frame {
                return tocFrame
            } else {
                return nil
            }
        }
        set {
            let key = FrameKey.tableOfContents(elementID: tocElementID)
            if let new = newValue {
                self.frames[key] = Frame.tocFrame(.init(
                    isTopTOC: new.topLevelFlag,
                    elementsAreOrdered: new.orderedFlag,
                    childElementIDs: new.childElementIDs,
                    embeddedSubframes: new.embeddedSubframes))
            } else {
                self.frames[key] = nil
            }
        }
    }
        
    /// Chapter frame getter-setter. Valid for tag versions 2.3 and 2.4 only.
    /// ID3 Identifier `CHAP`
    subscript(chapters chapterElementID: String) -> ChapterFrame? {
        get {
            if let frame = self.frames[.chapter(elementID: chapterElementID)],
                case .chapterFrame(let chapterFrame) = frame {
                return chapterFrame
            } else {
                return nil
            }
        }
        set {
            let key = FrameKey.chapter(elementID: chapterElementID)
            if let new = newValue {
                self.frames[key] = Frame.chapterFrame(.init(
                    startTime: new.startTime,
                    endTime: new.endTime,
                    embeddedSubframes: new.embeddedSubframes))
            }
        }
    }

    
    
}
