//
//  TagParser.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/9/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

struct FrameParser {
    
    var mp3File: Mp3File
    
    init(forFile mp3File: Mp3File) {
        self.mp3File = mp3File
    }
    
    
    internal func parseFrames() throws -> FrameData {
        let tagProperties = TagProperties(for: self.mp3File)
        let framePosition = tagProperties.tagHeaderSize
        let tagSize = try tagProperties.size()
        while framePosition < tagSize {
            
        }
    }
    
//    func parse(mp3: NSData, id3Tag: ID3Tag) {
//        var currentFramePosition = id3TagConfiguration.headerSize();
//        while currentFramePosition < id3Tag.properties.size {
//            let frameSize = frameSizeParser.parse(
//                mp3: mp3,
//                framePosition: currentFramePosition,
//                version: id3Tag.properties.version)
//            let frame = mp3.subdata(with: NSMakeRange(currentFramePosition, min(frameSize, mp3.length - currentFramePosition)))
//            id3FrameParser.parse(frame: frame, frameSize: frameSize, id3Tag: id3Tag)
//            currentFramePosition += frame.count;
//        }
//    }

    
    
    
}
