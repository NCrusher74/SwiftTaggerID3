/*

 SwiftTaggerID3_Write_Tests.swift
 SwiftTaggerID3

 Copyright ©2020 Nolaine Crusher. All rights reserved.

 */

import XCTest
import SwiftTaggerID3



class SwiftTaggerID3_Write_Tests: XCTestCase {
    
    // // MARK: - V24 writing test
    // Test writing, and accuracy of written data, version 2.4
    @available(OSX 10.12, *)
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
        
        // // MARK: - Language Frame
        tag?.languages = [.eng]
        
        // // MARK: - Part Of Total frame
        tag?.trackNumber?.track = 1
        tag?.trackNumber?.totalTracks = 2
        tag?.discNumber?.disc = 3
        tag?.discNumber?.totalDiscs = 4

        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")

//        let outputUrl = try localDirectory(fileName: "mp3-meta", fileExtension: "mp3")
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
        XCTAssertEqual(tagWritten.encodingSettings, "Encoding Settings")
        XCTAssertEqual(tagWritten.fileOwner, "File Owner")
        XCTAssertEqual(tagWritten.grouping, "Grouping")
        XCTAssertEqual(tagWritten.initialKey, .aFlatMinor)
        XCTAssertEqual(tagWritten.interpretedBy, "Arranger")
        XCTAssertEqual(tagWritten.isrc, 987654321098)
        XCTAssertEqual(tagWritten.label, "Publisher")
        XCTAssertEqual(tagWritten.languages, [.eng])
        XCTAssertEqual(tagWritten.length, 9767)
        XCTAssertEqual(tagWritten.lyricist, "Lyricist")
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
        XCTAssertEqual(tagWritten.remixer, "Arranger")
        XCTAssertEqual(tagWritten.series, "Content Group")
        XCTAssertEqual(tagWritten.setSubtitle, "Set Subtitle")
        XCTAssertEqual(tagWritten.studio, "Publisher")
        XCTAssertEqual(tagWritten.subtitle, "Subtitle")
        XCTAssertEqual(tagWritten.title, "Title")
        XCTAssertEqual(tagWritten.titleSort, "Title Sort")
        XCTAssertEqual(tagWritten.trackNumber?.track, 1)
        XCTAssertEqual(tagWritten.trackNumber?.totalTracks, 2)
        XCTAssertEqual(tagWritten.work, "Content Group")        
    }
    
    // // MARK: - V23 writing test
    // Test writing, and accuracy of written data, version 2.3
    @available(OSX 10.12, *)
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
        
        // // MARK: - Language Frame
        tag?.languages = [.eng]
        
        // // MARK: - Part Of Total frame
        tag?.trackNumber?.track = 1
        tag?.trackNumber?.totalTracks = 2
        tag?.discNumber?.disc = 3
        tag?.discNumber?.totalDiscs = 4
                
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        XCTAssertNoThrow(try TestFile.noMeta.mp3File()?.write(tagVersion: .v2_3, using: tag ?? Tag(readFrom: Mp3File(location: TestFile.v23.url)), writingTo: outputUrl))

        
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
        XCTAssertEqual(tagWritten.encodingSettings, "Encoding Settings")
        XCTAssertEqual(tagWritten.fileOwner, "File Owner")
        XCTAssertEqual(tagWritten.grouping, "Grouping")
        XCTAssertEqual(tagWritten.initialKey, .aFlatMinor)
        XCTAssertEqual(tagWritten.interpretedBy, "Arranger")
        XCTAssertEqual(tagWritten.isrc, 987654321098)
        XCTAssertEqual(tagWritten.label, "Publisher")
        XCTAssertEqual(tagWritten.languages, [.eng])
        XCTAssertEqual(tagWritten.length, 9767)
        XCTAssertEqual(tagWritten.lyricist, "Lyricist")
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
    @available(OSX 10.12, *)
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
        
        // // MARK: - Language Frame
        tag?.languages = [.eng]
        
        // // MARK: - Part Of Total frame
        tag?.trackNumber?.track = 1
        tag?.trackNumber?.totalTracks = 2
        tag?.discNumber?.disc = 3
        tag?.discNumber?.totalDiscs = 4
        
        let outputUrl = try tempDirectory().appendingPathComponent("test.mp3")
        XCTAssertNoThrow(try TestFile.noMeta.mp3File()?.write(tagVersion: .v2_2, using: tag ?? Tag(readFrom: Mp3File(location: TestFile.noMeta.url)), writingTo: outputUrl))

        
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
        XCTAssertEqual(tagWritten.encodingSettings, "Encoding Settings")
        XCTAssertEqual(tagWritten.initialKey, .aFlatMinor)
        XCTAssertEqual(tagWritten.interpretedBy, "Arranger")
        XCTAssertEqual(tagWritten.isrc, 987654321098)
        XCTAssertEqual(tagWritten.label, "Publisher")
        XCTAssertEqual(tagWritten.languages, [.eng])
        XCTAssertEqual(tagWritten.length, 9767)
        XCTAssertEqual(tagWritten.lyricist, "Lyricist")
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

    // // MARK: - Test alternative framekeys/identifiers
    @available(OSX 10.12, *)
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

    @available(OSX 10.12, *)
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

    @available(OSX 10.12, *)
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

    @available(OSX 10.12, *)
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

    @available(OSX 10.12, *)
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

    @available(OSX 10.12, *)
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

    @available(OSX 10.12, *)
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

    @available(OSX 10.12, *)
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

    @available(OSX 10.12, *)
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

    @available(OSX 10.12, *)
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

    @available(OSX 10.12, *)
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
    
    @available(OSX 10.12, *)
    func testImageFrameWriting() throws {
        var tag = Tag()
        
        try tag.set(imageType: .FrontCover, imageDescription: "Sample Cover", location: TestFile.sampleCover.url)
        try tag.set(imageType: .fileIcon, imageDescription: nil, location: TestFile.sampleIcon.url)
        try tag.set(imageType: .Other, imageDescription: nil, location: TestFile.sampleCover.url)
        try tag.set(imageType: .ABrightColouredFish, imageDescription: nil, location: TestFile.sampleCover.url)
        try tag.set(imageType: .ArtistPerformer, imageDescription: nil, location: TestFile.sampleCover.url)
        try tag.set(imageType: .BackCover, imageDescription: nil, location: TestFile.sampleCover.url)
        try tag.set(imageType: .BandArtistLogotype, imageDescription: nil, location: TestFile.sampleCover.url)
        try tag.set(imageType: .BandOrchestra, imageDescription: nil, location: TestFile.sampleCover.url)
        try tag.set(imageType: .Composer, imageDescription: nil, location: TestFile.sampleCover.url)
        try tag.set(imageType: .Conductor, imageDescription: nil, location: TestFile.sampleCover.url)
        try tag.set(imageType: .DuringPerformance, imageDescription: nil, location: TestFile.sampleCover.url)
        try tag.set(imageType: .DuringRecording, imageDescription: nil, location: TestFile.sampleCover.url)
        try tag.set(imageType: .Illustration, imageDescription: nil, location: TestFile.sampleCover.url)
        try tag.set(imageType: .LeadArtistLeadPerformerSoloist, imageDescription: nil, location: TestFile.sampleCover.url)
        try tag.set(imageType: .LeafletPage, imageDescription: nil, location: TestFile.sampleCover.url)
        try tag.set(imageType: .LyricistTextWriter, imageDescription: nil, location: TestFile.sampleCover.url)
        try tag.set(imageType: .Media, imageDescription: nil, location: TestFile.sampleCover.url)
        try tag.set(imageType: .MovieVideoScreenCapture, imageDescription: nil, location: TestFile.sampleCover.url)
        try tag.set(imageType: .OtherFileIcon, imageDescription: nil, location: TestFile.sampleCover.url)
        try tag.set(imageType: .PublisherStudioLogotype, imageDescription: nil, location: TestFile.sampleCover.url)
        try tag.set(imageType: .RecordingLocation, imageDescription: nil, location: TestFile.sampleCover.url)

        let output = try tempDirectory().appendingPathComponent("test.mp3")
        XCTAssertNoThrow(try TestFile.noMeta.mp3File()?.write(tagVersion: .v2_4, using: tag, writingTo: output))
    }
    
    @available(OSX 10.12, *)
    func testUnknownFramePassThrough() throws {
        var tag = try TestFile.unknown.tag()
        
        tag?.album = "Test"
                
        let output = try tempDirectory().appendingPathComponent("test.mp3")
        XCTAssertNoThrow(try TestFile.noMeta.mp3File()?.write(tagVersion: .v2_4, using: tag!, writingTo: output))

        let fileWritten = try Mp3File(location: output)
        let tagWritten = try Tag(readFrom: fileWritten)

        // NOTE: The real test here is to output the file to a local directory and check the unknown frames out in whatever app they originated from to see if they're intact.
        XCTAssertEqual(tagWritten.album, "Test")
    }

    @available(OSX 10.12, *)
    func testAll() throws {
        var tag = Tag()
        
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
        
        tag.languages = [.eng]
        
        tag.trackNumber?.track = 1
        tag.trackNumber?.totalTracks = 2
        tag.discNumber?.disc = 3
        tag.discNumber?.totalDiscs = 4

        tag.addInvolvedPersonCredit(role: .actor, person: "Actor Name")
        tag.addInvolvedPersonCredit(role: .actress, person: "Actress Name")
        tag.addMusicianCredit(role: .soprano, person: "Soprano Name")
        tag.addMusicianCredit(role: .alto, person: "Alto Name")

        tag.encodingDateTime?.year = 2002
        tag.encodingDateTime?.month = 11
        tag.encodingDateTime?.day = 7
        tag.encodingDateTime?.hour = 9
        tag.encodingDateTime?.minute = 23

        tag.taggingDateTime?.year = 2002
        tag.taggingDateTime?.month = 11
        tag.taggingDateTime?.day = 7
        tag.taggingDateTime?.hour = 9
        tag.taggingDateTime?.minute = 23

        tag.releaseDateTime?.year = 2002
        tag.releaseDateTime?.month = 11
        tag.releaseDateTime?.day = 7
        tag.releaseDateTime?.hour = 9
        tag.releaseDateTime?.minute = 23
        
        tag.originalReleaseTime?.year = 2002
        tag.originalReleaseTime?.month = 11
        tag.originalReleaseTime?.day = 7
        tag.originalReleaseTime?.hour = 9
        tag.originalReleaseTime?.minute = 23

        tag.recordingDateTime?.year = 2002
        tag.recordingDateTime?.month = 11
        tag.recordingDateTime?.day = 7
        tag.recordingDateTime?.hour = 9
        tag.recordingDateTime?.minute = 23

        tag[comments: .eng, "Comment"] = "Comment Content"
        tag[comments: .eng, "Description"] = "Description"
        tag[comments: .eng, "Long Description"] = "Long Description"
        tag[comments: .eng, "Series Description"] = "Series Description"
        tag[comments: .eng, "Song Description"] = "Song Description"
        tag[comments: .eng, "Liner Notes"] = "Liner Notes"
        tag[lyrics: .eng, "Lyrics"] = "Lyrics Content"
        tag[userDefinedUrl: "UserURL"] = "http://userdefined.url"
        tag[userDefinedText: "UserText"] = "User Text Content"
        tag[userDefinedText: "Acknowledgment"] = "Acknowledgment"
        tag[userDefinedText: "Thanks"] = "Thanks"
        tag[userDefinedText: "Source Credit"] = "Source Credit"

        tag.discNumber?.disc = 4
        tag.discNumber?.totalDiscs = 5
        tag.trackNumber?.track = 6
        tag.trackNumber?.totalTracks = 7

        tag.genre?.presetGenre = .Blues
        tag.genre?.customGenre = "Blues Refinement"
        
        tag.mediaType?.mediaType = .otherDigital
        tag.mediaType?.mediaTypeRefinement = .analogTransfer
        tag.mediaType?.additionalInformation = "Additional Information"
        
        tag.fileType?.fileType = .MPG
        tag.fileType?.fileTypeRefinement = .mpegLayerIII
        tag.fileType?.additionalInformation = "Additional Information"

        let outputUrl = try localDirectory(fileName: "mp3-meta", fileExtension: "mp3")
        XCTAssertNoThrow(try TestFile.noMeta.mp3File()?.write(tagVersion: .v2_4, using: tag, writingTo: outputUrl))        
    }
}
