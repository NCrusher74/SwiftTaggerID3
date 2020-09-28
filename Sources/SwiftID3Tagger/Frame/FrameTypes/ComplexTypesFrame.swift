//
//  ComplexTypesFrame.swift
//  SwiftTaggerID3
//
//  Created by Nolaine Crusher on 9/18/20.
//


// ///// Genre Type spec /////
// v2.2 and 2.3: (parenthetical)
// References to the ID3v1 genres can be made by, as first byte, enter
// "(" followed by a number from the genres list (appendix A.) and
// ended with a ")" character. This is optionally followed by a
// refinement, e.g. "(21)" or "(4)Eurodisco". Several references can be
// made in the same frame, e.g. "(51)(39)". If the refinement should
// begin with a "(" character it should be replaced with "((", e.g. "((I
// can figure out any genre)" or "(55)((I think...)". The following new
// content types is defined in ID3v2 and is implemented in the same way
// as the numerig content types, e.g. "(RX)".
//
// RX  Remix
// CR  Cover
//
// v2.4: (null terminated rather than parenthetical)
// The 'Content type', which ID3v1 was stored as a one byte numeric
// value only, is now a string. You may use one or several of the ID3v1
// types as numerical strings, or, since the category list would be
// impossible to maintain with accurate and up to date categories,
// define your own. Example: "21" $00 "Eurodisco" $00
//
// You may also use any of the following keywords:
//
// RX  Remix
// CR  Cover
//
// ///// Media Type spec /////
// // v2.2 and v2.3 (parenthetical)
// The 'Media type' frame describes from which media the sound
// originated. This may be a text string or a reference to the
// predefined media types found in the list below. References are made
// within "(" and ")" and are optionally followed by a text refinement,
// e.g. "(MC) with four channels". If a text refinement should begin
// with a "(" character it should be replaced with "((" in the same way
// as in the "TCO" frame. Predefined refinements is appended after the
// media type, e.g. "(CD/A)" or "(VID/PAL/VHS)".
//
// v2.4 (null terminated)
// The 'Media type' frame describes from which media the sound
// originated. This may be a text string or a reference to the
// predefined media types found in the list below. Example:
// "VID/PAL/VHS" $00.
//
// ///// File Type spec /////
// The 'File type' frame indicates which type of audio this tag defines.
// The following types and refinements are defined: (omitted)
// but other types may be used, but not for these types though. This is
// used in a similar way to the predefined types in the "TMED" frame,
// but without parentheses. If this frame is not present audio type is
// assumed to be "MPG".

import Foundation
/// A type representing a frame with up to three optional strings as content, at least one of which is selected from a preset list of options. This type manages frames `genreType`, `mediaType`, and `fileType`
class ComplexTypesFrame: Frame {

    var contentArray: [String]
    
    init(identifier: FrameIdentifier,
         version: Version,
         size: Int,
         flags: Data,
         payload: Data
    ) throws {
        // standard boilerplate, it's a text frame (of sorts) so strings are encoded
        var data = payload
        let encoding = try data.extractEncoding()
        // initialize an empty array to store the parsed strings in
        var parsedArray = [String]()
        
        // versions 2.2 and 2.3 handle strings differently than version 2.4.
        // 2.2 and 2.3 relies on parentheses, while 2.4 just uses null termination
        switch version {
            // v2.2 and v2.3 use parentheses to denote codes
            case .v2_2, .v2_3:
                // extract the full string
                if let unparsedString = data.extractNullTerminatedString(encoding) {
                    // parse out the parentheses and return the array of parsed strings
                    parsedArray = unparsedString.parseParentheticalString()
                }
            case .v2_4:
                while !data.isEmpty,
                      let next = data.extractNullTerminatedString(encoding) {
                    parsedArray.append(next)
                }
        }

        if identifier == .genre {
            self.contentArray = parsedArray.parsedGenreStrings
        } else if identifier == .mediaType {
            self.contentArray = parsedArray.parsedMediaTypeStrings
        } else {
            self.contentArray = parsedArray.parsedFileTypeStrings
        }

        super.init(identifier: identifier,
                   version: version,
                   size: size,
                   flags: flags)
    }
    
    // MARK: - Frame Building
    init(_ identifier: FrameIdentifier,
         version: Version,
         contentArray: [String]) {
        self.contentArray = contentArray
        let flags = version.defaultFlags
        
        var size = 1 // +1 for encoding byte
        switch version {
            case .v2_2, .v2_3: // null termination will be false
                if identifier == .genre {
                    size += contentArray
                        .encodedGenreParentheticalStrings.count
                } else if identifier == .mediaType {
                    size += contentArray
                        .encodedMediaTypeParentheticalStrings.count
                } else if identifier == .fileType {
                    size += contentArray.encodedFileTypeStrings.count
                }
            case .v2_4: // null termination will be true
                if identifier == .genre {
                    size += contentArray
                        .encodedNonParentheticalGenreStrings.count
                } else if identifier == .mediaType {
                    size += contentArray
                        .encodedNonParentheticalMediaTypeStrings.count
                } else if identifier == .fileType {
                    size += contentArray
                        .encodedNonParentheticalFileTypeStrings.count
                }
        }
        super.init(identifier: identifier,
                   version: version,
                   size: size,
                   flags: flags)
    }
    
    override var contentData: Data {
        var data = Data()
        // append encoding byte
        let encoding = String.Encoding.isoLatin1
        data.append(encoding.encodingByte)
        switch self.version {
            case .v2_2, .v2_3: // null termination will be false
                if self.identifier == .genre {
                    data.append(
                        contentArray.encodedGenreParentheticalStrings)
                } else if self.identifier == .mediaType {
                    data.append(
                        contentArray.encodedMediaTypeParentheticalStrings)
                } else if self.identifier == .fileType {
                    data.append(contentArray.encodedFileTypeStrings)
                }
            case .v2_4: // null termination will be true
                if self.identifier == .genre {
                    data.append(
                        contentArray.encodedNonParentheticalGenreStrings)
                } else if self.identifier == .mediaType {
                    data.append(
                        contentArray.encodedNonParentheticalMediaTypeStrings)
                } else if self.identifier == .fileType {
                    data.append(
                        contentArray.encodedNonParentheticalFileTypeStrings)
                }
        }
        return data
    }
}

// MARK: - Tag extensions
// get and set functions for `PresetOptionsFrame` frame types, which retrieves or sets three strings, all of which are optional (genre only uses two of these.) Each individual frame of this type will call these functions in a get-set property of function, where appropriate.
extension Tag {
    private func get(complexTypesFrame identifier: FrameIdentifier) -> [String]? {
        let frameKey = identifier.frameKey
        if let frame = self.frames[frameKey] as? ComplexTypesFrame {
            return frame.contentArray
        } else {
            return nil
        }
    }
    
    private mutating func set(complexTypesFrame identifier: FrameIdentifier,
                      contentArray: [String]) {
        let frameKey = identifier.frameKey
        if contentArray.isEmpty {
            self.frames[frameKey] = nil
        } else {
            let frame = ComplexTypesFrame(identifier,
                                          version: self.version,
                                          contentArray: contentArray)
            self.frames[frameKey] = frame
        }
    }
    
    public var genre: (genreCategory: GenreType?, genre: String?) {
        get {
            // if the array exists and isn't empty
            var tuple: (genreCategory: GenreType?, genre: String?) = (nil, nil)
            if let frameArray = get(complexTypesFrame: .genre) {
                var presetType: GenreType = .none
                var customString: String = ""
                // for each item in the array...
                for item in frameArray {
                    // if the item isn't an empty string
                    if item != "" {
                        // see if the string is a GenreType rawValue
                        if let genreType = GenreType(rawValue: item) {
                            presetType = genreType
                            // if not return it as a custom genre
                        } else {
                            customString = item
                        }
                    }
                }
                if presetType != .none {
                    tuple.genreCategory = presetType
                }
                if customString != "" {
                    tuple.genre = customString
                }
            }
            return tuple
        }
        set {
            if newValue != (nil, nil) {
                var frameArray = [String]()
                if let genre = newValue.genreCategory, genre != .none {
                    frameArray.append(genre.rawValue)
                }
                if let custom = newValue.genre, custom != "" {
                    frameArray.append(custom)
                }
                set(complexTypesFrame: .genre, contentArray: frameArray)
            } else {
                self.frames[.genre] = nil
            }
        }
    }

    public var mediaType: (mediaType: MediaType?, mediaTypeRefinement: MediaTypeRefinements?, additionalInformation: String?) {
        get {
            var tuple: (mediaType: MediaType?, mediaTypeRefinement: MediaTypeRefinements?, additionalInformation: String?) = (nil, nil, nil)
            // if the array exists and isn't empty
            if let frameArray = get(complexTypesFrame: .mediaType),
               !frameArray.isEmpty {
                var presetType: MediaType = .none
                var presetRefinement: MediaTypeRefinements = .none
                var refinementString: String = ""
                for element in frameArray {
                    if element != "" {
                        // forward slash means it's a refinement string
                        if element.first == "/" {
                            if let refinement = MediaTypeRefinements(code: element) {
                                presetRefinement = refinement
                            }
                            // if it's not a refinement, check to see if it's a media type
                        } else if let type = MediaType(rawValue: element) {
                            presetType = type
                            // if it's not either of those, handle it as a freeform description
                        } else {
                            refinementString = element
                        }
                    }
                }
                if presetType != .none {
                    tuple.mediaType = presetType
                }
                if presetRefinement != .none {
                    tuple.mediaTypeRefinement = presetRefinement
                }
                if refinementString != "" {
                    tuple.additionalInformation = refinementString
                }
            }
            return tuple
        }
        set {
            let identifier = FrameIdentifier.mediaType
            let frameKey = identifier.frameKey
            if newValue != (nil, nil, nil) {
                var frameArray = [String]()
                if let type = newValue.mediaType, type != .none {
                    let string = type.rawValue
                    frameArray.append(string)
                }
                if let refinement = newValue.mediaTypeRefinement, refinement != .none {
                    let string = refinement.code
                    frameArray.append(string)
                }
                if let string = newValue.additionalInformation, string != "" {
                    frameArray.append(string)
                }
                if !frameArray.isEmpty {
                    set(complexTypesFrame: .mediaType,
                        contentArray: frameArray)
                }
            } else {
                self.frames[frameKey] = nil
            }
        }
    }
    
    public var fileType: (fileType: FileType?, fileTypeRefinement: FileTypeRefinements?, additionalInformation: String?) {
        get {
            var tuple: (fileType: FileType?, fileTypeRefinement: FileTypeRefinements?, additionalInformation: String?) = (nil, nil, nil)
            // if the array exists and isn't empty
            if let frameArray = get(complexTypesFrame: .fileType),
               !frameArray.isEmpty {
                var presetType: FileType = .none
                var presetRefinement: FileTypeRefinements = .none
                var refinementString: String = ""
                for element in frameArray {
                    if element != "" {
                        // forward slash means it's a refinement string
                        if element.first == "/" {
                            if let refinement = FileTypeRefinements(rawValue: element) {
                                presetRefinement = refinement
                            }
                            // if it's not a refinement, check to see if it's a media type
                        } else if let type = FileType(rawValue: element) {
                            presetType = type
                            // if it's not either of those, handle it as a freeform description
                        } else {
                            refinementString = element
                        }
                    }
                }
                if presetType != .none {
                    tuple.fileType = presetType
                }
                if presetRefinement != .none {
                    tuple.fileTypeRefinement = presetRefinement
                }
                if refinementString != "" {
                    tuple.additionalInformation = refinementString
                }
            }
            return tuple
        }
        set {
            let identifier = FrameIdentifier.fileType
            let frameKey = identifier.frameKey
            if newValue != (nil, nil, nil) {
                var frameArray = [String]()
                if let type = newValue.fileType, type != .none {
                    let string = type.rawValue
                    frameArray.append(string)
                }
                if let refinement = newValue.fileTypeRefinement, refinement != .none {
                    let string = refinement.rawValue
                    frameArray.append(string)
                }
                if let string = newValue.additionalInformation, string !=
                    "" {
                    frameArray.append(string)
                }
                if !frameArray.isEmpty {
                    set(complexTypesFrame: identifier,
                        contentArray: frameArray)
                }
            } else {
                self.frames[frameKey] = nil
            }
        }
    }
}
