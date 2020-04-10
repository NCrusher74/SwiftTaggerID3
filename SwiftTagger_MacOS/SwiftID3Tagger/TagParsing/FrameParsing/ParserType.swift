//
//  ParserType.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/9/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

/** ParserType describes the method used in reading and parsing the data in the frame */

enum ParserType {
    
    case chapterParser
    case commentParser
    case creditsParser
    case dateParser
    case genreParser
    case imageParser
    case urlParser
    case stringParser
    case tocParser
    case userTextParser
    
}
