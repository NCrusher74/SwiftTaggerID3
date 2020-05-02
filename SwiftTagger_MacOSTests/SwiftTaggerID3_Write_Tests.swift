//
//  SwiftTaggerID3_Write_Tests.swift
//  SwiftTagger_MacOSTests
//
//  Created by Nolaine Crusher on 4/30/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import XCTest
import SwiftTagger_MacOS

class SwiftTaggerID3_Write_Tests: XCTestCase {
    
    func testV22Write() throws {
        let mp3file = try Mp3File(location: Bundle.writtenV22)
        var tag = try mp3file.read()
        
        tag.album = "Album"
        tag.albumArtist = "AlbumArtist"
        tag.albumSort = "SortAlbum"
        tag.albumArtistSort = "SortAlbumArtist"
        tag.artist = "Artist"
        tag.artistSort = "SortArtist"
        tag.artistWebpage = "http://artist.url"
        tag.arranger = "Arranger"
        tag.composer = "Composer"
        tag.composerSort = "SortComposer"
        tag.conductor = "Conductor"
        tag.contentGroup = "Content Group"
        try tag.setContentRating(contentRating: .usMovieUnrated)
        tag.copyright = "2020 Copyright"
        tag.date = "05-08"
        tag.time = "12:12"
        tag.year = "1999"
        tag.recordingDateTime = "1999-05-08"
        tag.encodedBy = "EncodedBy"
        tag.encodingSettings = "EncoderSettings"
        try tag.setInitialKey(initialKey: .cMajor)
        try tag.setLanguages(languages: [.eng])
        tag.lyricist = "Lyricist"
        tag.originalAlbum = "OriginalAlbum"
        tag.originalArtist = "OriginalArtist"
        tag.originalFilename = "OriginalFilename"
        tag.originalLyricist = "OriginalLyricist"
        tag.publisher = "Publisher"
        tag.radioStation = "RadioStation"
        tag.radioStationOwner = "RadioStationOwner"
        tag.title = "Album"
        tag.titleSort = "SortTitle"
        tag.audioFileWebpage = "http://audiofile.url"
        tag.audioSourceWebpage = "http://audiosource.url"
        tag.copyrightWebpage = "http://copyright.url"
        tag.publisherWebpage = "http://publisher.url"
        tag.bpm = 99
        tag.isrc = 123456789012
        tag.length = 5250
        tag.playlistDelay = 20
        tag.compilation = true
        tag.discNumber.disc = 3
        tag.discNumber.totalDiscs = 4
        tag.trackNumber.track = 1
        tag.trackNumber.totalTracks = 2
        tag[userDefinedText: "UserDefinedText"] = "User Defined Text Content"
        tag[userDefinedUrl: "UserDefinedUrl"] = "http://userdefined.url"
        try tag.setGenre(genreName: Optional.none, genreDescription: "Genre")
        try tag.setMediaType(mediaType: Optional.none, additionalMediaInfo: Optional.none, mediaTypeDescription: "MediaType")
        try tag.setFileType(fileType: .MPG, additionalFileTypeInfo: .mpegLayerIII, fileTypeDescription: "FileType")
        tag[comments: .eng, "CommentDescription"] = "Comment Content"
        tag[lyrics: .eng, "LyricsDescription"] = "Lyrics Content"
        tag[description: .eng] = "Description"
        tag[shortDescription: .eng] = "ShortDescription"
        tag[longDescription: .eng] = "LongDescription"
        tag[seriesDescription: .eng] = "SeriesDescription"
        tag[songDescription: .eng] = "SongDescription"
        tag[linerNotes: .eng] = "LinerNotes"
        tag.acknowledgment = "Acknowledgments"
        tag.thanks = "Thanks"
        tag.sourceCredit = "SourceCredit"
        //        tag.involvedPeopleList?[0].role = "Director" // Thread 1: Fatal error: Index out of range
        //        tag.involvedPeopleList?[0].person = "Director Name"
        //        tag.involvedPeopleList?[1].role = "Producer"
        //        tag.involvedPeopleList?[1].person = "Producer Name"
        
        let imageURL = Bundle.testImage
        try tag.setAttachedPicture(imageType: .Other, imageDescription: "SamplePicture", location: imageURL)

        let outputURL = URL(fileURLWithPath: "/Users/nolainecrusher/Downloads/audiobook_tools/sampleaax/test/testV22.mp3")
        try FileManager.default.createDirectory(
            at: outputURL.parentDirectory,
            withIntermediateDirectories: true)
        
        try mp3file.write(tagVersion: .v2_2, using: tag, writingTo: outputURL)
    }
    /*
     Raw Data:
     
     File size: 114661
     Format: MPEG-1, Layer 3
     File contains Info header at offset 33578
     Channel mode: Stereo
     Sample rate: 44100 Hz
     Duration: 5041 ms
     Bit rate: 129 kbits/sec
     ID3 Tag version 2.2.0
     Tag at offset: 0 size = 10999
     Padding: 0 bytes
     Audio base: 10999 size = 103662
     Adjusted audio base: 33578 size = 81083
     
     Tag Header bytes: 49 44 33 2 0 0 0 0 55 6d
     Bytes where first frame header should be: ff fe 54 0 58 0
     */
    
    func testV23Write() throws {
        let mp3file = try Mp3File(location: Bundle.writtenV23)
        var tag = try mp3file.read()
        
        tag.acknowledgment = "Acknowledgments"
        tag.album = "Album"
        tag.albumArtist = "AlbumArtist"
        tag.albumSort = "SortAlbum"
        tag.albumArtistSort = "SortAlbumArtist"
        tag.arranger = "Arranger"
        tag.artist = "Artist"
        tag.artistSort = "SortArtist"
        tag.artistWebpage = "http://artist.url"
        try tag.setAttachedPicture(imageType: .Other, imageDescription: "SamplePicture", location: Bundle.testImage)
        tag.audioFileWebpage = "http://audiofile.url"
        tag.audioSourceWebpage = "http://audiosource.url"
        tag.bpm = 99
        tag[comments: .eng, "CommentDescription"] = "Comment Content"
        tag.compilation = true
        tag.composer = "Composer"
        tag.composerSort = "SortComposer"
        tag.conductor = "Conductor"
        tag.contentGroup = "Content Group"
        tag.copyright = "2020 Copyright"
        tag.copyrightWebpage = "http://copyright.url"
        tag.date = "05-08"
        tag[description: .eng] = "Description"
        tag.discNumber.disc = 3
        tag.discNumber.totalDiscs = 4
        tag.encodedBy = "EncodedBy"
        tag.encodingSettings = "EncoderSettings"
        tag.fileOwner = "FileOwner"
        try tag.setFileType(fileType: .MPG, additionalFileTypeInfo: .mpegLayerIII, fileTypeDescription: "FileType")
        try tag.setGenre(genreName: Optional.none, genreDescription: "Genre")
        tag.grouping = "Grouping"
        try tag.setInitialKey(initialKey: .cMajor)
        tag.involvedPeopleList?[0].role = "Director" // Thread 1: Fatal error: Index out of range
        tag.involvedPeopleList?[0].person = "Director Name"
        tag.involvedPeopleList?[1].role = "Producer"
        tag.involvedPeopleList?[1].person = "Producer Name"
        tag.isrc = 123456789012
        try tag.setLanguages(languages: [.eng])
        tag.length = 5250
        tag[linerNotes: .eng] = "LinerNotes"
        tag[longDescription: .eng] = "LongDescription"
        tag.lyricist = "Lyricist"
        tag[lyrics: .eng, "LyricsDescription"] = "Lyrics Content"
        try tag.setMediaType(mediaType: Optional.none, additionalMediaInfo: Optional.none, mediaTypeDescription: "MediaType")
        tag.movementName = "MovementName"
        tag.movementNumber = 7
        tag.totalMovements = 8
        tag.originalAlbum = "OriginalAlbum"
        tag.originalArtist = "OriginalArtist"
        tag.originalFilename = "OriginalFilename"
        tag.originalLyricist = "OriginalLyricist"
        tag.playlistDelay = 20
        tag.podcastCategory = "PodcastCategory"
        tag.podcastDescription = "PodcastDescription"
        tag.podcastID = "PodcastID"
        tag.podcastKeywords = "PodcastKeywords"
        tag.podcastFeedLink = "PodcastFeedlink"
        tag.publisher = "Publisher"
        tag.radioStation = "RadioStation"
        tag.radioStationOwner = "RadioStationOwner"
        tag.radioStationWebpage = "http://radiostation.url"
        tag.recordingDateTime = "1999-05-08"
        tag.title = "Album"
        tag.titleSort = "SortTitle"
        tag.paymentWebpage = "http://payment.url"
        tag.publisherWebpage = "http://publisher.url"
        tag[seriesDescription: .eng] = "SeriesDescription"
        tag[shortDescription: .eng] = "ShortDescription"
        tag[songDescription: .eng] = "SongDescription"
        tag.sourceCredit = "SourceCredit"
        tag[tableOfContents: "CTOC"]?.topLevelFlag = true
        tag[tableOfContents: "CTOC"]?.orderedFlag = false
        tag[tableOfContents: "CTOC"]?.entryCount = 3
        tag[tableOfContents: "CTOC"]?.childElementIDs = ["CH01", "CH02", "CH03"]
        //        tag[embeddedSubframes: "CTOC"]? = "Table Of Contents" <- is get only right now
        tag[chapters: "CH01"]?.startTime = 0
        tag[chapters: "CH01"]?.endTime = 1700
        tag[chapters: "CH02"]?.startTime = 1700
        tag[chapters: "CH02"]?.endTime = 3400
        tag[chapters: "CH03"]?.startTime = 3400
        tag[chapters: "CH03"]?.endTime = 5041
        //        tag[embeddedSubframes: "CH01"]?.title = "Chapter 01"
        //        tag[embeddedSubframes: "CH02"]?.title = "Chapter 02"
        //        tag[embeddedSubframes: "CH03"]?.title = "Chapter 03"
        tag.thanks = "Thanks"
        tag.time = "12:12"
        tag.trackNumber.track = 1
        tag.trackNumber.totalTracks = 2
        tag[userDefinedText: "UserDefinedText"] = "User Defined Text Content"
        tag[userDefinedUrl: "UserDefinedUrl"] = "http://userdefined.url"
        tag.year = "1999"
        
        let outputURL = URL(fileURLWithPath: "/Users/nolainecrusher/Downloads/audiobook_tools/sampleaax/test/testV23.mp3")
        try FileManager.default.createDirectory(
            at: outputURL.parentDirectory,
            withIntermediateDirectories: true)
        
        try mp3file.write(tagVersion: .v2_3, using: tag, writingTo: outputURL)
    }
    
    func testV24Write() throws {
        let mp3file = try Mp3File(location: Bundle.writtenV23)
        var tag = try mp3file.read()
        
        tag.acknowledgment = "Acknowledgments"
        tag.album = "Album"
        tag.albumArtist = "AlbumArtist"
        tag.albumSort = "SortAlbum"
        tag.albumArtistSort = "SortAlbumArtist"
        tag.arranger = "Arranger"
        tag.artist = "Artist"
        tag.artistSort = "SortArtist"
        tag.artistWebpage = "http://artist.url"
        try tag.setAttachedPicture(imageType: .Other, imageDescription: "SamplePicture", location: Bundle.testImage)
        tag.audioFileWebpage = "http://audiofile.url"
        tag.audioSourceWebpage = "http://audiosource.url"
        tag.bpm = 99
        tag[comments: .eng, "CommentDescription"] = "Comment Content"
        tag.compilation = true
        tag.composer = "Composer"
        tag.composerSort = "SortComposer"
        tag.conductor = "Conductor"
        tag.contentGroup = "Content Group"
        tag.copyright = "2020 Copyright"
        tag.copyrightWebpage = "http://copyright.url"
        tag[description: .eng] = "Description"
        tag.discNumber.disc = 3
        tag.discNumber.totalDiscs = 4
        tag.encodedBy = "EncodedBy"
        tag.encodingSettings = "EncoderSettings"
        tag.fileOwner = "FileOwner"
        try tag.setFileType(fileType: .MPG, additionalFileTypeInfo: .mpegLayerIII, fileTypeDescription: "FileType")
        try tag.setGenre(genreName: Optional.none, genreDescription: "Genre")
        tag.grouping = "Grouping"
        try tag.setInitialKey(initialKey: .cMajor)
        tag.involvedPeopleList?[0].role = "Director"
        tag.involvedPeopleList?[0].person = "Director Name"
        tag.involvedPeopleList?[1].role = "Producer"
        tag.involvedPeopleList?[1].person = "Producer Name"
        tag.isrc = 123456789012
        try tag.setLanguages(languages: [.eng])
        tag.length = 5250
        tag[linerNotes: .eng] = "LinerNotes"
        tag[longDescription: .eng] = "LongDescription"
        tag.lyricist = "Lyricist"
        tag[lyrics: .eng, "LyricsDescription"] = "Lyrics Content"
        try tag.setMediaType(mediaType: Optional.none, additionalMediaInfo: Optional.none, mediaTypeDescription: "MediaType")
            tag.mood = "Mood"
        tag.movementName = "MovementName"
        tag.movementNumber = 7
        tag.totalMovements = 8
        tag.musicianCreditList?[0].role = "Musician"
        tag.musicianCreditList?[0].person = "Musician Name"
        tag.musicianCreditList?[1].role = "Singer"
        tag.musicianCreditList?[1].person = "Singer Name"
        tag.originalAlbum = "OriginalAlbum"
        tag.originalArtist = "OriginalArtist"
        tag.originalFilename = "OriginalFilename"
        tag.originalLyricist = "OriginalLyricist"
        tag.playlistDelay = 20
        tag.podcastCategory = "PodcastCategory"
        tag.podcastDescription = "PodcastDescription"
        tag.podcastID = "PodcastID"
        tag.podcastKeywords = "PodcastKeywords"
        tag.podcastFeedLink = "PodcastFeedlink"
        tag.publisher = "Publisher"
        tag.radioStation = "RadioStation"
        tag.radioStationOwner = "RadioStationOwner"
        tag.radioStationWebpage = "http://radiostation.url"
        tag.recordingDateTime = "1999-05-08"
        tag.title = "Album"
        tag.titleSort = "SortTitle"
        tag.paymentWebpage = "http://payment.url"
        tag.publisherWebpage = "http://publisher.url"
        tag[seriesDescription: .eng] = "SeriesDescription"
        tag[shortDescription: .eng] = "ShortDescription"
        tag[songDescription: .eng] = "SongDescription"
        tag.sourceCredit = "SourceCredit"
        tag[tableOfContents: "CTOC"]?.topLevelFlag = true
        tag[tableOfContents: "CTOC"]?.orderedFlag = false
        tag[tableOfContents: "CTOC"]?.entryCount = 3
        tag[tableOfContents: "CTOC"]?.childElementIDs = ["CH01", "CH02", "CH03"]
        //        tag[embeddedSubframes: "CTOC"]? = "Table Of Contents" <- is get only right now
        tag[chapters: "CH01"]?.startTime = 0
        tag[chapters: "CH01"]?.endTime = 1700
        tag[chapters: "CH02"]?.startTime = 1700
        tag[chapters: "CH02"]?.endTime = 3400
        tag[chapters: "CH03"]?.startTime = 3400
        tag[chapters: "CH03"]?.endTime = 5041
        //        tag[embeddedSubframes: "CH01"]?.title = "Chapter 01"
        //        tag[embeddedSubframes: "CH02"]?.title = "Chapter 02"
        //        tag[embeddedSubframes: "CH03"]?.title = "Chapter 03"
        tag.thanks = "Thanks"
        tag.trackNumber.track = 1
        tag.trackNumber.totalTracks = 2
        tag[userDefinedText: "UserDefinedText"] = "User Defined Text Content"
        tag[userDefinedUrl: "UserDefinedUrl"] = "http://userdefined.url"
        tag.releaseDateTime = "1999-05-08"
        tag.originalReleaseDate = "1998-03-04"
        tag.taggingDateTime = "1997-06-07"
        tag.encodingDateTime = "1996-08-09"
        tag.setSubtitle = "SetSubtitle"
        tag.producedNotice = "2020 ProducedNotice"
        
        let outputURL = URL(fileURLWithPath: "/Users/nolainecrusher/Downloads/audiobook_tools/sampleaax/test/testV24.mp3")
        try FileManager.default.createDirectory(
            at: outputURL.parentDirectory,
            withIntermediateDirectories: true)
        
        try mp3file.write(tagVersion: .v2_3, using: tag, writingTo: outputURL)
    }
}

