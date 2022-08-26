//
//  File.swift
//
//
//  Created by Nolaine Crusher on 9/19/20.
//

import Foundation

import XCTest
@testable import SwiftTaggerID3

// Tests for chapter frame and CTOC frame
class SwiftTaggerID3_Misc_Tests: XCTestCase {

    let testString = "Trên Tình Bạn Dưới Tình Yêu"
    
    func testV24() throws {
        var tag = tagNoMeta
        
        tag.album = testString
        tag.albumArtist = testString
        tag.albumSort = testString
        tag.albumArtistSort = testString
        tag.arranger = testString
        tag.artist = testString
        tag.artistSort = testString
        tag.composer = testString
        tag.composerSort = testString
        tag.conductor = testString
        tag.contentGroup = testString
        tag.encodedBy = testString
        tag.encodingSettings = testString
        tag.fileOwner = testString
        tag.grouping = testString
        tag.lyricist = testString
        tag.mood = testString
        tag.movement = testString
        tag.originalAlbum = testString
        tag.originalArtist = testString
        tag.originalFilename = testString
        tag.originalLyricist = testString
        tag.podcastID = testString
        tag.podcastFeed = testString
        tag.podcastCategory = testString
        tag.podcastDescription = testString
        tag.podcastKeywords = [testString]
        tag.publisher = testString
        tag.radioStation = testString
        tag.radioStationOwner = testString
        tag.subtitle = testString
        tag.setSubtitle = testString
        tag.title = testString
        tag.titleSort = testString
        
        let outputUrl = tempOutputDirectory
//        let outputUrl = localOutputDirectory
        XCTAssertNoThrow(try mp3NoMeta.write(tag: &tag,
                                             version: .v2_4,
                                             outputLocation: outputUrl))
        
        
        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try Tag(mp3File: outputMp3)
        
        XCTAssertEqual(output.album, testString)
        XCTAssertEqual(output.albumArtist, testString)
        XCTAssertEqual(output.albumArtistSort, testString)
        XCTAssertEqual(output.albumSort, testString)
        XCTAssertEqual(output.arranger, testString)
        XCTAssertEqual(output.artist, testString)
        XCTAssertEqual(output.artistSort, testString)
        XCTAssertEqual(output.composer, testString)
        XCTAssertEqual(output.composerSort, testString)
        XCTAssertEqual(output.conductor, testString)
        XCTAssertEqual(output.contentGroup, testString)
        XCTAssertEqual(output.encodedBy, testString)
        XCTAssertEqual(output.encodingSettings, testString)
        XCTAssertEqual(output.fileOwner, testString)
        XCTAssertEqual(output.grouping, testString)
        XCTAssertEqual(output.lyricist, testString)
        XCTAssertEqual(output.mood, testString)
        XCTAssertEqual(output.movement, testString)
        XCTAssertEqual(output.originalAlbum, testString)
        XCTAssertEqual(output.originalArtist, testString)
        XCTAssertEqual(output.originalFilename, testString)
        XCTAssertEqual(output.originalLyricist, testString)
        XCTAssertEqual(output.podcastCategory, testString)
        XCTAssertEqual(output.podcastDescription, testString)
        XCTAssertEqual(output.podcastFeed, testString)
        XCTAssertEqual(output.podcastID, testString)
        XCTAssertEqual(output.podcastKeywords, [testString])
        XCTAssertEqual(output.publisher, testString)
        XCTAssertEqual(output.radioStation, testString)
        XCTAssertEqual(output.radioStationOwner, testString)
        XCTAssertEqual(output.setSubtitle, testString)
        XCTAssertEqual(output.subtitle, testString)
        XCTAssertEqual(output.title, testString)
        XCTAssertEqual(output.titleSort, testString)
        XCTAssertEqual(output.work, testString)
    }
    
    func testLocalizedFrame() throws {
        var tag = tagNoMeta

        tag[comment: testString, .eng] = testString
        tag[lyrics: testString, .eng] = testString
        tag[testString] = testString

        let outputUrl = tempOutputDirectory
//        let outputUrl = localOutputDirectory
        XCTAssertNoThrow(try mp3NoMeta.write(tag: &tag,
                                             version: .v2_4,
                                             outputLocation: outputUrl))
        
        
        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try Tag(mp3File: outputMp3)

        XCTAssertEqual(output[comment: testString, .eng], testString)
        XCTAssertEqual(output[lyrics: testString, .eng], testString)
        XCTAssertEqual(output[testString], testString)
    }
    
    func testV23Writing() throws {
        var tag = tagNoMeta
        
        tag.album = testString
        tag.albumArtist = testString
        tag.albumSort = testString
        tag.albumArtistSort = testString
        tag.arranger = testString
        tag.artist = testString
        tag.artistSort = testString
        tag.composer = testString
        tag.composerSort = testString
        tag.conductor = testString
        tag.contentGroup = testString
        tag.encodedBy = testString
        tag.encodingSettings = testString
        tag.fileOwner = testString
        tag.grouping = testString
        tag.lyricist = testString
        tag.movement = testString
        tag.originalAlbum = testString
        tag.originalArtist = testString
        tag.originalFilename = testString
        tag.originalLyricist = testString
        tag.podcastID = testString
        tag.podcastCategory = testString
        tag.podcastFeed = testString
        tag.podcastDescription = testString
        tag.podcastKeywords = [testString, testString]
        tag.publisher = testString
        tag.radioStation = testString
        tag.radioStationOwner = testString
        tag.subtitle = testString
        tag.title = testString
        tag.titleSort = testString
                
        let outputUrl = tempOutputDirectory
//        let outputUrl = localOutputDirectory
        XCTAssertNoThrow(try mp3NoMeta.write(tag: &tag, version: .v2_3, outputLocation: outputUrl))
        
        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try Tag(mp3File: outputMp3)
        
        XCTAssertEqual(output.album, testString)
        XCTAssertEqual(output.albumArtist, testString)
        XCTAssertEqual(output.albumArtistSort, testString)
        XCTAssertEqual(output.albumSort, testString)
        XCTAssertEqual(output.arranger, testString)
        XCTAssertEqual(output.artist, testString)
        XCTAssertEqual(output.artistSort, testString)
        XCTAssertEqual(output.composer, testString)
        XCTAssertEqual(output.composerSort, testString)
        XCTAssertEqual(output.conductor, testString)
        XCTAssertEqual(output.contentGroup, testString)
        XCTAssertEqual(output.encodedBy, testString)
        XCTAssertEqual(output.encodingSettings, testString)
        XCTAssertEqual(output.fileOwner, testString)
        XCTAssertEqual(output.grouping, testString)
        XCTAssertEqual(output.lyricist, testString)
        XCTAssertEqual(output.movement, testString)
        XCTAssertEqual(output.originalAlbum, testString)
        XCTAssertEqual(output.originalArtist, testString)
        XCTAssertEqual(output.originalFilename, testString)
        XCTAssertEqual(output.originalLyricist, testString)
        XCTAssertEqual(output.podcastCategory, testString)
        XCTAssertEqual(output.podcastDescription, testString)
        XCTAssertEqual(output.podcastFeed, testString)
        XCTAssertEqual(output.podcastID, testString)
        XCTAssertEqual(output.podcastKeywords, [testString, testString])
        XCTAssertEqual(output.publisher, testString)
        XCTAssertEqual(output.radioStation, testString)
        XCTAssertEqual(output.radioStationOwner, testString)
        XCTAssertEqual(output.subtitle, testString)
        XCTAssertEqual(output.title, testString)
        XCTAssertEqual(output.titleSort, testString)
        XCTAssertEqual(output.work, testString)
    }
    
    // Test writing, and accuracy of written data, version 2.2
    func testV22Writing() throws {
        var tag = tagNoMeta
        
        tag.album = testString
        tag.albumArtist = testString
        tag.albumSort = testString
        tag.albumArtistSort = testString
        tag.arranger = testString
        tag.artist = testString
        tag.artistSort = testString
        tag.composer = testString
        tag.composerSort = testString
        tag.conductor = testString
        tag.contentGroup = testString
        tag.encodedBy = testString
        tag.encodingSettings = testString
        tag.lyricist = testString
        tag.originalAlbum = testString
        tag.originalArtist = testString
        tag.originalFilename = testString
        tag.originalLyricist = testString
        tag.publisher = testString
        tag.radioStation = testString
        tag.radioStationOwner = testString
        tag.subtitle = testString
        tag.title = testString
        tag.titleSort = testString
        
        let outputUrl = tempOutputDirectory
//        let outputUrl = localOutputDirectory
        XCTAssertNoThrow(try mp3NoMeta.write(tag: &tag, version: .v2_2, outputLocation: outputUrl))
        
        let outputMp3 = try Mp3File(location: outputUrl)
        let output = try Tag(mp3File: outputMp3)
        
        XCTAssertEqual(output.album, testString)
        XCTAssertEqual(output.albumArtist, testString)
        XCTAssertEqual(output.albumArtistSort, testString)
        XCTAssertEqual(output.albumSort, testString)
        XCTAssertEqual(output.arranger, testString)
        XCTAssertEqual(output.artist, testString)
        XCTAssertEqual(output.artistSort, testString)
        XCTAssertEqual(output.composer, testString)
        XCTAssertEqual(output.composerSort, testString)
        XCTAssertEqual(output.conductor, testString)
        XCTAssertEqual(output.contentGroup, testString)
        XCTAssertEqual(output.encodedBy, testString)
        XCTAssertEqual(output.encodingSettings, testString)
        XCTAssertEqual(output.lyricist, testString)
        XCTAssertEqual(output.originalAlbum, testString)
        XCTAssertEqual(output.originalArtist, testString)
        XCTAssertEqual(output.originalFilename, testString)
        XCTAssertEqual(output.originalLyricist, testString)
        XCTAssertEqual(output.publisher, testString)
        XCTAssertEqual(output.radioStation, testString)
        XCTAssertEqual(output.radioStationOwner, testString)
        XCTAssertEqual(output.subtitle, testString)
        XCTAssertEqual(output.title, testString)
        XCTAssertEqual(output.titleSort, testString)
        XCTAssertEqual(output.work, testString)
    }
    
    func testMetadataExporterText() throws {
        let url = localDirectory
            .appendingPathComponent("testing/output.mp3")
        let mp3 = try Mp3File(location: url)
        var tag = try mp3.tag()
        
        XCTAssertNoThrow(try tag.exportMetadata(file: .text))
    }
    
    func testMetadataImporterText() throws {
        let url = localDirectory
            .appendingPathComponent("testing/output.mp3")
        let mp3 = try Mp3File(location: url)
        var tag = try mp3.tag()

        XCTAssertEqual(tag.frames.count, 89)

        XCTAssertNoThrow(tag.removeAllMetadata())
        XCTAssertEqual(tag.frames.count, 22)

        let text = url.deletingPathExtension()
            .appendingPathExtension("txt")

        XCTAssertNoThrow(try tag.importMetadata(location: text))
        XCTAssertEqual(tag.frames.count, 89)

        let outputURL = url.deletingLastPathComponent().appendingPathComponent("import-test-text.mp3")

        XCTAssertNoThrow(try mp3.write(tag: &tag, version: .v2_4, outputLocation: outputURL))
        let outputFile = try Mp3File(location: outputURL)
        let output = try outputFile.tag()

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
        XCTAssertEqual(output.copyright, "2020 Copyright")
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
        XCTAssertEqual(output.producedNotice, "2020 Produced Notice")
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
    }
    
    func testMetadataExporterCSV() throws {
        let url = localDirectory
            .appendingPathComponent("testing/output.mp3")
        let mp3 = try Mp3File(location: url)
        var tag = try mp3.tag()
        
        XCTAssertNoThrow(try tag.exportMetadata(file: .csv))
    }
    
//    func testMetadataImporterCSV() throws {
//        let url = localDirectory
//            .appendingPathComponent("testing/output.mp3")
//        let mp3 = try Mp3File(location: url)
//        var tag = try mp3.tag()
//
//        XCTAssertEqual(tag.metadataAtoms.count, 110)
//
//        XCTAssertNoThrow(tag.removeAllMetadata())
//        XCTAssertEqual(tag.metadataAtoms.count, 1)
//
//        let csv = url.deletingPathExtension()
//            .appendingPathExtension("csv")
//
//        XCTAssertNoThrow(try tag.importMetadata(location: csv))
//        XCTAssertEqual(tag.metadataAtoms.count, 110)
//
//        let outputURL = url.deletingLastPathComponent().appendingPathComponent("import-test-csv.mp3")
//
//        XCTAssertNoThrow(try mp3.write(tag: tag, to: outputURL))
//        let outputFile = try Mp3File(location: outputURL)
//        let output = try outputFile.tag()
//
//        XCTAssertEqual(output.acknowledgment,"Acknowledgment")
//        XCTAssertEqual(output.album,"Album")
//        XCTAssertEqual(output.albumArtist,"Album Artist")
//        XCTAssertEqual(output.albumArtistSort,"Sort, AlbumArtist")
//        XCTAssertEqual(output.albumSort,"Sort, Album")
//        XCTAssertEqual(output.appleStoreCountryID,123)
//        XCTAssertEqual(output.arranger,"Arranger")
//        XCTAssertEqual(output.arrangerKeywords,["Arranger", "Keywords"])
//        XCTAssertEqual(output.artDirector,"Art Director")
//        XCTAssertEqual(output.artist,"Artist")
//        XCTAssertEqual(output.artistID,1234567)
//        XCTAssertEqual(output.artistKeywords,["Artist", "Keywords"])
//        XCTAssertEqual(output.artistSort,"Sort, Artist")
//        XCTAssertEqual(output.artistUrl,"www.url.com")
//        XCTAssertEqual(output.bpm,99)
//        XCTAssertEqual(output.category,"Category")
//        XCTAssertEqual(output.comment,"Comment")
//        XCTAssertEqual(output.compilation,true)
//        XCTAssertEqual(output.composer,"Composer")
//        XCTAssertEqual(output.composerKeywords,["Composer", "Keywords"])
//        XCTAssertEqual(output.composerSort,"Sort, Composer")
//        XCTAssertEqual(output.conductor,"Conductor")
//        XCTAssertEqual(output.conductorID,3456789)
//        XCTAssertEqual(output.copyright,"2021 Copyright")
//        XCTAssertEqual(output.customGenre,"Genre")
//        XCTAssertEqual(output.description,"Description")
//        XCTAssertEqual(output.director,"Director")
//        XCTAssertEqual(output.discNumber.index,6)
//        XCTAssertEqual(output.discNumber.total,11)
//        XCTAssertEqual(output.editDateAndDescription1,"EDD1")
//        XCTAssertEqual(output.editDateAndDescription2,"EDD2")
//        XCTAssertEqual(output.editDateAndDescription3,"EDD3")
//        XCTAssertEqual(output.editDateAndDescription4,"EDD4")
//        XCTAssertEqual(output.editDateAndDescription5,"EDD5")
//        XCTAssertEqual(output.editDateAndDescription6,"EDD6")
//        XCTAssertEqual(output.editDateAndDescription7,"EDD7")
//        XCTAssertEqual(output.editDateAndDescription8,"EDD8")
//        XCTAssertEqual(output.editDateAndDescription9,"EDD9")
//        XCTAssertEqual(output.encodedBy,"Encoded By")
//        XCTAssertEqual(output.encodingTool,"Encoding Tool")
//        XCTAssertEqual(output.executiveProducer,"Executive Producer")
//        XCTAssertEqual(output.labelUrl,"www.label.url")
//        XCTAssertEqual(output.format,"Format")
//        XCTAssertEqual(output.gaplessPlayback,true)
//        XCTAssertEqual(output.genreID?.identifier,Genre.audiobooks(.audiobooks).identifier)
//        XCTAssertEqual(output.grouping,"Grouping")
//        XCTAssertEqual(output.information,"Information")
//        XCTAssertEqual(output.isrc,"ISRC1234ISRC")
//        XCTAssertEqual(output.iTunesAccount, "Itunes Account")
//        XCTAssertEqual(output.iTunesAccountType,82)
//        XCTAssertEqual(output.keywords,["Tag", "Keywords"])
//        XCTAssertEqual(output.label,"Label")
//        XCTAssertEqual(output.linerNotes,"Liner Notes")
//        XCTAssertEqual(output.longDescription,"Long Description")
//        XCTAssertEqual(output.lyricist,"Lyricist")
//        XCTAssertEqual(output.lyrics,"Lyrics")
//        XCTAssertEqual(output.mediaKind,.audiobook)
//        XCTAssertEqual(output.movementCount,3)
//        XCTAssertEqual(output.movementNumber,1)
//        XCTAssertEqual(output.movement,"Movement Name")
//        XCTAssertEqual(output.narrator,"Narrator")
//        XCTAssertEqual(output.originalArtist,"Original Artist")
//        XCTAssertEqual(output.owner,"Owner")
//        XCTAssertEqual(output.performers,["Performers"])
//        XCTAssertEqual(output.playlistID,5678901)
//        XCTAssertEqual(output.podcast,true)
//        XCTAssertEqual(output.podcastID,"Podcast")
//        XCTAssertEqual(output.podcastFeed,"www.podcast.url")
//        XCTAssertEqual(output.predefinedGenre?.stringValue,Genre.audiobooks(.audiobooksLatino).stringValue)
//        XCTAssertEqual(output.producer,"Producer")
//        XCTAssertEqual(output.producerKeywords,["Producer", "Keywords"])
//        XCTAssertEqual(output.publisher,"Publisher")
//        XCTAssertEqual(output.recordCompanyUrl,"www.recordcompany.url")
//        XCTAssertEqual(output.rating,.clean)
//        XCTAssertEqual(output.recordCompany,"Record Company")
//        XCTAssertEqual(output.recordingCopyright,"2021 Recording Copyright")
//        XCTAssertEqual(output.requirements,"Requirements")
//        XCTAssertEqual(output.sellerID,"SellerID")
//        XCTAssertEqual(output.showWorkAndMovement,true)
//        XCTAssertEqual(output.softwareVersion,"Software Version")
//        XCTAssertEqual(output.soloist,"Soloist")
//        XCTAssertEqual(output.songDescription,"Song Description")
//        XCTAssertEqual(output.songwriterKeywords,["Songwriter", "Keywords"])
//        XCTAssertEqual(output.songwriter,"Songwriter")
//        XCTAssertEqual(output.soundEngineer,"Sound Engineer")
//        XCTAssertEqual(output.sourceCredit,"Source")
//        XCTAssertEqual(output.subtitle,"Subtitle")
//        XCTAssertEqual(output.subtitleKeywords,["Subtitle", "Keywords"])
//        XCTAssertEqual(output.thanks,"Thanks")
//        XCTAssertEqual(output.title,"Title")
//        XCTAssertEqual(output.titleKeywords,["Title", "Keywords"])
//        XCTAssertEqual(output.titleSort,"Sort, Title")
//        XCTAssertEqual(output.trackNumber.index,7)
//        XCTAssertEqual(output.trackNumber.total,13)
//        XCTAssertEqual(output.trackSubtitle,"Track Subtitle")
//        XCTAssertEqual(output.tvEpisodeNumber,12)
//        XCTAssertEqual(output.tvSeason,5)
//        XCTAssertEqual(output.tvShow,"TV Show")
//        XCTAssertEqual(output.tvNetwork,"Network")
//        XCTAssertEqual(output.tvShowSort,"Sort, Show")
//        XCTAssertEqual(output.tvEpisodeTitle,"Episode Title")
//        XCTAssertEqual(output.tvShowDescription,"Show Description")
//        XCTAssertEqual(output.website,"www.website.com")
//        XCTAssertEqual(output.workName,"Work")
//        XCTAssertEqual(output.writer,"Writer")
//        XCTAssertEqual(output.year,2021)
//        XCTAssertEqual(output.releaseDate, Date.distantFuture)
//        XCTAssertEqual(output.recordingDate, Date.distantPast)
//        XCTAssertEqual(output.purchaseDate, Date.distantFuture)
//    }
    
    func testMetadataExporterJSON() throws {
        let url = localDirectory
            .appendingPathComponent("testing/output.mp3")
        let mp3 = try Mp3File(location: url)
        var tag = try mp3.tag()
        
        XCTAssertNoThrow(try tag.exportMetadata(file: .json))
    }
    
//    func testMetadataImporterJSON() throws {
//        let url = localDirectory
//            .appendingPathComponent("testing/output.mp3")
//        let mp3 = try Mp3File(location: url)
//        var tag = try mp3.tag()
//
//        XCTAssertEqual(tag.metadataAtoms.count, 110)
//
//        XCTAssertNoThrow(tag.removeAllMetadata())
//        XCTAssertEqual(tag.metadataAtoms.count, 1)
//
//        let json = url.deletingPathExtension()
//            .appendingPathExtension("json")
//
//        XCTAssertNoThrow(try tag.importMetadata(location: json))
//        XCTAssertEqual(tag.metadataAtoms.count, 110)
//
//        let outputURL = url.deletingLastPathComponent().appendingPathComponent("import-test-json.mp3")
//
//        XCTAssertNoThrow(try mp3.write(tag: tag, to: outputURL))
//        let outputFile = try Mp3File(location: outputURL)
//        let output = try outputFile.tag()
//
//        XCTAssertEqual(output.acknowledgment,"Acknowledgment")
//        XCTAssertEqual(output.album,"Album")
//        XCTAssertEqual(output.albumArtist,"Album Artist")
//        XCTAssertEqual(output.albumArtistSort,"Sort, AlbumArtist")
//        XCTAssertEqual(output.albumSort,"Sort, Album")
//        XCTAssertEqual(output.appleStoreCountryID,123)
//        XCTAssertEqual(output.arranger,"Arranger")
//        XCTAssertEqual(output.arrangerKeywords,["Arranger", "Keywords"])
//        XCTAssertEqual(output.artDirector,"Art Director")
//        XCTAssertEqual(output.artist,"Artist")
//        XCTAssertEqual(output.artistID,1234567)
//        XCTAssertEqual(output.artistKeywords,["Artist", "Keywords"])
//        XCTAssertEqual(output.artistSort,"Sort, Artist")
//        XCTAssertEqual(output.artistUrl,"www.url.com")
//        XCTAssertEqual(output.bpm,99)
//        XCTAssertEqual(output.category,"Category")
//        XCTAssertEqual(output.comment,"Comment")
//        XCTAssertEqual(output.compilation,true)
//        XCTAssertEqual(output.composer,"Composer")
//        XCTAssertEqual(output.composerKeywords,["Composer", "Keywords"])
//        XCTAssertEqual(output.composerSort,"Sort, Composer")
//        XCTAssertEqual(output.conductor,"Conductor")
//        XCTAssertEqual(output.conductorID,3456789)
//        XCTAssertEqual(output.copyright,"2021 Copyright")
//        XCTAssertEqual(output.customGenre,"Genre")
//        XCTAssertEqual(output.description,"Description")
//        XCTAssertEqual(output.director,"Director")
//        XCTAssertEqual(output.discNumber.index,6)
//        XCTAssertEqual(output.discNumber.total,11)
//        XCTAssertEqual(output.editDateAndDescription1,"EDD1")
//        XCTAssertEqual(output.editDateAndDescription2,"EDD2")
//        XCTAssertEqual(output.editDateAndDescription3,"EDD3")
//        XCTAssertEqual(output.editDateAndDescription4,"EDD4")
//        XCTAssertEqual(output.editDateAndDescription5,"EDD5")
//        XCTAssertEqual(output.editDateAndDescription6,"EDD6")
//        XCTAssertEqual(output.editDateAndDescription7,"EDD7")
//        XCTAssertEqual(output.editDateAndDescription8,"EDD8")
//        XCTAssertEqual(output.editDateAndDescription9,"EDD9")
//        XCTAssertEqual(output.encodedBy,"Encoded By")
//        XCTAssertEqual(output.encodingTool,"Encoding Tool")
//        XCTAssertEqual(output.executiveProducer,"Executive Producer")
//        XCTAssertEqual(output.labelUrl,"www.label.url")
//        XCTAssertEqual(output.format,"Format")
//        XCTAssertEqual(output.gaplessPlayback,true)
//        XCTAssertEqual(output.genreID?.identifier,Genre.audiobooks(.audiobooks).identifier)
//        XCTAssertEqual(output.grouping,"Grouping")
//        XCTAssertEqual(output.information,"Information")
//        XCTAssertEqual(output.isrc,"ISRC1234ISRC")
//        XCTAssertEqual(output.iTunesAccount, "Itunes Account")
//        XCTAssertEqual(output.iTunesAccountType,82)
//        XCTAssertEqual(output.keywords,["Tag", "Keywords"])
//        XCTAssertEqual(output.label,"Label")
//        XCTAssertEqual(output.linerNotes,"Liner Notes")
//        XCTAssertEqual(output.longDescription,"Long Description")
//        XCTAssertEqual(output.lyricist,"Lyricist")
//        XCTAssertEqual(output.lyrics,"Lyrics")
//        XCTAssertEqual(output.mediaKind,.audiobook)
//        XCTAssertEqual(output.movementCount,3)
//        XCTAssertEqual(output.movementNumber,1)
//        XCTAssertEqual(output.movement,"Movement Name")
//        XCTAssertEqual(output.narrator,"Narrator")
//        XCTAssertEqual(output.originalArtist,"Original Artist")
//        XCTAssertEqual(output.owner,"Owner")
//        XCTAssertEqual(output.performers,["Performers"])
//        XCTAssertEqual(output.playlistID,5678901)
//        XCTAssertEqual(output.podcast,true)
//        XCTAssertEqual(output.podcastID,"Podcast")
//        XCTAssertEqual(output.podcastFeed,"www.podcast.url")
//        XCTAssertEqual(output.predefinedGenre?.stringValue,Genre.audiobooks(.audiobooksLatino).stringValue)
//        XCTAssertEqual(output.producer,"Producer")
//        XCTAssertEqual(output.producerKeywords,["Producer", "Keywords"])
//        XCTAssertEqual(output.publisher,"Publisher")
//        XCTAssertEqual(output.recordCompanyUrl,"www.recordcompany.url")
//        XCTAssertEqual(output.rating,.clean)
//        XCTAssertEqual(output.recordCompany,"Record Company")
//        XCTAssertEqual(output.recordingCopyright,"2021 Recording Copyright")
//        XCTAssertEqual(output.requirements,"Requirements")
//        XCTAssertEqual(output.sellerID,"SellerID")
//        XCTAssertEqual(output.showWorkAndMovement,true)
//        XCTAssertEqual(output.softwareVersion,"Software Version")
//        XCTAssertEqual(output.soloist,"Soloist")
//        XCTAssertEqual(output.songDescription,"Song Description")
//        XCTAssertEqual(output.songwriterKeywords,["Songwriter", "Keywords"])
//        XCTAssertEqual(output.songwriter,"Songwriter")
//        XCTAssertEqual(output.soundEngineer,"Sound Engineer")
//        XCTAssertEqual(output.sourceCredit,"Source")
//        XCTAssertEqual(output.subtitle,"Subtitle")
//        XCTAssertEqual(output.subtitleKeywords,["Subtitle", "Keywords"])
//        XCTAssertEqual(output.thanks,"Thanks")
//        XCTAssertEqual(output.title,"Title")
//        XCTAssertEqual(output.titleKeywords,["Title", "Keywords"])
//        XCTAssertEqual(output.titleSort,"Sort, Title")
//        XCTAssertEqual(output.trackNumber.index,7)
//        XCTAssertEqual(output.trackNumber.total,13)
//        XCTAssertEqual(output.trackSubtitle,"Track Subtitle")
//        XCTAssertEqual(output.tvEpisodeNumber,12)
//        XCTAssertEqual(output.tvSeason,5)
//        XCTAssertEqual(output.tvShow,"TV Show")
//        XCTAssertEqual(output.tvNetwork,"Network")
//        XCTAssertEqual(output.tvShowSort,"Sort, Show")
//        XCTAssertEqual(output.tvEpisodeTitle,"Episode Title")
//        XCTAssertEqual(output.tvShowDescription,"Show Description")
//        XCTAssertEqual(output.website,"www.website.com")
//        XCTAssertEqual(output.workName,"Work")
//        XCTAssertEqual(output.writer,"Writer")
//        XCTAssertEqual(output.year,2021)
//        XCTAssertEqual(output.releaseDate, Date.distantFuture)
//        XCTAssertEqual(output.recordingDate, Date.distantPast)
//        XCTAssertEqual(output.purchaseDate, Date.distantFuture)
//    }
//
//    func testChapterExporterCue() throws {
//        let url = localDirectory
//            .appendingPathComponent("testing/basilisk.mp3")
//        let mp3 = try Mp3File(location: url)
//        let tag = try mp3.tag()
//
//        XCTAssertNoThrow(try tag.exportChapters(format: .cue, usingFullCueMetadata: true))
//    }
//
//    func testChapterExporterOgg() throws {
//        let url = localDirectory
//            .appendingPathComponent("testing/basilisk.mp3")
//        let mp3 = try Mp3File(location: url)
//        let tag = try mp3.tag()
//
//        XCTAssertNoThrow(try tag.exportChapters(format: .ogg))
//    }
//
//    func testChapterExporterMp3v2() throws {
//        let url = localDirectory
//            .appendingPathComponent("testing/basilisk.mp3")
//        let mp3 = try Mp3File(location: url)
//        let tag = try mp3.tag()
//
//        XCTAssertNoThrow(try tag.exportChapters(format: .mp3v2))
//    }
//
//    func testCueChapterImporter() throws {
//        let url = localDirectory
//            .appendingPathComponent("testing/basilisk.mp3")
//        let mp3 = try Mp3File(location: url)
//        var tag = try mp3.tag()
//
//        let cueURL = url
//            .deletingPathExtension()
//            .appendingPathExtension("cue")
//
//        XCTAssertNoThrow(try tag.exportChapters(format: .cue))
//        let exportCount = tag.chapterList.count
//        let exportedTitle = tag.album
//        let exportedArtist = tag.albumArtist
//
//        tag.removeAllChapters()
//        tag.removeAllMetadata()
//        XCTAssertTrue(tag.chapterList.isEmpty)
//        XCTAssertEqual(tag.metadataAtoms.count, 1)
//
//        XCTAssertNoThrow(try tag.importChapters(
//                            location: cueURL,
//                            format: .cue))
//
//        XCTAssertEqual(tag.chapterList.count, exportCount)
//        XCTAssertEqual(tag.album, exportedTitle)
//        XCTAssertEqual(tag.albumArtist, exportedArtist)
//    }
//
//    func testOggChapterImporter() throws {
//        let url = localDirectory
//            .appendingPathComponent("testing/basilisk.mp3")
//        let mp3 = try Mp3File(location: url)
//        var tag = try mp3.tag()
//
//        let exportCount = tag.chapterList.count
//        let exported = tag.chapterList
//
//        let txtURL = url
//            .deletingPathExtension()
//            .deletingLastPathComponent()
//            .appendingPathComponent("basilisk.txt")
//
//        XCTAssertNoThrow(try tag.exportChapters(format: .ogg))
//
//        tag.removeAllChapters()
//        XCTAssertTrue(tag.chapterList.isEmpty)
//
//        XCTAssertNoThrow(try tag.importChapters(
//                            location: txtURL,
//                            format: .ogg))
//
//        XCTAssertEqual(tag.chapterList.count, exportCount)
//        XCTAssertEqual(tag.chapterList, exported)
//    }
//
//    func testMp3v2ChapterImporter() throws {
//        let url = localDirectory
//            .appendingPathComponent("testing/basilisk.mp3")
//        let mp3 = try Mp3File(location: url)
//        var tag = try mp3.tag()
//
//        let exportCount = tag.chapterList.count
//        let exported = tag.chapterList
//
//        let txtURL = url
//            .deletingPathExtension()
//            .deletingLastPathComponent()
//            .appendingPathComponent("basilisk.txt")
//
//        XCTAssertNoThrow(try tag.exportChapters(format: .mp3v2))
//
//        tag.removeAllChapters()
//        XCTAssertTrue(tag.chapterList.isEmpty)
//
//        XCTAssertNoThrow(try tag.importChapters(
//                            location: txtURL,
//                            format: .mp3v2))
//
//        XCTAssertEqual(tag.chapterList.count, exportCount)
//        XCTAssertEqual(tag.chapterList, exported)
//    }
//
//    func testFullMetaCueImport() throws {
//        let url = localDirectory
//            .appendingPathComponent("testing/basilisk.mp3")
//        let mp3 = try Mp3File(location: url)
//        var tag = try mp3.tag()
//
//        tag.removeAllMetadata()
//        XCTAssertEqual(tag.metadataAtoms.count, 1)
//
//        tag.acknowledgment = "Acknowledgment"
//        tag.album = "Album"
//        tag.albumArtist = "Album Artist"
//        tag.albumSort = "Sort, Album"
//        tag.albumArtistSort = "Sort, AlbumArtist"
//        tag.appleStoreCountryID = 123
//        tag.arranger = "Arranger"
//        tag.arrangerKeywords = ["Arranger", "Keywords"]
//        tag.artDirector = "Art Director"
//        tag.artist = "Artist"
//        tag.artistID = 1234567
//        tag.artistKeywords = ["Artist", "Keywords"]
//        tag.artistSort = "Sort, Artist"
//        tag.artistUrl = "www.url.com"
//        tag.bpm = 99
//        tag.category = "Category"
//        tag.comment = "Comment"
//        tag.compilation = true
//        tag.composer = "Composer"
//        tag.composerID = 2345678
//        tag.composerKeywords = ["Composer", "Keywords"]
//        tag.composerSort = "Sort, Composer"
//        tag.conductor = "Conductor"
//        tag.conductorID = 3456789
//        tag.contentRating = .au_Movie_G("String")
//        tag.copyright = "2021 Copyright"
//        tag.customGenre = "Genre"
//        tag.description = "Description"
//        tag.director = "Director"
//        tag.discNumber.index = 6
//        tag.discNumber.total = 11
//        tag.editDateAndDescription1 = "EDD1"
//        tag.editDateAndDescription2 = "EDD2"
//        tag.editDateAndDescription3 = "EDD3"
//        tag.editDateAndDescription4 = "EDD4"
//        tag.editDateAndDescription5 = "EDD5"
//        tag.editDateAndDescription6 = "EDD6"
//        tag.editDateAndDescription7 = "EDD7"
//        tag.editDateAndDescription8 = "EDD8"
//        tag.editDateAndDescription9 = "EDD9"
//        tag.encodedBy = "Encoded By"
//        tag.encodingTool = "Encoding Tool"
//        tag.executiveProducer = "Executive Producer"
//        tag.format = "Format"
//        tag.gaplessPlayback = true
//        tag.genreID = .audiobooks(.audiobooks)
//        tag.grouping = "Grouping"
//        tag.iTunesAccount = "Itunes Account"
//        tag.iTunesAccountType = 4567890
//        tag.information = "Information"
//        tag.isrc = "ISRC1234ISRC"
//        tag.keywords = ["Tag", "Keywords"]
//        tag.label = "Label"
//        tag.labelUrl = "www.label.url"
//        tag.languages = [.english]
//        tag.linerNotes = "Liner Notes"
//        tag.longDescription = "Long Description"
//        tag.lyricist = "Lyricist"
//        tag.lyrics = "Lyrics"
//        tag.mediaKind = .audiobook
//        tag.movement = "Movement Name"
//        tag.movementNumber = 1
//        tag.movementCount = 3
//        tag.narrator = "Narrator"
//        tag.originalArtist = "Original Artist"
//        tag.owner = "Owner"
//        tag.performers = ["Performers"]
//        tag.playlistID = 5678901
//        tag.podcast = true
//        tag.podcastFeed = "www.podcast.url"
//        tag.podcastID = "Podcast"
//        tag.predefinedGenre = .audiobooks(.audiobooksLatino)
//        tag.producer = "Producer"
//        tag.producerKeywords = ["Producer", "Keywords"]
//        tag.publisher = "Publisher"
//        tag.purchaseDate = Date.distantFuture
//        tag.rating = .clean
//        tag.recordCompany = "Record Company"
//        tag.recordCompanyUrl = "www.recordcompany.url"
//        tag.recordingCopyright = "2021 Recording Copyright"
//        tag.recordingDate = Date.distantPast
//        tag.releaseDate = Date.distantFuture
//        tag.requirements = "Requirements"
//        tag.sellerID = "SellerID"
//        tag.showWorkAndMovement = true
//        tag.softwareVersion = "Software Version"
//        tag.soloist = "Soloist"
//        tag.songDescription = "Song Description"
//        tag.songwriter = "Songwriter"
//        tag.songwriterKeywords = ["Songwriter", "Keywords"]
//        tag.soundEngineer = "Sound Engineer"
//        tag.sourceCredit = "Source"
//        tag.subtitle = "Subtitle"
//        tag.subtitleKeywords = ["Subtitle", "Keywords"]
//        tag.thanks = "Thanks"
//        tag.title = "Title"
//        tag.titleKeywords = ["Title", "Keywords"]
//        tag.titleSort = "Sort, Title"
//        tag.trackNumber.index = 7
//        tag.trackNumber.total = 13
//        tag.trackSubtitle = "Track Subtitle"
//        tag.tvEpisodeNumber = 12
//        tag.tvEpisodeTitle = "Episode Title"
//        tag.tvNetwork = "Network"
//        tag.tvShow = "TV Show"
//        tag.tvSeason = 5
//        tag.tvShowDescription = "Show Description"
//        tag.website = "www.website.com"
//        tag.tvShowSort = "Sort, Show"
//        tag.workName = "Work"
//        tag.writer = "Writer"
//        tag.year = 2021
//
//        tag.removeAllChapters()
//        XCTAssertTrue(tag.chapterList.isEmpty)
//
//        tag.addChapter(startTime: 0, title: "Introduction")
//        tag.addChapter(startTime: 1500000, title: "Chapter 001")
//        tag.addChapter(startTime: 3000000, title: "Chapter 002")
//        tag.addChapter(startTime: 4500000, title: "Chapter 003")
//        tag.addChapter(startTime: 6000000, title: "Chapter 004")
//        tag.addChapter(startTime: 7500000, title: "Chapter 005")
//        tag.addChapter(startTime: 9000000, title: "Chapter 006")
//        tag.addChapter(startTime: 10500000, title: "Chapter 007")
//        tag.addChapter(startTime: 12000000, title: "Chapter 008")
//        tag.addChapter(startTime: 13500000, title: "Chapter 009")
//        tag.addChapter(startTime: 15000000, title: "Chapter 010")
//        tag.addChapter(startTime: 16500000, title: "Chapter 011")
//        tag.addChapter(startTime: 18000000, title: "Chapter 012")
//        tag.addChapter(startTime: 19500000, title: "Chapter 013")
//        tag.addChapter(startTime: 21000000, title: "Chapter 014")
//        tag.addChapter(startTime: 22500000, title: "Chapter 015")
//        tag.addChapter(startTime: 24000000, title: "Chapter 016")
//        tag.addChapter(startTime: 25500000, title: "Chapter 017")
//
//        let chapterList = tag.chapterList
//        let count = tag.metadataAtoms.count
//        let chapterCount = tag.chapterList.count
//
//        let cueURL = url
//            .deletingPathExtension()
//            .appendingPathExtension("cue")
//
//        XCTAssertNoThrow(try tag.exportChapters(format: .cue, usingFullCueMetadata: true))
//
//        XCTAssertNoThrow(try tag.importChapters(location: cueURL, format: .cue))
//        XCTAssertEqual(tag.metadataAtoms.count, count)
//        XCTAssertEqual(tag.chapterList.count, chapterCount)
//
//        let output = url.deletingLastPathComponent().appendingPathComponent("output.mp3")
//        XCTAssertNoThrow(try mp3.write(tag: tag, to: output))
//
//        let resultMp3 = try Mp3File(location: output)
//        let result = try resultMp3.tag()
//
//        XCTAssertEqual(result.acknowledgment, "Acknowledgment")
//        XCTAssertEqual(result.album, "Album")
//        XCTAssertEqual(result.albumArtist, "Album Artist")
//        XCTAssertEqual(result.albumSort, "Sort, Album")
//        XCTAssertEqual(result.albumArtistSort, "Sort, AlbumArtist")
//        XCTAssertEqual(result.appleStoreCountryID, 123)
//        XCTAssertEqual(result.arranger, "Arranger")
//        XCTAssertEqual(result.arrangerKeywords, ["Arranger", "Keywords"])
//        XCTAssertEqual(result.artDirector, "Art Director")
//        XCTAssertEqual(result.artist, "Artist")
//        XCTAssertEqual(result.artistID, 1234567)
//        XCTAssertEqual(result.artistKeywords, ["Artist", "Keywords"])
//        XCTAssertEqual(result.artistSort, "Sort, Artist")
//        XCTAssertEqual(result.artistUrl, "www.url.com")
//        XCTAssertEqual(result.bpm, 99)
//        XCTAssertEqual(result.category, "Category")
//        XCTAssertEqual(result.comment, "Comment")
//        XCTAssertEqual(result.compilation, true)
//        XCTAssertEqual(result.composer, "Composer")
//        XCTAssertEqual(result.composerID, 2345678)
//        XCTAssertEqual(result.composerKeywords, ["Composer", "Keywords"])
//        XCTAssertEqual(result.composerSort, "Sort, Composer")
//        XCTAssertEqual(result.conductor, "Conductor")
//        XCTAssertEqual(result.conductorID, 3456789)
//        XCTAssertEqual(result.copyright, "2021 Copyright")
//        XCTAssertEqual(result.customGenre, "Genre")
//        XCTAssertEqual(result.description, "Description")
//        XCTAssertEqual(result.director, "Director")
//        XCTAssertEqual(result.discNumber.index, 6)
//        XCTAssertEqual(result.discNumber.total, 11)
//        XCTAssertEqual(result.editDateAndDescription1, "EDD1")
//        XCTAssertEqual(result.editDateAndDescription2, "EDD2")
//        XCTAssertEqual(result.editDateAndDescription3, "EDD3")
//        XCTAssertEqual(result.editDateAndDescription4, "EDD4")
//        XCTAssertEqual(result.editDateAndDescription5, "EDD5")
//        XCTAssertEqual(result.editDateAndDescription6, "EDD6")
//        XCTAssertEqual(result.editDateAndDescription7, "EDD7")
//        XCTAssertEqual(result.editDateAndDescription8, "EDD8")
//        XCTAssertEqual(result.editDateAndDescription9, "EDD9")
//        XCTAssertEqual(result.encodedBy, "Encoded By")
//        XCTAssertEqual(result.encodingTool, "Encoding Tool")
//        XCTAssertEqual(result.executiveProducer, "Executive Producer")
//        XCTAssertEqual(result.format, "Format")
//        XCTAssertEqual(result.gaplessPlayback, true)
//        XCTAssertEqual(result.grouping, "Grouping")
//        XCTAssertEqual(result.iTunesAccount, "Itunes Account")
//        XCTAssertEqual(result.iTunesAccountType, 82)
//        XCTAssertEqual(result.information, "Information")
//        XCTAssertEqual(result.isrc, "ISRC1234ISRC")
//        XCTAssertEqual(result.keywords, ["Tag", "Keywords"])
//        XCTAssertEqual(result.label, "Label")
//        XCTAssertEqual(result.labelUrl, "www.label.url")
//        XCTAssertEqual(result.languages, [.english])
//        XCTAssertEqual(result.linerNotes, "Liner Notes")
//        XCTAssertEqual(result.longDescription, "Long Description")
//        XCTAssertEqual(result.lyricist, "Lyricist")
//        XCTAssertEqual(result.lyrics, "Lyrics")
//        XCTAssertEqual(result.mediaKind, .audiobook)
//        XCTAssertEqual(result.movement, "Movement Name")
//        XCTAssertEqual(result.movementNumber, 1)
//        XCTAssertEqual(result.movementCount, 3)
//        XCTAssertEqual(result.narrator, "Narrator")
//        XCTAssertEqual(result.originalArtist, "Original Artist")
//        XCTAssertEqual(result.owner, "Owner")
//        XCTAssertEqual(result.performers, ["Performers"])
//        XCTAssertEqual(result.playlistID, 5678901)
//        XCTAssertEqual(result.podcast, true)
//        XCTAssertEqual(result.podcastFeed, "www.podcast.url")
//        XCTAssertEqual(result.podcastID, "Podcast")
//        XCTAssertEqual(result.producer, "Producer")
//        XCTAssertEqual(result.producerKeywords, ["Producer", "Keywords"])
//        XCTAssertEqual(result.publisher, "Publisher")
//        XCTAssertEqual(result.purchaseDate, Date.distantFuture)
//        XCTAssertEqual(result.rating, .clean)
//        XCTAssertEqual(result.recordCompany, "Record Company")
//        XCTAssertEqual(result.recordCompanyUrl, "www.recordcompany.url")
//        XCTAssertEqual(result.recordingCopyright, "2021 Recording Copyright")
//        XCTAssertEqual(result.recordingDate, Date.distantPast)
//        XCTAssertEqual(result.releaseDate, Date.distantFuture)
//        XCTAssertEqual(result.requirements, "Requirements")
//        XCTAssertEqual(result.sellerID, "SellerID")
//        XCTAssertEqual(result.showWorkAndMovement, true)
//        XCTAssertEqual(result.softwareVersion, "Software Version")
//        XCTAssertEqual(result.soloist, "Soloist")
//        XCTAssertEqual(result.songDescription, "Song Description")
//        XCTAssertEqual(result.songwriter, "Songwriter")
//        XCTAssertEqual(result.songwriterKeywords, ["Songwriter", "Keywords"])
//        XCTAssertEqual(result.soundEngineer, "Sound Engineer")
//        XCTAssertEqual(result.sourceCredit, "Source")
//        XCTAssertEqual(result.subtitle, "Subtitle")
//        XCTAssertEqual(result.subtitleKeywords, ["Subtitle", "Keywords"])
//        XCTAssertEqual(result.thanks, "Thanks")
//        XCTAssertEqual(result.title, "Title")
//        XCTAssertEqual(result.titleKeywords, ["Title", "Keywords"])
//        XCTAssertEqual(result.titleSort, "Sort, Title")
//        XCTAssertEqual(result.trackNumber.index, 7)
//        XCTAssertEqual(result.trackNumber.total, 13)
//        XCTAssertEqual(result.trackSubtitle, "Track Subtitle")
//        XCTAssertEqual(result.tvEpisodeNumber, 12)
//        XCTAssertEqual(result.tvEpisodeTitle, "Episode Title")
//        XCTAssertEqual(result.tvNetwork, "Network")
//        XCTAssertEqual(result.tvShow, "TV Show")
//        XCTAssertEqual(result.tvSeason, 5)
//        XCTAssertEqual(result.tvShowDescription, "Show Description")
//        XCTAssertEqual(result.website, "www.website.com")
//        XCTAssertEqual(result.tvShowSort, "Sort, Show")
//        XCTAssertEqual(result.workName, "Work")
//        XCTAssertEqual(result.writer, "Writer")
//        XCTAssertEqual(result.year, 2021)
//
//        XCTAssertEqual(result.chapterList.count, chapterCount)
//        XCTAssertEqual(chapterList, result.chapterList)
//    }
//
//    func testChapterDiscrepancy() throws {
//        let url = localDirectory
//            .appendingPathComponent("testing/basilisk.mp3")
//        let mp3 = try Mp3File(location: url)
//        var tag = try mp3.tag()
//
//        tag.removeAllChapters()
//        XCTAssertTrue(tag.chapterList.isEmpty)
//        XCTAssertTrue(((mp3.moov.udta?.chpl?.chapterTable.isEmpty) != nil))
//
//        tag.addChapter(startTime: 0, title: "Introduction")
//        tag.addChapter(startTime: 1500000, title: "Chapter 001")
//        tag.addChapter(startTime: 3000000, title: "Chapter 002")
//        tag.addChapter(startTime: 4500000, title: "Chapter 003")
//        tag.addChapter(startTime: 6000000, title: "Chapter 004")
//        tag.addChapter(startTime: 7500000, title: "Chapter 005")
//        tag.addChapter(startTime: 9000000, title: "Chapter 006")
//        tag.addChapter(startTime: 10500000, title: "Chapter 007")
//        tag.addChapter(startTime: 12000000, title: "Chapter 008")
//        tag.addChapter(startTime: 13500000, title: "Chapter 009")
//        tag.addChapter(startTime: 15000000, title: "Chapter 010")
//        tag.addChapter(startTime: 16500000, title: "Chapter 011")
//        tag.addChapter(startTime: 18000000, title: "Chapter 012")
//        tag.addChapter(startTime: 19500000, title: "Chapter 013")
//        tag.addChapter(startTime: 21000000, title: "Chapter 014")
//        tag.addChapter(startTime: 22500000, title: "Chapter 015")
//        tag.addChapter(startTime: 24000000, title: "Chapter 016")
//        tag.addChapter(startTime: 25500000, title: "Chapter 017")
//
//        let chapterList = tag.chapterList
//        let chapterCount = tag.chapterList.count
//
//        let cueURL = url
//            .deletingPathExtension()
//            .appendingPathExtension("cue")
//
//        XCTAssertNoThrow(try tag.exportChapters(format: .cue, usingFullCueMetadata: true))
//
//        XCTAssertNoThrow(try tag.importChapters(location: cueURL, format: .cue))
//
//        XCTAssertEqual(tag.chapterList.count, chapterCount)
//
//        let output = url.deletingLastPathComponent().appendingPathComponent("output.mp3")
//        XCTAssertNoThrow(try mp3.write(tag: tag, to: output))
//
//        let resultMp3 = try Mp3File(location: output)
//        let result = try resultMp3.tag()
//
//        XCTAssertEqual(result.chapterList.count, chapterCount)
//        XCTAssertEqual(chapterList, result.chapterList)
//    }

//    func testAll() throws {
//        let url = localDirectory
//            .appendingPathComponent("testing/basilisk.mp3")
//
//        let mp3 = try Mp3File(location: url)
//        var tag = try mp3.tag()
//        tag.removeAllMetadata()
//
//        for frame in tag.frames {
//            print(frame.key.keyString(format: .text))
//        }
//        XCTAssertEqual(tag.frames.count, 22)
//
//        tag.album = "Album"
//        tag.albumArtist = "Album Artist"
//        tag.albumSort = "Album Sort"
//        tag.albumArtistSort = "Album Artist Sort"
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
//        tag.movement = "Movement Name"
//        tag.originalAlbum = "Original Album"
//        tag.originalArtist = "Original Artist"
//        tag.originalFilename = "Original Filename"
//        tag.originalLyricist = "Original Lyricist"
//        tag.podcastID = "Podcast ID"
//        tag.podcastCategory = "Podcast Category"
//        tag.podcastFeed = "http://podcast.url"
//        tag.podcastDescription = "Podcast Description"
//        tag.podcastKeywords = ["Podcast", "Keywords"]
//        tag.publisher = "Publisher"
//        tag.producedNotice = "2020 Produced Notice"
//        tag.radioStation = "Radio Station"
//        tag.radioStationOwner = "Radio Station Owner"
//        tag.subtitle = "Subtitle"
//        tag.setSubtitle = "Set Subtitle"
//        tag.title = "Title"
//        tag.titleSort = "Title Sort"
//
//        tag.compilation = true
//        tag.bpm = 99
//        tag.isrc = "987654321098"
//        tag.movementNumber = 5
//        tag.movementCount = 6
//        tag.playlistDelay = 0
//
//        tag.audioSourceWebpage = "http://audiosource.url"
//        tag.audioFileWebpage = "http://audiofile.url"
//        tag.artistWebpage = "http://artist.url"
//        tag.copyrightWebpage = "http://copyright.url"
//        tag.paymentWebpage = "http://payment.url"
//        tag.publisherWebpage = "http://publisher.url"
//        tag.radioStationWebpage = "http://radiostation.url"
//
//        tag.languages = [.english]
//
//        tag.trackNumber.index = 1
//        tag.trackNumber.total = 2
//        tag.discNumber.index = 3
//        tag.discNumber.total = 4
//
//        tag.addInvolvementCredit(role: .director, person: "Director Name")
//        tag.addInvolvementCredit(role: .producer, person: "Producer Name")
//        tag.addMusicianCredit(role: .soprano, person: "Soprano Name")
//        tag.addMusicianCredit(role: .alto, person: "Alto Name")
//
//        tag.encodingDateTime = testAllDate
//        tag.taggingDateTime = testAllDate
//        tag.releaseDateTime = testAllDate
//        tag.originalRelease = testAllDate
//        tag.recordingDateTime = testAllDate
//
//        tag[comment: "Comment", .eng] = "Comment Content"
//        tag[lyrics: "Lyrics", .eng] = "Lyrics Content"
//        tag[userDefinedUrl: "UserURL"] = "http://userdefined.url"
//        tag["UserText"] = "User Text Content"
//
//        tag.discNumber.index = 4
//        tag.discNumber.total = 5
//        tag.trackNumber.index = 6
//        tag.trackNumber.total = 7
//
//        tag.genre.genreCategory = .Blues
//        tag.genre.genre = "Blues Refinement"
//
//        tag.mediaType.mediaType = .otherDigital
//        tag.mediaType.mediaTypeRefinement = .analogTransfer
//        tag.mediaType.additionalInformation = "Additional Information"
//
//        tag.fileType.fileType = .MPG
//        tag.fileType.fileTypeRefinement = .mpegLayerIII
//        tag.fileType.additionalInformation = "Additional Information"
//
//        let outputUrl = localDirectory
//            .appendingPathComponent("testing/output.mp3")
//
//        XCTAssertNoThrow(try mp3.write(tag: &tag, version: .v2_4, outputLocation: outputUrl))
//
//        let outputMp3 = try Mp3File(location: outputUrl)
//        let output = try Tag(mp3File: outputMp3)
//
//        XCTAssertEqual(output.album, "Album")
//        XCTAssertEqual(output.albumArtist, "Album Artist")
//        XCTAssertEqual(output.albumSort, "Album Sort")
//        XCTAssertEqual(output.albumArtistSort, "Album Artist Sort")
//        XCTAssertEqual(output.arranger, "Arranger")
//        XCTAssertEqual(output.artist, "Artist")
//        XCTAssertEqual(output.artistSort, "Artist Sort")
//        XCTAssertEqual(output.composer, "Composer")
//        XCTAssertEqual(output.composerSort, "Composer Sort")
//        XCTAssertEqual(output.conductor, "Conductor")
//        XCTAssertEqual(output.contentGroup, "Content Group")
//        XCTAssertEqual(output.copyright, "2020 Copyright")
//        XCTAssertEqual(output.encodedBy, "Encoded By")
//        XCTAssertEqual(output.encodingSettings, "Encoding Settings")
//        XCTAssertEqual(output.fileOwner, "File Owner")
//        XCTAssertEqual(output.grouping, "Grouping")
//        XCTAssertEqual(output.initialKey, .aFlatMinor)
//        XCTAssertEqual(output.lyricist, "Lyricist")
//        XCTAssertEqual(output.mood, "Mood")
//        XCTAssertEqual(output.movement, "Movement Name")
//        XCTAssertEqual(output.originalAlbum, "Original Album")
//        XCTAssertEqual(output.originalArtist, "Original Artist")
//        XCTAssertEqual(output.originalFilename, "Original Filename")
//        XCTAssertEqual(output.originalLyricist, "Original Lyricist")
//        XCTAssertEqual(output.podcastID, "Podcast ID")
//        XCTAssertEqual(output.podcastCategory, "Podcast Category")
//        XCTAssertEqual(output.podcastFeed, "http://podcast.url")
//        XCTAssertEqual(output.podcastDescription, "Podcast Description")
//        XCTAssertEqual(output.podcastKeywords, ["Podcast", "Keywords"])
//        XCTAssertEqual(output.publisher, "Publisher")
//        XCTAssertEqual(output.producedNotice, "2020 Produced Notice")
//        XCTAssertEqual(output.radioStation, "Radio Station")
//        XCTAssertEqual(output.radioStationOwner, "Radio Station Owner")
//        XCTAssertEqual(output.subtitle, "Subtitle")
//        XCTAssertEqual(output.setSubtitle, "Set Subtitle")
//        XCTAssertEqual(output.title, "Title")
//        XCTAssertEqual(output.titleSort, "Title Sort")
//
//        XCTAssertEqual(output.compilation, true)
//        XCTAssertEqual(output.bpm, 99)
//        XCTAssertEqual(output.isrc, "987654321098")
//        XCTAssertEqual(output.movementNumber, 5)
//        XCTAssertEqual(output.movementCount, 6)
//        XCTAssertEqual(output.playlistDelay, 0)
//
//        XCTAssertEqual(output.audioSourceWebpage, "http://audiosource.url")
//        XCTAssertEqual(output.audioFileWebpage, "http://audiofile.url")
//        XCTAssertEqual(output.artistWebpage, "http://artist.url")
//        XCTAssertEqual(output.copyrightWebpage, "http://copyright.url")
//        XCTAssertEqual(output.paymentWebpage, "http://payment.url")
//        XCTAssertEqual(output.publisherWebpage, "http://publisher.url")
//        XCTAssertEqual(output.radioStationWebpage, "http://radiostation.url")
//
//        XCTAssertEqual(output.languages, [.english])
//
//        XCTAssertEqual(output.trackNumber.index, 6)
//        XCTAssertEqual(output.trackNumber.total, 7)
//        XCTAssertEqual(output.discNumber.index, 4)
//        XCTAssertEqual(output.discNumber.total, 5)
//
//        XCTAssertEqual(output.involvementCreditsList[.director], ["Director Name"])
//        XCTAssertEqual(output.involvementCreditsList[.producer], ["Producer Name"])
//        XCTAssertEqual(output.musicianCreditsList[.soprano], ["Soprano Name"])
//        XCTAssertEqual(output.musicianCreditsList[.alto], ["Alto Name"])
//        XCTAssertEqual(output.encodingDateTime, testAllDate)
//        XCTAssertEqual(output.taggingDateTime, testAllDate)
//        XCTAssertEqual(output.releaseDateTime, testAllDate)
//        XCTAssertEqual(output.originalRelease, testAllDate)
//        XCTAssertEqual(output.recordingDateTime, testAllDate)
//
//        XCTAssertEqual(output[comment: "Comment", .eng], "Comment Content")
//        XCTAssertEqual(output[lyrics: "Lyrics", .eng], "Lyrics Content")
//        XCTAssertEqual(output[userDefinedUrl: "UserURL"], "http://userdefined.url")
//        XCTAssertEqual(output["UserText"], "User Text Content")
//
//        XCTAssertEqual(output.discNumber.index, 4)
//        XCTAssertEqual(output.discNumber.total, 5)
//        XCTAssertEqual(output.trackNumber.index, 6)
//        XCTAssertEqual(output.trackNumber.total, 7)
//
//        XCTAssertEqual(output.genre.genreCategory, .Blues)
//        XCTAssertEqual(output.genre.genre, "Blues Refinement")
//
//        XCTAssertEqual(output.mediaType.mediaType, .otherDigital)
//        XCTAssertEqual(output.mediaType.mediaTypeRefinement, .analogTransfer)
//        XCTAssertEqual(output.mediaType.additionalInformation, "Additional Information")
//
//        XCTAssertEqual(output.fileType.fileType, .MPG)
//        XCTAssertEqual(output.fileType.fileTypeRefinement, .mpegLayerIII)
//        XCTAssertEqual(output.fileType.additionalInformation, "Additional Information")
//    }
}
