//
//  TagData.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/8/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation
import AVFoundation

struct TagData {
    
    var mp3File: Mp3File
    
    init(from mp3File: Mp3File) {
        self.mp3File = mp3File
    }
 
    
    
}
