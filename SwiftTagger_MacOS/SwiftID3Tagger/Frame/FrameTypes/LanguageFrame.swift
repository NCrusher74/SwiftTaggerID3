//
//  LanguageFrame.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/11/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

/**
 A type representing an ID3 frame that holds a single string field, `Language`, which contains the 3-charcter string for the ISO-639-2 language code. There may be multiple language frames in a tag, but only one per language. Therefore, the `languageString` will serve as the `FrameKey`
 
 Though this frame is stored in the tag as an `ISO-639-2` code, parsing will return the isoName of the language in full, for user-friendliness. It will also take an `isoName` or `nativeName` as the `languageString` and convert it to the appropriate 3-letter code.
 */
public struct LanguageFrame: FrameProtocol {
    
    public init(languages: [ISO6392Codes.RawValue]) {
        self.init(layout: .known(.languages), languages: languages)
    }
    
    /// ISO-639-2 languge code
    var languages: [String]
    
    /**
     - parameter language: the ISO-639-2 language code.
     */
    private init(layout: FrameLayoutIdentifier, languages: [String]) {
        self.languages = languages
        self.flags = LanguageFrame.defaultFlags
        self.layout = layout
        self.frameKey = .languages
    }
    
    // encode the contents of the frame to add to an ID3 tag
    func encodeContents(version: Version) throws -> Data {
        let encodingByte = StringEncoding.preferred.rawValue.encoding(endianness: .bigEndian)
        var languagesAsData = Data()
        for language in self.languages {
            switch version {
                case .v2_2, .v2_3:
                    languagesAsData.append(language.encoded(withNullTermination: false))
                case .v2_4:
                    languagesAsData.append(language.encoded(withNullTermination: true))
            }
        }
        return encodingByte + languagesAsData
    }
    
    // MARK: Decoding
    var flags: Data
    var layout: FrameLayoutIdentifier
    var frameKey: FrameKey
    
    /// if desired, return may be changed from "isoName" to "nativeName"
    init(decodingContents contents: Data.SubSequence,
         version: Version,
         layout: FrameLayoutIdentifier,
         flags: Data
    ) throws {
        self.flags = flags
        self.layout = layout
        
        var parsing = contents
        let encoding = try LanguageFrame.extractEncoding(data: &parsing, version: version)
        let languageCodes = [parsing.extractPrefixAsStringUntilNullTermination(encoding)]
        var languagesArray: [String] = []
        for code in languageCodes {
            if ISO6392Codes.allCases.contains(where:
                { $0.iso6392TCode == code }) {
                languagesArray.append(code ?? "und")
            }
            else {
                languagesArray = ["und"]
            }
        }
        self.languages = languagesArray
        self.frameKey = .languages
    }
        
}
