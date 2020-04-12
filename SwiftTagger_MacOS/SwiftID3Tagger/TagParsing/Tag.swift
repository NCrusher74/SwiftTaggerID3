//
//  Tag.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/10/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

struct Tag {
    
    var frames: [FrameKey : Frame]
    
    init(frames: [FrameKey: Frame]) {
        self.frames = frames
    }
    
    
}
