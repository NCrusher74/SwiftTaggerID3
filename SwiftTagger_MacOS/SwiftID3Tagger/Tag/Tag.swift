//
//  Tag.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/10/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation
import Cocoa

/// A type representing an ID3 tag to be read from or written to a file
public struct Tag {
    
    var frames: [FrameKey : Frame]
    
    init(readFromEmbeddedSubframes subframes: [FrameKey:Frame]) {
        self.frames = subframes
    }
    
    /// handles the parsing of an ID3 tag
    init(readFrom file: Mp3File) throws {
        // a type containing tag-level properties and methods for querying tag-level information
        let properties = TagProperties()
        
        // the data derived from the input file
        let fileData: Data = file.data
        
        // the file data as a data subsequence
        var remainder: Data.SubSequence = fileData[fileData.startIndex..<fileData.endIndex]
        
        // initialized variables for tagSize and Version
        var tagSize: Data.Index = 0
        var version: Version = .v2_4
        
        // validate file is an mp3 file
        if file.location.pathExtension.lowercased() != "mp3" {
            throw Mp3File.Error.InvalidFileFormat
        } else {
            // parse version data from tag header
            // the first five bytes of a valid ID3 Tag are "ID3"+ the version number in UInt8
            let versionData = remainder.extractFirst(properties.versionDeclarationLength)
            version = try properties.version(data: versionData)
            // parse flags from tag header. This data is generally unused and use of this data is not supported by SwiftTagger
            _ = remainder.extractFirst(properties.tagFlagsLength)
            // parse size from tag header
            let tagSizeData = remainder.extractFirst(properties.tagSizeDeclarationLength)
            tagSize = try properties.size(data: tagSizeData)
        }
        
        // set range of tag data using tag size as the upper bound
        let tagDataRange = remainder.startIndex ..< remainder.startIndex + tagSize
        remainder = remainder.subdata(in: tagDataRange)
        
        // parse frames from remaining tag data
        var frames: [FrameKey : Frame] = [:]
        while !remainder.isEmpty  {
            // extract frame identifier data
            let identifierBytes = remainder.extractFirst(version.identifierLength)
            // check to be sure the data is a frame
            if identifierBytes.first == 0x00 { break } // Padding, not a frame.
            // convert data to string
            let identifier = try String(ascii: identifierBytes)
            // hand the data over to `Frame` to decide which frame handler it goes to
            let frame = try Frame(
                identifier: identifier,
                data: &remainder,
                version: version)
            
            // used parsed frame data to get frame key
            let frameKey = frame.frameKey
            // add frame and framekey to frames dictionary
            frames[frameKey] = frame
        }
        self.frames = frames
    }
    
    func buildTagHeader(version: Version) throws -> Data {
        var headerData = Data()
        switch version {
            case .v2_2:
                headerData.append(contentsOf: TagProperties().v2_2Bytes)
            case .v2_3:
                headerData.append(contentsOf: TagProperties().v2_3Bytes)
            case .v2_4:
                headerData.append(contentsOf: TagProperties().v2_4Bytes)
        }
        headerData.append(contentsOf: TagProperties().defaultFlag)
        headerData.append(contentsOf: (try TagProperties().calculateNewTagSize(data: self.framesData(version: version))))
        return headerData
    }
    
    func framesData(version: Version) throws -> Data {
        var framesData = Data()
        for frame in self.frames.values {
            framesData.append(try frame.getFramesData(version: version))
        }
        return framesData
    }
    
    func buildTag(version: Version) throws -> Data {
        var tagData = Data()
        tagData.append(try buildTagHeader(version: version))
        tagData.append(try self.framesData(version: version))
        return tagData
    }
}

extension Tag {
    
    func string(for frameKey: FrameKey) -> String? {
        if let frame = self.frames[frameKey],
            case .stringFrame(let stringFrame) = frame {
            return stringFrame.contentString
        } else {
            return nil
        }
    }
    
    mutating func set(_ layout: FrameLayoutIdentifier,_ frameKey: FrameKey,to string: String) {
        let frame = StringFrame(layout: layout, contentString: string)
        self.frames[frameKey] = .stringFrame(frame)
    }
    
    func url(for frameKey: FrameKey) -> String? {
        if let frame = self.frames[frameKey],
            case .urlFrame(let urlFrame) = frame {
            return urlFrame.urlString
        } else {
            return nil
        }
    }
    
    mutating func set(_ layout: FrameLayoutIdentifier,_ frameKey: FrameKey,to url: URL) {
        let frame = URLFrame(layout: layout, urlString: url.path)
        self.frames[frameKey] = .urlFrame(frame)
    }
    
    func integer(for frameKey: FrameKey) -> Int? {
        if let frame = self.frames[frameKey],
            case .integerFrame(let integerFrame) = frame {
            return integerFrame.value
        } else {
            return nil
        }
    }
    
    mutating func set(_ layout: FrameLayoutIdentifier,_ frameKey: FrameKey, to value: Int) {
        let frame = IntegerFrame(layout: layout, value: value)
        self.frames[frameKey] = .integerFrame(frame)
    }
    
    func intTuple(for frameKey: FrameKey) -> (part: Int, total: Int?)? {
        if let frame = self.frames[frameKey],
            case .partOfTotalFrame(let partOfTotalFrame) = frame {
            return (partOfTotalFrame.part, partOfTotalFrame.total)
        } else {
            return nil
        }
    }
    
    mutating func set(_ layout: FrameLayoutIdentifier,_ frameKey: FrameKey, to part: Int, and total: Int?) {
        let frame = PartOfTotalFrame(layout: layout, part: part, total: total)
        self.frames[frameKey] = .partOfTotalFrame(frame)
    }
    
    func tupleArray(for frameKey: FrameKey) -> [(role: String, person: String)]? {
        if let frame = self.frames[frameKey],
            case .creditsListFrame(let creditsListFrame) = frame {
            return creditsListFrame.entries
        } else {
            return nil
        }
    }
    
    mutating func set(_ layout: FrameLayoutIdentifier, _ frameKey: FrameKey, to entries: [(role: String, person: String)]?) {
        let frame = CreditsListFrame(layout: layout, entries: entries ?? [])
        self.frames[frameKey] = .creditsListFrame(frame)
    }
    
    func userTextGetter(for frameKey: FrameKey, with description: String?) -> String? {
        if frameKey == .userDefinedWebpage(description: description ?? "") {
            if let frame = self.frames[.userDefinedWebpage(description: description ?? "")],
                case .userTextFrame(let userTextFrame) = frame {
                return userTextFrame.contentString
            } else {
                if let frame = self.frames[.userDefinedText(description: description ?? "")],
                    case .userTextFrame(let userTextFrame) = frame {
                    return userTextFrame.contentString
                }
            }
        }; return nil
    }
    
    mutating func set(_ layout: FrameLayoutIdentifier,_ frameKey: FrameKey, description: String?, content: String) {
        let frame = UserTextFrame(layout: layout, descriptionString: description ?? "", contentString: content)
        self.frames[frameKey] = .userTextFrame(frame)
    }
    
    func localizedGetter(
        for frameKey: FrameKey,
        in language: ISO6392Codes?,
        with description: String?) -> String? {
        if frameKey == .unsynchronizedLyrics(description: description ?? "") {
            if let frame = self.frames[.unsynchronizedLyrics(description: description ?? "")],
                case .localizedFrame(let localizedFrame) = frame {
                return localizedFrame.contentString
            }
        } else {
            if let frame = self.frames[.comments(description: description ?? "")],
                case .localizedFrame(let localizedFrame) = frame {
                return localizedFrame.contentString
            }
        }; return nil
    }
    
    mutating func set(_ layout: FrameLayoutIdentifier,_ frameKey: FrameKey, language: String, description: String?, content: String) {
        let frame = LocalizedFrame(layout: layout, languageString: language, descriptionString: description, contentString: content)
        self.frames[frameKey] = .localizedFrame(frame)
    }
    
    func presetOptionsGetter(for frameKey: FrameKey) -> (presetName: String?, presetRefinement: String?, description: String?)? {
        if let frame = self.frames[.genre],
            case .presetOptionsFrame(let presetOptionsFrame) = frame {
            return (presetName: presetOptionsFrame.presetName, presetRefinement: nil,
                    description: presetOptionsFrame.refinementDescription)
        } else if let frame = self.frames[.mediaType],
            case .presetOptionsFrame(let presetOptionsFrame) = frame {
            return (presetName: presetOptionsFrame.presetName, presetRefinement: presetOptionsFrame.presetRefinement,
                    description: presetOptionsFrame.refinementDescription)
        } else if let frame = self.frames[.fileType],
            case .presetOptionsFrame(let presetOptionsFrame) = frame {
            return (presetName: presetOptionsFrame.presetName, presetRefinement: presetOptionsFrame.presetRefinement,
                    description: presetOptionsFrame.refinementDescription)
        }; return nil
    }
    
    mutating func set(_ layout: FrameLayoutIdentifier,_ frameKey: FrameKey, presetName: String?, presetRefinement: String?, description: String?) {
        let frame = PresetOptionsFrame(layout: layout, presetName: presetName, presetRefinement: presetRefinement, refinementDescription: description)
        self.frames[frameKey] = .presetOptionsFrame(frame)
    }
}
