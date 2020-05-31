/*

 SwiftTaggerID3_Write_Tests.swift
 SwiftTaggerID3

 Copyright ©2020 Nolaine Crusher. All rights reserved.

 */

import XCTest
import SwiftTaggerID3

@available(OSX 10.12, *)
class SwiftTaggerID3_Write_Tests: XCTestCase {
    
    // MARK: V24 writing test
    // Test writing, and accuracy of written data, version 2.4
    func testV24Writing() throws {
        var tag = try TestFile.noMeta.tag()

        tag?.album = "Album"
        tag?.albumArtist = "Album Artist"
        tag?.albumSort = "Album Sort"
        tag?.albumArtistSort = "Album Artist Sort"
        tag?.arranger = "Arranger"
        tag?.artist = "Artist"
        tag?.artistSort = "Artist Sort"
        tag?.composer = "Composer"
        tag?.composerSort = "Composer Sort"
        tag?.conductor = "Conductor"
        tag?.contentGroup = "Content Group"
        tag?.copyright = "2020 Copyright"
        tag?.encodedBy = "Encoded By"
        tag?.encodingSettings = "Encoding Settings"
        tag?.fileOwner = "File Owner"
        tag?.grouping = "Grouping"
        tag?.initialKey = .aFlatMinor
        tag?.lyricist = "Lyricist"
        tag?.mood = "Mood"
        tag?.movementName = "Movement Name"
        tag?.originalAlbum = "Original Album"
        tag?.originalArtist = "Original Artist"
        tag?.originalFilename = "Original Filename"
        tag?.originalLyricist = "Original Lyricist"
        tag?.podcastID = "Podcast ID"
        tag?.podcastCategory = "Podcast Category"
        tag?.podcastFeedLink = "http://podcast.url"
        tag?.podcastDescription = "Podcast Description"
        tag?.podcastKeywords = "Podcast Keywords"
        tag?.publisher = "Publisher"
        tag?.producedNotice = "2020 Produced Notice"
        tag?.radioStation = "Radio Station"
        tag?.radioStationOwner = "Radio Station Owner"
        tag?.subtitle = "Subtitle"
        tag?.setSubtitle = "Set Subtitle"
        tag?.title = "Title"
        tag?.titleSort = "Title Sort"
        
        tag?.compilation = true
        tag?.bpm = 99
        tag?.isrc = 987654321098
        tag?.length = 9767
        tag?.movementNumber = 5
        tag?.totalMovements = 6
        tag?.playlistDelay = 0
        
        tag?.audioSourceWebpage = "http://audiosource.url"
        tag?.audioFileWebpage = "http://audiofile.url"
        tag?.artistWebpage = "http://artist.url"
        tag?.copyrightWebpage = "http://copyright.url"
        tag?.paymentWebpage = "http://payment.url"
        tag?.publisherWebpage = "http://publisher.url"
        tag?.radioStationWebpage = "http://radiostation.url"
        
        // MARK: Language Frame
        tag?.languages = [.eng]
        
        // MARK: Part Of Total frame
        tag?.trackNumber?.track = 1
        tag?.trackNumber?.totalTracks = 2
        tag?.discNumber?.disc = 3
        tag?.discNumber?.totalDiscs = 4
                        
        // MARK: Preset Options Frame
        tag?.fileType?.fileType = nil
        tag?.fileType?.fileTypeRefinement = nil
        tag?.fileType?.additionalInformation = "File Type"
        tag?.genre?.presetGenre = .Audiobook
        tag?.genre?.customGenre = "Genre Type"
        tag?.mediaType?.mediaType = nil
        tag?.mediaType?.mediaTypeRefinement = nil
        tag?.mediaType?.additionalInformation = "Media Type"
        
        // MARK: Date Frame
        tag?.releaseDateTime = (year: 2015, month: 02, day: 03, hour: 11, minute: 11)
        tag?.encodingDateTime = (year: 2016, month: 04, day: 05, hour: nil, minute: nil)
        tag?.taggingDateTime = (year: 2017, month: 06, day: 07, hour: nil, minute: nil)
        tag?.originalReleaseTime = (year: 2014, month: 08, day: 09, hour: nil, minute: nil)
        tag?.recordingDateTime = (year: 2018, month: 10, day: 11, hour: nil, minute: nil)

        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        XCTAssertNoThrow(try TestFile.noMeta.mp3File()?.write(tagVersion: .v2_4, using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v24.url)), writingTo: outputUrl))
        
        
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
        XCTAssertEqual(tagWritten.contentGroup, "Content Group")
        XCTAssertEqual(tagWritten.copyright, "2020 Copyright")
        XCTAssertEqual(tagWritten.copyrightWebpage, "http://copyright.url")
        XCTAssertEqual(tagWritten.discNumber?.disc, 3)
        XCTAssertEqual(tagWritten.discNumber?.totalDiscs, 4)
        XCTAssertEqual(tagWritten.encodedBy, "Encoded By")
        XCTAssertEqual(tagWritten.encodingDateTime?.year, 2016)
        XCTAssertEqual(tagWritten.encodingDateTime?.month, 04)
        XCTAssertEqual(tagWritten.encodingDateTime?.day, 05)
        XCTAssertEqual(tagWritten.encodingDateTime?.hour, 0)
        XCTAssertEqual(tagWritten.encodingDateTime?.minute, 0)

        XCTAssertEqual(tagWritten.encodingSettings, "Encoding Settings")
        XCTAssertEqual(tagWritten.fileOwner, "File Owner")
        XCTAssertNil(tagWritten.fileType?.fileType)
        XCTAssertNil(tagWritten.fileType?.fileTypeRefinement)
        XCTAssertEqual(tagWritten.fileType?.additionalInformation, "File Type")
        XCTAssertEqual(tagWritten.genre?.presetGenre, .Audiobook)
        XCTAssertEqual(tagWritten.genre?.customGenre, "Genre Type")
        XCTAssertEqual(tagWritten.grouping, "Grouping")
        XCTAssertEqual(tagWritten.initialKey, .aFlatMinor)
        XCTAssertEqual(tagWritten.interpretedBy, "Arranger")
        XCTAssertEqual(tagWritten.isrc, 987654321098)
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
        XCTAssertEqual(tagWritten.narrator, "Composer")
        XCTAssertEqual(tagWritten.narratorSort, "Composer Sort")
        XCTAssertEqual(tagWritten.originalAlbum, "Original Album")
        XCTAssertEqual(tagWritten.originalArtist, "Original Artist")
        XCTAssertEqual(tagWritten.originalFilename, "Original Filename")
        XCTAssertEqual(tagWritten.originalLyricist, "Original Lyricist")
        XCTAssertEqual(tagWritten.originalReleaseTime?.year, 2014)
        XCTAssertEqual(tagWritten.originalReleaseTime?.month, 08)
        XCTAssertEqual(tagWritten.originalReleaseTime?.day, 09)
        XCTAssertEqual(tagWritten.originalReleaseTime?.hour, 0)
        XCTAssertEqual(tagWritten.originalReleaseTime?.minute, 0)
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
        XCTAssertEqual(tagWritten.recordingDateTime?.year, 2018)
        XCTAssertEqual(tagWritten.recordingDateTime?.month, 10)
        XCTAssertEqual(tagWritten.recordingDateTime?.day, 11)
        XCTAssertEqual(tagWritten.recordingDateTime?.hour, 0)
        XCTAssertEqual(tagWritten.recordingDateTime?.minute, 0)
        XCTAssertEqual(tagWritten.releaseDateTime?.year, 2015)
        XCTAssertEqual(tagWritten.releaseDateTime?.month, 02)
        XCTAssertEqual(tagWritten.releaseDateTime?.day, 03)
        XCTAssertEqual(tagWritten.releaseDateTime?.hour, 11)
        XCTAssertEqual(tagWritten.releaseDateTime?.minute, 11)
        XCTAssertEqual(tagWritten.remixer, "Arranger")
        XCTAssertEqual(tagWritten.series, "Content Group")
        XCTAssertEqual(tagWritten.setSubtitle, "Set Subtitle")
        XCTAssertEqual(tagWritten.studio, "Publisher")
        XCTAssertEqual(tagWritten.subtitle, "Subtitle")
        XCTAssertEqual(tagWritten.taggingDateTime?.year, 2017)
        XCTAssertEqual(tagWritten.taggingDateTime?.month, 06)
        XCTAssertEqual(tagWritten.taggingDateTime?.day, 07)
        XCTAssertEqual(tagWritten.taggingDateTime?.hour, 0)
        XCTAssertEqual(tagWritten.taggingDateTime?.minute, 0)
        XCTAssertEqual(tagWritten.title, "Title")
        XCTAssertEqual(tagWritten.titleSort, "Title Sort")
        XCTAssertEqual(tagWritten.trackNumber?.track, 1)
        XCTAssertEqual(tagWritten.trackNumber?.totalTracks, 2)
        XCTAssertEqual(tagWritten.work, "Content Group")        
    }
    
    // MARK: V23 writing test
    // Test writing, and accuracy of written data, version 2.3
    func testV23Writing() throws {
        var tag = try TestFile.noMeta.tag()

        tag?.album = "Album"
        tag?.albumArtist = "Album Artist"
        tag?.albumSort = "Album Sort"
        tag?.albumArtistSort = "Album Artist Sort"
        tag?.arranger = "Arranger"
        tag?.artist = "Artist"
        tag?.artistSort = "Artist Sort"
        tag?.composer = "Composer"
        tag?.composerSort = "Composer Sort"
        tag?.conductor = "Conductor"
        tag?.contentGroup = "Content Group"
        tag?.copyright = "2020 Copyright"
        tag?.encodedBy = "Encoded By"
        tag?.encodingSettings = "Encoding Settings"
        tag?.fileOwner = "File Owner"
        tag?.grouping = "Grouping"
        tag?.initialKey = .aFlatMinor
        tag?.lyricist = "Lyricist"
        tag?.movementName = "Movement Name"
        tag?.originalAlbum = "Original Album"
        tag?.originalArtist = "Original Artist"
        tag?.originalFilename = "Original Filename"
        tag?.originalLyricist = "Original Lyricist"
        tag?.podcastID = "Podcast ID"
        tag?.podcastCategory = "Podcast Category"
        tag?.podcastFeedLink = "http://podcast.url"
        tag?.podcastDescription = "Podcast Description"
        tag?.podcastKeywords = "Podcast Keywords"
        tag?.publisher = "Publisher"
        tag?.radioStation = "Radio Station"
        tag?.radioStationOwner = "Radio Station Owner"
        tag?.subtitle = "Subtitle"
        tag?.title = "Title"
        tag?.titleSort = "Title Sort"
        
        tag?.compilation = true
        tag?.bpm = 99
        tag?.isrc = 987654321098
        tag?.length = 9767
        tag?.movementNumber = 5
        tag?.totalMovements = 6
        tag?.playlistDelay = 0
        
        tag?.audioSourceWebpage = "http://audiosource.url"
        tag?.audioFileWebpage = "http://audiofile.url"
        tag?.artistWebpage = "http://artist.url"
        tag?.copyrightWebpage = "http://copyright.url"
        tag?.paymentWebpage = "http://payment.url"
        tag?.publisherWebpage = "http://publisher.url"
        tag?.radioStationWebpage = "http://radiostation.url"
        
        // MARK: Language Frame
        tag?.languages = [.eng]
        
        // MARK: Part Of Total frame
        tag?.trackNumber?.track = 1
        tag?.trackNumber?.totalTracks = 2
        tag?.discNumber?.disc = 3
        tag?.discNumber?.totalDiscs = 4
                
        // MARK: Preset Options Frame
        tag?.fileType?.fileType = nil
        tag?.fileType?.fileTypeRefinement = nil
        tag?.fileType?.additionalInformation = "File Type"
        tag?.genre?.presetGenre = .Audiobook
        tag?.genre?.customGenre = "Genre Type"
        tag?.mediaType?.mediaType = nil
        tag?.mediaType?.mediaTypeRefinement = nil
        tag?.mediaType?.additionalInformation = "Media Type"
        
        // MARK: Date frame
        tag?.recordingDateTime = (year: 2018, month: 10, day: 11, hour: nil, minute: nil)
        tag?.date = (month: 02, day: 03)
        tag?.time = (hour: 11, minute: 11)
        tag?.year = 2015
        tag?.originalReleaseTime = (year: 2014, month: nil, day: nil, hour: nil, minute: nil)
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        XCTAssertNoThrow(try TestFile.noMeta.mp3File()?.write(tagVersion: .v2_3, using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v23.url)), writingTo: outputUrl))

        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.recordingDateTime?.year, 2018)
        XCTAssertEqual(tagWritten.recordingDateTime?.month, 10)
        XCTAssertEqual(tagWritten.recordingDateTime?.day, 11)
        XCTAssertEqual(tagWritten.recordingDateTime?.hour, 0)
        XCTAssertEqual(tagWritten.recordingDateTime?.minute, 0)
        XCTAssertEqual(tagWritten.date?.month, 02)
        XCTAssertEqual(tagWritten.date?.day, 03)
        XCTAssertEqual(tagWritten.time?.hour, 11)
        XCTAssertEqual(tagWritten.time?.minute, 11)
        XCTAssertEqual(tagWritten.year, 2015)
        XCTAssertEqual(tagWritten.originalReleaseTime?.year, 2014)
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
        XCTAssertEqual(tagWritten.contentGroup, "Content Group")
        XCTAssertEqual(tagWritten.copyright, "2020 Copyright")
        XCTAssertEqual(tagWritten.copyrightWebpage, "http://copyright.url")
        XCTAssertEqual(tagWritten.discNumber?.disc, 3)
        XCTAssertEqual(tagWritten.discNumber?.totalDiscs, 4)
        XCTAssertEqual(tagWritten.encodedBy, "Encoded By")
        XCTAssertEqual(tagWritten.encodingSettings, "Encoding Settings")
        XCTAssertEqual(tagWritten.fileOwner, "File Owner")
        XCTAssertNil(tagWritten.fileType?.fileType)
        XCTAssertNil(tagWritten.fileType?.fileTypeRefinement)
        XCTAssertEqual(tagWritten.fileType?.additionalInformation, "File Type")
        XCTAssertEqual(tagWritten.genre?.presetGenre, .Audiobook)
        XCTAssertEqual(tagWritten.genre?.customGenre, "Genre Type")
        XCTAssertEqual(tagWritten.grouping, "Grouping")
        XCTAssertEqual(tagWritten.initialKey, .aFlatMinor)
        XCTAssertEqual(tagWritten.interpretedBy, "Arranger")
        XCTAssertEqual(tagWritten.isrc, 987654321098)
        XCTAssertEqual(tagWritten.label, "Publisher")
        XCTAssertEqual(tagWritten.languages, [.eng])
        XCTAssertEqual(tagWritten.length, 9767)
        XCTAssertEqual(tagWritten.lyricist, "Lyricist")
        XCTAssertNil(tagWritten.mediaType?.mediaType)
        XCTAssertNil(tagWritten.mediaType?.mediaTypeRefinement)
        XCTAssertEqual(tagWritten.mediaType?.additionalInformation, "Media Type")
        XCTAssertEqual(tagWritten.movementName, "Movement Name")
        XCTAssertEqual(tagWritten.movementNumber, 5)
        XCTAssertEqual(tagWritten.totalMovements, 6)
        XCTAssertEqual(tagWritten.narrator, "Composer")
        XCTAssertEqual(tagWritten.narratorSort, "Composer Sort")
        XCTAssertEqual(tagWritten.originalAlbum, "Original Album")
        XCTAssertEqual(tagWritten.originalArtist, "Original Artist")
        XCTAssertEqual(tagWritten.originalFilename, "Original Filename")
        XCTAssertEqual(tagWritten.originalLyricist, "Original Lyricist")
        XCTAssertEqual(tagWritten.paymentWebpage, "http://payment.url")
        XCTAssertEqual(tagWritten.playlistDelay, 0)
        XCTAssertEqual(tagWritten.podcastCategory, "Podcast Category")
        XCTAssertEqual(tagWritten.podcastDescription, "Podcast Description")
        XCTAssertEqual(tagWritten.podcastFeedLink, "http://podcast.url")
        XCTAssertEqual(tagWritten.podcastID, "Podcast ID")
        XCTAssertEqual(tagWritten.podcastKeywords, "Podcast Keywords")
        XCTAssertEqual(tagWritten.publisher, "Publisher")
        XCTAssertEqual(tagWritten.publisherWebpage, "http://publisher.url")
        XCTAssertEqual(tagWritten.radioStation, "Radio Station")
        XCTAssertEqual(tagWritten.radioStationOwner, "Radio Station Owner")
        XCTAssertEqual(tagWritten.radioStationWebpage, "http://radiostation.url")
        XCTAssertEqual(tagWritten.recordCompany, "Publisher")
        XCTAssertEqual(tagWritten.remixer, "Arranger")
        XCTAssertEqual(tagWritten.series, "Content Group")
        XCTAssertEqual(tagWritten.studio, "Publisher")
        XCTAssertEqual(tagWritten.subtitle, "Subtitle")
        XCTAssertEqual(tagWritten.title, "Title")
        XCTAssertEqual(tagWritten.titleSort, "Title Sort")
        XCTAssertEqual(tagWritten.trackNumber?.track, 1)
        XCTAssertEqual(tagWritten.trackNumber?.totalTracks, 2)
        XCTAssertEqual(tagWritten.work, "Content Group")
    }
    
    // Test writing, and accuracy of written data, version 2.2
    func testV22Writing() throws {
        var tag = try TestFile.noMeta.tag()

        tag?.album = "Album"
        tag?.albumArtist = "Album Artist"
        tag?.albumSort = "Album Sort"
        tag?.albumArtistSort = "Album Artist Sort"
        tag?.arranger = "Arranger"
        tag?.artist = "Artist"
        tag?.artistSort = "Artist Sort"
        tag?.composer = "Composer"
        tag?.composerSort = "Composer Sort"
        tag?.conductor = "Conductor"
        tag?.contentGroup = "Content Group"
        tag?.copyright = "2020 Copyright"
        tag?.encodedBy = "Encoded By"
        tag?.encodingSettings = "Encoding Settings"
        tag?.initialKey = .aFlatMinor
        tag?.lyricist = "Lyricist"
        tag?.originalAlbum = "Original Album"
        tag?.originalArtist = "Original Artist"
        tag?.originalFilename = "Original Filename"
        tag?.originalLyricist = "Original Lyricist"
        tag?.publisher = "Publisher"
        tag?.radioStation = "Radio Station"
        tag?.radioStationOwner = "Radio Station Owner"
        tag?.subtitle = "Subtitle"
        tag?.title = "Title"
        tag?.titleSort = "Title Sort"
        
        tag?.compilation = true
        tag?.bpm = 99
        tag?.isrc = 987654321098
        tag?.length = 9767
        tag?.playlistDelay = 0
        
        tag?.audioSourceWebpage = "http://audiosource.url"
        tag?.audioFileWebpage = "http://audiofile.url"
        tag?.artistWebpage = "http://artist.url"
        tag?.copyrightWebpage = "http://copyright.url"
        tag?.publisherWebpage = "http://publisher.url"
        
        // MARK: Language Frame
        tag?.languages = [.eng]
        
        // MARK: Part Of Total frame
        tag?.trackNumber?.track = 1
        tag?.trackNumber?.totalTracks = 2
        tag?.discNumber?.disc = 3
        tag?.discNumber?.totalDiscs = 4
        
        // MARK: Preset Options Frame
        tag?.fileType?.fileType = nil
        tag?.fileType?.fileTypeRefinement = nil
        tag?.fileType?.additionalInformation = "File Type"
        tag?.genre?.presetGenre = .Audiobook
        tag?.genre?.customGenre = "Genre Type"
        tag?.mediaType?.mediaType = nil
        tag?.mediaType?.mediaTypeRefinement = nil
        tag?.mediaType?.additionalInformation = "Media Type"
        
        // MARK: Date frame
        tag?.recordingDateTime = (year: 2018, month: 10, day: 11, hour: nil, minute: nil)
        tag?.date = (month: 02, day: 03)
        tag?.time = (hour: 11, minute: 11)
        tag?.year = 2015
        tag?.originalReleaseTime = (year: 2014, month: nil, day: nil, hour: nil, minute: nil)

        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        XCTAssertNoThrow(try TestFile.noMeta.mp3File()?.write(tagVersion: .v2_2, using: tag ?? Tag(readFrom: Mp3File(location: TestFile.noMeta.url)), writingTo: outputUrl))

        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.recordingDateTime?.year, 2018)
        XCTAssertEqual(tagWritten.recordingDateTime?.month, 10)
        XCTAssertEqual(tagWritten.recordingDateTime?.day, 11)
        XCTAssertEqual(tagWritten.recordingDateTime?.hour, 0)
        XCTAssertEqual(tagWritten.recordingDateTime?.minute, 0)
        XCTAssertEqual(tagWritten.date?.month, 02)
        XCTAssertEqual(tagWritten.date?.day, 03)
        XCTAssertEqual(tagWritten.time?.hour, 11)
        XCTAssertEqual(tagWritten.time?.minute, 11)
        XCTAssertEqual(tagWritten.year, 2015)
        XCTAssertEqual(tagWritten.originalReleaseTime?.year, 2014)
        
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
        XCTAssertEqual(tagWritten.contentGroup, "Content Group")
        XCTAssertEqual(tagWritten.copyright, "2020 Copyright")
        XCTAssertEqual(tagWritten.copyrightWebpage, "http://copyright.url")
        XCTAssertEqual(tagWritten.discNumber?.disc, 3)
        XCTAssertEqual(tagWritten.discNumber?.totalDiscs, 4)
        XCTAssertEqual(tagWritten.encodedBy, "Encoded By")
        XCTAssertEqual(tagWritten.encodingSettings, "Encoding Settings")
        XCTAssertNil(tagWritten.fileType?.fileType)
        XCTAssertNil(tagWritten.fileType?.fileTypeRefinement)
        XCTAssertEqual(tagWritten.fileType?.additionalInformation, "File Type")
        XCTAssertEqual(tagWritten.genre?.presetGenre, .Audiobook)
        XCTAssertEqual(tagWritten.genre?.customGenre, "Genre Type")
        XCTAssertEqual(tagWritten.initialKey, .aFlatMinor)
        XCTAssertEqual(tagWritten.interpretedBy, "Arranger")
        XCTAssertEqual(tagWritten.isrc, 987654321098)
        XCTAssertEqual(tagWritten.label, "Publisher")
        XCTAssertEqual(tagWritten.languages, [.eng])
        XCTAssertEqual(tagWritten.length, 9767)
        XCTAssertEqual(tagWritten.lyricist, "Lyricist")
        XCTAssertNil(tagWritten.mediaType?.mediaType)
        XCTAssertNil(tagWritten.mediaType?.mediaTypeRefinement)
        XCTAssertEqual(tagWritten.mediaType?.additionalInformation, "Media Type")
        XCTAssertEqual(tagWritten.narrator, "Composer")
        XCTAssertEqual(tagWritten.narratorSort, "Composer Sort")
        XCTAssertEqual(tagWritten.originalAlbum, "Original Album")
        XCTAssertEqual(tagWritten.originalArtist, "Original Artist")
        XCTAssertEqual(tagWritten.originalFilename, "Original Filename")
        XCTAssertEqual(tagWritten.originalLyricist, "Original Lyricist")
        XCTAssertEqual(tagWritten.playlistDelay, 0)
        XCTAssertEqual(tagWritten.publisher, "Publisher")
        XCTAssertEqual(tagWritten.publisherWebpage, "http://publisher.url")
        XCTAssertEqual(tagWritten.radioStation, "Radio Station")
        XCTAssertEqual(tagWritten.radioStationOwner, "Radio Station Owner")
        XCTAssertEqual(tagWritten.recordCompany, "Publisher")
        XCTAssertEqual(tagWritten.remixer, "Arranger")
        XCTAssertEqual(tagWritten.series, "Content Group")
        XCTAssertEqual(tagWritten.studio, "Publisher")
        XCTAssertEqual(tagWritten.subtitle, "Subtitle")
        XCTAssertEqual(tagWritten.title, "Title")
        XCTAssertEqual(tagWritten.titleSort, "Title Sort")
        XCTAssertEqual(tagWritten.trackNumber?.track, 1)
        XCTAssertEqual(tagWritten.trackNumber?.totalTracks, 2)
        XCTAssertEqual(tagWritten.work, "Content Group")
    }

    // MARK: Test alternative framekeys/identifiers
    func testRemixer() throws {
        var tag = Tag()
        tag.remixer = "Remixer"
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        XCTAssertNoThrow(try TestFile.noMeta.mp3File()?.write(tagVersion: .v2_4, using: tag , writingTo: outputUrl))
        
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.remixer, "Remixer")
    }

    func testInterpetedBy() throws {
        var tag = Tag()
        tag.interpretedBy = "InterpretedBy"
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        XCTAssertNoThrow(try TestFile.noMeta.mp3File()?.write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))
        
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.interpretedBy, "InterpretedBy")
    }

    func testWork() throws {
        var tag = Tag()
        tag.work = "Work"
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        XCTAssertNoThrow(try TestFile.noMeta.mp3File()?.write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))
        
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.work, "Work")
    }

    func testSeries() throws {
        var tag = Tag()
        tag.series = "Series"
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        XCTAssertNoThrow(try TestFile.noMeta.mp3File()?.write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))
        
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.series, "Series")
    }

    func testAuthor() throws {
        var tag = Tag()
        tag.author = "Author"
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        XCTAssertNoThrow(try TestFile.noMeta.mp3File()?.write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))
        
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.author, "Author")
    }

    func testAuthorSort() throws {
        var tag = Tag()
        tag.authorSort = "SortAuthor"
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        XCTAssertNoThrow(try TestFile.noMeta.mp3File()?.write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))
        
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.authorSort, "SortAuthor")
    }

    func testNarrator() throws {
        var tag = Tag()
        tag.narrator = "Narrator"
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        XCTAssertNoThrow(try TestFile.noMeta.mp3File()?.write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))
        
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.narrator, "Narrator")
    }

    func testNarratorSort() throws {
        var tag = Tag()
        tag.narratorSort = "SortNarrator"
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        XCTAssertNoThrow(try TestFile.noMeta.mp3File()?.write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))
        
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.narratorSort, "SortNarrator")
    }

    func testLabel() throws {
        var tag = Tag()
        tag.label = "Label"
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        XCTAssertNoThrow(try TestFile.noMeta.mp3File()?.write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))
        
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.label, "Label")
    }

    func testStudio() throws {
        var tag = Tag()
        tag.studio = "Studio"
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        XCTAssertNoThrow(try TestFile.noMeta.mp3File()?.write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))
        
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.studio, "Studio")
    }

    func testRecordCompany() throws {
        var tag = Tag()
        tag.recordCompany = "RecordCompany"
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        XCTAssertNoThrow(try TestFile.noMeta.mp3File()?.write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))
        
        
        let mp3UrlWritten = outputUrl
        let mp3FileWritten = try Mp3File(location: mp3UrlWritten)
        let tagWritten = try Tag(readFrom: mp3FileWritten)
        
        XCTAssertEqual(tagWritten.recordCompany, "RecordCompany")
    }
    
    func testImageFrameWriting() throws {
        var tag = Tag()
        
        try tag.setAttachedPicture(imageType: .FrontCover, imageDescription: "Sample Cover", location: TestFile.sampleCover.url)
        try tag.setAttachedPicture(imageType: .fileIcon, imageDescription: nil, location: TestFile.sampleIcon.url)
        try tag.setAttachedPicture(imageType: .Other, imageDescription: nil, location: TestFile.sampleCover.url)
        try tag.setAttachedPicture(imageType: .ABrightColouredFish, imageDescription: nil, location: TestFile.sampleCover.url)
        try tag.setAttachedPicture(imageType: .ArtistPerformer, imageDescription: nil, location: TestFile.sampleCover.url)
        try tag.setAttachedPicture(imageType: .BackCover, imageDescription: nil, location: TestFile.sampleCover.url)
        try tag.setAttachedPicture(imageType: .BandArtistLogotype, imageDescription: nil, location: TestFile.sampleCover.url)
        try tag.setAttachedPicture(imageType: .BandOrchestra, imageDescription: nil, location: TestFile.sampleCover.url)
        try tag.setAttachedPicture(imageType: .Composer, imageDescription: nil, location: TestFile.sampleCover.url)
        try tag.setAttachedPicture(imageType: .Conductor, imageDescription: nil, location: TestFile.sampleCover.url)
        try tag.setAttachedPicture(imageType: .DuringPerformance, imageDescription: nil, location: TestFile.sampleCover.url)
        try tag.setAttachedPicture(imageType: .DuringRecording, imageDescription: nil, location: TestFile.sampleCover.url)
        try tag.setAttachedPicture(imageType: .Illustration, imageDescription: nil, location: TestFile.sampleCover.url)
        try tag.setAttachedPicture(imageType: .LeadArtistLeadPerformerSoloist, imageDescription: nil, location: TestFile.sampleCover.url)
        try tag.setAttachedPicture(imageType: .LeafletPage, imageDescription: nil, location: TestFile.sampleCover.url)
        try tag.setAttachedPicture(imageType: .LyricistTextWriter, imageDescription: nil, location: TestFile.sampleCover.url)
        try tag.setAttachedPicture(imageType: .Media, imageDescription: nil, location: TestFile.sampleCover.url)
        try tag.setAttachedPicture(imageType: .MovieVideoScreenCapture, imageDescription: nil, location: TestFile.sampleCover.url)
        try tag.setAttachedPicture(imageType: .OtherFileIcon, imageDescription: nil, location: TestFile.sampleCover.url)
        try tag.setAttachedPicture(imageType: .PublisherStudioLogotype, imageDescription: nil, location: TestFile.sampleCover.url)
        try tag.setAttachedPicture(imageType: .RecordingLocation, imageDescription: nil, location: TestFile.sampleCover.url)

        let output = try localDirectory(fileName: "mp3-with-image", fileExtension: "mp3")
        XCTAssertNoThrow(try TestFile.noMeta.mp3File()?.write(tagVersion: .v2_4, using: tag, writingTo: output))
    }
}
