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
public struct PartOfTotalFrame: FrameProtocol {
    
    public init(disc: Int, totalDiscs: Int?) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.discNumber), part: disc, total: totalDiscs)
    }
    
    public init(track: Int, totalTracks: Int?) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.trackNumber), part: track, total: totalTracks)
    }

    /// The index of the track/disc.
    var part: Int
    /// The total number of tracks/discs.
    var total: Int?
    
    /**
     - parameter part: the index of the track/disc.
     - parameter total: the total tracks/discs of the recordings.
     */
    private init(layout: FrameLayoutIdentifier, part: Int, total: Int?) {
        self.part = part
        self.total = total
        self.flags = PartOfTotalFrame.defaultFlags
        self.layout = layout
        switch layout {
            case .known(.discNumber) : self.frameKey = .discNumber
            case .known(.trackNumber): self.frameKey = .trackNumber
            default: self.frameKey = .userDefinedText(description: "")
        }
    }
    
    func encodeContents(version: Version) throws -> Data {
        if self.total == nil {
            let partOfTotalString = String(self.part)
            return partOfTotalString.encoded(withNullTermination: false)
        } else {
            let partOfTotalString = "\(self.part)/\(self.total ?? 0)"
            return partOfTotalString.encoded(withNullTermination: false)
        }
    }
    
    var flags: Data
    var layout: FrameLayoutIdentifier
    var frameKey: FrameKey
//    var identifier: String
    
    init(decodingContents contents: Data.SubSequence,
                  version: Version,
                  layout: FrameLayoutIdentifier,
                  flags: Data
    ) throws {
        self.flags = flags
        self.layout = layout
        switch layout {
            case .known(.discNumber) : self.frameKey = .discNumber
            case .known(.trackNumber): self.frameKey = .trackNumber
            default: self.frameKey = .userDefinedText(description: "")
        }

        var parsing = contents
        let encoding = PartOfTotalFrame.extractEncoding(data: &parsing, version: version)
        let contentString = parsing.extractPrefixAsStringUntilNullTermination(encoding) ?? ""
        let contentComponents = contentString.components(separatedBy: "/")
        self.part = Int(contentComponents[0]) ?? 0
        self.total = Int(contentComponents[1])
    }
}
