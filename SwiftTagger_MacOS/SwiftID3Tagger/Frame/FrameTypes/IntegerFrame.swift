////
////  IntegerFrame.swift
////  SwiftTagger_MacOS
////
////  Created by Nolaine Crusher on 4/12/20.
////  Copyright © 2020 Nolaine Crusher. All rights reserved.
////
//
//import Foundation
//
///**
// A type representing an ID3 frame that holds a single integer value
// */
//internal struct IntegerFrame: FrameProtocol {
//    
//    let value: Int
//    
//    /**
//     A frame with only an integer string as content, presented as an integer
//     - parameter value: the content of the frame.
//     */
//    init(value: Int) {
//        self.value = value
//    }
//    
//    init(decodingContents contents: Data.SubSequence, version: Version, frameIdentifier: FrameLayoutIdentifier, flags: Data) throws {
//        <#code#>
//    }
//    
//    var flags: Data
//    var size: Int
//    var identifier: FrameLayoutIdentifier
//    
//
//}
