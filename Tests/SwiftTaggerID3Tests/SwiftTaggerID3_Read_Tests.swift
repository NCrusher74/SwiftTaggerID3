/*
 
 SwiftTaggerID3_Read_Tests.swift
 SwiftTaggerID3
 
 Copyright ©2020 Nolaine Crusher. All rights reserved.
 
 */

import XCTest
import SwiftTaggerID3



class SwiftTaggerID3_Read_Tests: XCTestCase {
    
    // test reading of V24 tag from file
    @available(OSX 10.12, *)
    func testV24Reading() throws {
        let tag = try TestFile.v24.tag()
        
        // StringFrame
        XCTAssertEqual(tag?.album, "Album")
        XCTAssertEqual(tag?.albumArtist, "Album Artist")
        XCTAssertEqual(tag?.albumArtistSort, "Album Artist Sort")
        XCTAssertEqual(tag?.albumSort, "Album Sort")
        XCTAssertEqual(tag?.arranger, "Arranger")
        XCTAssertEqual(tag?.artist, "Artist")
        XCTAssertEqual(tag?.artistSort, "Artist Sort")
        XCTAssertEqual(tag?.author, "Artist")
        XCTAssertEqual(tag?.authorSort, "Artist Sort")
        XCTAssertEqual(tag?.composer, "Composer")
        XCTAssertEqual(tag?.composerSort, "Composer Sort")
        XCTAssertEqual(tag?.conductor, "Conductor")
        XCTAssertEqual(tag?.contentGroup, "Content Group")
        XCTAssertEqual(tag?.copyright, "2020 Copyright")
        XCTAssertEqual(tag?.encodedBy, "Encoded By")
        XCTAssertEqual(tag?.encodingSettings, "Encoding Settings")
        XCTAssertEqual(tag?.fileOwner, "File Owner")
        XCTAssertEqual(tag?.grouping, "Grouping")
        XCTAssertEqual(tag?.initialKey, .aFlatMinor)
        XCTAssertEqual(tag?.label, "Publisher")
        XCTAssertEqual(tag?.lyricist, "Lyricist")
        XCTAssertEqual(tag?.mood, "Mood")
        XCTAssertEqual(tag?.movementName, "Movement Name")
        XCTAssertEqual(tag?.originalAlbum, "Original Album")
        XCTAssertEqual(tag?.originalArtist, "Original Artist")
        XCTAssertEqual(tag?.originalFilename, "Original Filename")
        XCTAssertEqual(tag?.originalLyricist, "Original Lyricist")
        XCTAssertEqual(tag?.podcastCategory, "Podcast Category")
        XCTAssertEqual(tag?.podcastDescription, "Podcast Description")
        XCTAssertEqual(tag?.podcastID, "Podcast ID")
        XCTAssertEqual(tag?.podcastKeywords, "Podcast Keywords")
        XCTAssertEqual(tag?.producedNotice, "2020 Produced Notice")
        XCTAssertEqual(tag?.publisher, "Publisher")
        XCTAssertEqual(tag?.radioStation, "Radio Station")
        XCTAssertEqual(tag?.radioStationOwner, "Radio Station Owner")
        XCTAssertEqual(tag?.setSubtitle, "Set Subtitle")
        XCTAssertEqual(tag?.subtitle, "Subtitle")
        XCTAssertEqual(tag?.title, "Title")
        XCTAssertEqual(tag?.titleSort, "Title Sort")
        
        // StringFrame: Other
        XCTAssertEqual(tag?.artistWebpage, "http://artist.url")
        XCTAssertEqual(tag?.audioFileWebpage, "http://audiofile.url")
        XCTAssertEqual(tag?.audioSourceWebpage, "http://audiosource.url")
        XCTAssertEqual(tag?.copyrightWebpage, "http://copyright.url")
        XCTAssertEqual(tag?.paymentWebpage, "http://payment.url")
        XCTAssertEqual(tag?.podcastFeedLink, "http://podcast.url")
        XCTAssertEqual(tag?.publisherWebpage, "http://publisher.url")
        XCTAssertEqual(tag?.radioStationWebpage, "http://radiostation.url")
        XCTAssertEqual(tag?.compilation, true)
        XCTAssertEqual(tag?.bpm, 99)
        XCTAssertEqual(tag?.isrc, 987654321098)
        XCTAssertEqual(tag?.length, 9767)
        XCTAssertEqual(tag?.movementNumber, 5)
        XCTAssertEqual(tag?.totalMovements, 6)
        XCTAssertEqual(tag?.playlistDelay, 0)
        
        // StringFrame: Alternatives
        XCTAssertEqual(tag?.interpretedBy, "Arranger")
        XCTAssertEqual(tag?.narrator, "Composer")
        XCTAssertEqual(tag?.narratorSort, "Composer Sort")
        XCTAssertEqual(tag?.remixer, "Arranger")
        XCTAssertEqual(tag?.series, "Content Group")
        XCTAssertEqual(tag?.recordCompany, "Publisher")
        XCTAssertEqual(tag?.studio, "Publisher")
        XCTAssertEqual(tag?.work, "Content Group")
        
    }
    // test reading of v23 tag from file
    

    @available(OSX 10.12, *)
    func testV23Reading() throws {
        let tag = try TestFile.v23.tag()
        
        // StringFrame
        XCTAssertEqual(tag?.album, "Album")
        XCTAssertEqual(tag?.albumArtist, "Album Artist")
        XCTAssertEqual(tag?.albumArtistSort, "Album Artist Sort")
        XCTAssertEqual(tag?.albumSort, "Album Sort")
        XCTAssertEqual(tag?.arranger, "Arranger")
        XCTAssertEqual(tag?.artist, "Artist")
        XCTAssertEqual(tag?.artistSort, "Artist Sort")
        XCTAssertEqual(tag?.author, "Artist")
        XCTAssertEqual(tag?.authorSort, "Artist Sort")
        XCTAssertEqual(tag?.composer, "Composer")
        XCTAssertEqual(tag?.composerSort, "Composer Sort")
        XCTAssertEqual(tag?.conductor, "Conductor")
        XCTAssertEqual(tag?.contentGroup, "Content Group")
        XCTAssertEqual(tag?.copyright, "2020 Copyright")
        XCTAssertEqual(tag?.encodedBy, "Encoded By")
        XCTAssertEqual(tag?.encodingSettings, "Encoding Settings")
        XCTAssertEqual(tag?.fileOwner, "File Owner")
        XCTAssertEqual(tag?.grouping, "Grouping")
        XCTAssertEqual(tag?.initialKey, .aFlatMinor)
        XCTAssertEqual(tag?.interpretedBy, "Arranger")
        XCTAssertEqual(tag?.lyricist, "Lyricist")
        XCTAssertEqual(tag?.movementName, "Movement Name")
        XCTAssertEqual(tag?.originalAlbum, "Original Album")
        XCTAssertEqual(tag?.originalArtist, "Original Artist")
        XCTAssertEqual(tag?.originalFilename, "Original Filename")
        XCTAssertEqual(tag?.originalLyricist, "Original Lyricist")
        XCTAssertEqual(tag?.podcastCategory, "Podcast Category")
        XCTAssertEqual(tag?.podcastDescription, "Podcast Description")
        XCTAssertEqual(tag?.podcastID, "Podcast ID")
        XCTAssertEqual(tag?.podcastKeywords, "Podcast Keywords")
        XCTAssertEqual(tag?.publisher, "Publisher")
        XCTAssertEqual(tag?.radioStation, "Radio Station")
        XCTAssertEqual(tag?.radioStationOwner, "Radio Station Owner")
        XCTAssertEqual(tag?.subtitle, "Subtitle")
        XCTAssertEqual(tag?.title, "Title")
        XCTAssertEqual(tag?.titleSort, "Title Sort")
        
        // StringFrame: Other
        XCTAssertEqual(tag?.compilation, true)
        XCTAssertEqual(tag?.bpm, 99)
        XCTAssertEqual(tag?.isrc, 987654321098)
        XCTAssertEqual(tag?.length, 9767)
        XCTAssertEqual(tag?.movementNumber, 5)
        XCTAssertEqual(tag?.totalMovements, 6)
        XCTAssertEqual(tag?.playlistDelay, 0)
        XCTAssertEqual(tag?.artistWebpage, "http://artist.url")
        XCTAssertEqual(tag?.audioFileWebpage, "http://audiofile.url")
        XCTAssertEqual(tag?.audioSourceWebpage, "http://audiosource.url")
        XCTAssertEqual(tag?.copyrightWebpage, "http://copyright.url")
        XCTAssertEqual(tag?.paymentWebpage, "http://payment.url")
        XCTAssertEqual(tag?.podcastFeedLink, "http://podcast.url")
        XCTAssertEqual(tag?.publisherWebpage, "http://publisher.url")
        XCTAssertEqual(tag?.radioStationWebpage, "http://radiostation.url")
        
        // StringFrame: Alternative String Frames
        XCTAssertEqual(tag?.narrator, "Composer")
        XCTAssertEqual(tag?.narratorSort, "Composer Sort")
        XCTAssertEqual(tag?.remixer, "Arranger")
        XCTAssertEqual(tag?.studio, "Publisher")
        XCTAssertEqual(tag?.label, "Publisher")
        XCTAssertEqual(tag?.recordCompany, "Publisher")
        XCTAssertEqual(tag?.series, "Content Group")
        XCTAssertEqual(tag?.work, "Content Group")
    }
    
    // test reading of v22 tag from file
    

    @available(OSX 10.12, *)
    func testV22Reading() throws {
        let tag = try TestFile.v22.tag()
        
        // StringFrame
        XCTAssertEqual(tag?.album, "Album")
        XCTAssertEqual(tag?.albumArtist, "Album Artist")
        XCTAssertEqual(tag?.albumArtistSort, "Album Artist Sort")
        XCTAssertEqual(tag?.albumSort, "Album Sort")
        XCTAssertEqual(tag?.arranger, "Arranger")
        XCTAssertEqual(tag?.artist, "Artist")
        XCTAssertEqual(tag?.artistSort, "Artist Sort")
        XCTAssertEqual(tag?.composer, "Composer")
        XCTAssertEqual(tag?.composerSort, "Composer Sort")
        XCTAssertEqual(tag?.conductor, "Conductor")
        XCTAssertEqual(tag?.contentGroup, "Content Group")
        XCTAssertEqual(tag?.copyright, "2020 Copyright")
        XCTAssertEqual(tag?.encodedBy, "Encoded By")
        XCTAssertEqual(tag?.encodingSettings, "Encoding Settings")
        XCTAssertEqual(tag?.lyricist, "Lyricist")
        XCTAssertEqual(tag?.originalAlbum, "Original Album")
        XCTAssertEqual(tag?.originalArtist, "Original Artist")
        XCTAssertEqual(tag?.originalFilename, "Original Filename")
        XCTAssertEqual(tag?.originalLyricist, "Original Lyricist")
        XCTAssertEqual(tag?.publisher, "Publisher")
        XCTAssertEqual(tag?.radioStation, "Radio Station")
        XCTAssertEqual(tag?.radioStationOwner, "Radio Station Owner")
        XCTAssertEqual(tag?.subtitle, "Subtitle")
        XCTAssertEqual(tag?.title, "Title")
        
        // StringFrame: Other content
        XCTAssertEqual(tag?.initialKey, .aFlatMinor)
        XCTAssertEqual(tag?.artistWebpage, "http://artist.url")
        XCTAssertEqual(tag?.audioFileWebpage, "http://audiofile.url")
        XCTAssertEqual(tag?.audioSourceWebpage, "http://audiosource.url")
        XCTAssertEqual(tag?.copyrightWebpage, "http://copyright.url")
        XCTAssertEqual(tag?.publisherWebpage, "http://publisher.url")
        XCTAssertEqual(tag?.compilation, true)
        XCTAssertEqual(tag?.bpm, 99)
        XCTAssertEqual(tag?.isrc, 987654321098)
        XCTAssertEqual(tag?.length, 9767)
        XCTAssertEqual(tag?.playlistDelay, 0)
        
        // StringFrame: Alternative String Names
        XCTAssertEqual(tag?.titleSort, "Title Sort")
        XCTAssertEqual(tag?.label, "Publisher")
        XCTAssertEqual(tag?.recordCompany, "Publisher")
        XCTAssertEqual(tag?.author, "Artist")
        XCTAssertEqual(tag?.authorSort, "Artist Sort")
        XCTAssertEqual(tag?.interpretedBy, "Arranger")
        XCTAssertEqual(tag?.narrator, "Composer")
        XCTAssertEqual(tag?.narratorSort, "Composer Sort")
        XCTAssertEqual(tag?.remixer, "Arranger")
        XCTAssertEqual(tag?.work, "Content Group")
    }
    
    @available(OSX 10.12, *)
    func testListMetdata() throws {
        var tag = try TestFile.v24.tag()
        
    }
}
