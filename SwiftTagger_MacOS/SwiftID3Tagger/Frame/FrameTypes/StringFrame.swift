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
public struct StringFrame: FrameProtocol {
    
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
    

    // MARK: Public Initializers
    // initializers for each specific type of string frame
    public init(artist: String) {
        self.init(layout: .known(.artist), contentString: artist)
    }
    
    public init(album: String) {
        self.init(layout: .known(.album), contentString: album)
    }
    
    public init(albumSort: String) {
        self.init(layout: .known(.albumSort), contentString: albumSort)
    }
    
    public init(albumArtist: String) {
        self.init(layout: .known(.albumArtist), contentString: albumArtist)
    }
    
    public init(albumArtistSort: String) {
        self.init(layout: .known(.albumArtistSort), contentString: albumArtistSort)
    }
    
    public init(artistSort: String) {
        self.init(layout: .known(.artistSort), contentString: artistSort)
    }
    
    public init(arranger: String) {
        self.init(layout: .known(.arranger), contentString: arranger)
    }
    
    public init(composer: String) {
        self.init(layout: .known(.composer), contentString: composer)
    }
    
    public init(composerSort: String) {
        self.init(layout: .known(.composerSort), contentString: composerSort)
    }
    
    public init(conductor: String) {
        self.init(layout: .known(.conductor), contentString: conductor)
    }
    
    public init(contentGroup: String) {
        self.init(layout: .known(.contentGroup), contentString: contentGroup)
    }
    
    public init(copyright: String) {
        self.init(layout: .known(.copyright), contentString: copyright)
    }
    
    public init(encodedBy: String) {
        self.init(layout: .known(.encodedBy), contentString: encodedBy)
    }
    
    public init(encodingSettings: String) {
        self.init(layout: .known(.encodingSettings), contentString: encodingSettings)
    }
        
    public init(fileOwner: String) {
        self.init(layout: .known(.fileOwner), contentString: fileOwner)
    }
    
    public init(grouping: String) {
        self.init(layout: .known(.grouping), contentString: grouping)
    }
    
    public init(initialKey: KeySignature) {
        let keyString = initialKey.rawValue
        self.init(layout: .known(.initialKey), contentString: keyString)
    }
    
    public init(lyricist: String) {
        self.init(layout: .known(.lyricist), contentString: lyricist)
    }
    
    public init(mediaType: String) {
        self.init(layout: .known(.mediaType), contentString: mediaType)
    }
    
    public init(mood: String) {
        self.init(layout: .known(.mood), contentString: mood)
    }
    
    public init(movementName: String) {
        self.init(layout: .known(.movementName), contentString: movementName)
    }
    
    public init(originalAlbum: String) {
        self.init(layout: .known(.originalAlbum), contentString: originalAlbum)
    }
    
    public init(originalArtist: String) {
        self.init(layout: .known(.originalArtist), contentString: originalArtist)
    }
    
    public init(originalFilename: String) {
        self.init(layout: .known(.originalFilename), contentString: originalFilename)
    }
    
    public init(originalLyricist: String) {
        self.init(layout: .known(.originalLyricist), contentString: originalLyricist)
    }
    
    public init(podcastCategory: String) {
        self.init(layout: .known(.podcastCategory), contentString: podcastCategory)
    }
    
    public init(podcastDescription: String) {
        self.init(layout: .known(.podcastDescription), contentString: podcastDescription)
    }
    
    public init(podcastID: String) {
        self.init(layout: .known(.podcastID), contentString: podcastID)
    }
    
    public init(podcastKeywords: String) {
        self.init(layout: .known(.podcastKeywords), contentString: podcastKeywords)
    }
    
    public init(podcastFeedLink: String) {
        self.init(layout: .known(.podcastFeedLink), contentString: podcastFeedLink)
    }
    
    public init(producedNotice: String) {
        self.init(layout: .known(.producedNotice), contentString: producedNotice)
    }
    
    public init(publisher: String) {
        self.init(layout: .known(.publisher), contentString: publisher)
    }
    
    public init(radioStation: String) {
        self.init(layout: .known(.radioStation), contentString: radioStation)
    }
    
    public init(radioStationOwner: String) {
        self.init(layout: .known(.radioStationOwner), contentString: radioStationOwner)
    }
    
    public init(setSubtitle: String) {
        self.init(layout: .known(.setSubtitle), contentString: setSubtitle)
    }
    
    public init(subtitle: String) {
        self.init(layout: .known(.subtitle), contentString: subtitle)
    }
    
    public init(title: String) {
        self.init(layout: .known(.title), contentString: title)
    }

    public init(titleSort: String) {
        self.init(layout: .known(.titleSort), contentString: titleSort)
    }

    public init(remixer: String) {
        self.init(layout: .known(.arranger), contentString: remixer)
    }
    
    public init(interpretedBy: String) {
        self.init(layout: .known(.arranger), contentString: interpretedBy)
    }
    
    public init(work: String) {
        self.init(layout: .known(.contentGroup), contentString: work)
    }
    
    public init(author: String) {
        self.init(layout: .known(.artist), contentString: author)
    }
    
    public init(authorSort: String) {
        self.init(layout: .known(.artistSort), contentString: authorSort)
    }
    
    public init(narrator: String) {
        self.init(layout: .known(.composer), contentString: narrator)
    }
    
    public init(narratorSort: String) {
        self.init(layout: .known(.composerSort), contentString: narratorSort)
    }
    
    public init(recordCompany: String) {
        self.init(layout: .known(.publisher), contentString: recordCompany)
    }
    
    public init(studio: String) {
        self.init(layout: .known(.publisher), contentString: studio)
    }
    
    public init(label: String) {
        self.init(layout: .known(.publisher), contentString: label)
    }
    
    public init(series: String) {
        self.init(layout: .known(.contentGroup), contentString: series)
    }
    
}
