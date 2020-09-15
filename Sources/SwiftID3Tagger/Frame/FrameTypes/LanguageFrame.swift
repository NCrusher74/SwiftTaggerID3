/*

 LanguageFrame.swift
 SwiftTaggerID3

 Copyright ©2020 Nolaine Crusher. All rights reserved.

 */

import Foundation
import SwiftLanguageAndLocaleCodes
/**
 A type representing an ID3 frame that holds a single string field, `Language`, which contains the 3-charcter string for the ISO-639-2 language code. There may be multiple language frames in a tag, but only one per language. Therefore, the `languageString` will serve as the `FrameKey`
 
 Though this frame is stored in the tag as an `ISO-639-2` code, parsing will return the isoName of the language in full, for user-friendliness. It will also take an `isoName` or `nativeName` as the `languageString` and convert it to the appropriate 3-letter code.
 */
struct LanguageFrame: FrameProtocol, CustomStringConvertible {
    public var description: String {
        return """
        \(self.frameKey): \(self.languages)
        """
    }

    // MARK: - Properties
    var flags: Data
    var layout: FrameLayoutIdentifier
    var frameKey: FrameKey
    
    /// ISO-639-2 languge code
    var languages: [String]
    
    
    // MARK: - Frame parsing
    init(decodingContents contents: Data.SubSequence,
         version: Version,
         layout: FrameLayoutIdentifier,
         flags: Data
    ) throws {
        self.flags = flags
        self.layout = layout
        
        var parsing = contents
        // extract and interpret the encoding byte
        let encoding = try LanguageFrame.extractEncoding(data: &parsing, version: version)
        
        // extract each language code as a string
        var languagesArray: [String] = []
        while !parsing.isEmpty {
            let languageCodes = [parsing.extractPrefixAsStringUntilNullTermination(encoding)]
            for code in languageCodes {
                if ISO6392Code.allCases.contains(where:
                    { $0.rawValue == code }) {
                    languagesArray.append(code ?? "und")
                }
                else {
                    languagesArray = ["und"]
                }
            }
        }
        self.languages = languagesArray
        self.frameKey = .languages
    }
    
    // MARK: - Frame building
    /// Initialize a frame-building instance
    /// - Parameters:
    ///   - layout: the frame layout
    ///   - languages: the ISO-639-2 language codes as a string array
    init(_ layout: FrameLayoutIdentifier,
         languages: [String]) {
        self.languages = languages
        self.flags = LanguageFrame.defaultFlags
        self.layout = layout
        self.frameKey = .languages
    }
    
    func encodeContents(version: Version) throws -> Data {
        var frameData = Data()
        // append encoding byte
        frameData.append(StringEncoding.preferred.rawValue)
        // append languages in language array
        for language in self.languages {
            frameData.append(language.encoded(withNullTermination: true))
        }
        return frameData
    }
    
}

extension Tag {
    /// - Language frame getter-setter. ID3 Identifier: `TLA`/`TLAN`
    public var languages: [ISO6392Code]? {
        get {
            if let frame = self.frames[.languages],
                case .languageFrame(let languageFrame) = frame {
                var languageArray: [ISO6392Code] = []
                for language in languageFrame.languages {
                    let languageCode = ISO6392Code(rawValue: language) ?? .und
                    languageArray.append(languageCode)
                }
                return languageArray
            }; return nil
        }
        set {
            var languageStrings: [String] = []
            for code in newValue ?? [.und] {
                languageStrings.append(code.rawValue)
            }
            let frame = LanguageFrame(
                .known(.languages),
                languages: languageStrings)
            self.frames[.languages] = .languageFrame(frame)
        }
    }
}
