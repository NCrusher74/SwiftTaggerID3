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
        tag.copyright = "2020 Copyright"
        tag.date = "05-08"
        tag.time = "12:12"
        tag.year = "1999"
        tag.recordingDateTime = "1999-05-08"
        tag.encodedBy = "EncodedBy"
        tag.encodingSettings = "EncoderSettings"
//        tag.fileOwner = "FileOwner"
//        tag.grouping = "Grouping"
        tag.initialKey = "b#"
        _ = tag.setLanguages(languages: [.eng])
        tag.lyricist = "Lyricist"
//        tag.movementName = "MovementName"
        tag.originalAlbum = "OriginalAlbum"
        tag.originalArtist = "OriginalArtist"
        tag.originalFilename = "OriginalFilename"
        tag.originalLyricist = "OriginalLyricist"
//        tag.podcastCategory = "PodcastCategory"
//        tag.podcastDescription = "PodcastDescription"
//        tag.podcastID = "PodcastID"
//        tag.podcastKeywords = "PodcastKeywords"
//        tag.podcastFeedLink = "PodcastFeedlink"
        tag.publisher = "Publisher"
        tag.radioStation = "RadioStation"
        tag.radioStationOwner = "RadioStationOwner"
        tag.title = "Album"
        tag.titleSort = "SortTitle"
        tag.audioFileWebpage = "http://audiofile.url"
        tag.audioSourceWebpage = "http://audiosource.url"
        tag.copyrightWebpage = "http://copyright.url"
//        tag.paymentWebpage = "http://payment.url"
        tag.publisherWebpage = "http://publisher.url"
//        tag.radioStationWebpage = "http://radiostation.url"
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
        tag.genre.genreName = nil
        tag.genre.genreDescription = "Genre"
        tag.mediaType.mediaType = nil
        tag.mediaType.additionalMediaInfo = nil
        tag.mediaType.mediaTypeDescription = "MediaType"
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
        tag.involvedPeopleList?[0].role = "Director"
        tag.involvedPeopleList?[0].person = "Director Name"
        tag.involvedPeopleList?[1].role = "Producer"
        tag.involvedPeopleList?[1].person = "Producer Name"
        
        let imageURL = Bundle.testImage
        _ = try tag.setAttachedPicture(imageType: .Other, imageDescription: "SamplePicture", location: imageURL)
//        tag.musicianCreditList?[0].role = "Musician"
//        tag.musicianCreditList?[0].person = "Musician Name"
//        tag.musicianCreditList?[1].role = "Singer"
//        tag.musicianCreditList?[1].person = "Singer Name"
//        tag.releaseDateTime = "1999-05-08"
//        tag.originalReleaseDate = "1998-03-04"
//        tag.taggingDateTime = "1997-06-07"
//        tag.encodingDateTime = "1996-08-09"
//        tag.mood = "Mood"
//        tag.setSubtitle = "SetSubtitle"
//        tag.producedNotice = "2020 ProducedNotice"
//        tag[tableOfContents: "TOC"]?.entryCount = 2
//        tag[tableOfContents: "TOC"]?.topLevelFlag = true
//        tag[tableOfContents: "TOC"]?.orderedFlag = true
//        tag[tableOfContents: "TOC"]?.childElementIDs = ["ch0","ch1"]
//        tag[chapters: "ch0"]?.startTime = 0
//        tag[chapters: "ch0"]?.endTime = 2795
//        tag[chapters: "ch0"]?.startByteOffset = 0
//        tag[chapters: "ch0"]?.endByteOffset = 0
//        tag[chapters: "ch1"]?.startTime = 2795
//        tag[chapters: "ch1"]?.endTime = 5250
//        tag[chapters: "ch1"]?.startByteOffset = 0
//        tag[chapters: "ch1"]?.endByteOffset = 0        
//        tag[embeddedSubframes: "ch0"]?.title = "Chapter 01"
//        tag[embeddedSubframes: "ch1"]?.title = "Chapter 02"
        
        let outputURL = URL(fileURLWithPath: "/Users/nolainecrusher/Downloads/audiobook_tools/sampleaax/test/testV22.mp3")
        try FileManager.default.createDirectory(
            at: outputURL.parentDirectory,
            withIntermediateDirectories: true)
        
        try mp3file.write(using: tag, writingTo: outputURL)
    }
}
