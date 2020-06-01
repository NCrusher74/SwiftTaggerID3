/*

 PresetOptionsFrame.swift
 SwiftTaggerID3

 Copyright ©2020 Nolaine Crusher. All rights reserved.

 */

import Foundation

/// A type representing a frame with up to three optional strings as content, at least one of which is required to be pre-set content.
struct PresetOptionsFrame: FrameProtocol, CustomStringConvertible {
    public var description: String {
        return """
        frameKey: .\(self.frameKey):
        \(self.genreMediaOrFileInfo)
        """
    }

    
    // MARK: Properties
    // (inherited from FrameProtocol)
    var flags: Data
    var layout: FrameLayoutIdentifier
    var frameKey: FrameKey
    
    // the array of strings from the frame
    var genreMediaOrFileInfo: [String?]
    
    init(decodingContents contents: Data.SubSequence,
         version: Version,
         layout: FrameLayoutIdentifier,
         flags: Data) throws {
        self.flags = flags
        self.layout = layout
        self.frameKey = layout.frameKey(additionalIdentifier: nil)
        
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
            if self.frameKey == .genre {
                self.genreMediaOrFileInfo = PresetOptionsFrame.parseGenreStrings(parsedArray: parsedArray)
            } else if self.frameKey == .mediaType {
                self.genreMediaOrFileInfo = PresetOptionsFrame.parseMediaTypeStrings(parsedArray: parsedArray)
            } else {
                self.genreMediaOrFileInfo = PresetOptionsFrame.parseFileTypeStrings(parsedArray: parsedArray)
        }
    }

    
    // MARK: Frame Building
    init(_ layout: FrameLayoutIdentifier,
         genreMediaOrFileInfo: [String?]) {
        self.layout = layout
        self.genreMediaOrFileInfo = genreMediaOrFileInfo
        self.flags = PresetOptionsFrame.defaultFlags
        self.frameKey = layout.frameKey(additionalIdentifier: nil)
    }
    
    func encodeContents(version: Version) throws -> Data {
        var frameData = Data()
        // append encoding byte
        frameData.append(StringEncoding.preferred.rawValue)
        switch version {
            case .v2_2, .v2_3: // null termination will be false
                if self.frameKey == .genre {
                    frameData.append(
                        reassembleAndEncodeGenreParentheticalStrings())
                } else if self.frameKey == .mediaType {
                    frameData.append(
                        reassembleAndEncodeMediaTypeParentheticalStrings())
                } else if self.frameKey == .fileType {
                    frameData.append(reassembleAndEncodeFileTypeStrings())
            }
            case .v2_4: // null termination will be true
                if self.frameKey == .genre {
                    frameData.append(
                        reassembleAndEncodeNonParentheticalGenreStrings())
                } else if self.frameKey == .mediaType {
                    frameData.append(
                        reassembleAndEncodeNonParentheticalMediaTypeStrings())
                } else if self.frameKey == .fileType {
                    frameData.append(
                        reassembleAndEncodeNonParentheticalFileTypeStrings())
            }
        }
        return frameData
    }
    
    // NOTE: This will produce a numeric code wrapped in parentheses, which is in keeping with the spec, but a lot of metadata reading apps won't extrapolate from the numeric code to a genre type
    private func reassembleAndEncodeGenreParentheticalStrings() -> Data {
        var newArray: [String] = []
        for item in self.genreMediaOrFileInfo {
            // get rid of the empty strings
            if item != "" {
                // see if the item represents a genreType
                if let genreType = GenreType(rawValue: item ?? "") {
                    // if it does, append the code in parens to the return array
                    if genreType == .Remix {
                        newArray.append("(RX)")
                    } else if genreType == .Cover {
                        newArray.append("(CR)")
                    } else {
                        newArray.append("(\(genreType.code))")
                    }
                } else {
                    // otherwise just append the string to the array
                    newArray.append(item ?? "")
                }
            }
        }
        var genreData = Data()
        for item in newArray {
            genreData.append(item.encoded(withNullTermination: false))
        }
        return genreData
    }
    
    private func reassembleAndEncodeNonParentheticalGenreStrings() -> Data {
        var frameData = Data()
        // convert the raw value to the numerical code, if necessary
        for item in self.genreMediaOrFileInfo {
            if let itemString = item, itemString != "" {
                if let genreType = GenreType(rawValue: itemString) {
                    var itemCode: String = ""
                    if genreType == .Remix {
                        itemCode = "RX"
                    } else if genreType == .Cover {
                        itemCode = "CR"
                    } else {
                        itemCode = String(genreType.code)
                    }
                    frameData.append(itemCode.encoded(withNullTermination: true))
                } else {
                    frameData.append(itemString.encoded(withNullTermination: true))
                }
            }
        }
        return frameData
    }
    
    private func reassembleAndEncodeMediaTypeParentheticalStrings() -> Data {
        var newArray: [String] = []
        for (index, item) in self.genreMediaOrFileInfo.enumerated() {
            // make sure the item isn't an empty string
            if item != "" {
                // check if it's a valid media type
                if let mediaType = MediaType(rawValue: item ?? "") {
                    if let nextItem = self.genreMediaOrFileInfo[index + 1], nextItem.first == "/" {
                            if let refinement = MediaTypeRefinements(
                                code: nextItem) {
                                // if it is, merge them into a single string
                                let mergedItems = "(\(mediaType.rawValue)\(refinement.code))"
                                // add them to the new array
                                newArray.append(mergedItems)
                            }
                        } else {
                            // if there's not a refinement after it, but it is a media type raw value
                            // wrap it in parens and call it a day
                            let wrappedItem = "(\(mediaType.rawValue))"
                            newArray.append(wrappedItem)
                        }
                    // if it's not a media type or refinement, add it to the array as is
                } else if item?.first != "/" {
                    newArray.append(item ?? "")
                }
            }
        }
        var mediaTypeData = Data()
        for item in newArray {
            mediaTypeData.append(item.encoded(withNullTermination: false))
        }
        return mediaTypeData
    }
    
    private func reassembleAndEncodeNonParentheticalMediaTypeStrings() -> Data {
        var frameData = Data()
        for (index, item) in self.genreMediaOrFileInfo.enumerated() {
            // make sure the string isn't empty
            if let itemString = item, itemString != "" {
                // if the string represents a valid media type
                if let mediaType = MediaType(rawValue: itemString) {
                    // see if the next one is a valid refinement
                    if let nextItem = self.genreMediaOrFileInfo[index + 1], nextItem.first == "/" {
                            if let refinement = MediaTypeRefinements(code: nextItem) {
                                // if it is, merge them into one string
                                let mergedItems = "\(mediaType.rawValue)\(refinement.code)"
                                // and encode them together
                                frameData.append(mergedItems.encoded(withNullTermination: true))
                        }
                        // if it isn't, encode the media type raw value by itself
                    } else {
                        frameData.append(mediaType.rawValue.encoded(withNullTermination: true))
                    }
                    // if the item isn't a media type or a refinement, encode it as is
                } else if itemString.first != "/" {
                    frameData.append(itemString.encoded(
                        withNullTermination: true))
                }
            }
        }
        return frameData
    }
    
    // According to the letter of the specs, fileType isn't supposed to have parentheses
    // however, it's easier to parse the codes from the freeform string this way
    private func reassembleAndEncodeFileTypeStrings() -> Data {
        var newArray: [String] = []
        for (index, item) in self.genreMediaOrFileInfo.enumerated() {
            // make sure the item isn't an empty string
            if item != "" {
                // check if it's a valid file type
                if let fileType = FileType(rawValue: item ?? "") {
                    if let nextItem = self.genreMediaOrFileInfo[index + 1], nextItem.first == "/" {
                            if let refinement = FileTypeRefinements(
                                rawValue: nextItem) {
                                // if it is, merge them into a single string, no parens
                                let mergedItems = "(\(fileType.rawValue)\(refinement.rawValue))"
                                // add them to the new array
                                newArray.append(mergedItems)
                            }
                    } else {
                        // if there's not a refinement after it, but it is a file type raw value
                        // add it to the array
                        let fileTypeItem = "(\(fileType.rawValue))"
                        newArray.append(fileTypeItem)
                    }
                    // if it's not a media type or refinement, add it to the array as is
                } else if item?.first != "/" {
                    newArray.append(item ?? "")
                }
            }
        }
        var fileTypeData = Data()
        for item in newArray {
            fileTypeData.append(item.encoded(withNullTermination: false))
        }
        return fileTypeData
    }

    private func reassembleAndEncodeNonParentheticalFileTypeStrings() -> Data {
        var frameData = Data()
        for (index, item) in self.genreMediaOrFileInfo.enumerated() {
            if let itemString = item, itemString != "" {
                if let fileType = FileType(rawValue: itemString) {
                    if let nextItem = self.genreMediaOrFileInfo[index + 1], nextItem.first == "/" {
                        if let refinement = FileTypeRefinements(rawValue: nextItem) {
                            let mergedItems = "\(fileType.rawValue)\(refinement.rawValue)"
                            frameData.append(
                                mergedItems.encoded(withNullTermination: true))
                        }
                    } else {
                        frameData.append(fileType.rawValue.encoded(
                                withNullTermination: true))
                    }
                } else if itemString.first != "/" {
                    frameData.append(itemString.encoded(
                        withNullTermination: true))
                }
            }
        }
        return frameData
    }

    
}

// MARK: Tag extensions
// get and set functions for `PresetOptionsFrame` frame types, which retrieves or sets three strings, all of which are optional (genre only uses two of these.) Each individual frame of this type will call these functions in a get-set property of function, where appropriate.
@available(OSX 10.12, *)
extension Tag {
    func presetOptionArray(for frameKey: FrameKey) -> [String?]? {
        if let frame = self.frames[frameKey],
            case .presetOptionsFrame(let presetOptionsFrame) = frame {
            return presetOptionsFrame.genreMediaOrFileInfo
        }; return nil
    }
    
    internal mutating func set(_ layout: FrameLayoutIdentifier,
                               _ frameKey: FrameKey,
                               infoArray: [String?]) {
        let frame = PresetOptionsFrame(
            layout, genreMediaOrFileInfo: infoArray)
        self.frames[frameKey] = .presetOptionsFrame(frame)
    }
    
    public var genre: (presetGenre: GenreType?, customGenre: String?)? {
        get {
            var presetType: GenreType? = nil
            var customString: String? = ""
            // if the array exists and isn't empty
            if let frameArray = presetOptionArray(for: .genre) {
                // for each item in the array...
                for item in frameArray {
                    // if the item isn't an empty string
                    if let itemString = item, itemString != "" {
                        // see if the string is a GenreType rawValue
                        if let genreType = GenreType(rawValue: itemString) {
                            presetType = genreType
                            // if not return it as a custom genre
                        } else {
                            customString = itemString
                        }
                    }
                }
            }
            return (presetType, customString)
        }
        set {
            var frameArray = [String?]()
            frameArray.append(newValue?.presetGenre?.rawValue)
            frameArray.append(newValue?.customGenre)
            set(.known(.genre), .genre, infoArray: frameArray)
        }
    }
    
    public var mediaType: (mediaType: MediaType?, mediaTypeRefinement: MediaTypeRefinements?, additionalInformation: String?)? {
        get {
            var presetType: MediaType? = nil
            var presetRefinement: MediaTypeRefinements? = nil
            var refinementString: String? = ""
            // if the array exists and isn't empty
            if let frameArray = presetOptionArray(for: .mediaType),
                !frameArray.isEmpty {
                for element in frameArray {
                    if let elementString = element, elementString != "" {
                        // forward slash means it's a refinement string
                        if elementString.first == "/" {
                            presetRefinement = MediaTypeRefinements(code: elementString)
                            // if it's not a refinement, check to see if it's a media type
                        } else if MediaType(rawValue: elementString) != nil {
                            presetType = MediaType(rawValue: elementString)
                            // if it's not either of those, handle it as a freeform description
                        } else {
                            refinementString = elementString
                        }
                    }
                }
            }
            return (presetType, presetRefinement, refinementString)
        }
        set {
            var frameArray = [String?]()
            frameArray.append(newValue?.mediaType?.rawValue)
            frameArray.append(newValue?.mediaTypeRefinement?.code)
            frameArray.append(newValue?.additionalInformation)
            set(.known(.mediaType), .mediaType, infoArray: frameArray)
            
        }
    }
    
    public var fileType: (fileType: FileType?, fileTypeRefinement: FileTypeRefinements?, additionalInformation: String?)? {
        get {
            var presetType: FileType? = nil
            var presetRefinement: FileTypeRefinements? = nil
            var refinementString: String? = ""
            // if the array exists and isn't empty
            if let frameArray = presetOptionArray(for: .fileType),
                !frameArray.isEmpty {
                for element in frameArray {
                    if let elementString = element, elementString != "" {
                        // forward slash means it's a refinement string
                        if elementString.first == "/" {
                            presetRefinement = FileTypeRefinements(rawValue: elementString)
                            // if it's not a refinement, check to see if it's a media type
                        } else if FileType(rawValue: elementString) != nil {
                            presetType = FileType(rawValue: elementString)
                            // if it's not either of those, handle it as a freeform description
                        } else {
                            refinementString = elementString
                        }
                    }
                }
            }
            return (presetType, presetRefinement, refinementString)
        }
        set {
            var frameArray = [String?]()
            frameArray.append(newValue?.fileType?.rawValue)
            frameArray.append(newValue?.fileTypeRefinement?.rawValue)
            frameArray.append(newValue?.additionalInformation)
            set(.known(.fileType), .fileType, infoArray: frameArray)
        }
    }
}
