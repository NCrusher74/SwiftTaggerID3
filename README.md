<!--

 README.md
 SwiftTaggerID3

 Copyright ©2020 Nolaine Crusher. All rights reserved.

 -->

# SwiftTaggerID3

SwiftTaggerID3 is a Swift library for reading and writing ID3 tags in MP3 audio files. 

**Usage**
*Reading ID3 frames from a file*
```swift
let mp3Url = URL(fileURLWithPath: "/path/to/file.mp3")
let mp3File = try Mp3File(location: mp3Url)
let tag = try mp3File.read()

print(tag.album)
print(tag.artist)
print(tag.trackNumber)
```

*Writing ID3 frames to a file*
To add new frames to a file, or edit existing frames, read the tag as demonstrated above, and add/edit whatever frames you wish:
```swift
tag.album = "New Album Title"
tag.artist = "New Artist"
tag.trackNumber.track = 3
tag.trackNumber.totalTracks = 12

let outputUrl = URL(fileURLWithPath: "/path/to/new.mp3")
try mp3File.write(
    tagVersion: .v2_4,
    using: tag,
    writingTo: outputUrl)
```

If you wish to overwrite all metadata on the file and replace it with only your newly-created frames, initialize `tag` to an empty `Tag()` instance. 
```swift
let tag = Tag()

tag.album = "Completely New Album Title"
```

To wipe the data from a particular frame, set it equal to `nil`:
```swift
let tag = try mp3File.read()

tag.album = nil
tag.artist = nil
tag.trackNumber = nil
```

For some frames (such as `Comment` or `userDefinedText`), multiple versions of the frame are permitted in a tag (according to the ID3 spec.) In these cases, you can locate the specific frame using it's `descriptionString` as a subscript, or for frames that also require an ISO-639-2 language code, the language code and the `descriptionString`:
```swift
print(tag[userDefinedText: "UserDefinedText"]) // "User Defined Text Content"
print(tag[comments: .eng, "CommentDescription"]) // "Comment Content"
print(tag[lyrics: .eng, "LyricsDescription"]) // "Lyrics Content"

// and to write to these frames
tag[userDefinedText: "NewDescription"] = "New User Defined Text Content"
tag[comments .eng, "NewDescription"] = "New Comment Content"
tag[lyrics: .eng, "NewDescription"] = "New Lyrics Content"

```
To overwrite an existing frame with a subscript accessor, just use the same `descriptionString` and language (if applicable). To remove an existing frame of this type, access it using its removal function:
```swift
tag.removeCommentFrame(withDescription: "Comment")
tag.removeUserTextFrame(withDescription: "UserText")
```

*Involved People and Musician Credit List frames*
To access information from the `InvolvedPeopleList` and `MusicianCreditsList` frames:
```swift
print(tag.involvedPeopleList?[1].role) // .Producer
print(tag.involvedPeopleList?[1].person) // "Producer Name"
print(tag.musicianCreditsList?[0].role) // .Musician
print(tag.musicianCreditsList?[0].person) // "Musician Name"
```
(NEED REMOVAL INSTRUCTIONS)

*Chapter Frames*
To retrieve a list of all the chapters in the file, use the `allChapters` property.
```swift
print(tag.allChapters)
```
This will return an array of ( `startTime`,  `chapterTitle`) pairs, where the `startTime` is in milliseconds.

To access the data of a specific chapter, use its index in the `allChapters` array:
```swift
print(tag.allChapters[0].startTime) // 0
print(tag.allChapters[0].title) // "Chapter 01"
```

To add a chapter, use the `addChapter(at startTime: Int, title: String)` function. **The `startTime` must be in milliseconds**. *If a chapter exists at the specified `startTime`, it will be overwritten.* Otherwise, new chapters will be added to any existing chapters:

```swift
tag.addChapter(at: 1000, title: "Chapter 02")
```

To remove a single chapter from the tag:
```swift
tag.removeChapter(at: startTime)
```

To wipe all chapters from the tag:
```swift
tag.removeAllChapters()
```


*Other Frames*
You can export the images from the `AttachedPicture` frames using their optional `descriptionString` as a subscript, but honestly it'd be just as easy to get them using `AVFoundation`:
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
* `attachedPicture // query using description as subscript accessor`
* `audioFileWebpage`
* `audioSourceWebpage`
* `bpm`
* `chapter`
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
* `tableOfContents`
* `taggingTime`
* `time`
* `title`
* `titleSort`
* `trackNumber`
* `unsynchronizedLyrics // query using description as subscript accessor`
* `userDefinedText // query using description as subscript accessor`
* `userDefinedWebpage // query using description as subscript accessor`
* `year`

*A note on ID3 specification compliance*
`SwiftTaggerID3` tries to stick pretty close to the requirements of the documented specs, but there are a few places where it deviates, either because the spec is silly, or compliance would be more cumbersome to achieve can be justified by the author's needs, or compliance would make the usage of `SwiftTaggerID3` too convoluted. These deviations are:

* In cases where a frame didn't exist for ID3 version 2.2, but does in version 2.3/2.4, a non-standard ID3 identifier for the frame has been created. Whenever possible, this identifier is the same one used by `TagLib` in similar instances, so that the frame will be recognized by apps built using `TagLib`. Chapter frames, however, are still not supported for version 2.2.
* The ID3 specs for the `TCON` ("Genre"), `TMED` ("MediaType"), and `TFLT` ("File Type") frames make these frames exceptionally difficult to parse. So while the spec allows for an unlimited array of pre-determined types, pre-determined refinements, and free-form description or refinement strings, `SwiftTaggerID3` only permits one of each type of input. This should be more than sufficient for most user's needs.
* The ID3 specs allow for multiple `CTOC` (Table Of Contents) frames, and for the `CTOC` frames to have embedded subframes. To keep chapter implementation simple, however, `SwiftTaggerID3` only supports a single `CTOC` frame, with no embedded subframes.

If you wish to add these missing features, while keeping the usage user-friendly, the author will welcome pull requests.
