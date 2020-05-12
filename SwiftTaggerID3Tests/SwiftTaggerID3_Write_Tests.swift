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
    
    // MARK: V24 writing test
    func testV24Writing() throws {
        let mp3Url = Bundle.v23NoMeta
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.album = "Album"
        tag.albumArtist = "Album Artist"
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
        tag.encodedBy = "Encoded By"
        tag.encodingSettings = "Encoding Settings"
        tag.fileOwner = "File Owner"
        tag.grouping = "Grouping"
        tag.initialKey = .aFlatMinor
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
        tag.podcastKeywords = "Podcast Keywords"
        tag.publisher = "Publisher"
        tag.producedNotice = "2020 Produced Notice"
        tag.radioStation = "Radio Station"
        tag.radioStationOwner = "Radio Station Owner"
        tag.subtitle = "Subtitle"
        tag.setSubtitle = "Set Subtitle"
        tag.title = "Title"
        tag.titleSort = "Title Sort"

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
        tag.fileType?.additionalInformation = "File Type"
        tag.genre?.presetGenre = .Audiobook
        tag.genre?.customGenre = "Genre Type" // needs to be fixed
        tag.mediaType?.mediaType = nil // get rid of parens when nil
        tag.mediaType?.mediaTypeRefinement = nil
        tag.mediaType?.additionalInformation = "Media Type"

//        // MARK: Date Frame
//        tag.releaseDateTime = (year: 2015, month: 02, day: 03, hour: 11, minute: 11)
//        tag.encodingDateTime = (year: 2016, month: 04, day: 05, hour: nil, minute: nil)
//        tag.taggingDateTime = (year: 2017, month: 06, day: 07, hour: nil, minute: nil)
//        tag.originalReleaseDate = (year: 2014, month: 08, day: 09, hour: nil, minute: nil)
//        tag.recordingDateTime = (year: 2018, month: 10, day: 11, hour: nil, minute: nil)

        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/testV24Writing.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))
        
        // MARK: Confirm accuracy
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)

        XCTAssertEqual(tagWritten.album, "Album")
        XCTAssertEqual(tagWritten.albumArtist, "Album Artist")
        XCTAssertEqual(tagWritten.albumArtistSort, "Album Artist Sort")
        XCTAssertEqual(tagWritten.albumSort, "Album Sort")
        XCTAssertEqual(tagWritten.arranger, "Arranger")
        XCTAssertEqual(tagWritten.artist, "Artist")
        XCTAssertEqual(tagWritten.artistSort, "Artist Sort")
        XCTAssertEqual(tagWritten.artistWebpage, "http://artist.url")
        XCTAssertEqual(tagWritten.audioFileWebpage, "http://audiofile.url")
        XCTAssertEqual(tagWritten.audioSourceWebpage, "http://audiosource.url")
        XCTAssertEqual(tagWritten.author, "Artist")
        XCTAssertEqual(tagWritten.authorSort, "Artist Sort")
        XCTAssertEqual(tagWritten.bpm, 99)
        XCTAssertEqual(tagWritten.compilation, true)
        XCTAssertEqual(tagWritten.composer, "Composer")
        XCTAssertEqual(tagWritten.composerSort, "Composer Sort")
        XCTAssertEqual(tagWritten.conductor, "Conductor")
        XCTAssertEqual(tagWritten.contentAdvisory, .usMovieUnrated)
        XCTAssertEqual(tagWritten.contentGroup, "Content Group")
        XCTAssertEqual(tagWritten.contentRating, .clean)
        XCTAssertEqual(tagWritten.copyright, "2020 Copyright")
        XCTAssertEqual(tagWritten.copyrightWebpage, "http://copyright.url")
        XCTAssertEqual(tagWritten.discNumber?.disc, 3)
        XCTAssertEqual(tagWritten.discNumber?.totalDiscs, 4)
        XCTAssertEqual(tagWritten.encodedBy, "Encoded By")
//        XCTAssertEqual(tagWritten.encodingDateTime?.year, 2016)
//        XCTAssertEqual(tagWritten.encodingDateTime?.month, 04)
//        XCTAssertEqual(tagWritten.encodingDateTime?.day, 05)
//        XCTAssertNil(tagWritten.encodingDateTime?.hour)
//        XCTAssertNil(tagWritten.encodingDateTime?.minute)
        XCTAssertEqual(tagWritten.encodingSettings, "Encoding Settings")
        XCTAssertEqual(tagWritten.episodeName, "Episode Name")
        XCTAssertEqual(tagWritten.episodeNumber, 7)
        XCTAssertEqual(tagWritten.fileOwner, "File Owner")
        XCTAssertNil(tagWritten.fileType?.fileType)
        XCTAssertNil(tagWritten.fileType?.fileTypeRefinement)
        XCTAssertEqual(tagWritten.fileType?.additionalInformation, "File Type")
        XCTAssertEqual(tagWritten.genre?.presetGenre, .Audiobook)
        XCTAssertEqual(tagWritten.genre?.customGenre, "Genre Type")
        XCTAssertEqual(tagWritten.grouping, "Grouping")
        XCTAssertEqual(tagWritten.initialKey, .aFlatMinor)
        XCTAssertEqual(tagWritten.interpretedBy, "Arranger")
        XCTAssertEqual(tagWritten.involvedPeopleList?[.actor], ["Actor Name"])
        XCTAssertEqual(tagWritten.involvedPeopleList?[.actress], ["Actress Name"])
        XCTAssertEqual(tagWritten.isrc, 987654321098)
        XCTAssertEqual(tagWritten.keywords, ["Key","Words"])
        XCTAssertEqual(tagWritten.label, "Publisher")
        XCTAssertEqual(tagWritten.languages, [.eng])
        XCTAssertEqual(tagWritten.length, 9767)
        XCTAssertEqual(tagWritten.lyricist, "Lyricist")
        XCTAssertNil(tagWritten.mediaType?.mediaType)
        XCTAssertNil(tagWritten.mediaType?.mediaTypeRefinement)
        XCTAssertEqual(tagWritten.mediaType?.additionalInformation, "Media Type")
        XCTAssertEqual(tagWritten.mood, "Mood")
        XCTAssertEqual(tagWritten.movementName, "Movement Name")
        XCTAssertEqual(tagWritten.movementNumber, 5)
        XCTAssertEqual(tagWritten.totalMovements, 6)
        XCTAssertEqual(tagWritten.musicianCreditsList?[.soprano], ["Soprano Name"])
        XCTAssertEqual(tagWritten.musicianCreditsList?[.alto], ["Alto Name"])
        XCTAssertEqual(tagWritten.narrator, "Composer")
        XCTAssertEqual(tagWritten.narratorSort, "Composer Sort")
        XCTAssertEqual(tagWritten.network, "Network")
        XCTAssertEqual(tagWritten.onlineExtras, "http://onlineextras.url")
        XCTAssertEqual(tagWritten.originalAlbum, "Original Album")
        XCTAssertEqual(tagWritten.originalArtist, "Original Artist")
        XCTAssertEqual(tagWritten.originalFilename, "Original Filename")
        XCTAssertEqual(tagWritten.originalLyricist, "Original Lyricist")
//        XCTAssertEqual(tagWritten.originalReleaseDate?.year, 2014)
//        XCTAssertEqual(tagWritten.originalReleaseDate?.month, 08)
//        XCTAssertEqual(tagWritten.originalReleaseDate?.day, 09)
//        XCTAssertNil(tagWritten.originalReleaseDate?.hour)
//        XCTAssertNil(tagWritten.originalReleaseDate?.minute)
        XCTAssertEqual(tagWritten.paymentWebpage, "http://payment.url")
        XCTAssertEqual(tagWritten.playlistDelay, 0)
        XCTAssertEqual(tagWritten.podcastCategory, "Podcast Category")
        XCTAssertEqual(tagWritten.podcastDescription, "Podcast Description")
        XCTAssertEqual(tagWritten.podcastFeedLink, "http://podcast.url")
        XCTAssertEqual(tagWritten.podcastID, "Podcast ID")
        XCTAssertEqual(tagWritten.podcastKeywords, "Podcast Keywords")
        XCTAssertEqual(tagWritten.producedNotice, "2020 Produced Notice")
        XCTAssertEqual(tagWritten.publisher, "Publisher")
        XCTAssertEqual(tagWritten.publisherWebpage, "http://publisher.url")
        XCTAssertEqual(tagWritten.radioStation, "Radio Station")
        XCTAssertEqual(tagWritten.radioStationOwner, "Radio Station Owner")
        XCTAssertEqual(tagWritten.radioStationWebpage, "http://radiostation.url")
        XCTAssertEqual(tagWritten.recordCompany, "Publisher")
//        XCTAssertEqual(tagWritten.recordingDateTime?.year, 2018)
//        XCTAssertEqual(tagWritten.recordingDateTime?.month, 10)
//        XCTAssertEqual(tagWritten.recordingDateTime?.day, 11)
//        XCTAssertNil(tagWritten.recordingDateTime?.hour)
//        XCTAssertNil(tagWritten.recordingDateTime?.minute)
//        XCTAssertEqual(tagWritten.releaseDateTime?.year, 2015)
//        XCTAssertEqual(tagWritten.releaseDateTime?.month, 02)
//        XCTAssertEqual(tagWritten.releaseDateTime?.day, 03)
//        XCTAssertEqual(tagWritten.releaseDateTime?.hour, 11)
//        XCTAssertEqual(tagWritten.releaseDateTime?.minute, 11)
        XCTAssertEqual(tagWritten.remixer, "Arranger")
        XCTAssertEqual(tagWritten.season, 8)
        XCTAssertEqual(tagWritten.series, "Content Group")
        XCTAssertEqual(tagWritten.seriesName, "Series Name")
        XCTAssertEqual(tagWritten.setSubtitle, "Set Subtitle")
        XCTAssertEqual(tagWritten.sourceCredit, "Source Credit")
        XCTAssertEqual(tagWritten.studio, "Publisher")
        XCTAssertEqual(tagWritten.subtitle, "Subtitle")
//        XCTAssertEqual(tagWritten.taggingDateTime?.year, 2017)
//        XCTAssertEqual(tagWritten.taggingDateTime?.month, 06)
//        XCTAssertEqual(tagWritten.taggingDateTime?.day, 07)
//        XCTAssertNil(tagWritten.taggingDateTime?.hour)
//        XCTAssertNil(tagWritten.taggingDateTime?.minute)
        XCTAssertEqual(tagWritten.thanks, "Thanks")
        XCTAssertEqual(tagWritten.title, "Title")
        XCTAssertEqual(tagWritten.titleSort, "Title Sort")
        XCTAssertEqual(tagWritten.trackNumber?.track, 1)
        XCTAssertEqual(tagWritten.trackNumber?.totalTracks, 2)
        XCTAssertEqual(tagWritten.work, "Content Group")
        
    }
    
    // MARK: V23 writing test
    func testV23Writing() throws {
        let mp3Url = Bundle.v23NoMeta
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.album = "Album"
        tag.albumArtist = "Album Artist"
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
        tag.encodedBy = "Encoded By"
        tag.encodingSettings = "Encoding Settings"
        tag.fileOwner = "File Owner"
        tag.grouping = "Grouping"
        tag.initialKey = .aFlatMinor
        tag.lyricist = "Lyricist"
        tag.movementName = "Movement Name"
        tag.originalAlbum = "Original Album"
        tag.originalArtist = "Original Artist"
        tag.originalFilename = "Original Filename"
        tag.originalLyricist = "Original Lyricist"
        tag.podcastID = "Podcast ID"
        tag.podcastCategory = "Podcast Category"
        tag.podcastFeedLink = "http://podcast.url"
        tag.podcastDescription = "Podcast Description"
        tag.podcastKeywords = "Podcast Keywords"
        tag.publisher = "Publisher"
        tag.radioStation = "Radio Station"
        tag.radioStationOwner = "Radio Station Owner"
        tag.subtitle = "Subtitle"
        tag.title = "Title"
        tag.titleSort = "Title Sort"
        
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
        
        // MARK: Preset Options Frame
        tag.fileType?.fileType = nil
        tag.fileType?.fileTypeRefinement = nil
        tag.fileType?.additionalInformation = "File Type"
        tag.genre?.presetGenre = .Audiobook
        tag.genre?.customGenre = "Genre Type" // needs to be fixed
        tag.mediaType?.mediaType = nil // get rid of parens when nil
        tag.mediaType?.mediaTypeRefinement = nil
        tag.mediaType?.additionalInformation = "Media Type"
        
        // MARK: Date frame
        tag.recordingDateTime = (year: 2018, month: 10, day: 11, hour: nil, minute: nil)
        tag.date = (month: 02, day: 03)
        tag.time = (hour: 11, minute: 11)
        tag.year = 2015
        tag.originalReleaseDate = (year: 2014, month: 08, day: 09, hour: nil, minute: nil)

        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/testV23Writing.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_3, using: tag, writingTo: outputUrl))
    }

    func testV22Writing() throws {
        let mp3Url = Bundle.v23NoMeta
        let mp3File = try Mp3File(location: mp3Url)
        var tag = try Tag(readFrom: mp3File)
        
        tag.album = "Album"
        tag.albumArtist = "Album Artist"
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
        tag.encodedBy = "Encoded By"
        tag.encodingSettings = "Encoding Settings"
        tag.initialKey = .aFlatMinor
        tag.lyricist = "Lyricist"
        tag.originalAlbum = "Original Album"
        tag.originalArtist = "Original Artist"
        tag.originalFilename = "Original Filename"
        tag.originalLyricist = "Original Lyricist"
        tag.publisher = "Publisher"
        tag.radioStation = "Radio Station"
        tag.radioStationOwner = "Radio Station Owner"
        tag.subtitle = "Subtitle"
        tag.title = "Title"
        tag.titleSort = "Title Sort"
        
        tag.compilation = true
        tag.bpm = 99
        tag.isrc = 987654321098
        tag.length = 9767
        tag.playlistDelay = 0
        
        tag.audioSourceWebpage = "http://audiosource.url"
        tag.audioFileWebpage = "http://audiofile.url"
        tag.artistWebpage = "http://artist.url"
        tag.copyrightWebpage = "http://copyright.url"
        tag.publisherWebpage = "http://publisher.url"
        
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
        
        // MARK: Credits List Frame
        tag.addInvolvedPersonCredit(role: .actor, person: "Actor Name")
        tag.addInvolvedPersonCredit(role: .actress, person: "Actress Name")
        
        // MARK: Preset Options Frame
        tag.fileType?.fileType = nil
        tag.fileType?.fileTypeRefinement = nil
        tag.fileType?.additionalInformation = "File Type"
        tag.genre?.presetGenre = .Audiobook
        tag.genre?.customGenre = "Genre Type" // needs to be fixed
        tag.mediaType?.mediaType = nil // get rid of parens when nil
        tag.mediaType?.mediaTypeRefinement = nil
        tag.mediaType?.additionalInformation = "Media Type"
        
        // MARK: Date frame
        tag.recordingDateTime = (year: 2018, month: 10, day: 11, hour: nil, minute: nil)
        tag.date = (month: 02, day: 03)
        tag.time = (hour: 11, minute: 11)
        tag.year = 2015
        tag.originalReleaseDate = (year: 2014, month: 08, day: 09, hour: nil, minute: nil)
        
        let outputUrl = URL(fileURLWithPath: "/Users/nolainecrusher/Desktop/test output/testV22Writing.mp3")
        XCTAssertNoThrow(try mp3File.write(tagVersion: .v2_2, using: tag, writingTo: outputUrl))
    }

}
