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
        let mp3Url = Bundle.writtenV24
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)

        tag.album = "New Album"
        tag.albumArtist = "New Album Artist"
        tag.acknowledgment = "New Acknowledgment"
        tag.audioSourceWebpage = "HTTP://AlbumSource.url"
        tag.audioFileWebpage = "HTTP://AlbumFile.url"
        tag.artist = "New Artist"
        tag.albumSort = "Album Sort"
        tag.albumArtistSort = "Album Artist Sort"
        tag.artistSort = "Artist Sort"
        tag.arranger = "Arranger"
        tag.artistWebpage = "HTTP://Artist.url"
        tag.bpm = 98
        tag.copyrightWebpage = "HTTP://Copyright.url"
        tag.composer = "New Composer"
        tag.conductor = "New Conductor"
        tag.copyright = "2020 Copyright"
        tag.compilation = false
        tag.composerSort = "Composer Sort"
        tag.contentGroup = "Content Group"
        tag.contentRating = .clean
        tag.contentAdvisory = .usMovieUnrated
        tag.discNumber.disc = 11
        tag.discNumber.totalDiscs = 12
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
        tag.mood = "New Mood"
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
        tag.producedNotice = "2020 New Produced Notice"
        tag.publisherWebpage = "HTTP://Publisher.url"
        tag.radioStation = "New Radio Station"
        tag.radioStationOwner = "New Radio Station Owner"
        tag.radioStationWebpage = "HTTP://RadioStation.url"
        tag.season = 16
        tag.subtitle = "New Subtitle"
        tag.seriesName = "Series Name"
        tag.setSubtitle = "New Set Subtitle"
        tag.sourceCredit = "Source Credit"
        tag.title = "New Title"
        tag.thanks = "Thanks"
        tag.titleSort = "Title Sort"

        tag[comments: .eng, "Comment Description"] = "Comment Content"
        tag[lyrics: .eng, "Lyrics Description"] = "Lyrics Content"
        tag[userDefinedText: "User Text Description"] = "User Text Content"
        tag[userDefinedUrl: "User Webpage Description"] = "HTTP://UserDefined.url"
        tag[description: .eng] = "Description Content"
        tag[linerNotes: .eng] = "Liner Notes Content"
        tag[longDescription: .eng] = "Long Description Content"
        tag[songDescription: .eng] = "Song Description Content"
        tag[seriesDescription: .eng] = "Series Description Content"
        
        tag[chapters: "Ch01"]?.startTime = 0
        tag[chapters: "Ch01"]?.endTime = 4000
//        tag[embeddedSubframes: "Ch01"]?.title = "Chapter Name" - subscript is get only?

        tag.addInvolvedPersonCredit(role: .actor, person: "Actor Name")
        tag.addInvolvedPersonCredit(role: .actress, person: "Actress Name")
        tag.addMusicianCredit(role: .soprano, person: "Soprono Name")
        tag.addMusicianCredit(role: .alto, person: "Alto Name")

        tag.fileType.fileType = .MPG
        tag.fileType.additionalFileTypeInfo = .mpegLayerIII
        tag.fileType.fileTypeDescription = "File Type Description"
        tag.genre.genreName = .Audiobook
        tag.genre.genreDescription = "Genre Description"
        tag.mediaType.mediaType = .otherDigital
        tag.mediaType.additionalMediaInfo = .analogTransfer
        tag.mediaType.mediaTypeDescription = "Media Type Description"
        
        #warning("Doesn't work. Metadata on file doesn't change, and audio doesn't play in Music (though it does in other apps)")
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/testV24Writing.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))
    }

    func testV23Writing() throws {
        let mp3Url = Bundle.writtenV23
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.album = "New Album"
        tag.albumArtist = "New Album Artist"
        tag.acknowledgment = "New Acknowledgment"
        tag.audioSourceWebpage = "HTTP://AlbumSource.url"
        tag.audioFileWebpage = "HTTP://AlbumFile.url"
        tag.artist = "New Artist"
        tag.albumSort = "Album Sort"
        tag.albumArtistSort = "Album Artist Sort"
        tag.artistSort = "Artist Sort"
        tag.arranger = "Arranger"
        tag.artistWebpage = "HTTP://Artist.url"
        tag.bpm = 98
        tag.copyrightWebpage = "HTTP://Copyright.url"
        tag.composer = "New Composer"
        tag.conductor = "New Conductor"
        tag.copyright = "2020 Copyright"
        tag.compilation = false
        tag.composerSort = "Composer Sort"
        tag.contentGroup = "Content Group"
        tag.contentRating = .clean
        tag.contentAdvisory = .usMovieUnrated
        tag.discNumber.disc = 11
        tag.discNumber.totalDiscs = 12
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
        tag[description: .eng] = "Description Content"
        tag[linerNotes: .eng] = "Liner Notes Content"
        tag[longDescription: .eng] = "Long Description Content"
        tag[songDescription: .eng] = "Song Description Content"
        tag[seriesDescription: .eng] = "Series Description Content"
        
        tag[chapters: "Ch01"]?.startTime = 0
        tag[chapters: "Ch01"]?.endTime = 4000
        //        tag[embeddedSubframes: "Ch01"]?.title = "Chapter Name" - subscript is get only?
        
        tag.addInvolvedPersonCredit(role: .actor, person: "Actor Name")
        tag.addInvolvedPersonCredit(role: .actress, person: "Actress Name")
        
        tag.fileType.fileType = .MPG
        tag.fileType.additionalFileTypeInfo = .mpegLayerIII
        tag.fileType.fileTypeDescription = "File Type Description"
        tag.genre.genreName = .Audiobook
        tag.genre.genreDescription = "Genre Description"
        tag.mediaType.mediaType = .otherDigital
        tag.mediaType.additionalMediaInfo = .analogTransfer
        tag.mediaType.mediaTypeDescription = "Media Type Description"
        
        #warning("Doesn't work. Metadata on file doesn't change, and audio doesn't play in Music (though it does in other apps)")
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/testV23Writing.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_3, using: tag, writingTo: outputUrl))
    }


    func testV22Writing() throws {
        let mp3Url = Bundle.writtenV22
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.album = "New Album"
        tag.albumArtist = "New Album Artist"
        tag.acknowledgment = "New Acknowledgment"
        tag.audioSourceWebpage = "HTTP://AlbumSource.url"
        tag.audioFileWebpage = "HTTP://AlbumFile.url"
        tag.artist = "New Artist"
        tag.albumSort = "Album Sort"
        tag.albumArtistSort = "Album Artist Sort"
        tag.artistSort = "Artist Sort"
        tag.arranger = "Arranger"
        tag.artistWebpage = "HTTP://Artist.url"
        tag.bpm = 98
        tag.copyrightWebpage = "HTTP://Copyright.url"
        tag.composer = "New Composer"
        tag.conductor = "New Conductor"
        tag.copyright = "2020 Copyright"
        tag.compilation = false
        tag.composerSort = "Composer Sort"
        tag.contentGroup = "Content Group"
        tag.contentRating = .clean
        tag.contentAdvisory = .usMovieUnrated
        tag.discNumber.disc = 11
        tag.discNumber.totalDiscs = 12
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
        tag.network = "Network"
        tag.onlineExtras = "HTTP://OnlineExtras.com"
        tag.originalAlbum = "New Original Album"
        tag.originalArtist = "New Original Artist"
        tag.originalFilename = "New Original Filename"
        tag.originalLyricist = "New Original Lyricist"
        tag.publisher = "New Publisher"
        tag.playlistDelay = 0
        tag.publisherWebpage = "HTTP://Publisher.url"
        tag.radioStation = "New Radio Station"
        tag.radioStationOwner = "New Radio Station Owner"
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
        tag[description: .eng] = "Description Content"
        tag[linerNotes: .eng] = "Liner Notes Content"
        tag[longDescription: .eng] = "Long Description Content"
        tag[songDescription: .eng] = "Song Description Content"
        tag[seriesDescription: .eng] = "Series Description Content"
                
        tag.addInvolvedPersonCredit(role: .actor, person: "Actor Name")
        tag.addInvolvedPersonCredit(role: .actress, person: "Actress Name")
        
        tag.fileType.fileType = .MPG
        tag.fileType.additionalFileTypeInfo = .mpegLayerIII
        tag.fileType.fileTypeDescription = "File Type Description"
        tag.genre.genreName = .Audiobook
        tag.genre.genreDescription = "Genre Description"
        tag.mediaType.mediaType = .otherDigital
        tag.mediaType.additionalMediaInfo = .analogTransfer
        tag.mediaType.mediaTypeDescription = "Media Type Description"
        
        #warning("Doesn't work. Metadata on file doesn't change, and audio doesn't play in Music (though it does in other apps)")
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/testV22Writing.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_2, using: tag, writingTo: outputUrl))
    }
}

