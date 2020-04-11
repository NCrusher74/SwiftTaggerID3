//
//  FrameProperties.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/9/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

struct FrameProperties {
    
    var mp3File: Mp3File
    var version: Version
    
    init(mp3File: Mp3File, version: Version) {
        self.mp3File = mp3File
        self.version = version
    }
    
    internal let encodingByteSize: Int = 1

    

//    internal func frameSize() -> Int {
//    }

    /*
     func parse(mp3: NSData, framePosition: Int, version: Version) -> Int {
     return frameContentSizeParser.parse(mp3: mp3, framePosition: framePosition, version: version) +
     id3FrameConfiguration.headerSizeFor(version: version)
     }

     */
    
    
//    internal func frameContentSize() -> {
//        
//    }
        /*
         let lengthOfSizeDeclaration = 4 // ? Or whatever it actually is.
         let sizeDataRange = frameSizePosition ..< frameSizePosition+lengthOfSizeDeclaration
         guard sizeDataRange.upperBound <= mp3Data.endIndex else {
         // If the data is corrupt and doesn’t even have room for a size declaration,
         // describe the size of whatever is actually there instead.
         return mp3Data.distance(from: frameSizePosition, to: mp3Data.endIndex)
         }
         let frameSizeData = mp3Data[sizeDataRange]
         let frameSize = UInt32(parsing: frameSizeData)
         }
         */



/*
func parse(mp3: NSData, framePosition: Int, version: Version) -> Int {
    var frameSize: UInt32 = getFrameSizeFrom(mp3: mp3, framePosition: framePosition, version: version)
    frameSize = decodeIfIsASynchsafeInteger(frameSize: frameSize, for: version)
    return Int(frameSize)
}

private func getFrameSizeFrom(mp3: NSData, framePosition: Int, version: Version) -> UInt32 {
    //let frameSizePosition = framePosition + id3FrameConfiguration.sizeOffsetFor(version: version)
    var frameSize: UInt32 = 0
    mp3.getBytes(&frameSize, range: NSMakeRange(frameSizePosition, 4))
    frameSize = frameSize.bigEndian & id3FrameConfiguration.sizeMaskFor(version: version)
    return frameSize
}

private func decodeIfIsASynchsafeInteger(frameSize: UInt32, for version: Version) -> UInt32 {
    var newFrameSize = frameSize
    if version == .version4 {
        newFrameSize = synchsafeIntegerDecoder.decode(integer: frameSize)
    }
    return newFrameSize
}
}
*/


}
