//
//  SwiftTaggerID3_Read_Tests.swift
//  SwiftTaggerID3Tests
//
//  Created by Nolaine Crusher on 4/21/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import XCTest
import SwiftTaggerID3

class SwiftTaggerID3_Read_Tests: XCTestCase {

    func testV22Reading() throws {
        let mp3Url = Bundle.writtenV22
        let mp3File = try Mp3File(location: mp3Url)
        let tag = try Tag(readFrom: mp3File)
        
        #warning("There's no sense running these V22 tests until I figure out the encoding issue with the written file")
//        XCTAssertEqual(tag.album, "Album")
    }
    
    func testV23Reading() throws {
        let mp3Url = Bundle.writtenV23
        let mp3File = try Mp3File(location: mp3Url)
        let tag = try Tag(readFrom: mp3File)

        XCTAssertEqual(tag.album, "Album")
        XCTAssertEqual(tag.albumArtist, "AlbumArtist")
        XCTAssertEqual(tag.albumArtistSort, "SortAlbumArtist")
        XCTAssertEqual(tag.albumSort, "SortAlbum")
        XCTAssertEqual(tag.arranger, "Arranger")
        XCTAssertEqual(tag.artist, "Artist")
        XCTAssertEqual(tag.artistSort, "SortArtist")
        XCTAssertEqual(tag.audioFileWebpage, "http://audiofile.url")
        XCTAssertEqual(tag.audioSourceWebpage, "http://audiosource.url")
        XCTAssertEqual(tag.author, "Artist")
        XCTAssertEqual(tag.authorSort, "SortArtist")
        XCTAssertEqual(tag.bpm, 99)
        XCTAssertEqual(tag.compilation, true)
        XCTAssertEqual(tag.composer, "Composer")
        XCTAssertEqual(tag.composerSort, "SortComposer")
        XCTAssertEqual(tag.conductor, "Conductor")
        XCTAssertEqual(tag.contentGroup, "Work")
        XCTAssertEqual(tag.copyright, "Copyright")
        XCTAssertEqual(tag.copyrightWebpage, "http://copyright.url")
        XCTAssertEqual(tag.discNumber.disc, 3)
        XCTAssertEqual(tag.discNumber.totalDiscs, 4)
        XCTAssertEqual(tag.encodedBy, "EncodedBy")
        XCTAssertEqual(tag.encodingSettings, "EncoderSettings")
        XCTAssertEqual(tag.fileOwner, "FileOwner")
        XCTAssertEqual(tag.grouping, "Grouping")
        XCTAssertEqual(tag.initialKey, .unknown )
        XCTAssertEqual(tag.interpretedBy, "Arranger")
        XCTAssertEqual(tag.isrc, 123456789012)
        XCTAssertEqual(tag.label, "Publisher")
        XCTAssertEqual(tag.languages, [.eng])
        XCTAssertEqual(tag.length, 5250)
        XCTAssertEqual(tag.lyricist, "Lyricist")
        XCTAssertEqual(tag.movementName, "MovementName")
        XCTAssertEqual(tag.totalMovements, 6)
        XCTAssertEqual(tag.narrator, "Composer")
        XCTAssertEqual(tag.narratorSort, "SortComposer")
        XCTAssertEqual(tag.originalAlbum, "OriginalAlbum")
        XCTAssertEqual(tag.originalArtist, "OriginalArtist")
        XCTAssertEqual(tag.originalFilename, "OriginalFilename")
        XCTAssertEqual(tag.originalLyricist, "OriginalLyricist")
        XCTAssertEqual(tag.publisher, "Publisher")
        XCTAssertEqual(tag.publisherWebpage, "http://publisher.url")
        XCTAssertEqual(tag.radioStation, "RadioStation")
        XCTAssertEqual(tag.radioStationOwner, "RadioStationOwner")
        XCTAssertEqual(tag.radioStationWebpage, "http://radiostation.url")
        XCTAssertEqual(tag.recordCompany, "Publisher")
        XCTAssertEqual(tag.remixer, "Arranger")
        XCTAssertEqual(tag.studio, "Publisher")
        XCTAssertEqual(tag.subtitle, "Subtitle")
        XCTAssertEqual(tag.series, "Work")
        XCTAssertEqual(tag.title, "Title")
        XCTAssertEqual(tag.titleSort, "SortTitle")
        XCTAssertEqual(tag.trackNumber.track, 1)
        XCTAssertEqual(tag.trackNumber.totalTracks, 2)
        XCTAssertEqual(tag.work, "Work")

    }
   
    func testProblemChildrenV23() throws {
        let mp3Url = Bundle.writtenV23
        let mp3File = try Mp3File(location: mp3Url)
        let tag = try Tag(readFrom: mp3File)
        
        XCTAssertEqual(tag.genre?.genreName, GenreType.none)
        XCTAssertEqual(tag.genre?.genreDescription, "Test Genre")
        // should not be nil, should be "Test Genre"
        // index 205-226
        // 54 43 4f 4e | 0 0 0 b | 0 0 | 0 | 54 65 73 74 20 47 65 6e 72 65 "Test Genre"
        // is there something in `54 65 73 74 20 47 65 6e 72 65` that is being read as 0 (or an integer string for 0?) Because that is the code for Blues.
        
        XCTAssertEqual(tag.mediaType?.additionalMediaInfo, MediaTypeRefinements.none)
        XCTAssertEqual(tag.mediaType?.mediaType, MediaType.none) // These two should be nil, but I think that means the frame is working as intended, because it should be returning .none if it comes up with Nil?
        XCTAssertEqual(tag.mediaType?.mediaTypeDescription, "MediaType")
        // should not be nil
        // index 594-614
        // 54 4d 45 44 | 0 0 0 a | 0 0 | 0 | 4d 65 64 69 61 54 79 70 65 - "MediaType"

        XCTAssertEqual(tag.involvedPeopleList?[.director], ["Director Name"])
        XCTAssertEqual(tag.involvedPeopleList?[.producer], ["Producer Name"])
        // index 760-816
        // 49 50 4c 53 | 0 0 0 2e | 0 0 | 0 |
        // 44 69 72 65 63 74 6f 72 0 = "Director"
        // 44 69 72 65 63 74 6f 72 20 4e 61 6d 65 0 = "Director Name"
        // 50 72 6f 64 75 63 65 72 0 = "Producer"
        // 50 72 6f 64 75 63 65 72 20 4e 61 6d 65 = "Producer Name"
        
        // both are being read as nil
    }

    func testV24Reading() throws {
        let mp3Url = Bundle.writtenV24
        let mp3File = try Mp3File(location: mp3Url)
        let tag = try Tag(readFrom: mp3File)
        
        XCTAssertEqual(tag.album, "Album")
        XCTAssertEqual(tag.albumArtist, "AlbumArtist")
        XCTAssertEqual(tag.albumArtistSort, "SortAlbumArtist")
        XCTAssertEqual(tag.albumSort, "SortAlbum")
        XCTAssertEqual(tag.arranger, "Arranger")
        XCTAssertEqual(tag.artist, "Artist")
        XCTAssertEqual(tag.artistSort, "SortArtist")
        XCTAssertEqual(tag.audioFileWebpage, "http://audiofile.url")
        XCTAssertEqual(tag.audioSourceWebpage, "http://audiosource.url")
        XCTAssertEqual(tag.author, "Artist")
        XCTAssertEqual(tag.authorSort, "SortArtist")
        XCTAssertEqual(tag.bpm, 99)
        XCTAssertEqual(tag.compilation, true)
        XCTAssertEqual(tag.composer, "Composer")
        XCTAssertEqual(tag.composerSort, "SortComposer")
        XCTAssertEqual(tag.conductor, "Conductor")
        XCTAssertEqual(tag.contentGroup, "Grouping")
        XCTAssertEqual(tag.copyright, "Copyright")
        XCTAssertEqual(tag.copyrightWebpage, "http://copyright.url")
        XCTAssertEqual(tag.discNumber.disc, 3)
        XCTAssertEqual(tag.discNumber.totalDiscs, 4)
        XCTAssertEqual(tag.encodedBy, "EncodedBy")
        XCTAssertEqual(tag.encodingSettings, "EncoderSettings")
        XCTAssertEqual(tag.fileOwner, "FileOwner")
        XCTAssertEqual(tag.grouping, "")
        XCTAssertEqual(tag.initialKey, .unknown )
        XCTAssertEqual(tag.interpretedBy, "Arranger")
        XCTAssertEqual(tag.isrc, 123456789012)
        XCTAssertEqual(tag.label, "Publisher")
        XCTAssertEqual(tag.languages, [.eng])
        XCTAssertEqual(tag.length, 5250)
        XCTAssertEqual(tag.lyricist, "Lyricist")
        XCTAssertEqual(tag.mood, "Mood")
        XCTAssertEqual(tag.movementName, "MovementName")
        XCTAssertEqual(tag.narrator, "Composer")
        XCTAssertEqual(tag.narratorSort, "SortComposer")
        XCTAssertEqual(tag.originalAlbum, "OriginalAlbum")
        XCTAssertEqual(tag.originalArtist, "OriginalArtist")
        XCTAssertEqual(tag.originalFilename, "OriginalFilename")
        XCTAssertEqual(tag.originalLyricist, "OriginalLyricist")
        XCTAssertEqual(tag.paymentWebpage, "http://payment.url")
        XCTAssertEqual(tag.producedNotice, "2020 ProducedNotice")
        XCTAssertEqual(tag.publisher, "Publisher")
        XCTAssertEqual(tag.publisherWebpage, "http://publisher.url")
        XCTAssertEqual(tag.radioStation, "RadioStation")
        XCTAssertEqual(tag.radioStationOwner, "RadioStationOwner")
        XCTAssertEqual(tag.radioStationWebpage, "http://radiostation.url")
        XCTAssertEqual(tag.recordCompany, "Publisher")
        XCTAssertEqual(tag.remixer, "Arranger")
        XCTAssertEqual(tag.studio, "Publisher")
        XCTAssertEqual(tag.subtitle, "Subtitle")
        XCTAssertEqual(tag.series, "Grouping")
        XCTAssertEqual(tag.title, "Title")
        XCTAssertEqual(tag.titleSort, "SortTitle")
        XCTAssertEqual(tag.trackNumber.track, 1)
        XCTAssertEqual(tag.trackNumber.totalTracks, 2)
        XCTAssertEqual(tag.work, "Grouping")

    }
 
    func testProblemChildrenV24() throws {
        let mp3Url = Bundle.writtenV24
        let mp3File = try Mp3File(location: mp3Url)
        let tag = try Tag(readFrom: mp3File)

        #warning("These aren't showing up, probably because the functions aren't complete yet")
        XCTAssertEqual(tag.involvedPeopleList?[.director], ["Director Name"])
        XCTAssertEqual(tag.involvedPeopleList?[.producer], ["Producer Name"])
        // index 873-929
        // 54 49 50 4c | 0 0 0 2e | 0 0 | 0 |
        // 44 69 72 65 63 74 6f 72 0 = "Director"
        // 44 69 72 65 63 74 6f 72 20 4e 61 6d 65 0 = "Director Name"
        // 50 72 6f 64 75 63 65 72 0 = "Producer"
        // 50 72 6f 64 75 63 65 72 20 4e 61 6d 65 = "Producer Name"
        // Both are being read as nil
        
        XCTAssertEqual(tag.musicianCreditsList?[.musician], ["Musician Name"])
        XCTAssertEqual(tag.musicianCreditsList?[.singer], ["Singer Name"])
        // index 971-1023
        // 54 4d 43 4c | 0 0 0 2a | 0 0 | 0 |
        // 4d 75 73 69 63 69 61 6e 0 = "Musician"
        // 4d 75 73 69 63 69 61 6e 20 4e 61 6d 65 0 = "Musician Name"
        // 53 69 6e 67 65 72 0 = "Singer"
        // 53 69 6e 67 65 72 20 4e 61 6d 65 = "Singer Name"
        // "Musician/Musician Name" works, but "Singer/Singer Name is nil?"
        // OH FOR PITY'S SAKE, NOW IT'S THE OTHER WAY AROUND! THE SECOND IS WORKING THE FIRST ISN'T
        
        XCTAssertEqual(tag.genre?.genreName, GenreType.none)
        XCTAssertEqual(tag.genre?.genreDescription, "Test Genre")
        XCTAssertNil(tag.mediaType?.mediaType) // Why is this nil here but not for version 2.3?
        XCTAssertEqual(tag.mediaType?.additionalMediaInfo, MediaTypeRefinements.none)
        XCTAssertEqual(tag.mediaType?.mediaTypeDescription, "MediaType") // should not be nil
    }
}
