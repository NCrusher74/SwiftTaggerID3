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
    public init(genreName: GenreType?,
                genreDescription: String?) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.genre),
                  presetType: PresetOption.genreType(
                    GenreType(rawValue: genreName?.rawValue ?? "") ?? .none),
                  presetRefinement: nil,
                  refinementDescription: genreDescription)
    }

    public init(mediaType: MediaType?,
                additionalMediaInfo: MediaTypeRefinements?,
                mediaTypeDescription: String?) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.mediaType),
                  presetType: PresetOption.mediaType(
                    MediaType(rawValue: mediaType?.rawValue ?? "") ?? .none),
                  presetRefinement: additionalMediaInfo,
                  refinementDescription: mediaTypeDescription)
    }

    // MARK: Private Initializer
    
    private var presetType: PresetOption?
    private var presetRefinement: MediaTypeRefinements?
    private var refinementDescription: String?
    
    /**
     - parameter presetType: the list of names of the genres or media types.
     - parameter presetRefinement: a list of preset refinements for media types.
     - parameter refinementDescription: a freeform string for customized descriptions.
     */
    private init(layout: FrameLayoutIdentifier,
                 presetType: PresetOption?,
                 presetRefinement: MediaTypeRefinements?,
                 refinementDescription: String?) {
        self.presetType = presetType
        self.presetRefinement = presetRefinement
        self.refinementDescription = refinementDescription
        self.flags = PresetOptionsFrame.defaultFlags()
        self.layout = layout
    }
    
    var flags: Data
    var layout: FrameLayoutIdentifier
    
    
    // MARK: Encode contents for writing
    internal func encodeContents(version: Version) throws -> Data {
        var encodedName = Data()
        var encodedPresetRefinement = Data()
        var encodedRefinement = Data()
        
        // encode presetType
        if let convertedType = convertAndEncodePresetType(version: version) {
            encodedName = convertedType
        }
        
        // encode presetRefinement
        if let convertedPresetRefinement = convertAndEncodePresetRefinement(version: version) {
            encodedPresetRefinement = convertedPresetRefinement
        }
        
        // encode freeform refinement/description
        if let convertedRefinement = encodeRefinementString(version: version) {
            encodedRefinement = convertedRefinement
        }
        return encodedName + encodedPresetRefinement + encodedRefinement
    }
    
    // encode presetType
    private func convertAndEncodePresetType(version: Version) -> Data? {
        switch version {
            case .v2_2, .v2_3 :
                if let presetCode = self.presetType?.code {
                    return (presetCode).encoded(withNullTermination: false)
            }
            case .v2_4 :
                if let presetCode = self.presetType?.code {
                    return (presetCode).encoded(withNullTermination: true)
            }
        }; return nil
    }
    
    // encode presetRefinement
    private func convertAndEncodePresetRefinement(version: Version) -> Data? {
        switch version {
            case .v2_2, .v2_3 :
                if let refinement = self.presetRefinement?.rawValue {
                    let refinementCode = MediaTypeRefinements(rawValue: refinement)?.code ?? ""
                    return refinementCode.encoded(withNullTermination: false)
            }
            case .v2_4 :
                if let refinement = self.presetRefinement?.rawValue {
                    let refinementCode = MediaTypeRefinements(rawValue: refinement)?.code ?? ""
                    return refinementCode.encoded(withNullTermination: true)
            }
        }; return nil
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
    internal init(decodingContents contents: Data.SubSequence,
                  version: Version,
                  layout: FrameLayoutIdentifier,
                  flags: Data) throws {
        self.flags = flags // this is just here for protocol comformance
        self.layout = layout
        var parsing = contents
        
        let encoding = PresetOptionsFrame.extractEncoding(data: &parsing, version: version)
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
                if layout == .known(KnownFrameLayoutIdentifier.genre) {
                    var genreType: GenreType = .none
                    
                    // check to see if the component is one of the genre "special cases"
                    if parsedComponent == "CR" {
                        genreType = .Cover
                    } else if parsedComponent == "RX" {
                        genreType = .Remix
                        
                        // if not, check to make sure it's a valid genre "code"
                    } else if let genreInt = Int(parsedComponent) {
                        let genreName = (GenreType.codeToRawValueMapping[genreInt]) ?? "None"
                        let validGenre = GenreType(rawValue: genreName)
                        genreType = validGenre ?? .none
                        
                        // if it's not a special case or valid genre code, handle it as a freeform string
                    } else {
                        self.refinementDescription = parsedComponent
                    }
                    self.presetType = PresetOption(presetName: genreType.rawValue)
                    
                } else if layout == .known(KnownFrameLayoutIdentifier.mediaType) {
                    var mediaType: MediaType = .none
                    
                    // check to see if it's a preset refinement string
                    // only preset refinement strings should start with "/"
                    if parsedComponent.first == "/" {
                        self.presetRefinement = MediaTypeRefinements(rawValue: parsedComponent)
                        
                        // if it's not a preset refinement string
                        // check to see if it's a known media type code
                    } else if let parsedName = MediaType.codeToNameMapping[parsedComponent] {
                        mediaType = MediaType(rawValue: parsedName) ?? .none
                        self.presetType = PresetOption(presetName: mediaType.rawValue)
                        
                        // if neither of those is true, treat it as a freeform string
                    } else {
                        self.refinementDescription = parsedComponent
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

