//
//  PartOfTotalFrame.swift
//  SwiftTaggerID3
//
//  Created by Nolaine Crusher on 4/11/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

/**
 A type representing the track/disc index of the total tracks or discs.
 */
struct PartOfTotalFrame: FrameProtocol {
  
    // MARK: Properties
    var flags: Data
    var layout: FrameLayoutIdentifier
    var frameKey: FrameKey
    var allowMultipleFrames: Bool = false

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
        let encoding = try PartOfTotalFrame.extractEncoding(data: &parsing, version: version)
        let contentString = parsing.extractPrefixAsStringUntilNullTermination(encoding) ?? ""
        let contentComponents = contentString.components(separatedBy: "/")
        self.part = Int(contentComponents[0]) ?? 0
        self.total = Int(contentComponents[1])
    }


    // MARK: Frame encoding
    /// The index of the track/disc.
    var part: Int
    /// The total number of tracks/discs.
    var total: Int?
    
    /**
     - parameter part: the index of the track/disc.
     - parameter total: the total tracks/discs of the recordings.
     */
    init(layout: FrameLayoutIdentifier, part: Int, total: Int?) {
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
    
    // encode the contents of the frame to add to an ID3 tag
    func encodeContents(version: Version) throws -> Data {
        var frameData = Data()
        frameData.append(StringEncoding.preferred.rawValue.encoding(endianness: .bigEndian))
        if self.total == nil {
            let partOfTotalString = String(self.part)
            frameData.append(
                partOfTotalString.encoded(withNullTermination: false))
        } else {
            let partOfTotalString = "\(self.part)/\(self.total ?? 0)"
            frameData.append(
                partOfTotalString.encoded(withNullTermination: false))
        }
        return frameData
    }
    
}

// MARK: Internal Tag extension
/* get and set functions for `PartOfTotalFrame` frame types. Each individual frame of this type will have its own get-set property that will call these fucntions */

internal extension Tag {
    func intTuple(for frameKey: FrameKey)
        -> (part: Int, total: Int?)? {
            // check that the frame is a PartOfTotalFrame
            if let frame = self.frames[frameKey],
                case .partOfTotalFrame(let partOfTotalFrame) = frame {
                // return an integer tuple
                return (partOfTotalFrame.part, partOfTotalFrame.total)
            } else {
                return nil
            }
    }
    
    mutating func set(_ layout: FrameLayoutIdentifier,
                      _ frameKey: FrameKey,
                      to part: Int,
                      and total: Int?) {
        let frame = PartOfTotalFrame(
            layout: layout,
            part: part,
            total: total)
        self.frames[frameKey] = .partOfTotalFrame(frame)
    }
}

// MARK: Public Tag Extension
/* has public getter-setter properties for each PartOfTotal-related FrameKey */
public extension Tag {
    /// - DiscNumber(/TotalDiscs) getter-setter. ID3 Identifier: `TPA`/`TPOS`
    var discNumber: (disc: Int, totalDiscs: Int?) {
        get {
            let tuple = intTuple(for: .discNumber)
            return (disc: tuple?.part ?? 0, totalDiscs: tuple?.total)
        }
        set {
            set(.known(.discNumber), .discNumber,
                to: newValue.disc, and: newValue.totalDiscs)
        }
    }
    
    /// - TrackNumber(/TotalTracks) getter-setter. ID3 Identifier: `TRK`/`TRCK`
    var trackNumber: (track: Int, totalTracks: Int?) {
        get {
            let tuple = intTuple(for: .trackNumber)
            return (track: tuple?.part ?? 0, totalTracks: tuple?.total)
        }
        set {
            set(.known(.trackNumber), .trackNumber,
                to: newValue.track, and: newValue.totalTracks)
        }
    }
}
