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
    
    /// ISO-639-2 languge code
    public var languageString: String
    
    /**
     - parameter language: the ISO-639-2 language code.
     */
    public init(languageString: String) {
        self.languageString = languageString
    }
    
    //    func encodeContents(version: Version) throws -> Data {
    //
    //    }
    
    internal var flags: Data
    internal var identifier: KnownFrameLayoutIdentifier
    
    /// if desired, return may be changed from "isoName" to "nativeName"
    internal init(decodingContents contents: Data.SubSequence,
         version: Version,
         frameIdentifier: KnownFrameLayoutIdentifier,
         flags: Data) throws {
        let languageCode = contents.stringASCII ?? "und"
        let languages = IsoLanguages.allLanguages.filter({ $0.iso6392T == languageCode })
        self.languageString = String(languages.first?.isoName ?? "undefined")
    }
}
