//
//  StringFrame.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/11/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

/**
 A type representing an ID3 frame that holds a single string, such as Artist, Title, Album, etc
 */
struct StringFrame: FrameProtocol {
    
    // MARK: Decoding
    // decode incoming data and parse it into a frame
    var flags: Data
    var layout: FrameLayoutIdentifier
    var frameKey: FrameKey
    var allowMultipleFrames: Bool = false
    
    // instantiates a string frame decoding operation
    init(decodingContents contents: Data.SubSequence,
         version: Version,
         layout: FrameLayoutIdentifier,
         flags: Data
    ) throws {
        self.flags = flags
        self.layout = layout
        
        switch layout {
            case .known(.album): self.frameKey = .album
            case .known(.albumSort): self.frameKey = .albumSort
            case .known(.albumArtist): self.frameKey = .albumArtist
            case .known(.albumArtistSort): self.frameKey = .albumArtistSort
            case .known(.arranger): self.frameKey = .arranger
            case .known(.artist): self.frameKey = .artist
            case .known(.artistSort): self.frameKey = .artistSort
            case .known(.composer): self.frameKey = .composer
            case .known(.composerSort): self.frameKey = .composerSort
            case .known(.conductor): self.frameKey = .conductor
            case .known(.contentGroup): self.frameKey = .contentGroup
            case .known(.copyright): self.frameKey = .copyright
            case .known(.encodedBy): self.frameKey = .encodedBy
            case .known(.encodingSettings): self.frameKey = .encodingSettings
            case .known(.fileOwner): self.frameKey = .fileOwner
            case .known(.grouping): self.frameKey = .grouping
            case .known(.initialKey): self.frameKey = .initialKey
            case .known(.lyricist): self.frameKey = .lyricist
            case .known(.mood): self.frameKey = .mood
            case .known(.movementName): self.frameKey = .movementName
            case .known(.originalAlbum): self.frameKey = .originalAlbum
            case .known(.originalArtist): self.frameKey = .originalArtist
            case .known(.originalFilename): self.frameKey = .originalFilename
            case .known(.originalLyricist): self.frameKey = .originalLyricist
            case .known(.podcastCategory): self.frameKey = .podcastCategory
            case .known(.podcastDescription): self.frameKey = .podcastDescription
            case .known(.podcastFeedLink): self.frameKey = .podcastFeedLink
            case .known(.podcastID): self.frameKey = .podcastID
            case .known(.podcastKeywords): self.frameKey = .podcastKeywords
            case .known(.producedNotice): self.frameKey = .producedNotice
            case .known(.publisher): self.frameKey = .publisher
            case .known(.radioStation): self.frameKey = .radioStation
            case .known(.radioStationOwner): self.frameKey = .radioStationOwner
            case .known(.setSubtitle): self.frameKey = .setSubtitle
            case .known(.subtitle): self.frameKey = .subtitle
            case .known(.title): self.frameKey = .title
            case .known(.titleSort): self.frameKey = .titleSort
            default: self.frameKey = .userDefinedText(description: "")
        }
        var parsing = contents
        // extract and decode the encoding byte
        let encoding = try StringFrame.extractEncoding(data: &parsing, version: version)
        // extract and decode the string content according to encoding as specified by encoding byte
        self.contentString = parsing.extractPrefixAsStringUntilNullTermination(encoding) ?? ""
    }

    // MARK: Private initializer for encoding
    var contentString: String
    
    /**
     A frame with only string content, presented as a single string without`(/n)` newline characters.
     - parameter contentString: the content of the frame.
     */
    private init(layout: FrameLayoutIdentifier, contentString: String) {
        self.contentString = contentString
        self.flags = StringFrame.defaultFlags
        self.layout = layout
        
        switch layout {
            case .known(.album): self.frameKey = .album
            case .known(.albumSort): self.frameKey = .albumSort
            case .known(.albumArtist): self.frameKey = .albumArtist
            case .known(.albumArtistSort): self.frameKey = .albumArtistSort
            case .known(.arranger): self.frameKey = .arranger
            case .known(.artist): self.frameKey = .artist
            case .known(.artistSort): self.frameKey = .artistSort
            case .known(.composer): self.frameKey = .composer
            case .known(.composerSort): self.frameKey = .composerSort
            case .known(.conductor): self.frameKey = .conductor
            case .known(.contentGroup): self.frameKey = .contentGroup
            case .known(.copyright): self.frameKey = .copyright
            case .known(.encodedBy): self.frameKey = .encodedBy
            case .known(.encodingSettings): self.frameKey = .encodingSettings
            case .known(.fileOwner): self.frameKey = .fileOwner
            case .known(.grouping): self.frameKey = .grouping
            case .known(.initialKey): self.frameKey = .initialKey
            case .known(.lyricist): self.frameKey = .lyricist
            case .known(.mood): self.frameKey = .mood
            case .known(.movementName): self.frameKey = .movementName
            case .known(.originalAlbum): self.frameKey = .originalAlbum
            case .known(.originalArtist): self.frameKey = .originalArtist
            case .known(.originalFilename): self.frameKey = .originalFilename
            case .known(.originalLyricist): self.frameKey = .originalLyricist
            case .known(.podcastCategory): self.frameKey = .podcastCategory
            case .known(.podcastDescription): self.frameKey = .podcastDescription
            case .known(.podcastFeedLink): self.frameKey = .podcastFeedLink
            case .known(.podcastID): self.frameKey = .podcastID
            case .known(.podcastKeywords): self.frameKey = .podcastKeywords
            case .known(.producedNotice): self.frameKey = .producedNotice
            case .known(.publisher): self.frameKey = .publisher
            case .known(.radioStation): self.frameKey = .radioStation
            case .known(.radioStationOwner): self.frameKey = .radioStationOwner
            case .known(.setSubtitle): self.frameKey = .setSubtitle
            case .known(.subtitle): self.frameKey = .subtitle
            case .known(.title): self.frameKey = .title
            case .known(.titleSort): self.frameKey = .titleSort
            default: self.frameKey = .userDefinedText(description: "")
        }

    }
    
    // encode the contents of the frame to be added to a tag instance
    func encodeContents(version: Version) throws -> Data {
        let encodingByte = StringEncoding.preferred.rawValue.encoding(endianness: .bigEndian)
        let contents = self.contentString
        return encodingByte + contents.encoded(withNullTermination: false)
    }
    

    // MARK: Initializers
    // initializers for each specific type of string frame
    init(artist: String) {
        self.init(layout: .known(.artist), contentString: artist)
    }
    
    init(album: String) {
        self.init(layout: .known(.album), contentString: album)
    }
    
    init(albumSort: String) {
        self.init(layout: .known(.albumSort), contentString: albumSort)
    }
    
    init(albumArtist: String) {
        self.init(layout: .known(.albumArtist), contentString: albumArtist)
    }
    
    init(albumArtistSort: String) {
        self.init(layout: .known(.albumArtistSort), contentString: albumArtistSort)
    }
    
    init(artistSort: String) {
        self.init(layout: .known(.artistSort), contentString: artistSort)
    }
    
    init(arranger: String) {
        self.init(layout: .known(.arranger), contentString: arranger)
    }
    
    init(composer: String) {
        self.init(layout: .known(.composer), contentString: composer)
    }
    
    init(composerSort: String) {
        self.init(layout: .known(.composerSort), contentString: composerSort)
    }
    
    init(conductor: String) {
        self.init(layout: .known(.conductor), contentString: conductor)
    }
    
    init(contentGroup: String) {
        self.init(layout: .known(.contentGroup), contentString: contentGroup)
    }
    
    init(copyright: String) {
        self.init(layout: .known(.copyright), contentString: copyright)
    }
    
    init(encodedBy: String) {
        self.init(layout: .known(.encodedBy), contentString: encodedBy)
    }
    
    init(encodingSettings: String) {
        self.init(layout: .known(.encodingSettings), contentString: encodingSettings)
    }
        
    init(fileOwner: String) {
        self.init(layout: .known(.fileOwner), contentString: fileOwner)
    }
    
    init(grouping: String) {
        self.init(layout: .known(.grouping), contentString: grouping)
    }
    
    init(initialKey: KeySignature) {
        let keyString = initialKey.rawValue
        self.init(layout: .known(.initialKey), contentString: keyString)
    }
    
    init(lyricist: String) {
        self.init(layout: .known(.lyricist), contentString: lyricist)
    }
    
    init(mediaType: String) {
        self.init(layout: .known(.mediaType), contentString: mediaType)
    }
    
    init(mood: String) {
        self.init(layout: .known(.mood), contentString: mood)
    }
    
    init(movementName: String) {
        self.init(layout: .known(.movementName), contentString: movementName)
    }
    
    init(originalAlbum: String) {
        self.init(layout: .known(.originalAlbum), contentString: originalAlbum)
    }
    
    init(originalArtist: String) {
        self.init(layout: .known(.originalArtist), contentString: originalArtist)
    }
    
    init(originalFilename: String) {
        self.init(layout: .known(.originalFilename), contentString: originalFilename)
    }
    
    init(originalLyricist: String) {
        self.init(layout: .known(.originalLyricist), contentString: originalLyricist)
    }
    
    init(podcastCategory: String) {
        self.init(layout: .known(.podcastCategory), contentString: podcastCategory)
    }
    
    init(podcastDescription: String) {
        self.init(layout: .known(.podcastDescription), contentString: podcastDescription)
    }
    
    init(podcastID: String) {
        self.init(layout: .known(.podcastID), contentString: podcastID)
    }
    
    init(podcastKeywords: String) {
        self.init(layout: .known(.podcastKeywords), contentString: podcastKeywords)
    }
    
    init(podcastFeedLink: String) {
        self.init(layout: .known(.podcastFeedLink), contentString: podcastFeedLink)
    }
    
    init(producedNotice: String) {
        self.init(layout: .known(.producedNotice), contentString: producedNotice)
    }
    
    init(publisher: String) {
        self.init(layout: .known(.publisher), contentString: publisher)
    }
    
    init(radioStation: String) {
        self.init(layout: .known(.radioStation), contentString: radioStation)
    }
    
    init(radioStationOwner: String) {
        self.init(layout: .known(.radioStationOwner), contentString: radioStationOwner)
    }
    
    init(setSubtitle: String) {
        self.init(layout: .known(.setSubtitle), contentString: setSubtitle)
    }
    
    init(subtitle: String) {
        self.init(layout: .known(.subtitle), contentString: subtitle)
    }
    
    init(title: String) {
        self.init(layout: .known(.title), contentString: title)
    }

    init(titleSort: String) {
        self.init(layout: .known(.titleSort), contentString: titleSort)
    }

    init(remixer: String) {
        self.init(layout: .known(.arranger), contentString: remixer)
    }
    
    init(interpretedBy: String) {
        self.init(layout: .known(.arranger), contentString: interpretedBy)
    }
    
    init(work: String) {
        self.init(layout: .known(.contentGroup), contentString: work)
    }
    
    init(author: String) {
        self.init(layout: .known(.artist), contentString: author)
    }
    
    init(authorSort: String) {
        self.init(layout: .known(.artistSort), contentString: authorSort)
    }
    
    init(narrator: String) {
        self.init(layout: .known(.composer), contentString: narrator)
    }
    
    init(narratorSort: String) {
        self.init(layout: .known(.composerSort), contentString: narratorSort)
    }
    
    init(recordCompany: String) {
        self.init(layout: .known(.publisher), contentString: recordCompany)
    }
    
    init(studio: String) {
        self.init(layout: .known(.publisher), contentString: studio)
    }
    
    init(label: String) {
        self.init(layout: .known(.publisher), contentString: label)
    }
    
    init(series: String) {
        self.init(layout: .known(.contentGroup), contentString: series)
    }
    
}
