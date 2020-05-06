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

/// A type representing a frame with up to three optional strings as content, at least one of which is required to be pre-set content.

struct PresetOptionsFrame: FrameProtocol {
    
    // MARK: Properties
    var flags: Data
    var layout: FrameLayoutIdentifier
    var frameKey: FrameKey
    var allowMultipleFrames: Bool = false
    
    // frame-specific properties
    var presetName: String?
    var presetRefinement: String?
    var refinementDescription: String?
    
    // MARK: Frame parsing
    init(decodingContents contents: Data.SubSequence,
         version: Version,
         layout: FrameLayoutIdentifier,
         flags: Data
    ) throws {
        self.flags = flags // this is just here for protocol comformance
        self.layout = layout
        if layout == .known(.genre) {
            self.frameKey = .genre
        } else if layout == .known(.mediaType) {
            self.frameKey = .mediaType
        } else {
            self.frameKey = .fileType
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
                    let genreCodeIntRange = 0...191
                    // check to see if the component is one of the genre "special cases"
                    if parsedComponent == "CR" {
                        genreType = .Cover
                    } else if parsedComponent == "RX" {
                        genreType = .Remix
                        
                        // if not, check to make sure it's a valid genre code
                    } else if genreCodeIntRange.contains(Int(parsedComponent) ?? 255) {
                        let validGenre = GenreType(code: Int(parsedComponent) ?? 255)
                        genreType = validGenre
                        
                        // if it's not a special case or valid genre code, handle it as a freeform string
                    } else {
                        self.refinementDescription = parsedComponent
                    }
                    // initialize presetName to the raw value of the genre type
                    self.presetName = String(genreType.code)
                } else if layout == .known(.mediaType) {
                    
                    // check to see if it's a preset refinement string
                    // only preset refinement strings should start with "/"
                    if parsedComponent.first == "/" {
                        self.presetRefinement = MediaTypeRefinements(rawValue: parsedComponent)!.rawValue
                        
                    // if it's not a preset refinement string
                    // check to see if it's a known media type code
                    } else if MediaType.allCases.contains(MediaType(rawValue: parsedComponent) ?? .none) {
                        self.presetName = parsedComponent
                    // if neither of those is true, handle it as a freeform string
                    } else {
                        self.refinementDescription = parsedComponent
                    }
                } else if layout == .known(.fileType) {
                    if parsedComponent.first == "/" {
                        self.presetRefinement = parsedComponent
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
    
    // MARK: Frame building
    /**
     Initialize a frame-building operation
     Parameters:
       - layout: the frame's layout
       - presetName: the list of names of the genres or media types.
       - presetRefinement: a list of preset refinements for media types.
       - refinementDescription: a freeform string for customized descriptions.
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
        if layout == .known(.genre) {
            self.frameKey = .genre
        } else if layout == .known(.mediaType) {
            self.frameKey = .mediaType
        } else {
            self.frameKey = .fileType
        }
    }
    
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
                        refinementCode = FileTypeRefinements(rawValue: refinement)?.rawValue ?? ""
                    }
                }
                return refinementCode.encoded(withNullTermination: false)
            case .v2_4 :
                if let refinement = self.presetRefinement {
                    if self.layout == .known(.mediaType) {
                        refinementCode = MediaTypeRefinements(rawValue: refinement)?.code ?? ""
                    } else if self.layout == .known(.fileType) {
                        refinementCode = FileTypeRefinements(rawValue: refinement)?.rawValue ?? ""
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
}

// MARK: Tag extensions
extension Tag {
    // get and set functions for `PresetOptionsFrame` frame types, which retrieves or sets three strings, all of which are optional (genre only uses two of these.) Each individual frame of this type will call these functions in a get-set property of function, where appropriate.
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
    
    /// - Genre getter ID3 Identifier: `TCO`/`TCON`
    /// `genreName`: refers to specific genre or genres catalogued by numeric codes in the `GenreType` enum.
    /// `genreDescription`: a freeform string for custom genre
    public var genre: (
        genreName: GenreType?,
        genreDescription: String?)? {
        get {
            if let frame = self.frames[.genre],
                case .presetOptionsFrame(let presetOptionsFrame) = frame {
                // the genre should be stored as an integer string of the code. We will fetch is as an integer
                let nameAsInt: Int = Int(presetOptionsFrame.presetName ?? "") ?? 255
                // initialize the genre type using the code
                let name = GenreType(code: nameAsInt)
                let description = presetOptionsFrame.refinementDescription
                return (name, description)
            }; return nil
        }
        set {
            set(.known(.genre), .genre,
                to: String(newValue?.genreName?.code ?? 255),
                and: nil,
                with: newValue?.genreDescription)
        }
    }
    
    //    / The `mediaTypeDescription` parameter is a freeform field that may be used to refine existing information
    /// MediaType getter-setter. ID3 identifier `TMT`/`TMED`
    /// `mediaType`: refers to specific type of media catalogued by codes in the `MediaType` enum.
    /// `additionalMediaInfo`: refers to a specific type of refinement pertaining to the `MediaType`, catalogued by codes in the `MediaTypeRefinements` enum
    /// `mediaTypeDescription`: a freeform string
    public var mediaType: (
        mediaType: MediaType?,
        additionalMediaInfo: MediaTypeRefinements?,
        mediaTypeDescription: String?)? {
        get {
            if let frame = self.frames[.mediaType],
                case .presetOptionsFrame(let presetOptionsFrame) = frame {
                // the media type and preset refinements should be stored as a string of the code.
                let presetName = MediaType(rawValue: presetOptionsFrame.presetName ?? "")
                let presetRefinement = MediaTypeRefinements(code: presetOptionsFrame.presetRefinement ?? "")
                let description = presetOptionsFrame.refinementDescription
                return (presetName, presetRefinement, description)
            }; return nil
        }
        set {
            set(.known(.mediaType), .mediaType,
                to: newValue?.mediaType?.rawValue,
                and: newValue?.additionalMediaInfo?.code,
                with: newValue?.mediaTypeDescription)
        }
    }
    
    /// - FileType getter-setter. ID3 Identifier: `TFT`/`TFLT`
    /// `fileType`: refers to specific type of file catalogued by codes in the `FileType` enum.
    /// `additionalFileTypeInfo`: refers to specific type of refinement pertaining to the `FileType`, catalogued by codes in the `FileTypeRefinements` enum
    /// `fileTypeDescription`: is a freeform string
    public var fileType: (
        fileType: FileType?,
        additionalFileTypeInfo: FileTypeRefinements?,
        fileTypeDescription: String?)? {
        get {
            if let frame = self.frames[.fileType],
                case .presetOptionsFrame(let presetOptionsFrame) = frame {
                let presetName = FileType(rawValue: presetOptionsFrame.presetName ?? "")
                // the preset refinement should be stored as a string of the code.
                let presetRefinement = FileTypeRefinements(rawValue: presetOptionsFrame.presetRefinement ?? "")
                let description = presetOptionsFrame.refinementDescription
                return (presetName, presetRefinement, description)
            }; return nil
        }
        set {
            set(.known(.fileType), .fileType,
                to: newValue?.fileType?.rawValue,
                and: newValue?.additionalFileTypeInfo?.rawValue,
                with: newValue?.fileTypeDescription)
        }
    }
}
