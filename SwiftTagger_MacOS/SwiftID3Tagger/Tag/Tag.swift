//
//  Tag.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/10/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation
import Cocoa

/// A type representing an ID3 tag to be read from or written to a file
public struct Tag {
    
    var frames: [FrameKey : Frame]
    
    init(readFromEmbeddedSubframes subframes: [FrameKey:Frame]) {
        self.frames = subframes
    }
    
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
    
//    func buildTag(mp3File: Mp3File) -> Data {
//        let mp3Data = mp3File.data
//
//
//    }
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
    
    /// - AlbumArtistSort frame getter-setter. ID3 Identifier: `TS2`/`TSO2`
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
    
    /// - Arranger/Remixer/InterpretedBy getter-setter. ID3 Identifier: `TP4`/`TPE4`.
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
    
    /// - Arranger/Remixer/InterpretedBy getter-setter. ID3 Identifier: `TP4`/`TPE4`
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

    /// - Arranger/Remixer/InterpretedBy getter-setter. ID3 Identifier: `TP4`/`TPE4`
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

    /// - Artist getter-setter. ID3 Identifier: `TP1`/`TPE1`
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
    
    /// - ArtistSort getter-setter. ID3 Identifier: `TSP`/`TSOP`
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
    
    /// - Author getter-setter. Writes to `Artist` frame, ID3 Identifier: `TP1`/`TPE1`.
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
    
    /// - AuthorSort getter-setter. Writes to `ArtistSort` frame, ID3 Identifier: `TSP`/`TSOP`.
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
    
    /// - Composer getter-setter. ID3 Identifier: `TCM`/`TCOM`
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
    
    /// - ComposerSort getter-setter. ID3 Identifier: `TSC`/`TSOC`
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
    
    /// - Narrator getter-setter. Writes to `Composer` frame, ID3 Identifier: `TCM`/`TCOM`.
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
    
    /// - NarratorSort getter-setter. Writes to `ComposerSort` frame,
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
    
    /// - Conductor getter-setter. ID3 Identifier: `TP3`/`TPE3`
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
    
    /// - ContentGroup getter-setter. ID3 Identifier: `TT1`/`TIT1`
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
    
    /// - WorkName getter-setter. Writes to `ContentGroup` frame,
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
    
    /// - Copyright getter-setter. ID3 Identifier: `TCR`/`TCOP`
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
    
    /// - EncodedBy getter-setter. ID3 Identifier: `TEN`/`TENC`
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
    
    /// - EncodingSettings getter-setter. ID3 Identifier: `TSS`/`TSSE`
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
    
    /// - FileOwner getter-setter. ID3 Identifier: `TOWN`. Valid only for tag versions 2.3/2.4
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
    
    /// - Grouping getter-setter. This is a non-standard, iTunes compliant frame.
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
    
    /// - InitialKey getter-setter. ID3 Identifier: `TKE`/`TKEY`
    var initialKey: String? {
        get {
            if let frame = self.frames[.initialKey],
                case .stringFrame(let stringFrame) = frame {
                return stringFrame.contentString
            } else {
                return nil
            }
        }
    }
 
    mutating func setInitialKey(initialKey: KeySignature) throws {
        let key = FrameKey.initialKey
        self.frames[key] = Frame.stringFrame(.init(initialKey: initialKey))
    }

    /// - Lyricist getter-setter. ID3 Identifier: `TXT`/`TEXT`
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
    
    /// - Mood getter-setter. ID3 Identifier: `TMOO`. Valid only for tag version 2.4
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
    
    /// - MovementName getter-setter. This is a non-standard, iTunes compliant frame
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
    
    /// - OriginalAlbum getter-setter. ID3 Identifier: `TOT`/`TOAL`.
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
    
    /// - OriginalArtist getter-setter. ID3 Identifier: `TOP`/`TOPE`.
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
    
    /// - OriginalFilename getter-setter. ID3 Identifier: `TOF`/`TOFN`.
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
    
    /// - OriginalLyricist getter-setter. ID3 Identifier: `TOL`/`TOLY`.
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
    
    /// - PodcastCategory getter-setter. This is a non-standard, iTunes compliant frame
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
    
    /// - PodcastDescription getter-setter. This is a non-standard, iTunes compliant frame
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
    
    /// - PodcastID getter-setter. This is a non-standard, iTunes compliant frame
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
    
    /// - PodcastKeywords getter-setter. This is a non-standard, iTunes compliant frame
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
    
    /// - PodcastFeedLink getter-setter. This is a non-standard, iTunes compliant frame
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
    
    /// - ProducedNotice getter-setter. ID3 Identifier: `TPRO`. Valid for tag version 2.4 only
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
    
    /// - Publisher getter-setter. ID3 Identifier: `TPB`/`TPUB`.
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
    
    /// - Label getter-setter. Writes to `Publisher` frame,
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
    
    /// - RecordCompany getter-setter. Writes to `Publisher` frame,
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
    
    /// - Studio getter-setter. Writes to `Publisher` frame,
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
    
    /// - (Internet)RadioStation getter-setter. ID3 Identifier: `TRS`/`TRSN`.
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
    
    /// - (Internet)RadioStationOwner getter-setter. ID3 Identifier: `TRO`/`TRSO`.
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
    
    /// - SetSubtitle getter-setter. ID3 Identifier: `TSST`. Valid for tag version 2.4 only.
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
    
    /// - Subtitle getter-setter. ID3 Identifier: `TT3`/`TIT3`
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
    
    /// - Title getter-setter. ID3 Identifier: `TT2`/`TIT2`
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
    
    /// - TitleSort getter-setter. ID3 Identifier: `TST`/`TSOT`
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
}
