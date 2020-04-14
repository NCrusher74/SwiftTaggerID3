//
//  LanguageFrame.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/11/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation
import IsoCountryAndLanguageCodes

/**
 A type representing an ID3 frame that holds a single string field, `Language`, which contains the 3-charcter string for the ISO-639-2 language code. There may be multiple language frames in a tag, but only one per language. Therefore, the `languageString` will serve as the `FrameKey`
 */
struct LanguageFrame: FrameProtocol {
    
    /// ISO-639-2 languge code
    public var languageString: IsoLanguageInfo
    
    /**
     - parameter language: the ISO-639-2 language code.
     */
    public init(languageString: IsoLanguageInfo) {
        self.languageString = languageString
    }
    
    var flags: Data
    var identifier: FrameLayoutIdentifier
    
//    func encodeContents(version: Version) throws -> Data {
//        <#code#>
//    }

    init(decodingContents contents: Data.SubSequence, version: Version, frameIdentifier: FrameLayoutIdentifier, flags: Data) throws {
        <#code#>
    }
    

    
}
