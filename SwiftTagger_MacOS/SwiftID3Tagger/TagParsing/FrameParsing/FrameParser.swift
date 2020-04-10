//
//  TagParser.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/9/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

struct FrameParser {
    
    var validatedTag: TagValidator
    var properties: TagProperties
    
    init(for validatedTag: TagValidator, with properties: TagProperties) {
        self.validatedTag = validatedTag
        self.properties = properties
    }
    
    
    
    
    
}
