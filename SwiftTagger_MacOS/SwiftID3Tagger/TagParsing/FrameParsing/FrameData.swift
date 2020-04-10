//
//  FrameData.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/10/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

struct FrameData {
    
    var mp3File: Mp3File
    
    init(fromFile mp3File: Mp3File) {
        self.mp3File = mp3File
    }
    
}
