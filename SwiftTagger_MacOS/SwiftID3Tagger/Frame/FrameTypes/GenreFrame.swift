//
//  GenreFrame.swift
//  SwiftTagger_MacOS
//
//  Some of this code is adapted from ID3TagEditor
//  Created by Fabrizio Duroni on 27/02/2018.
//  2018 Fabrizio Duroni. https://github.com/chicio/ID3TagEditor
//
//  Created by Nolaine Crusher on 4/11/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

/**
 A type used to represent an ID3 genre frame
 */
struct GenreFrame: FrameProtocol {
    /// Commonly recognized genres
    public var genreType: GenreType?
    /// A customizable genre description
    public var descriptionString: String?
    
    /**
     Init a ID3 genre frame.
     
     - parameter genre: a numerical value from the list of commonly recognized genres.
     - parameter description: a freeform string for customized genre descriptions.
     */
    public init(genreType: GenreType?, descriptionString: String?) {
        self.genreType = genreType
        self.descriptionString = descriptionString
    }
    
    //    func encodeContents(version: Version) throws -> Data {
    //        
    //    }
    
    var flags: Data
    var layout: KnownFrameLayoutIdentifier
    
    init(decodingContents contents: Data.SubSequence,
         version: Version,
         layout: KnownFrameLayoutIdentifier,
         flags: Data) throws {
        var parsing = contents
        let encoding = GenreFrame.extractEncoding(data: &parsing, version: version)
    }
    
    
}
