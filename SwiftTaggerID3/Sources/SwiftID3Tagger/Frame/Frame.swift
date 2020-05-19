//
//  Frame.swift
//  SwiftTaggerID3
//
//  Created by Nolaine Crusher on 4/8/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

/** An enum containing methods and variables for querying and building frames with a particular structure */
enum Frame {
    
    /** A frame type containing a single, unterminated string of content
     
        Frames of this type MAY NOT be duplicated within a valid ID3 tag */
    case stringFrame(StringFrame)
    /** A frame type containing the index of the track or disc in the collection, with an optional addition of the total number of tracks or discs
     
        Frames of this type MAY NOT be duplicated within a valid ID3 tag*/
    case partOfTotalFrame(PartOfTotalFrame)
    /** A frame type containing contents for `Comment`,`UnsynchronizedLyrics`, `UserDefinedText`, and `UserDefinedWebpage` frames.
     
        Composed of an (optional) language code string, an optional terminated description string, and a single string of content that is permitted to contain new line characters (only for `Comment` and `Lyrics` frames. `UserDefinedText` may not contain new lines)
     
        Frames of this type MAY be duplicated within a valid ID3 tag, but each is required to have a unique description unless the language is different. */
    case localizedFrame(LocalizedFrame)
    /** A frame type containing an array of ISO-639-2 language codes
     
        Frames of this type MAY NOT be duplicated within a valid ID3 tag*/
    case languageFrame(LanguageFrame)
    /** A frame type containing an array of `role:person` tuples
     
        Frames of this type MAY NOT be duplicated within a valid ID3 tag */
    case creditsListFrame(CreditsListFrame)
    /** A frame type containing an date value that will be encoded and stored as a timestamp string.
     
        Frames of this type MAY NOT be duplicated within a valid ID3 tag*/
    @available(macOS 10.12, *)
    case dateFrame(DateFrame)
    /** A frame type containing an attached image pertaining to the audio media.
        
        Frames of this type MAY be duplicated within a valid ID3 tag, but each must have a unique description string, except for the first and second `ImageType` options, which MAY NOT be duplicated. */
    case imageFrame(ImageFrame)
    /** A frame type consisting of optional strings from an enumeration of preset values, an optional string (terminated) of preset refinement values, and an optional string of freeform refinements or information.
     
        Frames of this type MAY NOT be duplicated within a valid ID3 tag*/
    case presetOptionsFrame(PresetOptionsFrame)
    /** a frame type containing a table of contents frame.
     
        Frames of this type MAY be duplicated within a valid ID3 tag, providing only one has the top-level flag set, and each has a unique `ElementID`*/
    case tocFrame(TableOfContentsFrame)
    /** a frame type containing a chapter frame.
     
        Frames of this type MAY be duplicated within a valid ID3 tag, but each one must have a unique `ElementID`*/
    case chapterFrame(ChapterFrame)
    /// allows unsupported frames to pass through and be returned unparsed
    case unknownFrame(UnknownFrame)
    
    /// Instantiates the frame handler appropriate for a particular frame
    /// - Parameters:
    ///   - identifier: The identifier string parsed out of the frame header
    ///   - data: The slice of data containing the frame as declared in the frame header
    ///   - version: The `Version` of the ID3 tag
    /// - Throws: Caller will determine how to handle any errors
    init(identifier: String,
         data: inout Data.SubSequence,
         version: Version) throws {
        // use the identifier string to determine frame layout
        let layout = FrameLayoutIdentifier(identifier: identifier)
        switch layout {
            case .known(.attachedPicture):
                self = .imageFrame(try ImageFrame(
                    decodingFromStartOf: &data,
                    version: version,
                    layout: layout))
            case .known(.chapter):
                self = .chapterFrame(try ChapterFrame(
                    decodingFromStartOf: &data,
                    version: version,
                    layout: layout))
            case .known(.tableOfContents):
                self = .tocFrame(try TableOfContentsFrame(
                    decodingFromStartOf: &data,
                    version: version,
                    layout: layout))
            case .known(.genre),
                 .known(.mediaType),
                 .known(.fileType):
                self = .presetOptionsFrame(try PresetOptionsFrame(
                    decodingFromStartOf: &data,
                    version: version,
                    layout: layout))
            case .known(.languages):
                self = .languageFrame(try LanguageFrame(
                    decodingFromStartOf: &data,
                    version: version,
                    layout: layout))
            case .known(.comments),
                 .known(.unsynchronizedLyrics),
                 .known(.userDefinedText),
                 .known(.userDefinedWebpage):
                self = .localizedFrame(try LocalizedFrame(
                    decodingFromStartOf: &data,
                    version: version,
                    layout: layout))
            case .known(.discNumber),
                 .known(.trackNumber):
                self = .partOfTotalFrame(try PartOfTotalFrame(
                    decodingFromStartOf: &data,
                    version: version,
                    layout: layout))
            case .known(.involvedPeopleList),
                 .known(.musicianCreditsList):
                self = .creditsListFrame(try CreditsListFrame(
                    decodingFromStartOf: &data,
                    version: version,
                    layout: layout))
            case .known(.date),
                 .known(.encodingTime),
                 .known(.originalReleaseTime),
                 .known(.recordingDate),
                 .known(.releaseTime),
                 .known(.taggingTime),
                 .known(.time),
                 .known(.year):
              if #available(macOS 10.12, *) {
                self = .dateFrame(try DateFrame(
                    decodingFromStartOf: &data,
                    version: version,
                    layout: layout))
              } else {
                self = .unknownFrame(try UnknownFrame(
                  decodingFromStartOf: &data,
                  version: version,
                  layout: layout))
              }
            case .unknown(identifier):
                self = .unknownFrame(try UnknownFrame(
                    decodingFromStartOf: &data,
                    version: version,
                    layout: layout))
            default:
                self = .stringFrame( try StringFrame(
                    decodingFromStartOf: &data,
                    version: version,
                    layout: layout))
        }
    }
    
    /** A unique identifier for a particular frame
     
        For frames that may not be duplicated within a valid `Tag`, this is usually the ID3 frame identifier string. For frames that may be duplicated within a valid `Tag`, other identifying information, such as a description string or `UUID` may be used */
    var frameKey: FrameKey {
        switch self {
            case .localizedFrame(let localizedFrame):
                return localizedFrame.frameKey
            case .languageFrame(let languageFrame):
                return languageFrame.frameKey
            case .creditsListFrame(let creditsListFrame):
                return creditsListFrame.frameKey
            case .presetOptionsFrame(let presetOptionsFrame):
                return presetOptionsFrame.frameKey
            case .stringFrame(let stringFrame):
                return stringFrame.frameKey
            case .partOfTotalFrame(let partOfTotalFrame):
                return partOfTotalFrame.frameKey
            case .unknownFrame(let unknownFrame):
                return unknownFrame.frameKey
            case .dateFrame(let dateFrame):
                return dateFrame.frameKey
            case .chapterFrame(let chapterFrame):
                return chapterFrame.frameKey
            case .tocFrame(let tableOfContentsFrame):
                return tableOfContentsFrame.frameKey
            case .imageFrame(let imageFrame):
                return imageFrame.frameKey
        }
    }
    
    /// Retrieves the data for a frame using the `FrameProtocol` `encode` function
    /// - Parameter version: The `Version` of the ID3 tag
    /// - Throws: Caller will determine how errors will be handled
    /// - Returns: `data` containing the encoded frame
    func framesData(version: Version) throws -> Data {
        switch self {
            case .stringFrame(let stringFrame):
                return try stringFrame.encode(version: version)
            case .partOfTotalFrame(let partOfTotalFrame):
                return try partOfTotalFrame.encode(version: version)
            case .localizedFrame(let localizedFrame):
                return try localizedFrame.encode(version: version)
            case .languageFrame(let languageFrame):
                return try languageFrame.encode(version: version)
            case .creditsListFrame(let creditsListFrame):
                return try creditsListFrame.encode(version: version)
            case .dateFrame(let dateFrame):
                return try dateFrame.encode(version: version)
            case .imageFrame(let imageFrame):
                return try imageFrame.encode(version: version)
            case .presetOptionsFrame(let presetOptionsFrame):
                return try presetOptionsFrame.encode(version: version)
            case .tocFrame(let tocFrame):
                return try tocFrame.encode(version: version)
            case .chapterFrame(let chapterFrame):
                return try chapterFrame.encode(version: version)
            case .unknownFrame(let unknownFrame):
                return try unknownFrame.encode(version: version)
        }
    }
}

extension Frame {
    /// A property that permits a subframe to be encoded as a frame
    var asFrameProtocol: FrameProtocol {
        switch self {
            case .stringFrame(let stringFrame):
                return stringFrame
            case .partOfTotalFrame(let partOfTotalFrame):
                return partOfTotalFrame
            case .localizedFrame(let localizedFrame):
                return localizedFrame
            case .languageFrame(let languageFrame):
                return languageFrame
            case .creditsListFrame(let creditsListFrame):
                return creditsListFrame
            case .dateFrame(let dateFrame):
                return dateFrame
            case .presetOptionsFrame(let presetOptionsFrame):
                return presetOptionsFrame
            case .tocFrame(let tocFrame):
                return tocFrame
            case .chapterFrame(let chapterFrame):
                return chapterFrame
            case .unknownFrame(let unknownFrame):
                return unknownFrame
            case .imageFrame(let imageFrame):
                return imageFrame
        }
    }
}
