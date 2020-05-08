//
//  GenreFrame.swift
//  SwiftTaggerID3
//
//  Created by Nolaine Crusher on 4/11/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

/// A type representing a frame with up to three optional strings as content, at least one of which is required to be pre-set content.
struct PresetOptionsFrame: FrameProtocol {
    
    // MARK: Properties
    // (inherited from FrameProtocol)
    var flags: Data
    var layout: FrameLayoutIdentifier
    var frameKey: FrameKey
    var allowMultipleFrames: Bool = false
    
    // the array of strings from the frame
    var genreMediaOrFileInfo: [String?]
    
    init(decodingContents contents: Data.SubSequence,
         version: Version,
         layout: FrameLayoutIdentifier,
         flags: Data) throws {
        self.flags = flags
        self.layout = layout
        
        // this frametype handles three frame keys
        if self.layout == .known(.fileType) {
            self.frameKey = .fileType
        } else if self.layout == .known(.mediaType) {
            self.frameKey = .mediaType
        } else {
            self.frameKey = .genre
        }
        
        // standard boilerplate, it's a text frame (of sorts) so strings are encoded
        var parsing = contents
        let encoding = try PresetOptionsFrame.extractEncoding(data: &parsing, version: version)
        // initialize an empty array to store the parsed strings in
        var parsedArray: [String] = []
        
        // versions 2.2 and 2.3 handle strings differently than version 2.4.
        // 2.2 and 2.3 relies on parentheses, while 2.4 just uses null termination
        switch version {
            // v2.2 and v2.3 use parentheses to denote codes
            case .v2_2, .v2_3:
                // extract the full string
                let unparsedString = parsing.extractPrefixAsStringUntilNullTermination(encoding) ?? ""
                // parse out the parentheses and return the array of parsed strings
                parsedArray = PresetOptionsFrame.parseParentheticalString(unparsedString: unparsedString)
            case .v2_4:
                while !parsing.isEmpty,
                    let next = parsing.extractPrefixAsStringUntilNullTermination(encoding) {
                        parsedArray.append(next)
            }
        }
        var infoArray: [String] = []
        for component in parsedArray {
            if self.frameKey == .genre {
                // these are the numeric codes for the genres in GenreType.code
                let codeRange = 0...191
                // see if the string can be converted to an Int
                if let genreInt = Int(component) {
                    // see if it matches any of the codes
                    if codeRange.contains(genreInt) {
                        // if so, we know it's a genreType
                        infoArray.append(GenreType(code: genreInt)?.rawValue ?? "")
                        // if not, see if it's one of the genre type special cases
                    } else if component == "RX" {
                        infoArray.append(GenreType.Remix.rawValue)
                    } else if component == "CR" {
                        infoArray.append(GenreType.Cover.rawValue)
                        // if it doesn't match a genreType, handle it as freeform description
                    } else {
                        infoArray.append(component)
                    }
                } else {
                    infoArray.append(component)
                }
            } else if self.frameKey == .mediaType {
                // forward slash means it's a refinement string
                if component.first == "/" {
                    infoArray.append(MediaTypeRefinements(
                        code: component)?.code ?? "")
                    // if it's not a refinement, check to see if it's a media type
                } else if let mediaTypeRawValue = MediaType(rawValue: component),
                    MediaType.allCases.contains(mediaTypeRawValue) {
                    infoArray.append(MediaType(rawValue: component)?.rawValue ?? "")
                    // if it's not either of those, handle it as a freeform description
                } else {
                    infoArray.append(component)
                }
            } else {
                // forward slash means it's a refinement string
                if component.first == "/" {
                    infoArray.append(
                        FileTypeRefinements(
                            rawValue: component)?.rawValue ?? "")
                    // if it's not a refinement, check to see if it's a file type
                } else if let fileTypeRawValue = FileType(rawValue: component),
                    FileType.allCases.contains(fileTypeRawValue) {
                    infoArray.append(
                        FileType(rawValue: component)?.rawValue ?? "")
                    // if it's not either of those, handle it as a freeform description
                } else {
                    infoArray.append(component)
                }
            }
        }
        self.genreMediaOrFileInfo = infoArray
    }
    
    init(_ layout: FrameLayoutIdentifier,
         genreMediaOrFileInfo: [String?]) {
        self.layout = layout
        self.genreMediaOrFileInfo = genreMediaOrFileInfo
        self.flags = PresetOptionsFrame.defaultFlags
        
        if self.layout == .known(.fileType) {
            self.frameKey = .fileType
        } else if self.layout == .known(.mediaType) {
            self.frameKey = .mediaType
        } else {
            self.frameKey = .genre
        }
    }
    
    func encodeContents(version: Version) throws -> Data {
        var frameData = Data()
        // append encoding byte
        frameData.append(StringEncoding.preferred.rawValue.encoding(
            endianness: .bigEndian))
        switch version {
            case .v2_2, .v2_3: // null termination will be false
                for item in genreMediaOrFileInfo {
                    frameData.append(
                        reassembleParentheticalStringsForEncoding(
                            itemString: item ?? "")
                            .encoded(withNullTermination: false))
            }
            case .v2_4: // null termination will be true
                for item in genreMediaOrFileInfo {
                    frameData.append(
                        reassembleParentheticalStringsForEncoding(
                            itemString: item ?? "")
                            .encoded(withNullTermination: true))
            }
        }
        return frameData
    }
    
    func reassembleParentheticalStringsForEncoding(itemString: String) -> String {
        if self.frameKey == .genre {
            // see if the string is a genre raw value
            if GenreType.allCases.contains(GenreType(rawValue: itemString) ?? .none) {
                // get the genre type
                let genreType = GenreType(rawValue: itemString)
                // get the genre code int
                let genreCode = genreType?.code
                // check if the int is one of the special cases for remix and cover
                if genreCode == 256 {
                    return "(RX)"
                } else if genreCode == 257 {
                    return "(CR)"
                } else {
                    // make the Int a string and wrap it in parentheses again
                    // this is necessary because the spec expects these strings in parentheses
                    let genreCodeString = String(genreCode ?? 255)
                    return "(\(genreCodeString))"
                }
            } else {
                // it's a freeform description, no need to put parentheses on it
                return itemString
            }
        } else if self.frameKey == .mediaType {
            // see if the string is a media type refinement code
            if itemString.first == "/", MediaTypeRefinements.allCases.contains(
                MediaTypeRefinements(code: itemString) ?? .none) {
                return MediaTypeRefinements(code: itemString)?.code ?? ""
                // if not, check and see if it's a media type code
            } else if MediaType.allCases.contains(
                MediaType(rawValue: itemString) ?? .none) {
                // ... and if so, wrap it in parens
                return "(\(MediaType(rawValue: itemString)?.rawValue ?? ""))"
            } else {
                // if not, it's a freeform description
                return itemString
            }
        } else if self.frameKey == .fileType {
            // see if the string is a file type refinement code
            if itemString.first == "/", FileTypeRefinements.allCases.contains(
                FileTypeRefinements(rawValue: itemString) ?? .none) {
                return FileTypeRefinements(rawValue: itemString)?.rawValue ?? ""
                // if not, check and see if it's a file type code
            } else if FileType.allCases.contains(
                FileType(rawValue: itemString) ?? .none) {
                // ... and if so, wrap it in parens
                return "(\(FileType(rawValue: itemString)?.rawValue ?? ""))"
            } else {
                // if not, it's a freeform description
                return itemString
            }
        }; return ""
    }
}

// MARK: Tag extensions
// get and set functions for `PresetOptionsFrame` frame types, which retrieves or sets three strings, all of which are optional (genre only uses two of these.) Each individual frame of this type will call these functions in a get-set property of function, where appropriate.
extension Tag {
    func presetOptionGetter(for frameKey: FrameKey) -> [String?]? {
        if let frame = self.frames[frameKey],
            case .presetOptionsFrame(let presetOptionsFrame) = frame {
            return presetOptionsFrame.genreMediaOrFileInfo
        }; return nil
    }

    internal mutating func set(_ layout: FrameLayoutIdentifier,
                               _ frameKey: FrameKey,
                               infoArray: [String?]) {
        let frame = PresetOptionsFrame(layout, genreMediaOrFileInfo: infoArray)
        self.frames[frameKey] = .presetOptionsFrame(frame)
    }
    
    public var genre: [String?]? {
        get {
            presetOptionGetter(for: .genre)
        }
        set {
            set(.known(.genre), .genre, infoArray: newValue ?? [])
        }
    }

    public var mediaType: [String?]? {
        get {
            presetOptionGetter(for: .mediaType)
        }
        set {
            set(.known(.mediaType), .mediaType, infoArray: newValue ?? [])
        }
    }

    public var fileType: [String?]? {
        get {
            presetOptionGetter(for: .fileType)
        }
        set {
            set(.known(.fileType), .fileType, infoArray: newValue ?? [])
        }
    }

//    public var genre: (presetGenre: GenreType?, customGenre: String?)? {
//        get {
//            var genrePreset: GenreType = .none
//            var customGenre: String = ""
//            if let frame = self.frames[.genre],
//                case .presetOptionsFrame(let presetOptionsFrame) = frame {
//                for item in presetOptionsFrame.genreMediaOrFileInfo {
//                    let genreCodeRange = 0...191
//                    if let genreInt = Int(item ?? "") {
//                        if genreCodeRange.contains(genreInt) {
//                            genrePreset = GenreType(code: genreInt) ?? .none
//                        }
//                    } else {
//                        customGenre = item ?? ""
//                    }
//                }
//            }
//            return (genrePreset, customGenre)
//        }
//        set {
//            var itemArray: [String?] = []
//            itemArray.append(newValue?.presetGenre?.rawValue)
//            itemArray.append(newValue?.customGenre)
//            set(.known(.genre), .genre, infoArray: itemArray)
//        }
//    }
//
//    public var mediaType: (mediaType: MediaType?, additionalMediaInfo: MediaTypeRefinements?, description: String?)? {
//        get {
//            var mediaPreset: MediaType = .none
//            var refinementPreset: MediaTypeRefinements = .none
//            var description: String = ""
//            if let frame = self.frames[.mediaType],
//                case .presetOptionsFrame(let presetOptionsFrame) = frame {
//                for item in presetOptionsFrame.genreMediaOrFileInfo {
//                    if item?.first == "/" {
//                        refinementPreset = MediaTypeRefinements(
//                            code: item ?? "") ?? .none
//                    } else if MediaType.allCases.contains(
//                        MediaType(rawValue: item ?? "") ?? .none) {
//                        mediaPreset = MediaType(rawValue: item ?? "") ?? .none
//                    } else {
//                        description = item ?? ""
//                    }
//                }
//            }
//            return (mediaPreset, refinementPreset, description)
//        }
//        set {
//            var itemArray: [String?] = []
//            itemArray.append(newValue?.mediaType?.rawValue)
//            itemArray.append(newValue?.additionalMediaInfo?.code)
//            itemArray.append(newValue?.description)
//            set(.known(.mediaType), .mediaType, infoArray: itemArray)
//        }
//    }
//
//    public var fileType: (fileType: FileType?, additionalFileInfo: FileTypeRefinements?, description: String?)? {
//        get {
//            var fileTypePreset: FileType = .none
//            var refinementPreset: FileTypeRefinements = .none
//            var description: String = ""
//            if let frame = self.frames[.fileType],
//                case .presetOptionsFrame(let presetOptionsFrame) = frame {
//                for item in presetOptionsFrame.genreMediaOrFileInfo {
//                    if item?.first == "/" {
//                        refinementPreset = FileTypeRefinements(
//                            rawValue: item ?? "") ?? .none
//                    } else if FileType.allCases.contains(
//                        FileType(rawValue: item ?? "") ?? .none) {
//                        fileTypePreset = FileType(rawValue: item ?? "") ?? .none
//                    } else {
//                        description = item ?? ""
//                    }
//                }
//            }
//            return (fileTypePreset, refinementPreset, description)
//        }
//        set {
//            var itemArray: [String?] = []
//            itemArray.append(newValue?.fileType?.rawValue)
//            itemArray.append(newValue?.additionalFileInfo?.rawValue)
//            itemArray.append(newValue?.description)
//            set(.known(.fileType), .fileType, infoArray: itemArray)
//        }
//    }
}
