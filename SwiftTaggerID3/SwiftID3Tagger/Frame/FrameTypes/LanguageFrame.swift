//
//  LanguageFrame.swift
//  SwiftTaggerID3
//
//  Created by Nolaine Crusher on 4/11/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

/**
 A type representing an ID3 frame that holds a single string field, `Language`, which contains the 3-charcter string for the ISO-639-2 language code. There may be multiple language frames in a tag, but only one per language. Therefore, the `languageString` will serve as the `FrameKey`
 
 Though this frame is stored in the tag as an `ISO-639-2` code, parsing will return the isoName of the language in full, for user-friendliness. It will also take an `isoName` or `nativeName` as the `languageString` and convert it to the appropriate 3-letter code.
 */
struct LanguageFrame: FrameProtocol {
    
    init(languages: [ISO6392Codes]) {
        var languageCodes: [String] = []
        for language in languages {
            languageCodes.append(language.rawValue)
        }
        self.init(layout: .known(.languages), languages: languageCodes)
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
        var frameData = Data()
        // append encoding byte
        frameData.append(StringEncoding.preferred.rawValue.encoding(endianness: .bigEndian))
        // append language array
        for language in self.languages {
            switch version {
                case .v2_2, .v2_3:
                    frameData.append(language.encoded(withNullTermination: false))
                case .v2_4:
                    frameData.append(language.encoded(withNullTermination: true))
            }
        }
        return frameData
    }
    
    // MARK: Properties
    var flags: Data
    var layout: FrameLayoutIdentifier
    var frameKey: FrameKey
    var allowMultipleFrames: Bool = false

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
                { $0.rawValue == code }) {
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

public extension Tag {
    /// - Language frame getter-setter. ID3 Identifier: `TLA`/`TLAN`
    var languages: [String]? {
        get {
            if let frame = self.frames[.languages],
                case .languageFrame(let languageFrame) = frame {
                return languageFrame.languages
            } else {
                return nil
            }
        }
    }
    
    mutating func setLanguages(languages: [ISO6392Codes]) throws {
        let key = FrameKey.languages
        self.frames[key] = Frame.languageFrame(.init(languages: languages))
    }
}
