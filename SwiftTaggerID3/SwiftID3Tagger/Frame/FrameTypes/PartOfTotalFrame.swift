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

    // the frame's unique properties
    /// The index of the track/disc.
    var part: Int
    /// The total number of tracks/discs.
    var total: Int?
    
    // MARK: Frame parsing initializer
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
            default: self.frameKey = .userDefinedText(description: "(\(layout.id3Identifier(version: version) ?? "TXXX"))")
        }
        
        var parsing = contents
        // extract and interpret encoding byte
        let encoding = try PartOfTotalFrame.extractEncoding(data: &parsing, version: version)
        // extract and decode content as a string
        let contentString = parsing.extractPrefixAsStringUntilNullTermination(encoding) ?? ""
        // parse the string into an array
        let contentComponents = contentString.components(separatedBy: "/")
        // parse the integer values out of the array
        self.part = Int(contentComponents[0]) ?? 0
        self.total = Int(contentComponents[1])
    }


    // MARK: Frame building
    /**
     Initialize a frame building instance
     - parameter part: the index of the track/disc.
     - parameter total: the total tracks/discs of the recordings.
     */
    init(_ layout: FrameLayoutIdentifier,
         part: Int,
         total: Int?) {
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
        // append the encoding byte
        frameData.append(StringEncoding.preferred.rawValue.encoding(endianness: .bigEndian))
        if self.total == nil { // string will contain only the "part" value
            let partOfTotalString = String(self.part)
            frameData.append(
                partOfTotalString.encoded(withNullTermination: false))
        } else { // string will contain both values, separated by a forward slash
            let partOfTotalString = "\(self.part)/\(self.total ?? 0)"
            frameData.append(
                partOfTotalString.encoded(withNullTermination: false))
        }
        return frameData
    }
}

// MARK: Internal Tag extension
/* get and set functions for `PartOfTotalFrame` frame types. Each individual frame of this type will have its own get-set property that will call these fucntions */
extension Tag {
    
    /// Retrieve an integer tuple from the frame data
    /// - Parameter frameKey: the unique identifier of the frame
    /// - Returns: the frame's contents as an integer tuple
    internal func intTuple(for frameKey: FrameKey)
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
    
    /// add the frame contents to an ID3 `Tag`
    /// - Parameters:
    ///   - layout: the frame's layout identifer
    ///   - frameKey: the frame's unique identifier, used to ensure frame uniqueness
    ///   - part: the position of a track or disc within a set
    ///   - total: the total number of tracks or discs in the set
    internal mutating func set(_ layout: FrameLayoutIdentifier,
                      _ frameKey: FrameKey,
                      to part: Int,
                      and total: Int?) {
        // call the frame building initializer
        let frame = PartOfTotalFrame(
            layout,
            part: part,
            total: total)
        self.frames[frameKey] = .partOfTotalFrame(frame)
    }

    /// DiscNumber(/TotalDiscs) getter-setter. ID3 Identifier: `TPA`/`TPOS`
    public var discNumber: (disc: Int, totalDiscs: Int?)? {
        get {
            let tuple = intTuple(for: .discNumber)
            return (disc: tuple?.part ?? 0, totalDiscs: tuple?.total)
        }
        set {
            set(.known(.discNumber), .discNumber,
                to: newValue?.disc ?? 0, and: newValue?.totalDiscs)
        }
    }
    
    /// TrackNumber(/TotalTracks) getter-setter. ID3 Identifier: `TRK`/`TRCK`
    public var trackNumber: (track: Int, totalTracks: Int?)? {
        get {
            let tuple = intTuple(for: .trackNumber)
            return (track: tuple?.part ?? 0, totalTracks: tuple?.total)
        }
        set {
            set(.known(.trackNumber), .trackNumber,
                to: newValue?.track ?? 0, and: newValue?.totalTracks)
        }
    }
}
