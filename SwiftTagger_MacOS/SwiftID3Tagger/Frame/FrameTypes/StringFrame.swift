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
    
    var contentString: String
    
    /**
     A frame with only string content, presented as a single string without`(/n)` newline characters.
     - parameter contentString: the content of the frame.
     */
    private init(layout: FrameLayoutIdentifier, contentString: String) {
        self.contentString = contentString
//        self.flags = StringFrame.defaultFlags(version: version)
        self.layout = layout
    }
    
    func encodeContents(version: Version) throws -> Data {
        let contents = self.contentString
        return contents.encoded(withNullTermination: false)
    }
    
    // MARK: Decode
    // decode incoming data and parse it into a frame
//    var flags: Data
    var layout: FrameLayoutIdentifier
    
    init(decodingContents contents: Data.SubSequence,
                  version: Version,
                  layout: FrameLayoutIdentifier
//                  flags: Data
    ) throws {
//        self.flags = flags
        self.layout = layout
        var parsing = contents
        let encoding = StringFrame.extractEncoding(data: &parsing, version: version)
        self.contentString = parsing.extractPrefixAsStringUntilNullTermination(encoding) ?? ""
    }
    
    // MARK: Public Initializers
    public init(artist: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.artist), contentString: artist)
    }
    
    public init(album: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.album), contentString: album)
    }

    public init(albumSort: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.albumSort), contentString: albumSort)
    }

    public init(albumArtist: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.albumArtist), contentString: albumArtist)
    }

    public init(albumArtistSort: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.albumArtistSort), contentString: albumArtistSort)
    }

    public init(artistSort: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.artistSort), contentString: artistSort)
    }

    public init(arranger: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.arranger), contentString: arranger)
    }

    public init(composer: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.composer), contentString: composer)
    }

    public init(composerSort: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.composerSort), contentString: composerSort)
    }

    public init(conductor: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.conductor), contentString: conductor)
    }

    public init(contentGroup: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.contentGroup), contentString: contentGroup)
    }
    
    public init(copyright: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.copyright), contentString: copyright)
    }

    public init(encodedBy: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.encodedBy), contentString: encodedBy)
    }

    public init(encodingSettings: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.encodingSettings), contentString: encodingSettings)
    }
    
    public init(fileType: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.fileType), contentString: fileType)
    }

    public init(fileOwner: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.fileOwner), contentString: fileOwner)
    }

    public init(grouping: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.grouping), contentString: grouping)
    }

    public init(initialKey: KeySignature.RawValue) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.initialKey), contentString: initialKey)
    }

    public init(lyricist: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.lyricist), contentString: lyricist)
    }
    
    public init(mediaType: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.mediaType), contentString: mediaType)
    }

    public init(mood: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.mood), contentString: mood)
    }

    public init(movementName: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.movementName), contentString: movementName)
    }

    public init(originalAlbum: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.originalAlbum), contentString: originalAlbum)
    }

    public init(originalArtist: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.originalArtist), contentString: originalArtist)
    }

    public init(originalFilename: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.originalFilename), contentString: originalFilename)
    }

    public init(originalLyricist: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.originalLyricist), contentString: originalLyricist)
    }

    public init(podcastCategory: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.podcastCategory), contentString: podcastCategory)
    }

    public init(podcastDescription: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.podcastDescription), contentString: podcastDescription)
    }

    public init(podcastID: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.podcastID), contentString: podcastID)
    }

    public init(podcastKeywords: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.podcastKeywords), contentString: podcastKeywords)
    }

    public init(podcastFeedLink: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.podcastFeedLink), contentString: podcastFeedLink)
    }

    public init(producedNotice: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.producedNotice), contentString: producedNotice)
    }

    public init(publisher: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.publisher), contentString: publisher)
    }

    public init(internetRadioStation: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.radioStation), contentString: internetRadioStation)
    }

    public init(internetRadioStationOwner: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.radioStationOwner), contentString: internetRadioStationOwner)
    }

    public init(setSubtitle: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.setSubtitle), contentString: setSubtitle)
    }

    public init(subtitle: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.subtitle), contentString: subtitle)
    }

    public init(title: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.titleSort), contentString: title)
    }

    public init(remixer: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.arranger), contentString: remixer)
    }

    public init(interpretedBy: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.arranger), contentString: interpretedBy)
    }

    public init(work: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.contentGroup), contentString: work)
    }

    public init(author: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.artist), contentString: author)
    }

    public init(authorSort: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.artistSort), contentString: authorSort)
    }

    public init(narrator: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.composer), contentString: narrator)
    }

    public init(narratorSort: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.composerSort), contentString: narratorSort)
    }

    public init(recordCompany: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.publisher), contentString: recordCompany)
    }

    public init(studio: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.publisher), contentString: studio)
    }

    public init(label: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.publisher), contentString: label)
    }

    public init(series: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.contentGroup), contentString: series)
    }

}
