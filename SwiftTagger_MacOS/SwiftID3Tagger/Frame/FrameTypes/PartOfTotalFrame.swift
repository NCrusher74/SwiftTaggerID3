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
    
    init(disc: Int, totalDiscs: Int?) {
        self.init(layout: .known(.discNumber), part: disc, total: totalDiscs)
    }
    
    init(track: Int, totalTracks: Int?) {
        self.init(layout: .known(.trackNumber), part: track, total: totalTracks)
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
    
    var flags: Data
    var layout: FrameLayoutIdentifier
    var frameKey: FrameKey
    var allowMultipleFrames: Bool = false
    
    // decode the contents of a frame from an ID3 tag
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
}

// MARK: Tag Extension
public extension Tag {
    /// - DiscNumber(/TotalDiscs) getter-setter. ID3 Identifier: `TPA`/`TPOS`
    var discNumber: (disc: Int, totalDiscs: Int?) {
        get {
            if let frame = self.frames[.discNumber],
                case .partOfTotalFrame(let partOfTotalFrame) = frame {
                return (partOfTotalFrame.part, partOfTotalFrame.total)
            } else {
                return (0,0)
            }
        }
        set {
            let frame = PartOfTotalFrame(disc: newValue.0, totalDiscs: newValue.1)
            frames[.discNumber] = .partOfTotalFrame(frame)
        }
    }
    
    /// - TrackNumber(/TotalTracks) getter-setter. ID3 Identifier: `TRK`/`TRCK`
    var trackNumber: (track: Int, totalTracks: Int?) {
        get {
            if let frame = self.frames[.trackNumber],
                case .partOfTotalFrame(let partOfTotalFrame) = frame {
                return (partOfTotalFrame.part, partOfTotalFrame.total)
            } else {
                return (0,0)
            }
        }
        set {
            let frame = PartOfTotalFrame(track: newValue.0, totalTracks: newValue.1)
            frames[.trackNumber] = .partOfTotalFrame(frame)
        }
    }
}
