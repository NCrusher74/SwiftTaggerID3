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
    case bool
    case chapter
    case date
    case genre
    case image
    case integer
    case integerArray
    case string
    case stringArray
    case toc
    case tupleArray
    case url
    
}
