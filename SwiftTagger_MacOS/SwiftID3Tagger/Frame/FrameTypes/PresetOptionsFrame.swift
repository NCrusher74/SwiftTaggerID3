//
//  PresetOptionsFrame.swift
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
    /// Commonly recognized genres
    public var presetOption: PresetOption?
    /// further refinement options
    public var mediaTypeRefinement: MediaTypeRefinement
    /// A customizable genre description
    public var customizationString: String?
    
    /**
     Init a ID3 genre frame.
     
     - parameter genre: a numerical value from the list of commonly recognized genres.
     - parameter description: a freeform string for customized genre descriptions.
     */
    private init(layout: FrameLayoutIdentifier,
                 presetOption: PresetOption?,
                 mediaTypeRefinement: MediaTypeRefinement,
                 customizationString: String?) {
        self.presetOption = presetOption
        self.mediaTypeRefinement = mediaTypeRefinement
        self.customizationString = customizationString
        self.flags = PresetOptionsFrame.defaultFlags()
        self.layout = layout
    }
    
    func encodeContents(version: Version) throws -> Data {
        
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
                if layout == FrameLayoutIdentifier.known(
                    KnownFrameLayoutIdentifier.genre) {
                    var genre: GenreType = .None
                    if component == "CR" {
                        genre = .Cover
                    } else if component == "RX" {
                        genre = .Remix
                    } else if let genreInt = Int(component),
                        let validGenre = GenreType(rawValue: genreInt) {
                        genre = validGenre
                    } else {
                        self.customizationString = component
                    }
                    self.presetOption = .genreTypes(genre)
                } else if layout == FrameLayoutIdentifier.known(
                    KnownFrameLayoutIdentifier.mediaType) {
                    var mediaType: MediaType = .none
                    self.presetOption = .mediaTypes(mediaType)
                    self.mediaTypeRefinement = MediaType.refinement.self
                    self.customizationString = component
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
    
    
    init(genreID: GenreType?, description: String?) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.genre),
                  presetOption: .genreTypes(genreID ?? .None),
                  mediaTypeRefinement: .none,
                  customizationString: description)
    }
    
    init(mediaType: MediaType?, additionalInfo: MediaTypeRefinement, description: String?) {
        self.init(layout: .known(
            KnownFrameLayoutIdentifier.mediaType),
                  genreType: mediaType,
                  mediaTypeRefinements: additionalInfo,
                  customizationString: description)
    }
}

enum PresetOption {
    case genreTypes(GenreType)
    case mediaTypes(MediaType)
}
