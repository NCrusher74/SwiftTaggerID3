//
//  TestPrint.swift
//  SwiftTaggerID3Tests
//
//  Created by Nolaine Crusher on 4/28/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import XCTest
import SwiftTaggerID3

class TestPrint: XCTestCase {
    
    
    func testProblems() throws {
        let mp3Url = Bundle.v23NoMeta
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)

        tag.album = "Album"
        tag.albumArtist = "Album Artist"
        tag.albumArtistSort = "Album Artist Sort"
        
//        tag.albumSort = "Album Sort"
//        tag.arranger = "Arranger"
//        tag.artist = "Artist"
//        tag.artistSort = "Artist Sort"
//        tag.composer = "Composer"
//        tag.composerSort = "Composer Sort"
//        tag.conductor = "Conductor"
//        tag.contentGroup = "Content Group"
//        tag.copyright = "2020 Copyright"
//        tag.encodedBy = "Encoded By"
//        tag.encodingSettings = "Encoding Settings"
//        tag.fileOwner = "File Owner"
//        tag.grouping = "Grouping"
//        tag.initialKey = .aFlatMinor
//        tag.lyricist = "Lyricist"
//        tag.mood = "Mood"
//        tag.movementName = "Movement Name"
//        tag.originalAlbum = "Original Album"
//        tag.originalArtist = "Original Artist"
//        tag.originalFilename = "Original Filename"
//        tag.originalLyricist = "Original Lyricist"
//        tag.podcastID = "Podcast ID"
//        tag.podcastCategory = "Podcast Category"
//        tag.podcastDescription = "Podcast Description"
//        tag.podcastFeedLink = "http://podcast.url"
//        tag.podcastKeywords = "Podcast Keywords"
//        tag.producedNotice = "2020 Produced Notice"
//        tag.publisher = "Publisher"
//        tag.radioStation = "Radio Station"
//        tag.radioStationOwner = "Radio Station Owner"
//        tag.setSubtitle = "Set Subtitle"
//        tag.subtitle = "Subtitle"
//        tag.title = "Title"
//        tag.titleSort = "Title Sort"
//
//        tag.compilation = true
//        tag.bpm = 99
//        tag.isrc = 987654321098
//        tag.length = 9767
//        tag.movementNumber = 5
//        tag.totalMovements = 6
//        tag.playlistDelay = 0
//
//        tag.audioFileWebpage = "http://audiofile.url"
//        tag.audioSourceWebpage = "http://audiosource.url"
//        tag.artistWebpage = "http://artist.url"
//        tag.copyrightWebpage = "http://copyright.url"
//        tag.paymentWebpage = "http://payment.url"
//        tag.publisherWebpage = "http://publisher.url"
//        tag.radioStationWebpage = "http://radiostation.url"
        
        // MARK: Language Frame
//        tag.languages = [.eng]
        
        // MARK: Part Of Total frame
//        tag.discNumber?.disc = 3
//        tag.discNumber?.totalDiscs = 4
//        tag.trackNumber?.track = 1
//        tag.trackNumber?.totalTracks = 2
        
        // MARK: Localized Frame
//        tag[comments: .eng, "Comment"] = "Comment Content" // reading description as part of the comment for some reason
//        tag[lyrics: .eng, "Lyrics"] = "Lyrics Content" // same here - null term not working?
//        tag[userDefinedUrl: "UserURL"] = "http://userdefined.url"
        tag[userDefinedText: "UserText"] = "User Defined Text Content"
        
        // MARK: Credits List Frame
//        tag.addInvolvedPersonCredit(role: .actor, person: "Actor Name")
//        tag.addInvolvedPersonCredit(role: .actress, person: "Actress Name")
//        tag.addMusicianCredit(role: .soprano, person: "Soprano Name")
//        tag.addMusicianCredit(role: .alto, person: "Alto Name")
        
        // MARK: Preset Options Frame
//        tag.fileType?.fileType = nil
//        tag.fileType?.fileTypeRefinement = nil
//        tag.fileType?.additionalInformation = "File Type"

//        tag.genre?.presetGenre = .Audiobook
//        tag.genre?.customGenre = "Genre Type" // needs to be fixed

//        tag.mediaType?.mediaType = nil // get rid of parens when nil
//        tag.mediaType?.mediaTypeRefinement = nil
//        tag.mediaType?.additionalInformation = "Media Type"
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/testV24Writing.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))
        
        // MARK: Confirm accuracy
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.album, "Album")
        XCTAssertEqual(tagWritten.albumArtist, "Album Artist")
        XCTAssertEqual(tagWritten.albumArtistSort, "Album Artist Sort")
        
//        XCTAssertEqual(tagWritten.albumSort, "Album Sort")
//        XCTAssertEqual(tagWritten.arranger, "Arranger")
//        XCTAssertEqual(tagWritten.artist, "Artist")
//        XCTAssertEqual(tagWritten.artistSort, "Artist Sort")
//        XCTAssertEqual(tagWritten.composer, "Composer")
//        XCTAssertEqual(tagWritten.composerSort, "Composer Sort")
//        XCTAssertEqual(tagWritten.conductor, "Conductor")
//        XCTAssertEqual(tagWritten.contentGroup, "Content Group")
//        XCTAssertEqual(tagWritten.copyright, "2020 Copyright")
//        XCTAssertEqual(tagWritten.encodedBy, "Encoded By")
//        XCTAssertEqual(tagWritten.encodingSettings, "Encoding Settings")
//        XCTAssertEqual(tagWritten.fileOwner, "File Owner")
//        XCTAssertEqual(tagWritten.grouping, "Grouping")
//        XCTAssertEqual(tagWritten.initialKey, .aFlatMinor)
//        XCTAssertEqual(tagWritten.lyricist, "Lyricist")
//        XCTAssertEqual(tagWritten.mood, "Mood")
//        XCTAssertEqual(tagWritten.movementName, "Movement Name")
//        XCTAssertEqual(tagWritten.originalAlbum, "Original Album")
//        XCTAssertEqual(tagWritten.originalArtist, "Original Artist")
//        XCTAssertEqual(tagWritten.originalFilename, "Original Filename")
//        XCTAssertEqual(tagWritten.originalLyricist, "Original Lyricist")
//        XCTAssertEqual(tagWritten.podcastID, "Podcast ID")
//        XCTAssertEqual(tagWritten.podcastCategory, "Podcast Category")
//        XCTAssertEqual(tagWritten.podcastDescription, "Podcast Description")
//        XCTAssertEqual(tagWritten.podcastFeedLink, "http://podcast.url")
//        XCTAssertEqual(tagWritten.podcastKeywords, "Podcast Keywords")
//        XCTAssertEqual(tagWritten.producedNotice, "2020 Produced Notice")
//        XCTAssertEqual(tagWritten.publisher, "Publisher")
//        XCTAssertEqual(tagWritten.radioStation, "Radio Station")
//        XCTAssertEqual(tagWritten.radioStationOwner, "Radio Station Owner")
//        XCTAssertEqual(tagWritten.setSubtitle, "Set Subtitle")
//        XCTAssertEqual(tagWritten.subtitle, "Subtitle")
//        XCTAssertEqual(tagWritten.title, "Title")
//        XCTAssertEqual(tagWritten.titleSort, "Title Sort")

//        XCTAssertEqual(tagWritten.compilation, true)
//        XCTAssertEqual(tagWritten.bpm, 99)
//        XCTAssertEqual(tagWritten.isrc, 987654321098)
//        XCTAssertEqual(tagWritten.length, 9767)
//        XCTAssertEqual(tagWritten.movementNumber, 5)
//        XCTAssertEqual(tagWritten.totalMovements, 6)
//        XCTAssertEqual(tagWritten.playlistDelay, 0)
//
//        XCTAssertEqual(tagWritten.audioFileWebpage, "http://audiofile.url")
//        XCTAssertEqual(tagWritten.audioSourceWebpage, "http://audiosource.url")
//        XCTAssertEqual(tagWritten.artistWebpage, "http://artist.url")
//        XCTAssertEqual(tagWritten.copyrightWebpage, "http://copyright.url")
//        XCTAssertEqual(tagWritten.paymentWebpage, "http://payment.url")
//        XCTAssertEqual(tagWritten.publisherWebpage, "http://publisher.url")
//        XCTAssertEqual(tagWritten.radioStationWebpage, "http://radiostation.url")
//
//        XCTAssertEqual(tagWritten.languages, [.eng])

//        XCTAssertEqual(tagWritten.discNumber?.disc, 3)
//        XCTAssertEqual(tagWritten.discNumber?.totalDiscs, 4)
//        XCTAssertEqual(tagWritten.trackNumber?.track, 1)
//        XCTAssertEqual(tagWritten.trackNumber?.totalTracks, 2)
//
//        XCTAssertEqual(tag[comments: .eng, "Comment"], "Comment Content")
//        XCTAssertEqual(tag[lyrics: .eng, "Lyrics"], "Lyrics Content")
//        XCTAssertEqual(tag[userDefinedUrl: "UserURL"], "http://userdefined.url")
        XCTAssertEqual(tag[userDefinedText: "UserText"], "User Defined Text Content")
//
//        XCTAssertEqual(tagWritten.involvedPeopleList?[.actor], ["Actor Name"])
//        XCTAssertEqual(tagWritten.involvedPeopleList?[.actress], ["Actress Name"])
//        XCTAssertEqual(tagWritten.musicianCreditsList?[.soprano], ["Soprano Name"])
//        XCTAssertEqual(tagWritten.musicianCreditsList?[.alto], ["Alto Name"])

//        XCTAssertNil(tagWritten.fileType?.fileType)
//        XCTAssertNil(tagWritten.fileType?.fileTypeRefinement)
//        XCTAssertEqual(tagWritten.fileType?.additionalInformation, "File Type")

//        XCTAssertEqual(tagWritten.genre?.presetGenre, .Audiobook)
//        XCTAssertEqual(tagWritten.genre?.customGenre, "Genre Type")

//        XCTAssertNil(tagWritten.mediaType?.mediaType)
//        XCTAssertNil(tagWritten.mediaType?.mediaTypeRefinement)
//        XCTAssertEqual(tagWritten.mediaType?.additionalInformation, "Media Type")

    }
}

/*
 // ALBUM + ALBUMARTIST + ALBUMARTISTSORT frame PLUS
 "AlbumSort" frame = success
 "Arranger" frame = success
 "Artist" frame = success
 "ArtistSort" frame = success
 "Composer" frame = success
 "ComposerSort" frame = success
 "Conductor" frame = success
 "Content Group" frame = success
 "Copyright" frame = success
 "EncodedBy" frame = success
 "Encoding Settings" frame = success
 "File Owner" frame = success
 "Grouping" frame = success
 "InitialKey" frame = success
 "Lyricist" frame = success
 "Mood" frame = success
 "Movement Name" frame = success
 "Original Album" frame = success
 "Original Artist" frame = success
 "Original Filename" frame = success
 "Original Lyricist" frame = success
 "PodcastID" frame = success
 "Podcast Category" frame = success
 "Podcast Feedlink" frame = success
 "Podcast Description" frame = success
 "Podcast Keywords" frame = success
 "Publisher" frame = success
 "Produced Notice" frame = success
 "Radio Station" frame = success
 "Radio Station Owner" frame = success
 "Subtitle" frame = success
 "Set Subtitle" frame = success
 "Title" frame = success
 "Title Sort" frame = success
 
 "Compilation" frame = success
 "BPM" frame = success
 "ISRC" frame = success
 "Length" frame = success
 "Movement Number" frame = success
 "Movement Count" frame = success
 "Playlist Delay" frame = success
 
 "Audio Source Webpage" frame = success
 "Audio File Webpage" frame = success
 "Artist Webpage" frame = success
 "Copyright Webpage" frame = success
 "Payment Webpage" frame = success
 "Publisher Webpage" frame = success
 "Radio Station Webpage" frame = success
 
 "Languages" frame = success
 
 "Track Number" frame = success
 "Disc Number" frame = success
 
 "Comments" frame = success
 "Lyrics" frame = success
 "UserDefinedUrl" frame = success
 "User Defined Text" frame = success
 
 "Involved People List" frame = success
 "Musician Credit List" frame = success
 
 "File Type" frame = success
 "Media Type" frame = success
 

 // ALBUM + ALBUMARTIST frame PLUS
 "AlbumArtistSort" frame = success
 "AlbumSort" frame = success
 "Arranger" frame = success
 "Artist" frame = success
 "ArtistSort" frame = success
 "Composer" frame = success
 "ComposerSort" frame = success
 "Conductor" frame = success
 "Content Group" frame = success
 "Copyright" frame = success
 "EncodedBy" frame = success
 "Encoding Settings" frame = success
 "File Owner" frame = success
 "Grouping" frame = success
 "InitialKey" frame = success
 "Lyricist" frame = success
 "Mood" frame = success
 "Movement Name" frame = success
 "Original Album" frame = success
 "Original Artist" frame = success
 "Original Filename" frame = success
 "Original Lyricist" frame = success
 "PodcastID" frame = success
 "Podcast Category" frame = success
 "Podcast Feedlink" frame = success
 "Podcast Description" frame = success
 "Podcast Keywords" frame = success
 "Publisher" frame = success
 "Produced Notice" frame = success
 "Radio Station" frame = success
 "Radio Station Owner" frame = success
 "Subtitle" frame = success
 "Set Subtitle" frame = success
 "Title" frame = success
 "Title Sort" frame = success
 
 "Compilation" frame = success
 "BPM" frame = success
 "ISRC" frame = success
 "Length" frame = success
 "Movement Number" frame = success
 "Movement Count" frame = success
 "Playlist Delay" frame = success
 
 "Audio Source Webpage" frame = success
 "Audio File Webpage" frame = success
 "Artist Webpage" frame = success
 "Copyright Webpage" frame = success
 "Payment Webpage" frame = success
 "Publisher Webpage" frame = success
 "Radio Station Webpage" frame = success
 
 "Languages" frame = success
 
 "Track Number" frame = success
 "Disc Number" frame = success
 
 "Comments" frame = success
 "Lyrics" frame = success
 "UserDefinedUrl" frame = success
 "User Defined Text" frame = success
 
 "Involved People List" frame = success
 "Musician Credit List" frame = success
 
 "File Type" frame = success
 "Media Type" frame = success

 
 // Omitting Genre Type since it's not working as intended
 // ALBUM frame PLUS
 "AlbumArtist" frame = success
 "AlbumArtistSort" frame = success
 "AlbumSort" frame = success
 "Arranger" frame = success
 "Artist" frame = success
 "ArtistSort" frame = success
 "Composer" frame = success
 "ComposerSort" frame = success
 "Conductor" frame = success
 "Content Group" frame = success
 "Copyright" frame = success
 "EncodedBy" frame = success
 "Encoding Settings" frame = success
 "File Owner" frame = success
 "Grouping" frame = success
 "InitialKey" frame = success
 "Lyricist" frame = success
 "Mood" frame = success
 "Movement Name" frame = success
 "Original Album" frame = success
 "Original Artist" frame = success
 "Original Filename" frame = success
 "Original Lyricist" frame = success
 "PodcastID" frame = success
 "Podcast Category" frame = success
 "Podcast Feedlink" frame = success
 "Podcast Description" frame = success
 "Podcast Keywords" frame = success
 "Publisher" frame = success
 "Produced Notice" frame = success
 "Radio Station" frame = success
 "Radio Station Owner" frame = success
 "Subtitle" frame = success
 "Set Subtitle" frame = success
 "Title" frame = success
 "Title Sort" frame = success

 "Compilation" frame = success
 "BPM" frame = success
 "ISRC" frame = success
 "Length" frame = success
 "Movement Number" frame = success
 "Movement Count" frame = success
 "Playlist Delay" frame = success

 "Audio Source Webpage" frame = success
 "Audio File Webpage" frame = success
 "Artist Webpage" frame = success
 "Copyright Webpage" frame = success
 "Payment Webpage" frame = success
 "Publisher Webpage" frame = success
 "Radio Station Webpage" frame = success

 "Languages" frame = success

 "Track Number" frame = success
 "Disc Number" frame = success

 "Comments" frame = success
 "Lyrics" frame = success
 "UserDefinedUrl" frame = success
 "User Defined Text" frame = success

 "Involved People List" frame = success
 "Musician Credit List" frame = success

 "File Type" frame = success
 "Media Type" frame = success
 
 // omitting Date, CTOC and CHAP frames, since those are known not to work yet
 Results for single frame read-write:
 "Album" frame alone = success
 "AlbumArtist" frame alone = success
 "AlbumArtistSort" frame alone = success
 "AlbumSort" frame alone = success
 "Arranger" frame alone = success
 "Artist" frame alone = success
 "ArtistSort" frame alone = success
 "Composer" frame alone = success
 "ComposerSort" frame alone = success
 "Conductor" frame alone = success
 "ContentGroup" frame alone = success
 "Copyright" frame alone = success
 "EncodedBy" frame alone = success
 "Encoding Settings" frame alone = success
 "File Owner" frame alone = success
 "Grouping" frame alone = success
 "Initial Key" frame alone = success
 "Lyricist" frame alone = success
 "Mood" frame alone = success
 "Movement Name" frame alone = success
 "Original Album" frame alone = success
 "Original Artist" frame alone = success
 "Original Filename" frame alone = success
 "Original Lyricist" frame alone = success
 "Podcast ID" frame alone = success
 "Podcast Category" frame alone = success
 "Podcast Feedlink" frame alone = success
 "Podcast Description" frame alone = success
 "Podcast Keywords" frame alone = success
 "Publisher" frame alone = success
 "Produced Notice" frame alone = success
 "Radio Station" frame alone = success
 "Radio Station Owner" frame alone = success
 "Subtitle" frame alone = success
 "Set Subtitle" frame alone = success
 "Title" frame alone = success
 "Title Sort" frame alone = success
 
 "Compilation" frame alone = success
 "BPM" frame alone = success
 "ISRC" frame alone = success
 "Length" frame alone = success
 "Movement Number" frame alone = success
 "Movement Count" frame alone = success
 "Playlist Delay" frame alone = success
 
 "Audio Source Webpage" frame alone = success
 "Audio File Webpage" frame alone = success
 "Artist Webpage" frame alone = success
 "Copyright Webpage" frame alone = success
 "Payment Webpage" frame alone = success
 "Publisher Webpage" frame alone = success
 "Radio Station Webpage" frame alone = success
 
 "Languages" frame alone = success
 
 "Track Number" frame alone = success
 "Disc Number" frame alone = success
 
 "Comment" frame alone = success // NOT WORKING AS INTENDED HOWEVER
 "Lyrics" frame alone = success // NOT WORKING AS INTENDED HOWEVER
 "User Defined Url" frame alone = success
 "User Defined Text" frame alone = success
 
 "Involved People List" frame alone = success
 "Musician List" frame alone = success
 
 "File Type" frame alone = success
 "Genre" frame alone = success // NOT WORKING AS INTENDED
 "Media Type" frame alone = success
 
 */
