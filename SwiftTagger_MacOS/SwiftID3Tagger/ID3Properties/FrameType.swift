//
//  FrameType.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/8/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

/** Frame Type describes how the information in the frame will be returned from the API, not how it is read and stored */

enum FrameType {
    case boolFrame
    case chapterFrame
    case dateFrame
    case genreFrame
    case imageFrame
    case integerFrame
    case integerArrayFrame
    case stringFrame
    case stringArrayFrame
    case tocFrame
    case tupleArrayFrame
    case urlFrame
    
}
