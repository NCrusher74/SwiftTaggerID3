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
struct GenreFrame: FrameProtocol {
    /// Commonly recognized genres
    public var genreType: GenreType?
    /// A customizable genre description
    public var descriptionString: String?
    
    /**
     Init a ID3 genre frame.
     
     - parameter genre: a numerical value from the list of commonly recognized genres.
     - parameter description: a freeform string for customized genre descriptions.
     */
    public init(genreType: GenreType?, descriptionString: String?) {
        self.genreType = genreType
        self.descriptionString = descriptionString
    }
    
    //    func encodeContents(version: Version) throws -> Data {
    //        
    //    }
    
    var flags: Data
    var layout: KnownFrameLayoutIdentifier
    
    init(decodingContents contents: Data.SubSequence,
         version: Version,
         layout: KnownFrameLayoutIdentifier,
         flags: Data) throws {
        self.flags = GenreFrame.defaultFlags(version: version)
        self.layout = layout
        var parsing = contents
        let encoding = GenreFrame.extractEncoding(data: &parsing, version: version)
        var parsedArray: [String] = []
        if version == .v2_2 || version == .v2_3 {
            let unparsedString = GenreFrame.extractTerminatedString(data: &parsing, encoding: encoding)
            parsedArray = parseParentheticalString(unparsedString: unparsedString)
        } else {
            while !parsing.isEmpty,
                let next = parsing.extractPrefixAsStringUntilNullTermination(encoding) {
                    parsedArray.append(next)
            }
            for component in parsedArray {
                var genre: GenreType = .None
                if component == "CR" {
                    genre = .Cover
                } else if component == "RX" {
                    genre = .Remix
                } else if let genreInt = Int(component),
                    let validGenre = GenreType(rawValue: genreInt) {
                    genre = validGenre
                } else {
                    self.descriptionString = component
                }
                self.genreType = genre
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
