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
    
    public init(language: ISO6392Codes.RawValue) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.languages), languageString: language)
    }

    /// ISO-639-2 languge code
    var languageString: String
    
    /**
     - parameter language: the ISO-639-2 language code.
     */
    private init(layout: FrameLayoutIdentifier, languageString: String) {
        self.languageString = languageString
        //        self.flags = LanguageFrame.defaultFlags()
        self.layout = layout
    }
    
    func encodeContents(version: Version) throws -> Data {
        return self.languageString.encoded(withNullTermination: false)
    }
    
    // MARK: Decoding
    //    var flags: Data
    var layout: FrameLayoutIdentifier
    
    /// if desired, return may be changed from "isoName" to "nativeName"
    init(decodingContents contents: Data.SubSequence,
         version: Version,
         layout: FrameLayoutIdentifier
        //                  flags: Data
    ) throws {
        //        self.flags = flags
        self.layout = layout
        var parsing = contents
        let languageCode = parsing.extractFirst(3).stringASCII ?? "und"
        if ISO6392Codes.allCases.contains(where: { $0.iso6392TCode == languageCode }) {
            self.languageString = languageCode
        } else {
            self.languageString = "und"
        }
    }
    
    func frameKey(version: Version) -> FrameKey? {
        if self.layout == .known(KnownFrameLayoutIdentifier.languages) {
            return .languages(language: self.languageString)
        } else {
            return nil
        }
    }

}
