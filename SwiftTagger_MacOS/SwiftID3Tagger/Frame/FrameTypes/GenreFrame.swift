////
////  GenreFrame.swift
////  SwiftTagger_MacOS
////
////  Some of this code is adapted from ID3TagEditor
////  Created by Fabrizio Duroni on 27/02/2018.
////  2018 Fabrizio Duroni. https://github.com/chicio/ID3TagEditor
////
////  Created by Nolaine Crusher on 4/11/20.
////  Copyright © 2020 Nolaine Crusher. All rights reserved.
////
//
//import Foundation
//
///**
// A type used to represent an ID3 genre frame
// */
//struct GenreFrame: FrameProtocol {
//    /// Commonly recognized genres
//    public var genreType: GenreType?
//    /// A customizable genre description
//    public var descriptionString: String?
//    
//    /**
//     Init a ID3 genre frame.
//     
//     - parameter genre: an ID3Genre to be setted in the ID3 tag.
//     - parameter description: a generic genre description. Useful to build your own genres.
//     */
//    public init(genreType: GenreType?, descriptionString: String?) {
//        self.genreType = genreType
//        self.descriptionString = descriptionString
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
