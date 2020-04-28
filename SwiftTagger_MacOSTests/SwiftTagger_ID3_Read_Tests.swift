//
//  SwiftTagger_ID3_Read_Tests.swift
//  SwiftTagger_MacOSTests
//
//  Created by Nolaine Crusher on 4/21/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import XCTest
import SwiftTagger_MacOS

class SwiftTagger_ID3_Read_Tests: XCTestCase {

    func testReadV23() throws {
        let mp3File = try Bundle.mp3V23()
        let tag = try mp3File.read()

        XCTAssertEqual(tag.album, "Album")
        XCTAssertEqual(tag.albumArtist, "AlbumArtist")
        XCTAssertEqual(tag.albumSort, "SortAlbum")
        XCTAssertEqual(tag.albumArtistSort, "SortAlbumArtist")
        XCTAssertEqual(tag.artist, "Artist")
        XCTAssertEqual(tag.artistSort, "SortArtist")
        XCTAssertEqual(tag.artistWebpage, "http://artist.url")
        XCTAssertEqual(tag.arranger, "Arranger")
        XCTAssertEqual(tag.composer, "Composer")
        XCTAssertEqual(tag.composerSort, "SortComposer")
        XCTAssertEqual(tag.conductor, "Conductor")
        XCTAssertEqual(tag.contentGroup, "Grouping")
        XCTAssertEqual(tag.copyright, "Copyright")
        XCTAssertEqual(tag.encodedBy, "EncodedBy")
        XCTAssertEqual(tag.encodingSettings, "EncoderSettings")
        XCTAssertEqual(tag.fileOwner, "FileOwner")
        XCTAssertEqual(tag.initialKey, "b#")
        XCTAssertEqual(tag.lyricist, "Lyricist")
        XCTAssertEqual(tag.movementName, "MovementName")
        XCTAssertEqual(tag.originalAlbum, "OriginalAlbum")
        XCTAssertEqual(tag.originalArtist, "OriginalArtist")
        XCTAssertEqual(tag.originalFilename, "OriginalFilename")
        XCTAssertEqual(tag.originalLyricist, "OriginalLyricist")
        XCTAssertEqual(tag.publisher, "Publisher")
        XCTAssertEqual(tag.radioStation, "RadioStation")
        XCTAssertEqual(tag.radioStationOwner, "RadioStationOwner")
        XCTAssertEqual(tag.title, "Title")
        XCTAssertEqual(tag.titleSort, "SortTitle")
        XCTAssertEqual(tag.audioFileWebpage, "http://audiofile.url")
        XCTAssertEqual(tag.audioSourceWebpage, "http://audiosource.url")
        XCTAssertEqual(tag.copyrightWebpage, "http://copyright.url")
        XCTAssertEqual(tag.publisherWebpage, "http://publisher.url")
        XCTAssertEqual(tag.radioStationWebpage, "http://radiostation.url")
        XCTAssertEqual(tag.bpm, 99)
        XCTAssertEqual(tag.isrc, 123456789012)
        XCTAssertEqual(tag.length, 5250)
        XCTAssertEqual(tag.movementCount, 6)
        XCTAssertEqual(tag.movementNumber, 0)
        XCTAssertEqual(tag.playlistDelay, 20)
        XCTAssertEqual(tag.compliation, true)
        XCTAssertEqual(tag.discNumber.disc, 3)
        XCTAssertEqual(tag.discNumber.totalDiscs, 4)
        XCTAssertEqual(tag.trackNumber.track, 1)
        XCTAssertEqual(tag.trackNumber.totalTracks, 2)
        XCTAssertEqual(tag.languages,["eng"])
        XCTAssertEqual(tag.userDefinedText.description, "UserText")
        XCTAssertEqual(tag.userDefinedText.content, "User Defined Text Content")
        XCTAssertEqual(tag.userDefinedWebpage.description, "UserDefinedURL")
        XCTAssertEqual(tag.userDefinedWebpage.content, "http://userdefined.url")
//        XCTAssertEqual(tag.genre.genreName, "Genre")
//        XCTAssertEqual(tag.genre.genreDescription, "Genre")
        XCTAssertEqual(tag.mediaType.mediaType, nil)
        XCTAssertEqual(tag.mediaType.additionalMediaInfo, nil)
        XCTAssertEqual(tag.mediaType.mediaTypeDescription, nil)
        XCTAssertEqual(tag.comments.language, "eng")
        XCTAssertEqual(tag.comments.description, "CommentDescription")
        XCTAssertEqual(tag.comments.comment, "Comment Content")
        XCTAssertEqual(tag.lyrics.language, "eng")
        XCTAssertEqual(tag.lyrics.description, "LyricsDesscription")
        XCTAssertEqual(tag.lyrics.lyrics, "Lyrics Content")
    }
    
    
}
