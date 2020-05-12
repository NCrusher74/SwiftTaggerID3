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
        
        XCTAssertEqual(tag.album, "Album")
        XCTAssertEqual(tag.albumArtist, "AlbumArtist")
        XCTAssertEqual(tag.artist, "Artist")
        XCTAssertEqual(tag.author, "Artist")
        XCTAssertEqual(tag.title, "Title")
        XCTAssertEqual(tag.trackNumber?.track, 1)
        XCTAssertEqual(tag.trackNumber?.totalTracks, 2)
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
        XCTAssertEqual(tag.discNumber?.disc, 3)
        XCTAssertEqual(tag.discNumber?.totalDiscs, 4)
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
        XCTAssertEqual(tag.trackNumber?.track, 1)
        XCTAssertEqual(tag.trackNumber?.totalTracks, 2)
        XCTAssertEqual(tag.work, "Work")
        XCTAssertEqual(tag.involvedPeopleList?[.director], ["Director Name"])
        XCTAssertEqual(tag.involvedPeopleList?[.producer], ["Producer Name"])

        XCTAssertNil(tag.fileType?.fileType)
        XCTAssertNil(tag.fileType?.fileTypeRefinement)
        XCTAssertEqual(tag.fileType?.additionalInformation, "FileType")
        
        XCTAssertNil(tag.mediaType?.mediaType)
        XCTAssertNil(tag.mediaType?.mediaTypeRefinement)
        XCTAssertEqual(tag.mediaType?.additionalInformation, "MediaType")
        
        XCTAssertNil(tag.genre?.presetGenre)
        XCTAssertEqual(tag.genre?.customGenre, "Test Genre")
    }
   
    func testProblemChildrenV23() throws {
        let mp3Url = Bundle.writtenV23
        let mp3File = try Mp3File(location: mp3Url)
        let tag = try Tag(readFrom: mp3File)
        
        XCTAssertEqual(tag.year, 2019)
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
        XCTAssertEqual(tag.discNumber?.disc, 3)
        XCTAssertEqual(tag.discNumber?.totalDiscs, 4)
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
        XCTAssertEqual(tag.trackNumber?.track, 1)
        XCTAssertEqual(tag.trackNumber?.totalTracks, 2)
        XCTAssertEqual(tag.work, "Grouping")
        XCTAssertEqual(tag.involvedPeopleList?[.director], ["Director Name"])
        XCTAssertEqual(tag.involvedPeopleList?[.producer], ["Producer Name"])
        XCTAssertEqual(tag.musicianCreditsList?[.musician], ["Musician Name"])
        XCTAssertEqual(tag.musicianCreditsList?[.singer], ["Singer Name"])
        XCTAssertNil(tag.fileType?.fileType)
        XCTAssertNil(tag.fileType?.fileTypeRefinement)
        XCTAssertEqual(tag.fileType?.additionalInformation, "FileType")
        
        XCTAssertNil(tag.mediaType?.mediaType)
        XCTAssertNil(tag.mediaType?.mediaTypeRefinement)
        XCTAssertEqual(tag.mediaType?.additionalInformation, "MediaType")
        
        XCTAssertNil(tag.genre?.presetGenre)
        XCTAssertEqual(tag.genre?.customGenre, "Test Genre")


    }
 
    func testProblemChildrenV24() throws {
        let mp3Url = Bundle.writtenV24
        let mp3File = try Mp3File(location: mp3Url)
        let tag = try Tag(readFrom: mp3File)
        
        XCTAssertEqual(tag.encodingDateTime?.year, 2019)
        XCTAssertEqual(tag.taggingDateTime?.year, 1997)
        XCTAssertEqual(tag.taggingDateTime?.month, 06)
        XCTAssertEqual(tag.taggingDateTime?.day, 07)
        XCTAssertEqual(tag.originalReleaseDate?.year, 1998)
        XCTAssertEqual(tag.originalReleaseDate?.month, 03)
        XCTAssertEqual(tag.originalReleaseDate?.day, 04)
        XCTAssertEqual(tag.releaseDateTime?.year, 1999)
        XCTAssertEqual(tag.releaseDateTime?.month, 05)
        XCTAssertEqual(tag.releaseDateTime?.day, 08)

    }
}
