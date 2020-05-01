//
//  GenreFrame.swift
//  SwiftTagger_MacOS
//
//  Some of this code is adapted from ID3TagEditor
//  Created by Fabrizio Duroni on 27/02/2018.
//  2018 Fabrizio Duroni. https://github.com/chicio/ID3TagEditor
//
//  Created by Nolaine Crusher on 4/11/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

/**
 A type used to represent an ID3 genre frame
 */
struct PresetOptionsFrame: FrameProtocol {
    
    // initializer for Genre Frame
    init(genreName: GenreType?,
                genreDescription: String?) {
        self.init(layout: .known(.genre),
                  presetName: String(genreName?.code ?? 255),
                  presetRefinement: nil,
                  refinementDescription: genreDescription)
    }
    
    init(mediaType: MediaType?,
                additionalMediaInfo: MediaTypeRefinements?,
                mediaTypeDescription: String?) {
        self.init(layout: .known(.mediaType),
                  presetName: mediaType?.code,
                  presetRefinement: additionalMediaInfo?.code,
                  refinementDescription: mediaTypeDescription)
    }

    init(fileType: FileType?,
                additionalFileTypeInfo: FileTypeRefinements?,
                fileTypeDescription: String?) {
        self.init(layout: .known(.fileType),
                  presetName: fileType?.rawValue,
                  presetRefinement: additionalFileTypeInfo?.code,
                  refinementDescription: fileTypeDescription)
    }

    // MARK: Private Initializer
    
    var presetName: String?
    var presetRefinement: String?
    var refinementDescription: String?
    
    /**
     - parameter presetName: the list of names of the genres or media types.
     - parameter presetRefinement: a list of preset refinements for media types.
     - parameter refinementDescription: a freeform string for customized descriptions.
     */
    private init(layout: FrameLayoutIdentifier,
                 presetName: String?,
                 presetRefinement: String?,
                 refinementDescription: String?) {
        self.presetName = presetName
        self.presetRefinement = presetRefinement
        self.refinementDescription = refinementDescription
        self.flags = PresetOptionsFrame.defaultFlags
        self.layout = layout
        
        switch layout {
            case .known(.genre) : self.frameKey = .genre
            case .known(.mediaType) : self.frameKey = .mediaType
            case .known(.fileType) : self.frameKey = .fileType
            default: self.frameKey = .userDefinedText(description: refinementDescription ?? "")
        }
    }
    
    var flags: Data
    var layout: FrameLayoutIdentifier
    var frameKey: FrameKey
    var allowMultipleFrames: Bool = false
    
    // MARK: Encode contents for writing
    func encodeContents(version: Version) throws -> Data {
        var frameData = Data()
        // append encoding byte
        frameData.append(StringEncoding.preferred.rawValue.encoding(
            endianness: .bigEndian))
        // encode and append presetType
        if let convertedType = convertAndEncodePresetType(version: version) {
            frameData.append(convertedType)
        }
        // encode and append presetRefinement
        if let convertedPresetRefinement = convertAndEncodePresetRefinement(version: version) {
            frameData.append(convertedPresetRefinement)
        }
        // encode and append freeform refinement/description
        if let convertedRefinement = encodeRefinementString(version: version) {
            frameData.append(convertedRefinement)
        }
        return frameData
    }
    
    // encode presetType
    private func convertAndEncodePresetType(version: Version) -> Data? {
        switch version {
            case .v2_2, .v2_3 :
                let presetCode = PresetOption(presetName: self.presetName ?? "").code
                return (presetCode).encoded(withNullTermination: false)
            case .v2_4 :
                let presetCode = PresetOption(presetName: self.presetName ?? "").code
                return (presetCode).encoded(withNullTermination: true)
        }
    }
    
    // encode presetRefinement
    private func convertAndEncodePresetRefinement(version: Version) -> Data? {
        var refinementCode: String = ""
        switch version {
            case .v2_2, .v2_3 :
                if let refinement = self.presetRefinement {
                    if self.layout == .known(.mediaType) {
                        refinementCode = MediaTypeRefinements(rawValue: refinement)?.code ?? ""
                    } else if self.layout == .known(.fileType) {
                        refinementCode = FileTypeRefinements(rawValue: refinement)?.code ?? ""
                    }
                }
                return refinementCode.encoded(withNullTermination: false)
            case .v2_4 :
                if let refinement = self.presetRefinement {
                    if self.layout == .known(.mediaType) {
                        refinementCode = MediaTypeRefinements(rawValue: refinement)?.code ?? ""
                    } else if self.layout == .known(.fileType) {
                        refinementCode = FileTypeRefinements(rawValue: refinement)?.code ?? ""
                    }
            }
                return refinementCode.encoded(withNullTermination: true)
        }
    }
    
    // encode freeform refinement/description
    private func encodeRefinementString(version: Version) -> Data? {
        switch version {
            case .v2_2, .v2_3 :
                if let refinement = self.refinementDescription {
                    return refinement.encoded(withNullTermination: false)
            }
            case .v2_4 :
                if let refinement = self.refinementDescription {
                    return refinement.encoded(withNullTermination: true)
            }
        }; return nil
    }
    
    // MARK: parse contents for reading
    init(decodingContents contents: Data.SubSequence,
         version: Version,
         layout: FrameLayoutIdentifier,
         flags: Data
    ) throws {
        self.flags = flags // this is just here for protocol comformance
        self.layout = layout
        
        switch layout {
            case .known(.genre) : self.frameKey = .genre
            case .known(.mediaType) : self.frameKey = .mediaType
            case .known(.fileType) : self.frameKey = .fileType
            default: self.frameKey = .userDefinedText(description: self.refinementDescription ?? "")
        }
        
        var parsing = contents
        
        let encoding = try PresetOptionsFrame.extractEncoding(data: &parsing, version: version)
        var parsedArray: [String] = []
        
        // versions 2.2 and 2.3 handle strings differently than version 2.4.
        // 2.2 and 2.3 relies on parentheses, while 2.4 just uses null termination
        if version == .v2_2 || version == .v2_3 {
            let unparsedString = parsing.extractPrefixAsStringUntilNullTermination(encoding) ?? ""
            parsedArray = parseParentheticalString(unparsedString: unparsedString)
        } else {
            while !parsing.isEmpty,
                let next = parsing.extractPrefixAsStringUntilNullTermination(encoding) {
                    parsedArray.append(next)
            }
            
            for parsedComponent in parsedArray {
                if layout == .known(.genre) {
                    var genreType: GenreType = .none
                    
                    // check to see if the component is one of the genre "special cases"
                    if parsedComponent == "CR" {
                        genreType = .Cover
                    } else if parsedComponent == "RX" {
                        genreType = .Remix
                        
                        // if not, check to make sure it's a valid genre "code"
                    } else if let genreInt = Int(parsedComponent) {
                        let parsedName = (GenreType.codeToRawValueMapping[genreInt]) ?? ""
                        let validGenre = GenreType(rawValue: parsedName)
                        genreType = validGenre ?? .none
                        
                        // if it's not a special case or valid genre code, handle it as a freeform string
                    } else {
                        self.refinementDescription = parsedComponent
                    }
                    self.presetName = genreType.rawValue
                    
                } else if layout == .known(.mediaType) {
                    
                    // check to see if it's a preset refinement string
                    // only preset refinement strings should start with "/"
                    if parsedComponent.first == "/" {
                        self.presetRefinement = MediaTypeRefinements(rawValue: parsedComponent)!.rawValue
                        
                        // if it's not a preset refinement string
                        // check to see if it's a known media type code
                    } else if let parsedName = MediaType.codeToNameMapping[parsedComponent] {
                        self.presetName = MediaType(rawValue: parsedName)!.rawValue
                        
                        // if neither of those is true, treat it as a freeform string
                    } else {
                        self.refinementDescription = parsedComponent
                    }
                } else if layout == .known(.fileType) {
                    if parsedComponent.first == "/" {
                        self.presetRefinement = FileTypeRefinements(rawValue: parsedComponent)!.rawValue
                    } else {
                        self.presetName = parsedComponent
                    }
                }
            }
        }
    }
    
    // parse the parentheses out of version 2.2 and 2.3 strings
    private func parseParentheticalString(unparsedString: String) -> [String] {
        var stringComponents = unparsedString.components(separatedBy: "(")
        for (index, value) in stringComponents.enumerated() {
            if index != 0 && value == "" {
                let previousIndex = index - 1
                let nextIndex = index + 1
                let rangeToReplace = previousIndex...nextIndex
                stringComponents[nextIndex].insert("(", at: stringComponents[nextIndex].startIndex)
                let componentsToJoin = [stringComponents[previousIndex], stringComponents[nextIndex]]
                let joinedComponents = [componentsToJoin.joined()]
                stringComponents.replaceSubrange(rangeToReplace, with: joinedComponents)
                stringComponents.removeAll(where: {$0 == ""})
            }
        }
        var refinedComponents: [String] = []
        for component in stringComponents {
            if component.contains(")") {
                var separatedComponents = component.components(separatedBy: ")")
                separatedComponents.removeAll(where: {$0 == ""})
                for (index, value) in separatedComponents.enumerated() {
                    if value.contains("(") {
                        var valueToChange = value
                        valueToChange.append(")")
                        separatedComponents.remove(at: index)
                        separatedComponents.insert(valueToChange, at: index)
                    }
                }
                refinedComponents.append(contentsOf: separatedComponents)
            }
        }
        return refinedComponents
    }
}

// MARK: Tag Extension

public extension Tag {
    /// - Genre getter ID3 Identifier: `TCO`/`TCON`
    var genre: (genreName: String?, genreDescription: String?) {
        get {
            if let frame = self.frames[.genre],
                case .presetOptionsFrame(let presetOptionsFrame) = frame {
                return (presetOptionsFrame.presetName, presetOptionsFrame.refinementDescription)
            } else {
                return (nil,nil)
            }
        }
    }
    
    /// genre setter
    /// The `genreName` parameter refers to specific genre or genres catalogued by numeric codes in the `GenreType` enum.
    /// The `genreDescription` parameter is a freeform field that may be used to refine existing genres or create custom genres
    mutating func setGenre(genreName: GenreType?, genreDescription: String?) throws {
        let key = FrameKey.genre
        self.frames[key] = Frame.presetOptionsFrame(.init(genreName: genreName, genreDescription: genreDescription))
    }
    
    /// - MediaType getter-setter. ID3 Identifier: `TMT`/`TMED`
    var mediaType: (mediaType: String?, additionalMediaInfo: String?, mediaTypeDescription: String?) {
        get {
            if let frame = self.frames[.mediaType],
                case .presetOptionsFrame(let presetOptionsFrame) = frame {
                return (presetOptionsFrame.presetName, presetOptionsFrame.presetRefinement, presetOptionsFrame.refinementDescription)
            } else {
                return (nil,nil,nil)
            }
        }
    }
    
    /// mediaType setter
    /// The `mediaType` parameter refers to specific type of media catalogued by codes in the `MediaType` enum.
    /// The `additionalMediaInfo` parameter refers to specific type of refinement pertaining to the `MediaType`, catalogued by codes in the `MediaTypeRefinements` enum
    /// The `mediaTypeDescription` parameter is a freeform field that may be used to refine existing information
    mutating func setMediaType(mediaType: MediaType?, additionalMediaInfo: MediaTypeRefinements?, mediaTypeDescription: String?) throws {
        let key = FrameKey.mediaType
        self.frames[key] = Frame.presetOptionsFrame(.init(mediaType: mediaType, additionalMediaInfo: additionalMediaInfo, mediaTypeDescription: mediaTypeDescription))
    }
    
    /// - FileType getter-setter. ID3 Identifier: `TFT`/`TFLT`
    var fileType: (fileType: String?, additionalFileTypeInfo: String?, fileTypeDescription: String?) {
        get {
            if let frame = self.frames[.fileType],
                case .presetOptionsFrame(let presetOptionsFrame) = frame {
                return (presetOptionsFrame.presetName, presetOptionsFrame.presetRefinement, presetOptionsFrame.refinementDescription)
            } else {
                return (nil,nil,nil)
            }
        }
    }
    
    /// file type setter
    /// The `fileType` parameter refers to specific type of file catalogued by codes in the `FileType` enum.
    /// The `additionalFileTypeInfo` parameter refers to specific type of refinement pertaining to the `FileType`, catalogued by codes in the `FileTypeRefinements` enum
    /// The `fileTypeDescription` parameter is a freeform field that may be used to refine existing information
    mutating func setFileType(fileType: FileType?, additionalFileTypeInfo: FileTypeRefinements?, fileTypeDescription: String?) throws {
        let key = FrameKey.fileType
        self.frames[key] = Frame.presetOptionsFrame(.init(fileType: fileType, additionalFileTypeInfo: additionalFileTypeInfo, fileTypeDescription: fileTypeDescription))
    }
}
