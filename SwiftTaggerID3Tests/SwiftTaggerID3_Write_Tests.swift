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
    
    func testV24Writing() throws {
        let mp3Url = Bundle.v23NoMeta
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.album = "Album"
        tag.albumArtist = "AlbumArtist"
        tag.albumSort = "Album Sort"
        tag.albumArtistSort = "Album Artist Sort"
        tag.arranger = "Arranger"
        tag.artist = "Artist"
        tag.artistSort = "Artist Sort"
        tag.composer = "Composer"
        tag.composerSort = "Composer Sort"
        tag.conductor = "Conductor"
        tag.contentGroup = "Content Group"
        tag.copyright = "2020 Copyright"
        tag.encodedBy = "EncodedBy"
        tag.encodingSettings = "Encoding Settings"
        tag.fileOwner = "File Owner"
        tag.grouping = "Grouping"
//        tag.initialKey = .aFlatMinor
        tag.lyricist = "Lyricist"
        tag.mood = "Mood"
        tag.movementName = "Movement Name"
        tag.originalAlbum = "Original Album"
        tag.originalArtist = "Original Artist"
        tag.originalFilename = "Original Filename"
        tag.originalLyricist = "Original Lyricist"
        tag.podcastID = "Podcast ID"
        tag.podcastCategory = "Podcast Category"
        tag.podcastFeedLink = "http://podcast.url"
        tag.podcastDescription = "Podcast Description"
        tag.publisher = "Publisher"
        tag.producedNotice = "2020 Produced Notice"
        tag.radioStation = "Radio Station"
        tag.radioStationOwner = "Radio Station Owner"
        tag.subtitle = "Subtitle"
        tag.setSubtitle = "Set Subtitle"
        tag.title = "Title"
        tag.titleSort = "TitleSort"

        tag.compilation = true
        tag.bpm = 99
        tag.isrc = 987654321098
        tag.length = 9767
        tag.movementNumber = 5
        tag.totalMovements = 6
        tag.playlistDelay = 0
        
        tag.audioSourceWebpage = "http://audiosource.url"
        tag.audioFileWebpage = "http://audiofile.url"
        tag.artistWebpage = "http://artist.url"
        tag.copyrightWebpage = "http://copyright.url"
        tag.paymentWebpage = "http://payment.url"
        tag.publisherWebpage = "http://publisher.url"
        tag.radioStationWebpage = "http://radiostation.url"

        // MARK: Language Frame
        tag.languages = [.eng]
        
        // MARK: Part Of Total frame
        tag.trackNumber?.track = 1
        tag.trackNumber?.totalTracks = 2
        tag.discNumber?.disc = 3
        tag.discNumber?.totalDiscs = 4
        
        // MARK: Localized Frame
        tag[comments: .eng, "Comment"] = "Comment Content" // reading description as part of the comment for some reason
        tag[lyrics: .eng, "Lyrics"] = "Lyrics Content" // same here - null term not working?
        tag[customComment: .eng, .description] = "Description Content"
        tag[customComment: .eng, .linerNotes] = "Liner Notes Content"
        tag[customComment: .eng, .longDescription] = "Long Description Content"
        tag[customComment: .eng, .seriesDescription] = "Series Description Content"
        tag[customComment: .eng, .songDescription] = "Song Description Content"
        
        tag[userDefinedUrl: "UserURL"] = "http://userdefined.url"
        tag.onlineExtras = "http://onlineextras.url"
        
        tag[userDefinedText: "UserText"] = "User Text Content"
        tag.thanks = "Thanks"
        tag.sourceCredit = "Source Credit"
        tag.season = 8
        tag.seriesName = "Series Name"
        tag.network = "Network"
        tag.acknowledgment = "Acknowledgment"
        tag.episodeName = "Episode Name"
        tag.episodeNumber = 7
        tag.keywords = ["Key","Words"]
        tag.contentRating = .clean
        tag.contentAdvisory = .usMovieUnrated
        
        // MARK: TOC and Chapter Frames
        tag[tableOfContents: "TOC"]?.topLevelFlag = true
        tag[tableOfContents: "TOC"]?.orderedFlag = true
        tag[tableOfContents: "TOC"]?.entryCount = 2
        tag[tableOfContents: "TOC"]?.childElementIDs = ["Ch01","Ch02"]
        
        tag[chapters: "Ch01"]?.startTime = 0
        tag[chapters: "Ch01"]?.endTime = 4900
        tag[chapters: "Ch02"]?.startTime = 4900
        tag[chapters: "Ch02"]?.endTime = 9767
        //        tag[embeddedSubframes: "Ch01"]?.title = "Chapter Name" - subscript is get only?
        //
        // MARK: Credits List Frame
        tag.addInvolvedPersonCredit(role: .actor, person: "Actor Name")
        tag.addInvolvedPersonCredit(role: .actress, person: "Actress Name")
        tag.addMusicianCredit(role: .soprano, person: "Soprono Name")
        tag.addMusicianCredit(role: .alto, person: "Alto Name")
        
        // MARK: Preset Options Frame
        tag.fileType?.fileType = nil
        tag.fileType?.fileTypeRefinement = nil
        tag.fileType?.additionalInformation = "FileType"
        tag.genre?.presetGenre = .Audiobook
        tag.genre?.customGenre = "GenreType" // needs to be fixed
        tag.mediaType?.mediaType = nil // get rid of parens when nil
        tag.mediaType?.mediaTypeRefinement = nil
        tag.mediaType?.additionalInformation = "MediaType"

        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/testV24Writing.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))
    }
/*
    func testV23Writing() throws {
        let mp3Url = Bundle.writtenV23
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.album = "New Album" // glitch
        tag.albumArtist = "New Album Artist" // no glitch
        tag.acknowledgment = "New Acknowledgment" // glitch
        tag.audioSourceWebpage = "HTTP://AlbumSource.url" // glitch
        tag.audioFileWebpage = "HTTP://AlbumFile.url" // no glitch
        tag.artist = "New Artist" // glitch
        tag.albumSort = "Album Sort" // glitch
        tag.albumArtistSort = "Album Artist Sort" // glitch
        tag.artistSort = "Artist Sort" // glitch
        tag.arranger = "Arranger" // glitch
        tag.artistWebpage = "HTTP://Artist.url" // glitch
        tag.bpm = 98 // glitch
        tag.copyrightWebpage = "HTTP://Copyright.url" // glitch
        tag.composer = "New Composer"
        tag.conductor = "New Conductor"
        tag.copyright = "2020 Copyright"
        tag.compilation = false
        tag.composerSort = "Composer Sort"
        tag.contentGroup = "Content Group"
        tag.contentRating = .clean
        tag.contentAdvisory = .usMovieUnrated
        tag.discNumber?.disc = 11
        tag.discNumber?.totalDiscs = 12
        tag.encodedBy = "New Encoded By"
        tag.episodeName = "Episode Name"
        tag.episodeNumber = 13
        tag.encodingSettings = "New Encoding Settings"
        tag.fileOwner = "New File Owner"
        tag.grouping = "Grouping"
        tag.isrc = 987654321098
        tag.initialKey = .cMinor
        tag.keywords = ["words","and more words"]
        tag.length = 5041
        tag.lyricist = "New Lyricist"
        tag.languages = [.und, .eng]
        tag.movementName = "New Movement Name"
        tag.movementNumber = 14
        tag.totalMovements = 15
        tag.network = "Network"
        tag.onlineExtras = "HTTP://OnlineExtras.com"
        tag.originalAlbum = "New Original Album"
        tag.originalArtist = "New Original Artist"
        tag.originalFilename = "New Original Filename"
        tag.originalLyricist = "New Original Lyricist"
        tag.podcastID = "Podcast ID"
        tag.podcastCategory = "Podcast Category"
        tag.podcastFeedLink = "HTTP://Podcast.url"
        tag.podcastDescription = "Podcast Description"
        tag.publisher = "New Publisher"
        tag.playlistDelay = 0
        tag.paymentWebpage = "HTTP://Payment.url"
        tag.publisherWebpage = "HTTP://Publisher.url"
        tag.radioStation = "New Radio Station"
        tag.radioStationOwner = "New Radio Station Owner"
        tag.radioStationWebpage = "HTTP://RadioStation.url"
        tag.season = 16
        tag.subtitle = "New Subtitle"
        tag.seriesName = "Series Name"
        tag.sourceCredit = "Source Credit"
        tag.title = "New Title"
        tag.thanks = "Thanks"
        tag.titleSort = "Title Sort"
        
        tag[comments: .eng, "Comment Description"] = "Comment Content"
        tag[lyrics: .eng, "Lyrics Description"] = "Lyrics Content"
        tag[userDefinedText: "User Text Description"] = "User Text Content"
        tag[userDefinedUrl: "User Webpage Description"] = "HTTP://UserDefined.url"
        tag[customComment: .eng, .description] = nil
        tag[customComment: .eng, .linerNotes] = nil
        tag[customComment: .eng, .longDescription] = nil
        tag[customComment: .eng, .seriesDescription] = nil
        tag[customComment: .eng, .songDescription] = nil
        
        
        tag[chapters: "Ch01"]?.startTime = 0
        tag[chapters: "Ch01"]?.endTime = 4000
        //        tag[embeddedSubframes: "Ch01"]?.title = "Chapter Name" - subscript is get only?
        
        tag.addInvolvedPersonCredit(role: .actor, person: "Actor Name")
        tag.addInvolvedPersonCredit(role: .actress, person: "Actress Name")
        
        tag.fileType?.fileType = .MPG
        tag.fileType?.fileTypeRefinement = .mpegLayerIII
        tag.fileType?.additionalInformation = "File Type Description"
        tag.genre?.presetGenre = .Audiobook
        tag.genre?.customGenre = "Genre Description"
        tag.mediaType?.mediaType = .otherDigital
        tag.mediaType?.mediaTypeRefinement = .analogTransfer
        tag.mediaType?.additionalInformation = "Media Type Description"
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/testV23Writing.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_3, using: tag, writingTo: outputUrl))
    }
    
    
    func testV22Writing() throws {
        let mp3Url = Bundle.writtenV22
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.album = "New Album"
        tag.albumArtist = "New Album Artist"
        tag.artist = "New Artist"
        tag.albumSort = "Album Sort"
        tag.albumArtistSort = "Album Artist Sort"
        tag.artistSort = "Artist Sort"
        tag.arranger = "Arranger"
        tag.composer = "New Composer"
        tag.conductor = "New Conductor"
        tag.copyright = "2020 Copyright"
        tag.composerSort = "Composer Sort"
        tag.contentGroup = "Content Group"
        tag.encodedBy = "New Encoded By"
        tag.encodingSettings = "New Encoding Settings"
        tag.fileOwner = "New File Owner"
        tag.grouping = "Grouping"
        tag.lyricist = "New Lyricist"
        tag.originalAlbum = "New Original Album"
        tag.originalArtist = "New Original Artist"
        tag.originalFilename = "New Original Filename"
        tag.originalLyricist = "New Original Lyricist"
        tag.publisher = "New Publisher"
        tag.radioStation = "New Radio Station"
        tag.radioStationOwner = "New Radio Station Owner"
        tag.subtitle = "New Subtitle"
        tag.title = "New Title"
        tag.titleSort = "Title Sort"
        
        tag.compilation = true
        tag.playlistDelay = 0
        tag[comments: .eng, "Comment Description"] = "Comment Content"
        tag[lyrics: .eng, "Lyrics Description"] = "Lyrics Content"
        /* EVERYTHING ABOVE THIS POINT PLAYS IN ITUNES */
        
        tag[customComment: .eng, .description] = nil
        tag[customComment: .eng, .linerNotes] = nil
        tag[customComment: .eng, .longDescription] = nil
        tag[customComment: .eng, .seriesDescription] = nil
        tag[customComment: .eng, .songDescription] = nil
        
        tag.initialKey = .cMinor
        tag.languages = [.und, .eng]
        tag.discNumber?.disc = 11
        tag.discNumber?.totalDiscs = 12
        tag.trackNumber?.track = 13
        tag.trackNumber?.totalTracks = 14
        
        tag.bpm = 98
        tag.isrc = 987654321098
        tag.length = 5041
        
        tag.audioSourceWebpage = "HTTP://AlbumSource.url"
        tag.audioFileWebpage = "HTTP://AlbumFile.url"
        tag.artistWebpage = "HTTP://Artist.url"
        tag.copyrightWebpage = "HTTP://Copyright.url"
        tag.publisherWebpage = "HTTP://Publisher.url"
        
        // MARK: Comments, Lyrics, User Text Frams
        tag[userDefinedText: "User Text Description"] = "User Text Content"
        tag[userDefinedUrl: "User Webpage Description"] = "HTTP://UserDefined.url"
        tag.acknowledgment = "New Acknowledgment"
        tag.thanks = "Thanks"
        tag.sourceCredit = "Source Credit"
        tag.seriesName = "Series Name"
        tag.season = 16
        tag.episodeNumber = 13
        tag.episodeName = "Episode Name"
        tag.network = "Network"
        tag.onlineExtras = "HTTP://OnlineExtras.com"
        tag.contentRating = .clean
        tag.contentAdvisory = .usMovieUnrated
        tag.keywords = ["words","and more words"]
        
        // MARK: Credits List Frame
        tag.addInvolvedPersonCredit(role: .actor, person: "Actor Name")
        tag.addInvolvedPersonCredit(role: .actress, person: "Actress Name")
        
        // MARK: Preset Options Frame
        tag.fileType?.fileType = .MPG
        tag.fileType?.fileTypeRefinement = .mpegLayerIII
        tag.fileType?.additionalInformation = "File Type Description"
        tag.genre?.presetGenre = .Audiobook
        tag.genre?.customGenre = "Genre Description"
        tag.mediaType?.mediaType = .otherDigital
        tag.mediaType?.mediaTypeRefinement = .analogTransfer
        tag.mediaType?.additionalInformation = "Media Type Description"
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/testV22Writing.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_2, using: tag, writingTo: outputUrl))
    }
 */
}

