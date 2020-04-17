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
    
    private var contentString: String
    
    /**
     A frame with only string content, presented as a single string without`(/n)` newline characters.
     - parameter contentString: the content of the frame.
     */
    private init(layout: FrameLayoutIdentifier, contentString: String) {
        self.contentString = contentString
        self.flags = StringFrame.defaultFlags()
        self.layout = layout
    }
    
    internal func encodeContents(version: Version) throws -> Data {
        
    }
    
    // MARK: Decode
    // decode incoming data and parse it into a frame
    internal var flags: Data
    internal var layout: FrameLayoutIdentifier
    
    internal init(decodingContents contents: Data.SubSequence,
                  version: Version,
                  layout: FrameLayoutIdentifier,
                  flags: Data) throws {
        self.flags = flags
        self.layout = layout
        var parsing = contents
        let encoding = StringFrame.extractEncoding(data: &parsing, version: version)
        self.contentString = parsing.extractPrefixAsStringUntilNullTermination(encoding) ?? ""
    }
    
    init(artist: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.artist), contentString: artist)
    }
    
    init(album: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.album), contentString: album)
    }

    init(albumSort: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.albumSort), contentString: albumSort)
    }

    init(albumArtist: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.albumArtist), contentString: albumArtist)
    }

    init(albumArtistSort: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.albumArtistSort), contentString: albumArtistSort)
    }

    init(artistSort: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.artistSort), contentString: artistSort)
    }

    init(arranger: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.arranger), contentString: arranger)
    }

    init(composer: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.composer), contentString: composer)
    }

    init(composerSort: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.composerSort), contentString: composerSort)
    }

    init(conductor: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.conductor), contentString: conductor)
    }

    init(contentGroup: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.contentGroup), contentString: contentGroup)
    }
    
    init(copyright: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.copyright), contentString: copyright)
    }

    init(encodedBy: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.encodedBy), contentString: encodedBy)
    }

    init(encodingSettings: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.encodingSettings), contentString: encodingSettings)
    }
    
    init(fileType: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.fileType), contentString: fileType)
    }

    init(fileOwner: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.fileOwner), contentString: fileOwner)
    }

    init(grouping: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.grouping), contentString: grouping)
    }

    init(initialKey: KeySignature.RawValue) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.initialKey), contentString: initialKey)
    }

    init(lyricist: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.lyricist), contentString: lyricist)
    }
    
    init(mediaType: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.mediaType), contentString: mediaType)
    }

    init(mood: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.mood), contentString: mood)
    }

    init(movementName: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.movementName), contentString: movementName)
    }

    init(originalAlbum: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.originalAlbum), contentString: originalAlbum)
    }

    init(originalArtist: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.originalArtist), contentString: originalArtist)
    }

    init(originalFilename: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.originalFilename), contentString: originalFilename)
    }

    init(originalLyricist: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.originalLyricist), contentString: originalLyricist)
    }

    init(podcastCategory: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.podcastCategory), contentString: podcastCategory)
    }

    init(podcastDescription: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.podcastDescription), contentString: podcastDescription)
    }

    init(podcastID: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.podcastID), contentString: podcastID)
    }

    init(podcastKeywords: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.podcastKeywords), contentString: podcastKeywords)
    }

    init(podcastFeedLink: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.podcastFeedLink), contentString: podcastFeedLink)
    }

    init(producedNotice: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.producedNotice), contentString: producedNotice)
    }

    init(publisher: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.publisher), contentString: publisher)
    }

    init(internetRadioStation: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.radioStation), contentString: internetRadioStation)
    }

    init(internetRadioStationOwner: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.radioStationOwner), contentString: internetRadioStationOwner)
    }

    init(setSubtitle: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.setSubtitle), contentString: setSubtitle)
    }

    init(subtitle: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.subtitle), contentString: subtitle)
    }

    init(title: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.titleSort), contentString: title)
    }

    init(remixer: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.arranger), contentString: remixer)
    }

    init(interpretedBy: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.arranger), contentString: interpretedBy)
    }

    init(work: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.contentGroup), contentString: work)
    }

    init(author: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.artist), contentString: author)
    }

    init(authorSort: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.artistSort), contentString: authorSort)
    }

    init(narrator: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.composer), contentString: narrator)
    }

    init(narratorSort: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.composerSort), contentString: narratorSort)
    }

    init(recordCompany: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.publisher), contentString: recordCompany)
    }

    init(studio: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.publisher), contentString: studio)
    }

    init(label: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.publisher), contentString: label)
    }

    init(series: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.contentGroup), contentString: series)
    }

}
