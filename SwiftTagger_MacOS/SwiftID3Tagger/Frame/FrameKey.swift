//
//  FrameKey.swift
//  WwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/11/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

/** the key used to refer to a particular frame. Usually this is the rawValue of the `FrameLayoutIdentifier`, but in cases where a frame may be duplicated, will derive from information contained in the frame, such as a description field */
public enum FrameKey: Hashable {
    
    /** The 'Album/Movie/Show title' frame is intended for the title of the recording (or source of sound) from which the audio in the file is taken. */
    case album
    /** The 'Album sort order' frame defines a string which should be used instead of the album name (TALB) for sorting purposes. E.g. an album named "A Soundtrack" might preferably be sorted as "Soundtrack". */
    case albumSort
    /** The ID3 spec describes this frame as: "The 'Band/Orchestra/Accompaniment' frame is used for additional information about the performers in the recording." But usually it just serves as the AlbumArtist frame */
    case albumArtist
    /** The 'Performer sort order' frame defines a string which should be used instead of the performer (TPE2) for sorting purposes. */
    case albumArtistSort
    /** The 'Interpreted, remixed, or otherwise modified by' frame contains more information about the people behind a remix and similar interpretations of another existing piece. */
    case arranger
    /** The 'Lead artist/Lead performer/Soloist/Performing group' is used for the main artist. */
    case artist
    /** Frame used for sorting by performer in iTunes */
    case artistSort
    /** The 'Official artist/performer webpage' frame is a URL pointing at the artists official webpage. There may be more than one "WOAR" frame in a tag if the audio contains more than one performer, but not with the same content. */
    case artistWebpage
    /// embedded image frame
    case attachedPicture
    /** The 'Official audio file webpage' frame is a URL pointing at a file specific webpage. */
    case audioFileWebpage
    /** The 'Official audio source webpage' frame is a URL pointing at the
     official webpage for the source of the audio file, e.g. a movie. */
    case audioSourceWebpage
    /** The 'BPM' frame contains the number of beats per minute in the main part of the audio. The BPM is an integer and represented as a numerical string. */
    case bpm
    /** The purpose of this frame is to describe a single chapter within an audio file. */
    case chapter(elementID: String)
    /** This frame is intended for any kind of full text information that does not fit in any other frame. ALLOWS `(/n)` new line characters */
    case comments(description: String)
    /** This is a simple text frame that iTunes uses to indicate if the file is part of a compilation. */
    case compilation
    /** The 'Composer' frame is intended for the name of the composer. */
    case composer
    /** Frame used for sorting by composer in iTunes */
    case composerSort
    /** The 'Conductor' frame is used for the name of the conductor. */
    case conductor
    /** The 'Content group description' frame is used if the sound belongs to a larger category of sounds/music. For example, classical music is often sorted in different musical sections (e.g. "Piano Concerto", "Weather - Hurricane"). */
    case contentGroup
    /** The 'Copyright message' frame, in which the string must begin with a year and a space character (making five characters), is intended for the copyright holder of the original sound, not the audio file itself. */
    case copyright
    /** The 'Copyright/Legal information' frame is a URL pointing at a webpage where the terms of use and ownership of the file is described. */
    case copyrightWebpage
    /** The 'Date' frame is a numeric string in the DDMM format containing the date for the recording. This field is always four characters long. FOR VERSION 2.4: This frame is replaced by the TDRC frame, `Recording time` */
    case date
    /** The 'Part of a set' frame is a numeric string that describes which part of a set the audio came from. This frame is used if the source described in the "TALB" frame is divided into several mediums, e.g. a double CD. The value MAY be extended with a "/" character and a numeric string containing the total number of parts in the set. E.g. "1/2". */
    case discNumber
    /** The 'Encoding time' frame contains a timestamp describing when the audio was encoded. Timestamp format is described in the ID3v2 structure document [ID3v2-strct]. */
    case encodingTime
    /** The 'Encoded by' frame contains the name of the person or organisation that encoded the audio file. This field may contain a copyright message, if the audio file also is copyrighted by the encoder. */
    case encodedBy
    /** The 'Software/Hardware and settings used for encoding' frame includes the used audio encoder and its settings when the file was encoded. Hardware refers to hardware encoders, not the computer on which a program was run. */
    case encodingSettings
    /** The 'File type' frame indicates which type of audio this tag defines. */
    case fileType
    /** The 'File owner/licensee' frame contains the name of the owner or licensee of the file and it's contents. */
    case fileOwner
    /** The 'Content type', which ID3v1 was stored as a one byte numeric value only, is now a string. You may use one or several of the ID3v1 types as numerical strings, or, since the category list would be impossible to maintain with accurate and up to date categories, define your own. Example: "21" $00 "Eurodisco" $00
     You may also use any of the following keywords:
     RX  Remix
     CR  Cover */
    case genre(description: String)
    /** Frame used by iTunes to group works */
    case grouping
    /** The 'Initial key' frame contains the musical key in which the sound starts. It is represented as a string with a maximum length of three characters. The ground keys are represented with "A","B","C","D","E", "F" and "G" and halfkeys represented with "b" and "#". Minor is represented as "m", e.g. "Dbm" $00. Off key is represented with an "o" only. */
    case initialKey
    /** The 'Involved people list' is very similar to the musician credits list, but maps between functions, like producer, and names. */
    case involvedPeopleList
    /** The 'ISRC' frame should contain the International Standard Recording Code [ISRC] (12 characters). */
    case isrc
    /** The 'Language' frame should contain the languages of the text or lyrics spoken or sung in the audio. The language is represented with three characters according to ISO-639-2 [ISO-639-2]. If more than one language is used in the text their language codes should follow according to the amount of their usage, e.g. "eng" $00 "sve" $00. */
    case languages(language: String)
    /** The 'Length' frame contains the length of the audio file in milliseconds, represented as a numeric string. */
    case length
    /** The 'Lyricist/Text writer' frame is intended for the writer of the text or lyrics in the recording. */
    case lyricist
    /** The 'Media type' frame describes from which media the sound originated. This may be a text string or a reference to predefined media types */
    case mediaType
    /** The 'Mood' frame is intended to reflect the mood of the audio with a few keywords, e.g. "Romantic" or "Sad". */
    case mood
    /** Frame used by iTunes to denote the number of movements in a work */
    case movementCount
    /** Frame used by iTunes to name the movements of a multi-part work */
    case movementName
    /** Frame used by iTunes to denote the total number of movements in a work */
    case movementNumber
    /** The 'Musician credits list' is intended as a mapping between instruments and the musician that played it. Every odd field is an instrument and every even is an artist or a comma delimited list of artists. */
    case musicianCreditsList
    /** The 'Original album/movie/show title' frame is intended for the title of the original recording (or source of sound), if for example the music in the file should be a cover of a previously released song.*/
    case originalAlbum
    /** The 'Original artist/performer' frame is intended for the performer of the original recording, if for example the music in the file should be a cover of a previously released song. */
    case originalArtist
    /** The 'Original filename' frame contains the preferred filename for the file, since some media doesn't allow the desired length of the filename. The filename is case sensitive and includes its suffix. */
    case originalFilename
    /** The 'Original lyricist/text writer' frame is intended for the text writer of the original recording, if for example the music in the file should be a cover of a previously released song. */
    case originalLyricist
    /** The 'Original release time' frame contains a timestamp describing when the original recording of the audio was released. */
    case originalReleaseTime
    /** The 'Payment' frame is a URL pointing at a webpage that will handle the process of paying for this file. */
    case paymentWebpage
    /** The 'Playlist delay' defines the numbers of milliseconds of silence that should be inserted before this audio. The value zero indicates that this is a part of a multifile audio track that should be played continuously. */
    case playlistDelay
    /** Frame used by iTunes to categorize podcasts */
    case podcastCategory
    /** Frame used by iTunes to describe podcasts */
    case podcastDescription
    /** Frame used by iTunes to list a podcast's ID */
    case podcastID
    /** Frame used by iTunes to for keywords describing a podcast */
    case podcastKeywords
    /** Frame used by iTunes to list the web feed of a podcast */
    case podcastFeedLink
    /** The 'Produced notice' frame, in which the string must begin with a year and a space character (making five characters), is intended for the production copyright holder of the original sound, not the audio file itself. */
    case producedNotice
    /** The 'Publisher' frame simply contains the name of the label or publisher. NEW IN VERSION 2.4*/
    case publisher
    /** The 'Publishers official webpage' frame is a URL pointing at the official webpage for the publisher. */
    case publisherWebpage
    /** The 'Internet radio station name' frame contains the name of the internet radio station from which the audio is streamed. */
    case radioStation
    /** The 'Internet radio station owner' frame contains the name of the owner of the internet radio station from which the audio is streamed. */
    case radioStationOwner
    /** The 'Official Internet radio station homepage' contains a URL pointing at the homepage of the internet radio station. */
    case radioStationWebpage
    /** The 'Recording dates' frame is a intended to be used as complement to the "TYE", "TDA" and "TIM" frames. E.g. "4th-7th June, 12th June" in combination with the "TYE" frame. */
    case recordingDate
    /** The 'Release time' frame contains a timestamp describing when the audio was first released. NEW IN VERSION 2.4 */
    case releaseTime
    /** The 'Set subtitle' frame is intended for the subtitle of the part of a set this track belongs to. NEW IN VERSION 2.4 */
    case setSubtitle
    /** The 'Subtitle/Description refinement' frame is used for information directly related to the contents title (e.g. "Op. 16" or "Performed live at Wembley"). */
    case subtitle
    /** The purpose of "CTOC" frames is to allow a table of contents to be defined. In the simplest case, a single "CTOC" frame can be used to provide a flat (single-level) table of contents. However, multiple "CTOC" frames can also be used to define a hierarchical (multi-level) table of contents.  */
    case tableOfContents(elementID: String)
    /** The 'Tagging time' frame contains a timestamp describing then the audio was tagged. NEW IN VERSION 2.4 */
    case taggingTime
    /** The 'Time' frame is a numeric string in the HHMM format containing the time for the recording. This field is always four characters long. FOR VERSION 2.4: This frame is replaced by the TDRC frame, `Recording time` */
    case time
    /** The 'Title/Songname/Content description' frame is the actual name of the piece (e.g. "Adagio", "Hurricane Donna"). */
    case title
    /** The 'Title sort order' frame defines a string which should be used instead of the title (TIT2) for sorting purposes. */
    case titleSort
    /** The 'Track number/Position in set' frame is a numeric string containing the order number of the audio-file on its original recording. This MAY be extended with a "/" character and a numeric string containing the total number of tracks/elements on the original recording. E.g. "4/9". */
    case trackNumber
    /** This frame contains the lyrics of the song or a text transcription of other vocal activities. */
    case unsynchronizedLyrics(description: String)
    /** This frame is intended for one-string text information concerning the audio file in a similar way to the other "T"-frames. ALLOWS `(/n)` new line characters */
    case userDefinedText(description: String)
    /** This frame is intended for URL [URL] links concerning the audio file in a similar way to the other "W"-frames. */
    case userDefinedWebpage(description: String)
    /** The 'Year' frame is a numeric string with a year of the recording. This frames is always four characters long (until the year 10000). FOR VERSION 2.4: This frame is replaced by the TDRC frame, 'Recording time' */
    case year
    case unknown(uuid: UUID)
    
    // MARK: Alternate Frame Keys
    /// also known as `Arranger` or `Interpreter`. Maps to the `Arranger` frame. If another `Arranger` frame is already present, the frame will be created as a `UserDefinedText` frame with the description, "Remixer"
    static var remixer: FrameKey { return .arranger }
    
    /// also known as `Remixer` or `Arranger`. Maps to the `Arranger` frame. If another `Arranger` frame is already present, the frame will be created as a `UserDefinedText` frame with the description, "Interpreted By"
    static var interpretedBy: FrameKey { return .arranger }
    
    /// also known as `contentGroup`. Maps to the `contentGroup` frame. If another `contentGroup` frame is already present, the frame will be created as a `grouping` frame. If another `grouping` frame is present, the frame will be created as a `UserDefinedText` frame with the description, "Work"
    static var work: FrameKey { return .contentGroup }
    
    /// Maps to the `subtitle` frame, which is often used for description text. If another `subtitle` frame is already present, the frame will be created as a `Comment` frame with the description, "Description"
    static var description: FrameKey { return .subtitle }
    
    /// For audiobook use. Maps to the `artist` frame, which is usually used for authors of audiobooks.
    static var author: FrameKey { return .artist }
    static var authorSort: FrameKey { return .authorSort }
    
    /// For audiobook use. Maps to the `composer` frame, which is usually used for narrators of audiobooks
    static var narrator: FrameKey { return .composer }
    static var narratorSort: FrameKey { return .composerSort }
    
    /// if there is already a `publisher` this should go to `UserText`
    static var recordCompany: FrameKey { return .publisher }
    static var label: FrameKey { return .publisher }
    static var studio: FrameKey { return .publisher }
    
    
    static var series: FrameKey { return .contentGroup }
    
    // These should be pre-set options for involved people and/or musician credits
    static var producer: FrameKey { return involvedPeopleList }
    static var executiveProducer: FrameKey { return involvedPeopleList }
    static var songProducer: FrameKey { return involvedPeopleList }
    static var engineer: FrameKey { return involvedPeopleList }
    static var director: FrameKey { return involvedPeopleList }
    static var performer: FrameKey { return involvedPeopleList } // or Musician Credit List if version 2.4
    static var soloist: FrameKey { return involvedPeopleList } // or Musician Credit List if version 2.4
    static var cast: FrameKey { return involvedPeopleList }
    
    
//    var layout: FrameLayoutIdentifier {
//        switch self {
//
//            case .album:
//                return .known(KnownFrameLayoutIdentifier.album)
//            case .albumSort:
//                return .known(KnownFrameLayoutIdentifier.albumSort)
//            case .albumArtist:
//                return .known(KnownFrameLayoutIdentifier.albumArtist)
//            case .albumArtistSort:
//                return .known(KnownFrameLayoutIdentifier.albumArtistSort)
//            case .arranger:
//                return .known(KnownFrameLayoutIdentifier.arranger)
//            case .artist:
//                return .known(KnownFrameLayoutIdentifier.artist)
//            case .artistSort:
//                return .known(KnownFrameLayoutIdentifier.artistSort)
//            case .artistWebpage:
//                return .known(KnownFrameLayoutIdentifier.artistWebpage)
//            case .attachedPicture:
//                return .known(KnownFrameLayoutIdentifier.attachedPicture)
//            case .audioFileWebpage:
//                return .known(KnownFrameLayoutIdentifier.audioFileWebpage)
//            case .audioSourceWebpage:
//                return .known(KnownFrameLayoutIdentifier.audioSourceWebpage)
//            case .bpm:
//                return .known(KnownFrameLayoutIdentifier.bpm)
//            case .chapter(elementID: let elementID):
//                return .known(KnownFrameLayoutIdentifier.chapter)
//            case .comments(description: let description):
//                return .known(KnownFrameLayoutIdentifier.comments)
//            case .compilation:
//                return .known(KnownFrameLayoutIdentifier.compilation)
//            case .composer:
//                return .known(KnownFrameLayoutIdentifier.composer)
//            case .composerSort:
//                return .known(KnownFrameLayoutIdentifier.composerSort)
//            case .conductor:
//                return .known(KnownFrameLayoutIdentifier.conductor)
//            case .contentGroup:
//                return .known(KnownFrameLayoutIdentifier.contentGroup)
//            case .copyright:
//                return .known(KnownFrameLayoutIdentifier.copyright)
//            case .copyrightWebpage:
//                return .known(KnownFrameLayoutIdentifier.copyrightWebpage)
//            case .date:
//                return .known(KnownFrameLayoutIdentifier.date)
//            case .discNumber:
//                return .known(KnownFrameLayoutIdentifier.discNumber)
//            case .encodingTime:
//                return .known(KnownFrameLayoutIdentifier.encodingTime)
//            case .encodedBy:
//                return .known(KnownFrameLayoutIdentifier.encodedBy)
//            case .encodingSettings:
//                return .known(KnownFrameLayoutIdentifier.encodingSettings)
//            case .fileType:
//                return .known(KnownFrameLayoutIdentifier.fileType)
//            case .fileOwner:
//                return .known(KnownFrameLayoutIdentifier.fileOwner)
//            case .genre(description: let description):
//                return .known(KnownFrameLayoutIdentifier.genre)
//            case .grouping:
//                return .known(KnownFrameLayoutIdentifier.grouping)
//            case .initialKey:
//                return .known(KnownFrameLayoutIdentifier.initialKey)
//            case .involvedPeopleList:
//                return .known(KnownFrameLayoutIdentifier.involvedPeopleList)
//            case .isrc:
//                return .known(KnownFrameLayoutIdentifier.isrc)
//            case .languages(language: let language):
//                return .known(KnownFrameLayoutIdentifier.languages)
//            case .length:
//                return .known(KnownFrameLayoutIdentifier.length)
//            case .lyricist:
//                return .known(KnownFrameLayoutIdentifier.lyricist)
//            case .mediaType:
//                return .known(KnownFrameLayoutIdentifier.mediaType)
//            case .mood:
//                return .known(KnownFrameLayoutIdentifier.mood)
//            case .movementCount:
//                return .known(KnownFrameLayoutIdentifier.movementCount)
//            case .movementName:
//                return .known(KnownFrameLayoutIdentifier.movementName)
//            case .movementNumber:
//                return .known(KnownFrameLayoutIdentifier.movementNumber)
//            case .musicianCreditsList:
//                return .known(KnownFrameLayoutIdentifier.musicianCreditsList)
//            case .originalAlbum:
//                return .known(KnownFrameLayoutIdentifier.originalAlbum)
//            case .originalArtist:
//                return .known(KnownFrameLayoutIdentifier.originalArtist)
//            case .originalFilename:
//                return .known(KnownFrameLayoutIdentifier.originalFilename)
//            case .originalLyricist:
//                return .known(KnownFrameLayoutIdentifier.originalLyricist)
//            case .originalReleaseTime:
//                return .known(KnownFrameLayoutIdentifier.originalReleaseTime)
//            case .paymentWebpage:
//                return .known(KnownFrameLayoutIdentifier.paymentWebpage)
//            case .playlistDelay:
//                return .known(KnownFrameLayoutIdentifier.playlistDelay)
//            case .podcastCategory:
//                return .known(KnownFrameLayoutIdentifier.podcastCategory)
//            case .podcastDescription:
//                return .known(KnownFrameLayoutIdentifier.podcastDescription)
//            case .podcastID:
//                return .known(KnownFrameLayoutIdentifier.podcastID)
//            case .podcastKeywords:
//                return .known(KnownFrameLayoutIdentifier.podcastKeywords)
//            case .podcastFeedLink:
//                return .known(KnownFrameLayoutIdentifier.podcastFeedLink)
//            case .producedNotice:
//                return .known(KnownFrameLayoutIdentifier.producedNotice)
//            case .publisher:
//                return .known(KnownFrameLayoutIdentifier.publisher)
//            case .publisherWebpage:
//                return .known(KnownFrameLayoutIdentifier.publisherWebpage)
//            case .radioStation:
//                return .known(KnownFrameLayoutIdentifier.radioStation)
//            case .radioStationOwner:
//                return .known(KnownFrameLayoutIdentifier.radioStationOwner)
//            case .radioStationWebpage:
//                return .known(KnownFrameLayoutIdentifier.radioStationWebpage)
//            case .recordingDate:
//                return .known(KnownFrameLayoutIdentifier.recordingDate)
//            case .releaseTime:
//                return .known(KnownFrameLayoutIdentifier.releaseTime)
//            case .setSubtitle:
//                return .known(KnownFrameLayoutIdentifier.setSubtitle)
//            case .subtitle:
//                return .known(KnownFrameLayoutIdentifier.subtitle)
//            case .tableOfContents(elementID: let elementID):
//                return .known(KnownFrameLayoutIdentifier.tableOfContents)
//            case .taggingTime:
//                return .known(KnownFrameLayoutIdentifier.taggingTime)
//            case .time:
//                return .known(KnownFrameLayoutIdentifier.time)
//            case .title:
//                return .known(KnownFrameLayoutIdentifier.title)
//            case .titleSort:
//                return .known(KnownFrameLayoutIdentifier.titleSort)
//            case .trackNumber:
//                return .known(KnownFrameLayoutIdentifier.trackNumber)
//            case .unsynchronizedLyrics(description: let description):
//                return .known(KnownFrameLayoutIdentifier.unsynchronizedLyrics)
//            case .userDefinedText(description: let description):
//                return .known(KnownFrameLayoutIdentifier.userDefinedText)
//            case .userDefinedWebpage(description: let description):
//                return .known(KnownFrameLayoutIdentifier.userDefinedWebpage)
//            case .year:
//                return .known(KnownFrameLayoutIdentifier.year)
//            case .unknown(uuid: let uuid):
//                return .unknown("\(uuid)")
//        }
//    }
    
    
}
