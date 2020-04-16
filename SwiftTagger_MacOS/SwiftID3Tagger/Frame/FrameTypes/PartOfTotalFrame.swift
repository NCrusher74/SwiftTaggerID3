//
//  PartOfTotalFrame.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/11/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

/**
 A type representing the track/disc index of the total tracks or discs.
 */
struct PartOfTotalFrame: FrameProtocol {
    /// The position of the track/disc.
    public var part: Int
    /// The total number of tracks/discs in recordings.
    public var total: Int?
    
    /**
     - parameter part: the index of the track/disc.
     - parameter total: the total tracks/discs of the recordings.
     */
    public init(part: Int, total: Int?) {
        self.part = part
        self.total = total
    }
    
    //    func encodeContents(version: Version) throws -> Data {
    //
    //    }
        
    var flags: Data
    var layout: FrameLayoutIdentifier
    
    init(decodingContents contents: Data.SubSequence,
         version: Version,
         layout: FrameLayoutIdentifier,
         flags: Data) throws {
        self.flags = PartOfTotalFrame.defaultFlags(version: version)
        self.layout = layout
        var parsing = contents
        let encoding = PartOfTotalFrame.extractEncoding(data: &parsing, version: version)
        let contentString = Self.extractTerminatedString(
            data: &parsing, encoding: encoding)
        let contentComponents = contentString.components(separatedBy: "/")
        self.part = Int(contentComponents[0]) ?? 0
        self.total = Int(contentComponents[1])
    }
    

}
