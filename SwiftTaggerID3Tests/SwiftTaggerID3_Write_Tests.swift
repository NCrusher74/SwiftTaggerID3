//
//  SwiftTaggerID3_Write_Tests.swift
//  SwiftTaggerID3Tests
//
//  Created by Nolaine Crusher on 4/30/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import XCTest
import SwiftTaggerID3

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
        tag.contentRating = .clean
        tag.copyright = "2020 Copyright"
        tag.date = "05-08"
        tag.time = "12:12"
        tag.year = "1999"
        tag.recordingDateTime = "1999-05-08"
        tag.encodedBy = "EncodedBy"
        tag.encodingSettings = "EncoderSettings"
        tag.initialKey = .cMajor
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
        #warning("fix this. The int needs to be a string. I think.")
        //        tag.genre.genreName = GenreType.Audiobook.code
        tag.genre.genreDescription = "Freeform description"
        tag.mediaType.mediaType = MediaType.otherDigital.code
        tag.mediaType.additionalMediaInfo = MediaTypeRefinements.none.rawValue
        tag.mediaType.mediaTypeDescription = "Freeform Desscription"
        tag.fileType.fileType = FileType.MPG.rawValue
        tag.fileType.additionalFileTypeInfo = FileTypeRefinements.mpegLayerIII.code
        tag.fileType.fileTypeDescription = "Freeform Description"
        tag[comments: .eng, "CommentDescription"] = "Comment Content"
        tag[lyrics: .eng, "LyricsDescription"] = "Lyrics Content"
        tag[description: .eng] = "Description"
        tag[longDescription: .eng] = "LongDescription"
        tag[seriesDescription: .eng] = "SeriesDescription"
        tag[songDescription: .eng] = "SongDescription"
        tag[linerNotes: .eng] = "LinerNotes"
        tag.acknowledgment = "Acknowledgments"
        tag.thanks = "Thanks"
        tag.sourceCredit = "SourceCredit"
        tag.addInvolvedPerson(role: .director, person: "Director Name")
        tag.addInvolvedPerson(role: .producer, person: "Producer Name")

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

        tag.genre.genreDescription = "Freeform description"
        tag.mediaType.mediaType = MediaType.otherDigital.code
        tag.mediaType.additionalMediaInfo = MediaTypeRefinements.none.rawValue
        tag.mediaType.mediaTypeDescription = "Freeform Desscription"
        tag.fileType.fileType = FileType.MPG.rawValue
        tag.fileType.additionalFileTypeInfo = FileTypeRefinements.mpegLayerIII.code
        tag.fileType.fileTypeDescription = "Freeform Description"

        tag.grouping = "Grouping"
        tag.initialKey = .cMajor
        tag.addInvolvedPerson(role: .director, person: "Director Name")
        tag.addInvolvedPerson(role: .producer, person: "Producer Name")
        tag.isrc = 123456789012
        try tag.setLanguages(languages: [.eng])
        tag.length = 5250
        tag[linerNotes: .eng] = "LinerNotes"
        tag[longDescription: .eng] = "LongDescription"
        tag.lyricist = "Lyricist"
        tag[lyrics: .eng, "LyricsDescription"] = "Lyrics Content"
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
        tag.grouping = "Grouping"
        tag.isrc = 123456789012
        try tag.setLanguages(languages: [.eng])
        tag.length = 5250
        tag[linerNotes: .eng] = "LinerNotes"
        tag[longDescription: .eng] = "LongDescription"
        tag.lyricist = "Lyricist"
        tag[lyrics: .eng, "LyricsDescription"] = "Lyrics Content"
            tag.mood = "Mood"
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
        tag.genre.genreDescription = "Freeform description"
        tag.mediaType.mediaType = MediaType.otherDigital.code
        tag.mediaType.additionalMediaInfo = MediaTypeRefinements.none.rawValue
        tag.mediaType.mediaTypeDescription = "Freeform Desscription"
        tag.fileType.fileType = FileType.MPG.rawValue
        tag.fileType.additionalFileTypeInfo = FileTypeRefinements.mpegLayerIII.code
        tag.fileType.fileTypeDescription = "Freeform Description"
        tag.addInvolvedPerson(role: .director, person: "Director Name")
        tag.addInvolvedPerson(role: .producer, person: "Producer Name")
        tag.addMusicianCredit(role: .musician, person: "Musician Name")
        tag.addMusicianCredit(role: .singing, person: "Singer Name")


        let outputURL = URL(fileURLWithPath: "/Users/nolainecrusher/Downloads/audiobook_tools/sampleaax/test/testV24.mp3")
        try FileManager.default.createDirectory(
            at: outputURL.parentDirectory,
            withIntermediateDirectories: true)
        
        try mp3file.write(tagVersion: .v2_3, using: tag, writingTo: outputURL)
    }
}

