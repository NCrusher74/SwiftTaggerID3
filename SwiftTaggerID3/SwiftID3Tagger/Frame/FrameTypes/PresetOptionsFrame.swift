//
//  GenreFrame.swift
//  SwiftTaggerID3
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
    
    // MARK: Private Initializer
    var presetName: String?
    var presetRefinement: String?
    var refinementDescription: String?
    
    /**
     - parameter presetName: the list of names of the genres or media types.
     - parameter presetRefinement: a list of preset refinements for media types.
     - parameter refinementDescription: a freeform string for customized descriptions.
     */
    init(layout: FrameLayoutIdentifier,
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
    
    /// The frame flags property.
    ///
    /// Typically this is two bytes `[0x00, 0x00]`
    /// SwiftTagger does not support altering these flags.
    var flags: Data
    /// The layout property describes the unique structure of a given frame
    var layout: FrameLayoutIdentifier
    /** The frameKey property
     
     Provides a unique identifier to permits duplication of frame types that the ID3 spec allows to be duplicated within a tag. */
    var frameKey: FrameKey
    /** A boolean value indicating whether or not frames of a particular type are permitted to be duplicated in a valid ID3 tag */
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
    
    /// Initialize a frame parsing operation
    /// - Parameters:
    ///   - contents: the slice of data containing the frame
    ///   - version: the ID3 version of the tag
    ///   - layout: the frame's FrameLayoutIdentifier
    ///   - flags: (current unsupported by SwiftTagger) [0x00, 0x00]
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

internal extension Tag {
    // get and set functions for `PresetOptionsFrame` frame types, which retrieves or sets three strings, all of which are optional (genre only uses two of these.) Each individual frame of this type will call these functions in a get-set property of function, where appropriate.
    func presetOptionsGetter(for frameKey: FrameKey)
        -> (presetName: String?, presetRefinement: String?, description: String?)? {
            // each preset option frame type is handled a little differently
            if let frame = self.frames[.genre],
                case .presetOptionsFrame(let presetOptionsFrame) = frame {
                return (presetName: presetOptionsFrame.presetName,
                        presetRefinement: nil,
                        description: presetOptionsFrame.refinementDescription)
                
            } else if let frame = self.frames[.mediaType],
                case .presetOptionsFrame(let presetOptionsFrame) = frame {
                return (presetName: presetOptionsFrame.presetName,
                        presetRefinement: presetOptionsFrame.presetRefinement,
                        description: presetOptionsFrame.refinementDescription)
                
            } else if let frame = self.frames[.fileType],
                case .presetOptionsFrame(let presetOptionsFrame) = frame {
                return (presetName: presetOptionsFrame.presetName,
                        presetRefinement: presetOptionsFrame.presetRefinement,
                        description: presetOptionsFrame.refinementDescription)
            }; return nil
    }
    
    mutating func set(_ layout: FrameLayoutIdentifier,
                      _ frameKey: FrameKey,
                      to presetName: String?,
                      and presetRefinement: String?,
                      with description: String?) {
        let frame = PresetOptionsFrame(layout: layout,
                                       presetName: presetName,
                                       presetRefinement: presetRefinement,
                                       refinementDescription: description)
        self.frames[frameKey] = .presetOptionsFrame(frame)
    }

}
// MARK: Tag Extension

public extension Tag {
    /// - Genre getter ID3 Identifier: `TCO`/`TCON`
    /// The `genreName` parameter refers to specific genre or genres catalogued by numeric codes in the `GenreType` enum.
    /// The `genreDescription` parameter is a freeform field that may be used to refine existing genres or create custom genres
    var genre: (genreName: String?, genreDescription: String?) {
        get {
            let name = presetOptionsGetter(for: .genre)?.presetName
            let description = presetOptionsGetter(for: .genre)?.description
            return (name, description)
        }
        set {
            set(.known(.genre), .genre,
                to: newValue.genreName,
                and: nil,
                with: newValue.genreDescription)
        }
    }
    
    /// - MediaType getter-setter. ID3 Identifier: `TMT`/`TMED`
    /// The `mediaType` parameter refers to specific type of media catalogued by codes in the `MediaType` enum.
    /// The `additionalMediaInfo` parameter refers to specific type of refinement pertaining to the `MediaType`, catalogued by codes in the `MediaTypeRefinements` enum
    /// The `mediaTypeDescription` parameter is a freeform field that may be used to refine existing information
    var mediaType: (mediaType: String?, additionalMediaInfo: String?, mediaTypeDescription: String?) {
        get {
            let presetName = presetOptionsGetter(for: .mediaType)?.presetName
            let presetRefinement = presetOptionsGetter(for: .mediaType)?.presetRefinement
            let description = presetOptionsGetter(for: .mediaType)?.description
            return (presetName, presetRefinement, description)
        }
        set {
            set(.known(.mediaType), .mediaType,
                to: newValue.mediaType,
                and: newValue.additionalMediaInfo,
                with: newValue.mediaTypeDescription)
        }
    }
    
    /// - FileType getter-setter. ID3 Identifier: `TFT`/`TFLT`
    /// The `fileType` parameter refers to specific type of file catalogued by codes in the `FileType` enum.
    /// The `additionalFileTypeInfo` parameter refers to specific type of refinement pertaining to the `FileType`, catalogued by codes in the `FileTypeRefinements` enum
    /// The `fileTypeDescription` parameter is a freeform field that may be used to refine existing information
    var fileType: (fileType: String?, additionalFileTypeInfo: String?, fileTypeDescription: String?) {
        get {
            let presetName = presetOptionsGetter(for: .fileType)?.presetName
            let presetRefinement = presetOptionsGetter(for: .fileType)?.presetRefinement
            let description = presetOptionsGetter(for: .fileType)?.description
            return (presetName, presetRefinement, description)
        }
        set {
            set(.known(.fileType), .fileType,
                to: newValue.fileType,
                and: newValue.additionalFileTypeInfo,
                with: newValue.fileTypeDescription)
        }
    }
}
