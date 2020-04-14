////
////  UserTextFrame.swift
////  SwiftTagger_MacOS
////
////  Created by Nolaine Crusher on 4/12/20.
////  Copyright © 2020 Nolaine Crusher. All rights reserved.
////
//
//import Foundation
//
//struct UserTextFrame: FrameProtocol {
//    
//    /// A short description of the frame content.
//    public var descriptionString: String?
//    /// the content of the frame
//    public var contentString: String
//    
//    /**
//     - parameter contentDescription: a terminated text string describing the frame content
//     - parameter contentText: the full text of the comment or lyric frame.
//     */
//    public init(descriptionString: String?, contentString: String) {
//        self.descriptionString = descriptionString
//        self.contentString = contentString
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
//}
