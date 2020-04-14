//
//  Tag.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/10/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

struct Tag {
    
    var frames: [FrameKey : Frame]
    var mp3File: Mp3File
    
    init(frames: [FrameKey: Frame]) throws {
        let file: Data = self.mp3File.data
        
        var remainder: Data.SubSequence = file[file.startIndex..<file.endIndex]
        
        let tagProperties = TagProperties(for: self.mp3File)
        let tagValidator = TagValidator(for: self.mp3File)
        
        // parse version from tag header
        var version: Version = .v2_4
        if try tagValidator.hasValidTag() != true {
            throw Mp3File.Error.InvalidTagData
        } else {
            // the first five bytes of a valid ID3 Tag are "ID3"+ the version number in UInt8
            let versionData = tagProperties.extractVersionData
            let version = try tagProperties.version(versionData: versionData)
            
            _ = tagProperties.extractFlagData
            let tagSizeData = tagProperties.extractTagSizeData
            let size = tagProperties.size(tagSizeData: tagSizeData)
        }
        var frames: [FrameKey: Frame]
        while !remainder.isEmpty {
            let identifierBytes = remainder.extractFirst(version.identifierLength)
            let identifier = String(ascii: identifierBytes)
            let layout = KnownFrameLayoutIdentifier(identifier: identifier) ?? .userDefinedText
            
            let frameHandler: FrameProtocol.Type = Tag.frameHandler(layout: layout)
            
            let parsed = frameHandler.init(
                // Cannot invoke value of type '(Data.SubSequence, Version, FrameLayoutIdentifier, Data) throws -> FrameProtocol' (aka '(Data, Version, FrameLayoutIdentifier, Data) throws -> FrameProtocol') with argument list '(decodingFromStartOf: Data.SubSequence, version: Version, frameIdentifier: String)'
                decodingFromStartOf: remainder,
                version: version,
                frameIdentifier: identifier
            )
            frames[parsed.frameKey] = parsed
        }
    }
    
    private static func frameHandler(layout: KnownFrameLayoutIdentifier) -> FrameProtocol.Type {
        switch layout {
            case .chapter: /* return ChapterFrame.self */ break
            case .tableOfContents: /* return TableOfContentsFrame.self */ break
            case .compilation: /* return BooleanFrame.self */ break
            case .genre: /* return GenreFrame.self */ break
            case .languages: /* return LanguageFrame.self */ break
            case .attachedPicture: /* return ImageFrame.self */ break
            case .comments,
                 .unsynchronizedLyrics: /* return LocalizedFrame.self */ break
            case .discNumber,
                 .trackNumber: /* return PartOfTotalFrame.self */ break
            case .userDefinedText,
                 .userDefinedWebpage: /* return UserTextFrame.self */ break
            case .involvedPeopleList,
                 .musicianCreditsList: /* return CreditsListFrame.self */ break
            case .bpm,
                 .isrc,
                 .length,
                 .movementCount,
                 .movementNumber,
                 .playlistDelay: /* return IntegerFrame.self */ break
            case .date,
                 .encodingTime,
                 .originalReleaseTime,
                 .recordingDate,
                 .releaseTime,
                 .taggingTime,
                 .time,
                 .year: /* return DateFrame.self */ break
            case .artistWebpage,
                 .audioFileWebpage,
                 .audioSourceWebpage,
                 .copyrightWebpage,
                 .paymentWebpage,
                 .publisherWebpage,
                 .radioStationWebpage: /* return URLFrame.self */ break
            default: return StringFrame.self
        }
    }
    
}
