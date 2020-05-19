# SwiftTaggerID3

SwiftTaggerID3 is a Swift library for reading and writing ID3 tags in MP3 audio files. 

**Usage**
```swift
let mp3Url = URL(fileURLWithPath: "/path/to/file.mp3")
let mp3File = try Mp3File(location: mp3Url)
let tag = try mp3File.read()

print(tag.album)
print(tag.artist)
print(tag.trackNumber)
```

For frames where there can be multiple versions of the frame in a tag, you can locate the specific frame using it's `descriptionString` as a subscript, or for frames that also require an ISO-639-2 language code, the language code and the `descriptionString`:

```swift
print(tag[userDefinedText: "UserDefinedText"]) // "User Defined Text Content"
print(tag[comments: .eng, "CommentDescription"]) // "Comment Content"
print(tag[lyrics: .eng, "LyricsDescription"]) // "Lyrics Content"
```

To access information from the `InvolvedPeopleList` and `MusicianCreditsList` frames:

```swift
print(tag.involvedPeopleList?[0].role) // "Director"
print(tag.involvedPeopleList?[0].person) // "Director Name"
print(tag.involvedPeopleList?[1].role) // "Producer"
print(tag.involvedPeopleList?[1].person) // "Producer Name"
print(tag.musicianCreditsList?[0].role) // "Musician"
print(tag.musicianCreditsList?[0].person) // "Musician Name"

```

To access `CTOC` and `CHAP` frame content, the subscript accessor is the frame's `elementID`:

```swift
print(tag[tableOfContents: "TOC"]?.topLevelFlag) // true
print(tag[tableOfContents: "TOC"]?.orderedFlag) // true
print(tag[tableOfContents: "TOC"]?.entryCount) // 2
print(tag[tableOfContents: "TOC"]?.childElementIDs) // ["ch0","ch1"]
print(tag[chapters: "ch0"]?.startTime) // 0
print(tag[chapters: "ch0"]?.endTime) // 2795
print(tag[embeddedSubframes: "ch0"]?.title) // "Chapter 01"
```

You can also export the images from the `AttachedPicture` frames using their optional `descriptionString` as a subscript, but honestly it's just as easy to get them using `AVFoundation`:

```swift
let outputURL = URL(fileURLWithPath: "/destination/path/for/image.jpg")
let coverImageData = tag[attachedPicture: "SampleCover"]
try coverImageData?.write(to: outputURL)
```

Unknown or unhandled frames are assigned a `UUID` that may be used in a similar fashion to a `descriptionString`.


Here's a complete list of the frames handled by SwiftTaggerID3:

* `album`
* `albumSort`
* `albumArtist`
* `albumArtistSort`
* `arranger`
* `artist`
* `artistSort`
* `artistWebpage`
* `attachedPicture`
* `audioFileWebpage`
* `audioSourceWebpage`
* `bpm`
* `chapter`
* `comments`
* `compilation`
* `composer`
* `composerSort`
* `conductor`
* `contentGroup`
* `copyright`
* `copyrightWebpage`
* `date`
* `discNumber`
* `encodingTime`
* `encodedBy`
* `encodingSettings`
* `fileType`
* `fileOwner`
* `genre`
* `grouping`
* `initialKey`
* `involvedPeopleList`
* `isrc`
* `languages`
* `length`
* `lyricist`
* `mediaType`
* `mood`
* `movementCount`
* `movementName`
* `movementNumber`
* `musicianCreditsList`
* `originalAlbum`
* `originalArtist`
* `originalFilename`
* `originalLyricist`
* `originalReleaseTime`
* `paymentWebpage`
* `playlistDelay`
* `podcastCategory`
* `podcastDescription`
* `podcastID`
* `podcastKeywords`
* `podcastFeedLink`
* `producedNotice`
* `publisher`
* `publisherWebpage`
* `radioStation`
* `radioStationOwner`
* `radioStationWebpage`
* `recordingDate`
* `releaseTime`
* `setSubtitle`
* `subtitle`
* `tableOfContents`
* `taggingTime`
* `time`
* `title`
* `titleSort`
* `trackNumber`
* `unsynchronizedLyrics`
* `userDefinedText`
* `userDefinedWebpage`
* `year`
