<!--

 README.md
 SwiftTaggerID3

 Copyright ©2020 Nolaine Crusher. All rights reserved.

 -->

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
print(tag.involvedPeopleList?[0].role) // .Director
print(tag.involvedPeopleList?[0].person) // "Director Name"
print(tag.involvedPeopleList?[1].role) // .Producer
print(tag.involvedPeopleList?[1].person) // "Producer Name"
print(tag.musicianCreditsList?[0].role) // .Musician
print(tag.musicianCreditsList?[0].person) // "Musician Name"

```

To access `CTOC` frame content, the subscript accessor is the `topLevelFlag` boolean (only one `CTOC` frame is allowed to have this flag set to `true`) followed by the `elementID` for `CTOC` frames where the `topLevelFlag` is set to false:

```swift
// topLevelFlag = true, elementID = "toc1"
tag?[tableOfContents: true, "toc1"]?.orderedFlag = true
tag?[tableOfContents: true, "toc1"]?.childElementIDs = ["toc2"]
tag?[tableOfContents: true, "toc1"]?.embeddedSubframesTag.title = "Table Of Contents (TOP)"

// topLevelFlag = false, elementID = "toc2"
tag?[tableOfContents: false, "toc2"]?.orderedFlag = true
tag?[tableOfContents: false, "toc2"]?.childElementIDs = ["ch1", "ch2", "ch3"]
tag?[tableOfContents: false, "toc2"]?.embeddedSubframesTag.title = "Table Of Contents (SECONDARY)"
```

To access `CHAP` frame content, the subscript accessor is the `startTime` (in milliseconds.)

```swift
// startTime is at 0 milliseconds
tag[chapter: 0]?.elementID = "ch1"
tag[chapter: 0]?.endTime = 1680
tag[chapter: 0]?.embeddedSubframesTag.title = "Chapter One"

// startTime is at 1680 milliseconds
tag[chapter: 1680]?.elementID = "ch2"
tag[chapter: 1680]?.endTime = 3360
tag[chapter: 1680]?.embeddedSubframesTag.title = "Chapter Two"

// startTime is at 3360 milliseconds
tag[chapter: 3360]?.elementID = "ch3"
tag[chapter: 3360]?.endTime = 5040
tag[chapter: 3360]?.embeddedSubframesTag.title = "Chapter Three"
```

In order for some apps to correctly recognize the chapters, the `CTOC` frame must be present and its list of `childElementIDs` must contain the `elementID` of every chapter frame.

In order to remove old or unused `CHAP` and `CTOC` frames, call the `remove` function using the same accessors used to write and query it:

```swift
tag?.removeTOCFrame(isTopLevel: true, withElementID: "TOC")
tag?.removeChapterFrame(atStartTime: 2795)
```



You can also export the images from the `AttachedPicture` frames using their optional `descriptionString` as a subscript, but honestly it'd be just as easy to get them using `AVFoundation`:

```swift
let outputURL = URL(fileURLWithPath: "/destination/path/for/image.jpg")
let coverImageData = tag[attachedPicture: "SampleCover"]
try coverImageData?.write(to: outputURL)
```

Unknown or unhandled frames are assigned a `UUID` that may be used in a similar fashion to a `descriptionString`.

**Removing Frames**
To wipe all metadata from a file, initialize `tag` to an empty `Tag()` instance. This also works if you wish to write only your metadata to the file, and wipe everything else. Simply add the values you wish to `tag`.
:
```swift
let tag = Tag()

tag.album = "Completely New Album Data"

let outputUrl = URL(fileURLWithPath: "/destination/path/for/blank.mp3")
try mp3NoMeta().write(tagVersion: .v2_3, // whatever version you wish
using: tag,
writingTo: outputUrl)
```

To wipe the data from a particular frame, set it equal to `nil`:
```swift
let tag = try mp3File.read()

tag.album = nil
tag.artist = nil
tag.trackNumber = nil
```

If the frame is one that is accessible by a subscript, you need to locate it using the `remove<Frame>(withSubscriptAccessor:)` function:

```swift
tag.removeCommentFrame(withDescription: "Comment Description")
```

Here's a complete list of the frames handled by SwiftTaggerID3:

* `album`
* `albumSort`
* `albumArtist`
* `albumArtistSort`
* `arranger`
* `artist`
* `artistSort`
* `artistWebpage`
* `attachedPicture // query using description as subscript accessor`
* `audioFileWebpage`
* `audioSourceWebpage`
* `bpm`
* `chapter // query using startTime in milliseconds as subscript accessor`
* `comments // query using description as subscript accessor`
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
* `tableOfContents // query using topLevelFlag boolean and elementID as subscript accessors`
* `taggingTime`
* `time`
* `title`
* `titleSort`
* `trackNumber`
* `unsynchronizedLyrics // query using description as subscript accessor`
* `userDefinedText // query using description as subscript accessor`
* `userDefinedWebpage // query using description as subscript accessor`
* `year`
