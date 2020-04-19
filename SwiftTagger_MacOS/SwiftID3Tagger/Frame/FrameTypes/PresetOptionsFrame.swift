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
    private var presetType: PresetOptions?
    private var presetRefinement: PresetOptions?
    private var refinementDescription: String?

    /**
     Init a ID3 genre frame.
     
     - parameter presetType: the list of names of the genres or media types.
     - parameter presetRefinement: a list of preset refinements for media types.
     - parameter refinementDescription: a freeform string for customized descriptions.
     */
    private init(layout: FrameLayoutIdentifier,
                 presetType: PresetOptions?,
                 presetRefinement: PresetOptions?,
                 refinementDescription: String?) {
        self.presetType = presetType
        self.presetRefinement = presetRefinement
        self.refinementDescription = refinementDescription
        self.flags = PresetOptionsFrame.defaultFlags()
        self.layout = layout
    }
    
    func encodeContents(version: Version) throws -> Data {
        var typeContentAsData = Data()
        var presetRefinementAsData = Data()
        var refinementStringAsData = Data()
        switch version {
            case .v2_2, .v2_3:
                if layout == .known(KnownFrameLayoutIdentifier.genre) {
                    if let typeContent = self.presetType?.genreCode.data {
                        typeContentAsData = typeContent
                    }
                    if let refinement = self.refinementDescription?.encoded(
                        withNullTermination: false) {
                        refinementStringAsData = refinement
                    }
                    return typeContentAsData + refinementStringAsData
                } else if layout == .known(KnownFrameLayoutIdentifier.mediaType) {
                    if let typeContent = self.presetType?.mediaTypeCode.encoded(
                        withNullTermination: false) {
                        typeContentAsData = typeContent
                    }
                    if let presetRefinement = self.presetType?.mediaRefinementCode.encoded(
                        withNullTermination: false) {
                        presetRefinementAsData = presetRefinement
                    }
                    if let refinement = self.refinementDescription?.encoded(
                        withNullTermination: false) {
                        refinementStringAsData = refinement
                    }
                    return typeContentAsData + presetRefinementAsData + refinementStringAsData
            }
            case .v2_4:
                if layout == .known(KnownFrameLayoutIdentifier.genre) {
                    if let typeContent = self.presetType?.genreCode.data {
                        typeContentAsData = typeContent
                    }
                    if let refinement = self.refinementDescription?.encoded(
                        withNullTermination: true) {
                        refinementStringAsData = refinement
                    }
                    return typeContentAsData + refinementStringAsData
                } else if layout == .known(KnownFrameLayoutIdentifier.mediaType) {
                    if let typeContent = self.presetType?.mediaTypeCode.encoded(
                        withNullTermination: true) {
                        typeContentAsData = typeContent
                    }
                    if let presetRefinement = self.presetType?.mediaRefinementCode.encoded(
                        withNullTermination: true) {
                        presetRefinementAsData = presetRefinement
                    }
                    if let refinement = self.refinementDescription?.encoded(
                        withNullTermination: true) {
                        refinementStringAsData = refinement
                    }
                    return typeContentAsData + presetRefinementAsData + refinementStringAsData
            }
        }; return "".encoded(withNullTermination: false)
    }

    internal var flags: Data
    internal var layout: FrameLayoutIdentifier
    
    
    internal init(decodingContents contents: Data.SubSequence,
                  version: Version,
                  layout: FrameLayoutIdentifier,
                  flags: Data) throws {
        self.flags = flags
        self.layout = layout
        var parsing = contents
        let encoding = PresetOptionsFrame.extractEncoding(data: &parsing, version: version)
        var parsedArray: [String] = []
        if version == .v2_2 || version == .v2_3 {
            let unparsedString = parsing.extractPrefixAsStringUntilNullTermination(encoding) ?? ""
            parsedArray = parseParentheticalString(unparsedString: unparsedString)
        } else {
            while !parsing.isEmpty,
                let next = parsing.extractPrefixAsStringUntilNullTermination(encoding) {
                    parsedArray.append(next)
            }
            for component in parsedArray {
                if layout == .known(KnownFrameLayoutIdentifier.genre) {
                    var genreCodes: [Int] = []
                    for genre in GenreType.allCases {
                        genreCodes.append(genre.code)
                    }
                } else if layout == .known(KnownFrameLayoutIdentifier.mediaType) {
                    
                }
            }
        }
    }
    
    func parseParentheticalString(unparsedString: String) -> [String] {
        var stringComponents = unparsedString.components(separatedBy: "(")
        for (index, value) in stringComponents.enumerated() {
            if index != 0 && value == "" {
                let rangeToReplace = (index - 1)...(index + 1)
                stringComponents[index + 1].insert("(", at: stringComponents[index + 1].startIndex)
                let componentsToJoin = [stringComponents[index - 1], stringComponents[index + 1]]
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
