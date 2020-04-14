////
////  CreditsListFrame.swift
////  SwiftTagger_MacOS
////
////  Created by Nolaine Crusher on 4/11/20.
////  Copyright © 2020 Nolaine Crusher. All rights reserved.
////
//
//import Foundation
//
///**
// A type used to represent an ID3 involved peeople list or musician credits frame.
// */
//struct CreditsListFrame: FrameProtocol {
//    
//    /// An array of the role:person tuples
//    public var entries: [(role: String, person: String)]
//    
//    /**
//     - parameter entries: the array of `role`:`person` tuples
//     - parameter role: the role of the involved person.
//     - parameter person: the name (or comma-delimited names) of the person fulfilling a given role.
//     */
//    public init(entries: [(role: String, person: String)]) {
//        self.entries = entries
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
//    
//}
