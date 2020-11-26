/*

 SwiftTaggerID3_Write_Tests.swift
 SwiftTaggerID3

 Copyright ©2020 Nolaine Crusher. All rights reserved.

 */

import XCTest
import SwiftConvenienceExtensions
@testable import SwiftTaggerID3

class SwiftTaggerID3_Write_Tests: XCTestCase {
    
    // // MARK: - V24 writing test
    // Test writing, and accuracy of written data, version 2.4
    @available(OSX 10.12, iOS 10.0, *)
    func testV24Writing() throws {
        var tag = tagNoMeta

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
        tag.movement = "Movement Name"
        tag.originalAlbum = "Original Album"
        tag.originalArtist = "Original Artist"
        tag.originalFilename = "Original Filename"
        tag.originalLyricist = "Original Lyricist"
        tag.podcastID = "Podcast ID"
        tag.podcastCategory = "Podcast Category"
        tag.podcastFeed = "http://podcast.url"
        tag.podcastDescription = "Podcast Description"
        tag.podcastKeywords = ["Podcast", "Keywords"]
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
        tag.isrc = "987654321098"
        tag.movementNumber = 5
        tag.movementCount = 6
        tag.playlistDelay = 0
        
        tag.audioSourceWebpage = "http://audiosource.url"
        tag.audioFileWebpage = "http://audiofile.url"
        tag.artistWebpage = "http://artist.url"
        tag.copyrightWebpage = "http://copyright.url"
        tag.paymentWebpage = "http://payment.url"
        tag.publisherWebpage = "http://publisher.url"
        tag.radioStationWebpage = "http://radiostation.url"
        
        // MARK: - Language Frame
        tag.languages = [.english]
        
        // MARK: Part Of Total frame
        tag.trackNumber.index = 1
        tag.trackNumber.total = 2
        tag.discNumber.index = 3
        tag.discNumber.total = 4

        let outputUrl = tempOutputDirectory

//        let outputUrl = try localDirectory(fileName: "mp3-meta", fileExtension: "mp3")
        XCTAssertNoThrow(try mp3NoMeta.write(tag: &tag,
                                             version: .v2_4,
                                             outputLocation: outputUrl))
        
        
        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try Tag(mp3File: outputMp3)
        
        XCTAssertEqual(output.album, "Album")
        XCTAssertEqual(output.albumArtist, "Album Artist")
        XCTAssertEqual(output.albumArtistSort, "Album Artist Sort")
        XCTAssertEqual(output.albumSort, "Album Sort")
        XCTAssertEqual(output.arranger, "Arranger")
        XCTAssertEqual(output.artist, "Artist")
        XCTAssertEqual(output.artistSort, "Artist Sort")
        XCTAssertEqual(output.artistWebpage, "http://artist.url")
        XCTAssertEqual(output.audioFileWebpage, "http://audiofile.url")
        XCTAssertEqual(output.audioSourceWebpage, "http://audiosource.url")
        XCTAssertEqual(output.bpm, 99)
        XCTAssertEqual(output.compilation, true)
        XCTAssertEqual(output.composer, "Composer")
        XCTAssertEqual(output.composerSort, "Composer Sort")
        XCTAssertEqual(output.conductor, "Conductor")
        XCTAssertEqual(output.contentGroup, "Content Group")
        XCTAssertEqual(output.copyright, "\u{00A9}2020 Copyright")
        XCTAssertEqual(output.copyrightWebpage, "http://copyright.url")
        XCTAssertEqual(output.discNumber.index, 3)
        XCTAssertEqual(output.discNumber.total, 4)
        XCTAssertEqual(output.encodedBy, "Encoded By")
        XCTAssertEqual(output.encodingSettings, "Encoding Settings")
        XCTAssertEqual(output.fileOwner, "File Owner")
        XCTAssertEqual(output.grouping, "Grouping")
        XCTAssertEqual(output.initialKey, .aFlatMinor)
        XCTAssertEqual(output.isrc, "987654321098")
        XCTAssertEqual(output.languages, [.english])
        XCTAssertEqual(output.length, 5041)
        XCTAssertEqual(output.lyricist, "Lyricist")
        XCTAssertEqual(output.mood, "Mood")
        XCTAssertEqual(output.movement, "Movement Name")
        XCTAssertEqual(output.movementNumber, 5)
        XCTAssertEqual(output.movementCount, 6)
        XCTAssertEqual(output.originalAlbum, "Original Album")
        XCTAssertEqual(output.originalArtist, "Original Artist")
        XCTAssertEqual(output.originalFilename, "Original Filename")
        XCTAssertEqual(output.originalLyricist, "Original Lyricist")
        XCTAssertEqual(output.paymentWebpage, "http://payment.url")
        XCTAssertEqual(output.playlistDelay, 0)
        XCTAssertEqual(output.podcastCategory, "Podcast Category")
        XCTAssertEqual(output.podcastDescription, "Podcast Description")
        XCTAssertEqual(output.podcastFeed, "http://podcast.url")
        XCTAssertEqual(output.podcastID, "Podcast ID")
        XCTAssertEqual(output.podcastKeywords, ["Podcast", "Keywords"])
        XCTAssertEqual(output.producedNotice, "\u{2117}2020 Produced Notice")
        XCTAssertEqual(output.publisher, "Publisher")
        XCTAssertEqual(output.publisherWebpage, "http://publisher.url")
        XCTAssertEqual(output.radioStation, "Radio Station")
        XCTAssertEqual(output.radioStationOwner, "Radio Station Owner")
        XCTAssertEqual(output.radioStationWebpage, "http://radiostation.url")
        XCTAssertEqual(output.setSubtitle, "Set Subtitle")
        XCTAssertEqual(output.subtitle, "Subtitle")
        XCTAssertEqual(output.title, "Title")
        XCTAssertEqual(output.titleSort, "Title Sort")
        XCTAssertEqual(output.trackNumber.index, 1)
        XCTAssertEqual(output.trackNumber.total, 2)
        XCTAssertEqual(output.work, "Content Group")
    }
    
    // // MARK: - V23 writing test
    // Test writing, and accuracy of written data, version 2.3
    @available(OSX 10.12, iOS 10.0, *)
    func testV23Writing() throws {
        var tag = tagNoMeta

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
        tag.movement = "Movement Name"
        tag.originalAlbum = "Original Album"
        tag.originalArtist = "Original Artist"
        tag.originalFilename = "Original Filename"
        tag.originalLyricist = "Original Lyricist"
        tag.podcastID = "Podcast ID"
        tag.podcastCategory = "Podcast Category"
        tag.podcastFeed = "http://podcast.url"
        tag.podcastDescription = "Podcast Description"
        tag.podcastKeywords = ["Podcast", "Keywords"]
        tag.publisher = "Publisher"
        tag.radioStation = "Radio Station"
        tag.radioStationOwner = "Radio Station Owner"
        tag.subtitle = "Subtitle"
        tag.title = "Title"
        tag.titleSort = "Title Sort"
        
        tag.compilation = true
        tag.bpm = 99
        tag.isrc = "987654321098"
        tag.movementNumber = 5
        tag.movementCount = 6
        tag.playlistDelay = 0
        
        tag.audioSourceWebpage = "http://audiosource.url"
        tag.audioFileWebpage = "http://audiofile.url"
        tag.artistWebpage = "http://artist.url"
        tag.copyrightWebpage = "http://copyright.url"
        tag.paymentWebpage = "http://payment.url"
        tag.publisherWebpage = "http://publisher.url"
        tag.radioStationWebpage = "http://radiostation.url"
        
        // // MARK: - Language Frame
        tag.languages = [.english]
        
        // // MARK: - Part Of Total frame
        tag.trackNumber.index = 1
        tag.trackNumber.total = 2
        tag.discNumber.index = 3
        tag.discNumber.total = 4
                
        let outputUrl = tempOutputDirectory
        XCTAssertNoThrow(try mp3NoMeta.write(tag: &tag, version: .v2_3, outputLocation: outputUrl))

        
        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try Tag(mp3File: outputMp3)
        
        XCTAssertEqual(output.album, "Album")
        XCTAssertEqual(output.albumArtist, "Album Artist")
        XCTAssertEqual(output.albumArtistSort, "Album Artist Sort")
        XCTAssertEqual(output.albumSort, "Album Sort")
        XCTAssertEqual(output.arranger, "Arranger")
        XCTAssertEqual(output.artist, "Artist")
        XCTAssertEqual(output.artistSort, "Artist Sort")
        XCTAssertEqual(output.artistWebpage, "http://artist.url")
        XCTAssertEqual(output.audioFileWebpage, "http://audiofile.url")
        XCTAssertEqual(output.audioSourceWebpage, "http://audiosource.url")
        XCTAssertEqual(output.bpm, 99)
        XCTAssertEqual(output.compilation, true)
        XCTAssertEqual(output.composer, "Composer")
        XCTAssertEqual(output.composerSort, "Composer Sort")
        XCTAssertEqual(output.conductor, "Conductor")
        XCTAssertEqual(output.contentGroup, "Content Group")
        XCTAssertEqual(output.copyright, "\u{00A9}2020 Copyright")
        XCTAssertEqual(output.copyrightWebpage, "http://copyright.url")
        XCTAssertEqual(output.discNumber.index, 3)
        XCTAssertEqual(output.discNumber.total, 4)
        XCTAssertEqual(output.encodedBy, "Encoded By")
        XCTAssertEqual(output.encodingSettings, "Encoding Settings")
        XCTAssertEqual(output.fileOwner, "File Owner")
        XCTAssertEqual(output.grouping, "Grouping")
        XCTAssertEqual(output.initialKey, .aFlatMinor)
        XCTAssertEqual(output.isrc, "987654321098")
        XCTAssertEqual(output.languages, [.english])
        XCTAssertEqual(output.length, 5041)
        XCTAssertEqual(output.lyricist, "Lyricist")
        XCTAssertEqual(output.movement, "Movement Name")
        XCTAssertEqual(output.movementNumber, 5)
        XCTAssertEqual(output.movementCount, 6)
        XCTAssertEqual(output.originalAlbum, "Original Album")
        XCTAssertEqual(output.originalArtist, "Original Artist")
        XCTAssertEqual(output.originalFilename, "Original Filename")
        XCTAssertEqual(output.originalLyricist, "Original Lyricist")
        XCTAssertEqual(output.paymentWebpage, "http://payment.url")
        XCTAssertEqual(output.playlistDelay, 0)
        XCTAssertEqual(output.podcastCategory, "Podcast Category")
        XCTAssertEqual(output.podcastDescription, "Podcast Description")
        XCTAssertEqual(output.podcastFeed, "http://podcast.url")
        XCTAssertEqual(output.podcastID, "Podcast ID")
        XCTAssertEqual(output.podcastKeywords, ["Podcast", "Keywords"])
        XCTAssertEqual(output.publisher, "Publisher")
        XCTAssertEqual(output.publisherWebpage, "http://publisher.url")
        XCTAssertEqual(output.radioStation, "Radio Station")
        XCTAssertEqual(output.radioStationOwner, "Radio Station Owner")
        XCTAssertEqual(output.radioStationWebpage, "http://radiostation.url")
        XCTAssertEqual(output.subtitle, "Subtitle")
        XCTAssertEqual(output.title, "Title")
        XCTAssertEqual(output.titleSort, "Title Sort")
        XCTAssertEqual(output.trackNumber.index, 1)
        XCTAssertEqual(output.trackNumber.total, 2)
        XCTAssertEqual(output.work, "Content Group")
    }
    
    // Test writing, and accuracy of written data, version 2.2
    @available(OSX 10.12, iOS 10.0, *)
    func testV22Writing() throws {
        var tag = tagNoMeta

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
        tag.isrc = "987654321098"
        tag.playlistDelay = 0
        
        tag.audioSourceWebpage = "http://audiosource.url"
        tag.audioFileWebpage = "http://audiofile.url"
        tag.artistWebpage = "http://artist.url"
        tag.copyrightWebpage = "http://copyright.url"
        tag.publisherWebpage = "http://publisher.url"
        
        // // MARK: - Language Frame
        tag.languages = [.english]
        
        // // MARK: - Part Of Total frame
        tag.trackNumber.index = 1
        tag.trackNumber.total = 2
        tag.discNumber.index = 3
        tag.discNumber.total = 4
        
        let outputUrl = tempOutputDirectory
        XCTAssertNoThrow(try mp3NoMeta.write(tag: &tag, version: .v2_2, outputLocation: outputUrl))

        
        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try Tag(mp3File: outputMp3)
        
        XCTAssertEqual(output.album, "Album")
        XCTAssertEqual(output.albumArtist, "Album Artist")
        XCTAssertEqual(output.albumArtistSort, "Album Artist Sort")
        XCTAssertEqual(output.albumSort, "Album Sort")
        XCTAssertEqual(output.arranger, "Arranger")
        XCTAssertEqual(output.artist, "Artist")
        XCTAssertEqual(output.artistSort, "Artist Sort")
        XCTAssertEqual(output.artistWebpage, "http://artist.url")
        XCTAssertEqual(output.audioFileWebpage, "http://audiofile.url")
        XCTAssertEqual(output.audioSourceWebpage, "http://audiosource.url")
        XCTAssertEqual(output.bpm, 99)
        XCTAssertEqual(output.compilation, true)
        XCTAssertEqual(output.composer, "Composer")
        XCTAssertEqual(output.composerSort, "Composer Sort")
        XCTAssertEqual(output.conductor, "Conductor")
        XCTAssertEqual(output.contentGroup, "Content Group")
        XCTAssertEqual(output.copyright, "\u{00A9}2020 Copyright")
        XCTAssertEqual(output.copyrightWebpage, "http://copyright.url")
        XCTAssertEqual(output.discNumber.index, 3)
        XCTAssertEqual(output.discNumber.total, 4)
        XCTAssertEqual(output.encodedBy, "Encoded By")
        XCTAssertEqual(output.encodingSettings, "Encoding Settings")
        XCTAssertEqual(output.initialKey, .aFlatMinor)
        XCTAssertEqual(output.isrc, "987654321098")
        XCTAssertEqual(output.languages, [.english])
        XCTAssertEqual(output.length, 5041)
        XCTAssertEqual(output.lyricist, "Lyricist")
        XCTAssertEqual(output.originalAlbum, "Original Album")
        XCTAssertEqual(output.originalArtist, "Original Artist")
        XCTAssertEqual(output.originalFilename, "Original Filename")
        XCTAssertEqual(output.originalLyricist, "Original Lyricist")
        XCTAssertEqual(output.playlistDelay, 0)
        XCTAssertEqual(output.publisher, "Publisher")
        XCTAssertEqual(output.publisherWebpage, "http://publisher.url")
        XCTAssertEqual(output.radioStation, "Radio Station")
        XCTAssertEqual(output.radioStationOwner, "Radio Station Owner")
        XCTAssertEqual(output.subtitle, "Subtitle")
        XCTAssertEqual(output.title, "Title")
        XCTAssertEqual(output.titleSort, "Title Sort")
        XCTAssertEqual(output.trackNumber.index, 1)
        XCTAssertEqual(output.trackNumber.total, 2)
        XCTAssertEqual(output.work, "Content Group")
    }

    @available(OSX 10.12, iOS 10.0, *)
    func testWork() throws {
        var tag = Tag(version: .v2_4)
        tag.work = "Work"
        
        let outputUrl = tempOutputDirectory
        XCTAssertNoThrow(try mp3NoMeta.write(tag: &tag, version: .v2_4, outputLocation: outputUrl))
        
        
        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try Tag(mp3File: outputMp3)
        
        XCTAssertEqual(output.work, "Work")
    }
    
    @available(OSX 10.12, iOS 10.0, *)
    func testImageFrameWriting() throws {
        var tag = Tag(version: .v2_4)
        
        try tag.set(attachedPicture: .frontCover, imageLocation: sampleCover, description: nil)
        try tag.set(attachedPicture: .fileIcon, imageLocation: sampleIcon, description: nil)
        try tag.set(attachedPicture: .other, imageLocation: sampleCover, description: nil)
        try tag.set(attachedPicture: .aBrightColouredFish, imageLocation: sampleCover, description: nil)
        try tag.set(attachedPicture: .artistPerformer, imageLocation: sampleCover, description: nil)
        try tag.set(attachedPicture: .backCover, imageLocation: sampleCover, description: nil)
        try tag.set(attachedPicture: .bandArtistLogotype, imageLocation: sampleCover, description: nil)
        try tag.set(attachedPicture: .bandOrchestra, imageLocation: sampleCover, description: nil)
        try tag.set(attachedPicture: .composer, imageLocation: sampleCover, description: nil)
        try tag.set(attachedPicture: .conductor, imageLocation: sampleCover, description: nil)
        try tag.set(attachedPicture: .duringPerformance, imageLocation: sampleCover, description: nil)
        try tag.set(attachedPicture: .duringRecording, imageLocation: sampleCover, description: nil)
        try tag.set(attachedPicture: .illustration, imageLocation: sampleCover, description: nil)
        try tag.set(attachedPicture: .leadArtistLeadPerformerSoloist, imageLocation: sampleCover, description: nil)
        try tag.set(attachedPicture: .leafletPage, imageLocation: sampleCover, description: nil)
        try tag.set(attachedPicture: .lyricistTextWriter, imageLocation: sampleCover, description: nil)
        try tag.set(attachedPicture: .media, imageLocation: sampleCover, description: nil)
        try tag.set(attachedPicture: .movieVideoScreenCapture, imageLocation: sampleCover, description: nil)
        try tag.set(attachedPicture: .otherFileIcon, imageLocation: sampleIcon, description: nil)
        try tag.set(attachedPicture: .publisherStudioLogotype, imageLocation: sampleCover, description: nil)
        try tag.set(attachedPicture: .recordingLocation, imageLocation: sampleCover, description: nil)

//        let outputUrl = try localOutputDirectory("imageTest")
        let outputUrl = tempOutputDirectory
        XCTAssertNoThrow(try mp3NoMeta.write(tag: &tag, version: .v2_4, outputLocation: outputUrl))
        
        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try Tag(mp3File: outputMp3)
        XCTAssertNotNil(output[attachedPicture: .aBrightColouredFish])
        XCTAssertNotNil(output[attachedPicture: .artistPerformer])
        XCTAssertNotNil(output[attachedPicture: .backCover])
        XCTAssertNotNil(output[attachedPicture: .bandArtistLogotype])
        XCTAssertNotNil(output[attachedPicture: .bandOrchestra])
        XCTAssertNotNil(output[attachedPicture: .composer])
        XCTAssertNotNil(output[attachedPicture: .conductor])
        XCTAssertNotNil(output[attachedPicture: .duringPerformance])
        XCTAssertNotNil(output[attachedPicture: .duringRecording])
        XCTAssertNotNil(output[attachedPicture: .fileIcon])
        XCTAssertNotNil(output[attachedPicture: .frontCover])
        XCTAssertNotNil(output[attachedPicture: .illustration])
        XCTAssertNotNil(output[attachedPicture: .leadArtistLeadPerformerSoloist])
        XCTAssertNotNil(output[attachedPicture: .leafletPage])
        XCTAssertNotNil(output[attachedPicture: .lyricistTextWriter])
        XCTAssertNotNil(output[attachedPicture: .movieVideoScreenCapture])
        XCTAssertNotNil(output[attachedPicture: .media])
        XCTAssertNotNil(output[attachedPicture: .other])
        XCTAssertNotNil(output[attachedPicture: .otherFileIcon])
        XCTAssertNotNil(output[attachedPicture: .publisherStudioLogotype])
        XCTAssertNotNil(output[attachedPicture: .recordingLocation])
    }
    
    @available(OSX 10.12, iOS 10.0, *)
    func testUnknownFramePassThrough() throws {
        var tag = tagUnknown
        let count = tag.frames.count
        tag.album = "Test"

        // let outputUrl = try localOutputDirectory("unknownTest")
        let outputUrl = tempOutputDirectory
        XCTAssertNoThrow(try mp3NoMeta.write(tag: &tag,
                                             version: .v2_4,
                                             outputLocation: outputUrl))

        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try Tag(mp3File: outputMp3)
        // NOTE: The real test here is to output the file to a local directory and check the unknown frames out in whatever app they originated from to see if they're intact.
        XCTAssertEqual(output.album, "Test")
        XCTAssertEqual(output.frames.count, count + 1)
    }

    @available(OSX 10.12, iOS 10.0, *)
    func testAll() throws {
        var tag = Tag(version: .v2_4)
        
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
        tag.movement = "Movement Name"
        tag.originalAlbum = "Original Album"
        tag.originalArtist = "Original Artist"
        tag.originalFilename = "Original Filename"
        tag.originalLyricist = "Original Lyricist"
        tag.podcastID = "Podcast ID"
        tag.podcastCategory = "Podcast Category"
        tag.podcastFeed = "http://podcast.url"
        tag.podcastDescription = "Podcast Description"
        tag.podcastKeywords = ["Podcast", "Keywords"]
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
        tag.isrc = "987654321098"
        tag.movementNumber = 5
        tag.movementCount = 6
        tag.playlistDelay = 0
        
        tag.audioSourceWebpage = "http://audiosource.url"
        tag.audioFileWebpage = "http://audiofile.url"
        tag.artistWebpage = "http://artist.url"
        tag.copyrightWebpage = "http://copyright.url"
        tag.paymentWebpage = "http://payment.url"
        tag.publisherWebpage = "http://publisher.url"
        tag.radioStationWebpage = "http://radiostation.url"
        
        tag.languages = [.english]
        
        tag.trackNumber.index = 1
        tag.trackNumber.total = 2
        tag.discNumber.index = 3
        tag.discNumber.total = 4

        tag.addInvolvementCredit(role: .director, person: "Director Name")
        tag.addInvolvementCredit(role: .producer, person: "Producer Name")
        tag.addMusicianCredit(role: .soprano, person: "Soprano Name")
        tag.addMusicianCredit(role: .alto, person: "Alto Name")

        tag.encodingDateTime = testAllDate
        tag.taggingDateTime = testAllDate
        tag.releaseDateTime = testAllDate
        tag.originalRelease = testAllDate
        tag.recordingDateTime = testAllDate
        
        tag[comment: "Comment", .eng] = "Comment Content"
        tag[lyrics: "Lyrics", .eng] = "Lyrics Content"
        tag[userDefinedUrl: "UserURL"] = "http://userdefined.url"
        tag["UserText"] = "User Text Content"

        tag.discNumber.index = 4
        tag.discNumber.total = 5
        tag.trackNumber.index = 6
        tag.trackNumber.total = 7

        tag.genre.genreCategory = .Blues
        tag.genre.genre = "Blues Refinement"
        
        tag.mediaType.mediaType = .otherDigital
        tag.mediaType.mediaTypeRefinement = .analogTransfer
        tag.mediaType.additionalInformation = "Additional Information"
        
        tag.fileType.fileType = .MPG
        tag.fileType.fileTypeRefinement = .mpegLayerIII
        tag.fileType.additionalInformation = "Additional Information"

        tag.addChapter(startTime: 0, title: "Chapter 01")
        tag.addChapter(startTime: 900, title: "Chapter 02")
        tag.addChapter(startTime: 1950, title: "Chapter 03")
        tag.addChapter(startTime: 3120, title: "Chapter 04")
        tag.addChapter(startTime: 4230, title: "Chapter 05")

        let outputUrl = localOutputDirectory("testAll")
//        let outputUrl = tempOutputDirectory
        XCTAssertNoThrow(try mp3NoMeta.write(tag: &tag, version: .v2_4, outputLocation: outputUrl))
        
        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try Tag(mp3File: outputMp3)
        
        XCTAssertEqual(output.album, "Album")
        XCTAssertEqual(output.albumArtist, "Album Artist")
        XCTAssertEqual(output.albumSort, "Album Sort")
        XCTAssertEqual(output.albumArtistSort, "Album Artist Sort")
        XCTAssertEqual(output.arranger, "Arranger")
        XCTAssertEqual(output.artist, "Artist")
        XCTAssertEqual(output.artistSort, "Artist Sort")
        XCTAssertEqual(output.composer, "Composer")
        XCTAssertEqual(output.composerSort, "Composer Sort")
        XCTAssertEqual(output.conductor, "Conductor")
        XCTAssertEqual(output.contentGroup, "Content Group")
        XCTAssertEqual(output.copyright, "\u{00A9}2020 Copyright")
        XCTAssertEqual(output.encodedBy, "Encoded By")
        XCTAssertEqual(output.encodingSettings, "Encoding Settings")
        XCTAssertEqual(output.fileOwner, "File Owner")
        XCTAssertEqual(output.grouping, "Grouping")
        XCTAssertEqual(output.initialKey, .aFlatMinor)
        XCTAssertEqual(output.lyricist, "Lyricist")
        XCTAssertEqual(output.mood, "Mood")
        XCTAssertEqual(output.movement, "Movement Name")
        XCTAssertEqual(output.originalAlbum, "Original Album")
        XCTAssertEqual(output.originalArtist, "Original Artist")
        XCTAssertEqual(output.originalFilename, "Original Filename")
        XCTAssertEqual(output.originalLyricist, "Original Lyricist")
        XCTAssertEqual(output.podcastID, "Podcast ID")
        XCTAssertEqual(output.podcastCategory, "Podcast Category")
        XCTAssertEqual(output.podcastFeed, "http://podcast.url")
        XCTAssertEqual(output.podcastDescription, "Podcast Description")
        XCTAssertEqual(output.podcastKeywords, ["Podcast", "Keywords"])
        XCTAssertEqual(output.publisher, "Publisher")
        XCTAssertEqual(output.producedNotice, "\u{2117}2020 Produced Notice")
        XCTAssertEqual(output.radioStation, "Radio Station")
        XCTAssertEqual(output.radioStationOwner, "Radio Station Owner")
        XCTAssertEqual(output.subtitle, "Subtitle")
        XCTAssertEqual(output.setSubtitle, "Set Subtitle")
        XCTAssertEqual(output.title, "Title")
        XCTAssertEqual(output.titleSort, "Title Sort")
        
        XCTAssertEqual(output.compilation, true)
        XCTAssertEqual(output.bpm, 99)
        XCTAssertEqual(output.isrc, "987654321098")
        XCTAssertEqual(output.movementNumber, 5)
        XCTAssertEqual(output.movementCount, 6)
        XCTAssertEqual(output.playlistDelay, 0)
        
        XCTAssertEqual(output.audioSourceWebpage, "http://audiosource.url")
        XCTAssertEqual(output.audioFileWebpage, "http://audiofile.url")
        XCTAssertEqual(output.artistWebpage, "http://artist.url")
        XCTAssertEqual(output.copyrightWebpage, "http://copyright.url")
        XCTAssertEqual(output.paymentWebpage, "http://payment.url")
        XCTAssertEqual(output.publisherWebpage, "http://publisher.url")
        XCTAssertEqual(output.radioStationWebpage, "http://radiostation.url")
        
        XCTAssertEqual(output.languages, [.english])
        
        XCTAssertEqual(output.trackNumber.index, 6)
        XCTAssertEqual(output.trackNumber.total, 7)
        XCTAssertEqual(output.discNumber.index, 4)
        XCTAssertEqual(output.discNumber.total, 5)
        
        XCTAssertEqual(output.involvementCreditsList[.director], ["Director Name"])
        XCTAssertEqual(output.involvementCreditsList[.producer], ["Producer Name"])
        XCTAssertEqual(output.musicianCreditsList[.soprano], ["Soprano Name"])
        XCTAssertEqual(output.musicianCreditsList[.alto], ["Alto Name"])
        XCTAssertEqual(output.encodingDateTime, testAllDate)
        XCTAssertEqual(output.taggingDateTime, testAllDate)
        XCTAssertEqual(output.releaseDateTime, testAllDate)
        XCTAssertEqual(output.originalRelease, testAllDate)
        XCTAssertEqual(output.recordingDateTime, testAllDate)
        
        XCTAssertEqual(output[comment: "Comment", .eng], "Comment Content")
        XCTAssertEqual(output[lyrics: "Lyrics", .eng], "Lyrics Content")
        XCTAssertEqual(output[userDefinedUrl: "UserURL"], "http://userdefined.url")
        XCTAssertEqual(output["UserText"], "User Text Content")
        
        XCTAssertEqual(output.discNumber.index, 4)
        XCTAssertEqual(output.discNumber.total, 5)
        XCTAssertEqual(output.trackNumber.index, 6)
        XCTAssertEqual(output.trackNumber.total, 7)
        
        XCTAssertEqual(output.genre.genreCategory, .Blues)
        XCTAssertEqual(output.genre.genre, "Blues Refinement")
        
        XCTAssertEqual(output.mediaType.mediaType, .otherDigital)
        XCTAssertEqual(output.mediaType.mediaTypeRefinement, .analogTransfer)
        XCTAssertEqual(output.mediaType.additionalInformation, "Additional Information")
        
        XCTAssertEqual(output.fileType.fileType, .MPG)
        XCTAssertEqual(output.fileType.fileTypeRefinement, .mpegLayerIII)
        XCTAssertEqual(output.fileType.additionalInformation, "Additional Information")
        
        let chapter1 = output.chapterList[0]
        let chapter2 = output.chapterList[1]
        let chapter3 = output.chapterList[2]
        let chapter4 = output.chapterList[3]
        let chapter5 = output.chapterList[4]
        XCTAssertEqual(chapter1.startTime, 0)
        XCTAssertEqual(chapter2.startTime, 900)
        XCTAssertEqual(chapter3.startTime, 1950)
        XCTAssertEqual(chapter4.startTime, 3120)
        XCTAssertEqual(chapter5.startTime, 4230)
        XCTAssertEqual(chapter1.title, "Chapter 01")
        XCTAssertEqual(chapter2.title, "Chapter 02")
        XCTAssertEqual(chapter3.title, "Chapter 03")
        XCTAssertEqual(chapter4.title, "Chapter 04")
        XCTAssertEqual(chapter5.title, "Chapter 05")

    }
    
    @available(OSX 10.12, iOS 10.0, *)
    func testRemoveAllMetadata() throws {
        var tag = tagV24
        tag.removeAllMetadata()
        XCTAssertTrue(tag.frames.isEmpty)
        
        let outputUrl = tempOutputDirectory
        // let outputUrl = try localOutputDirectory("tagRemovalTest")
        try mp3V24.write(tag: &tag, version: .v2_4, outputLocation: outputUrl)
        
        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try Tag(mp3File: outputMp3)
        XCTAssertTrue(output.frames.isEmpty)
    }
}
