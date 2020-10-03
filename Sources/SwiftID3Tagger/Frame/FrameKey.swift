//
//  FrameKey.swift
//  SwiftTaggerID3
//
//  Created by Nolaine Crusher on 9/23/20.
//

import Foundation
import SwiftLanguageAndLocaleCodes

/// The unique key used to refer to a particular frame.
///
/// Usually the `FrameKey` is the ID3 frame identifier string, but in cases where a frame may be duplicated within a valid ID3 tag, this key will derive from additional information contained in the frame, such as a description field
public enum FrameKey: Hashable {
    /// `Album/Movie/Show` title frame
    ///
    /// Intended for the title of the recording (or source of sound) from which the audio in the file is taken.
    case album
    /// `Album sort order` frame
    ///
    /// Defines a string which should be used instead of the album name (`TALB`) for sorting purposes. E.g. an album named "A Soundtrack" might preferably be sorted as "Soundtrack".
    ///
    /// In audiobook metadata, this is often used as the book title, especially important when the book is stored in multiple files and each one has a different name in the `Title` frame
    case albumSort
    /// `AlbumArtist` frame
    ///
    /// The ID3 spec describes this frame as: `Band/Orchestra/Accompaniment` frame used for additional information about the performers in the recording. But usually it just serves as the AlbumArtist frame
    case albumArtist
    /// `Performer sort order` frame
    ///
    /// Defines a string which should be used instead of the performer (TPE2) for sorting purposes.
    case albumArtistSort
    /// `Interpreted, remixed, or otherwise modified by` frame
    ///
    /// Contains more information about the people behind a remix and similar interpretations of another existing piece.
    case arranger
    /// `Lead artist/Lead performer/Soloist/Performing group` frame
    ///
    /// The main artist. Also commonly used in audiobook metadata for the name of a book's author.
    case artist
    /// Frame used for sorting by performer in iTunes
    case artistSort
    /// `Official artist/performer webpage` frame
    ///
    /// A URL pointing at the artists official webpage. There may be more than one "WOAR" frame in a tag if the audio contains more than one performer, but not with the same content.
    case artistWebpage
    /// Embedded image frame
    case attachedPicture(imageType: ImageType)
    /// `Official audio file webpage` frame
    ///
    /// URL pointing at a file specific webpage.
    case audioFileWebpage
    /// `Official audio source webpage` frame
    ///
    /// URL pointing at the official webpage for the source of the audio file, e.g. a movie.
    case audioSourceWebpage
    /// `BPM` frame
    ///
    /// Contains the number of beats per minute in the main part of the audio. The BPM is an integer and represented as a numerical string.
    case bpm
    /// `Chapter` frame
    ///
    /// The purpose of this frame is to describe a single chapter within an audio file.
    case chapter(startTime: Int)
    /// `Comments` frame
    ///
    /// This frame is intended for any kind of full text information that does not fit in any other frame. ALLOWS `(/n)` new line characters.
    ///
    /// For audiobooks, this frame is frequently used to contain the book-jacket description, or "blurb"
    case comments(language: ISO6392Code, description: String)
    /// `Compilation` frame
    ///
    /// This is a simple text frame that iTunes uses to indicate if the file is part of a compilation. Contains a text string (1 or 0) representing a boolean value
    case compilation
    /// `Composer` frame
    ///
    /// The name of the composer. Also used commonly in audiobooks for the name of the narrator.
    case composer
    /// `ComposerSort` frame
    ///
    /// Frame used for sorting by composer in iTunes
    case composerSort
    /// `Conductor`
    ///
    /// The name of the conductor.
    case conductor
    /// `Content group description` frame
    ///
    /// Used if the sound belongs to a larger category of sounds/music. For example, classical music is often sorted in different musical sections (e.g. "Piano Concerto", "Weather - Hurricane").
    ///
    /// For audiobooks, this may be used to contain series data
    case contentGroup
    /// `Copyright message` frame
    ///
    /// The string must begin with a year and a space character (making five characters), is intended for the copyright holder of the original sound, not the audio file itself.
    case copyright
    /// `Copyright/Legal information` frame
    ///
    /// URL pointing at a webpage where the terms of use and ownership of the file is described.
    case copyrightWebpage
    /// `Date` frame
    ///
    /// A numeric string in the `DDMM` format containing the date for the recording. This field is always four characters long. FOR VERSION 2.4: This frame is replaced by the TDRC frame, `Recording time`
    case date
    /// `Part of a set` frame
    ///
    /// A numeric string that describes which part of a set the audio came from. This frame is used if the source described in the "TALB" frame is divided into several mediums, e.g. a double CD. The value MAY be extended with a "/" character and a numeric string containing the total number of parts in the set. E.g. "1/2".
    case discNumber
    /// `Encoding time` frame
    ///
    /// NEW IN VERSION 2.4. Contains a timestamp describing when the audio was encoded.
    ///
    /// Timestamp format is described in the ID3v2 structure document [ID3v2-strct].
    case encodingDateTime
    /// `Encoded by` frame
    ///
    /// Contains the name of the person or organisation that encoded the audio file. This field may contain a copyright message, if the audio file also is copyrighted by the encoder.
    case encodedBy
    /// `Software/Hardware and settings used for encoding` frame
    ///
    /// Includes the used audio encoder and its settings when the file was encoded. Hardware refers to hardware encoders, not the computer on which a program was run.
    case encodingSettings
    /// `File type` frame
    ///
    /// Indicates which type of audio this tag defines.
    case fileType
    /// `File owner/licensee` frame
    ///
    /// Contains the name of the owner or licensee of the file and it's contents.
    case fileOwner
    /// `Content type` (aka `Genre`)
    ///
    /// In ID3v1 was stored as a one byte numeric value only, is now a string. You may use one or several of the ID3v1 types as numerical strings, or, since the category list would be impossible to maintain with accurate and up to date categories, define your own. Example: "21" $00 "Eurodisco" $00
    ///
    /// You may also use any of the following keywords:
    ///
    /// RX  Remix
    ///
    /// CR  Cover
    case genre
    /// `Grouping` frame
    ///
    /// Frame used by iTunes to group works.
    ///
    /// May also be used as an alternative to the `ContentGroup` frame for handling audiobook series
    case grouping
    /// `Initial key` frame
    ///
    /// Contains the musical key in which the sound starts. It is represented as a string with a maximum length of three characters. The ground keys are represented with "A","B","C","D","E", "F" and "G" and halfkeys represented with "b" and "#". Minor is represented as "m", e.g. "Dbm" $00. Off key is represented with an "o" only.
    case initialKey
    /// `InvolvedPeopleList` frame
    ///
    /// In versions 2.2 and 2.3, this frame is used both for musician credit and production credit.
    ///
    /// In version 2.4, `InvolvedPeopleList` handles production and support credits, while `MusicianCreditsList` handles performer credits.
    case involvedPeopleList
    /// `ISRC` frame
    ///
    /// Should contain the International Standard Recording Code [ISRC] (12 characters).
    case isrc
    /// `Language` frame
    ///
    /// Should contain the languages of the text or lyrics spoken or sung in the audio. The language is represented with three characters according to ISO-639-2 [ISO-639-2]. If more than one language is used in the text their language codes should follow according to the amount of their usage, e.g. "eng" $00 "sve" $00.
    case languages
    /// `Length` frame
    ///
    /// Contains the length of the audio file in milliseconds, represented as a numeric string.
    case length
    /// `Lyricist/Text writer` frame
    ///
    /// Intended for the writer of the text or lyrics in the recording.
    case lyricist
    /// `Media type` frame
    ///
    /// Describes from which media the sound originated. This may be a text string or a reference to predefined media types
    case mediaType
    /// `Mood` frame.
    ///
    /// NEW IN VERSION 2.4. Intended to reflect the mood of the audio with a few keywords, e.g. "Romantic" or "Sad".
    case mood
    /// `Movement Count` Frame
    ///
    /// Used by iTunes to denote the number of movements in a work
    case movementCount
    /// `Movement Name` Frame
    ///
    /// Used by iTunes to name the movements of a multi-part work
    case movement
    /// `Movement Number` Frame
    ///
    /// Used by iTunes to denote the total number of movements in a work
    case movementNumber
    /// `Musician credits list` frame
    ///
    /// Intended as a mapping between instruments and the musician that played it. Every odd field is an instrument and every even is an artist or a comma delimited list of artists.
    case musicianCreditsList
    /// `Original album/movie/show title` frame
    ///
    /// Intended for the title of the original recording (or source of sound), if for example the music in the file should be a cover of a previously released song.
    case originalAlbum
    /// `Original artist/performer`'` frame
    ///
    /// Intended for the performer of the original recording, if for example the music in the file should be a cover of a previously released song.
    case originalArtist
    /// `Original filename` frame
    ///
    /// Contains the preferred filename for the file, since some media doesn't allow the desired length of the filename. The filename is case sensitive and includes its suffix.
    case originalFilename
    /// `Original lyricist/text writer` frame
    ///
    /// Intended for the text writer of the original recording, if for example the music in the file should be a cover of a previously released song.
    case originalLyricist
    /// `Original release time` frame
    ///
    /// Contains a timestamp describing when the original recording of the audio was released.
    case originalReleaseDateTime
    /// `Payment Webpage` frame
    ///
    /// URL pointing at a webpage that will handle the process of paying for this file.
    case paymentWebpage
    /// `Playlist delay` frame
    ///
    /// Defines the numbers of milliseconds of silence that should be inserted before this audio. The value zero indicates that this is a part of a multifile audio track that should be played continuously.
    case playlistDelay
    /// `Podcast Category` frame
    ///
    /// Used by iTunes to categorize podcasts
    case podcastCategory
    /// `Podcast Description` Frame
    ///
    /// Used by iTunes to describe podcasts
    case podcastDescription
    /// `PodcastID` Frame
    ///
    /// Used by iTunes to list a podcast's ID
    case podcastID
    /// `Podcast Keywords` Frame
    ///
    /// Used by iTunes to for keywords describing a podcast
    case podcastKeywords
    /// `Podcast Feedlink `Frame
    ///
    /// Used by iTunes to list the web feed of a podcast (despite the identifier beginning with W, this is a string frame
    case podcastFeed
    /// `Produced notice` frame,
    ///
    /// NEW IN VERSION 2.4. The string must begin with a year and a space character (making five characters). Intended for the production copyright holder of the original sound, not the audio file itself.
    case producedNotice
    /// `Publisher` frame
    ///
    /// Simply contains the name of the label or publisher.4
    case publisher
    /// `Publishers official webpage` frame
    ///
    /// URL pointing at the official webpage for the publisher.
    case publisherWebpage
    /// `Internet radio station name` frame
    ///
    /// Contains the name of the internet radio station from which the audio is streamed.
    case radioStation
    /// `Internet radio station owner` frame
    ///
    /// Contains the name of the owner of the internet radio station from which the audio is streamed.
    case radioStationOwner
    /// `Official Internet radio station homepage` frame
    ///
    /// A URL pointing at the homepage of the internet radio station.
    case radioStationWebpage
    /// `Recording dates` frame
    ///
    /// (versions 2.2 and 2.3 only) Intended to be used as complement to the "TYE", "TDA" and "TIM" frames. E.g. "4th-7th June, 12th June" in combination with the "TYE" frame.
    case recordingDateTime
    /// `Release time` frame
    ///
    /// Contains a timestamp describing when the audio was first released. NEW IN VERSION 2.4
    case releaseDateTime
    /// `Set subtitle` frame
    ///
    /// Intended for the subtitle of the part of a set this track belongs to. NEW IN VERSION 2.4
    case setSubtitle
    /// `Subtitle/Description refinement` frame
    ///
    /// Used for information directly related to the contents title (e.g. "Op. 16" or "Performed live at Wembley").
    case subtitle
    /// `TableOfContents` frame
    ///
    /// The purpose of "CTOC" frames is to allow a table of contents to be defined.
    ///
    /// In the simplest case, a single "CTOC" frame can be used to provide a flat (single-level) table of contents. However, multiple "CTOC" frames can also be used to define a hierarchical (multi-level) table of contents.
    ///
    /// NOTE: `SwiftTaggerID3` does not support multiple TOC frames
    case tableOfContents
    /// `Tagging time` frame
    ///
    /// Contains a timestamp describing then the audio was tagged. NEW IN VERSION  2.4
    case taggingDateTime
    /// `Time` frame
    ///
    /// (versions 2.2 and 2.3 only) A numeric string in the HHMM format containing the time for the recording. This field is always four characters long. FOR VERSION 2.4: This frame is replaced by the TDRC frame, `Recording time`
    case time
    /// `Title/Songname/Content description`'` frame
    ///
    /// The actual name of the piece (e.g. "Adagio", "Hurricane Donna").
    ///
    /// For audiobooks that are stored in multiple files, this is usually the title of the part contained in the file, rather than the book title.
    case title
    /// `Title sort order` frame
    ///
    /// Defines a string which should be used instead of the title (TIT2) for sorting purposes.
    case titleSort
    /// `Track number/Position in set` frame
    ///
    /// A numeric string containing the order number of the audio-file on its original recording. This MAY be extended with a "/" character and a numeric string containing the total number of tracks/elements on the original recording. E.g. "4/9".
    case trackNumber
    /// `UnsynchronizedLyrics` frame
    ///
    /// This frame contains the lyrics of the song or a text transcription of other vocal activities.
    ///
    /// For audiobooks, this is commonly used to contain a long book-jacket description or "blurb"
    case unsynchronizedLyrics(language: ISO6392Code, description: String)
    /// `UserText` frame
    ///
    /// This frame is intended for one-string text information concerning the audio file in a similar way to the other "T"-frames. DOES NOT ALLOW `(/n)` new line characters
    case userDefinedText(String)
    /// `UserDefinedWebpage` frame
    ///
    /// This frame is intended for URL [URL] links concerning the audio file in a similar way to the other "W"-frames.
    case userDefinedWebpage(String)
    /// `Year` frame
    ///
    /// (versions 2.2 and 2.3 only) A numeric string with a year of the recording. This frames is always four characters long (until the year 10000). FOR VERSION 2.4: This frame is replaced by the TDRC frame, 'Recording time'
    case year
    /// any frame not handled by SwiftTagger
    case passThrough(idString: String, uuid: UUID)
}
