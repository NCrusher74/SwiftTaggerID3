/*

 PartOfTotalFrame.swift
 SwiftTaggerID3

 Copyright ©2020 Nolaine Crusher. All rights reserved.

 */

import Foundation

/**
 A type representing the track/disc index of the total tracks or discs.
 */
struct PartOfTotalFrame: FrameProtocol, CustomStringConvertible {
    public var description: String {
        if let part = self.part {
            if let total = self.total {
                return """
                \(self.frameKey): \(part) of \(total)
                """
            } else {
                return """
                \(self.frameKey): \(part)
                """
            }
        } else {
            return ""
        }
    }
    
    // MARK: - Properties
    var flags: Data
    var layout: FrameLayoutIdentifier
    var frameKey: FrameKey

    // the frame's unique properties
    /// The index of the track/disc.
    var part: Int?
    /// The total number of tracks/discs.
    var total: Int?
    
    // MARK: - Frame parsing initializer
    init(decodingContents contents: Data.SubSequence,
         version: Version,
         layout: FrameLayoutIdentifier,
         flags: Data
    ) throws {
        self.flags = flags
        self.layout = layout
        self.frameKey = layout.frameKey(additionalIdentifier: nil) 

        var parsing = contents
        // extract and interpret encoding byte
        let encoding = try PartOfTotalFrame.extractEncoding(data: &parsing, version: version)
        // extract and decode content as a string
        let contentString = parsing.extractPrefixAsStringUntilNullTermination(encoding) ?? ""
        // parse the string into an array
        let contentComponents = contentString.components(separatedBy: "/")

        // parse the integer values out of the array
        self.part = Int(contentComponents[0]) ?? 0
        if contentComponents.count > 1 {
            self.total = Int(contentComponents[1])
        }
    }


    // MARK: - Frame building
    /**
     Initialize a frame building instance
     - parameter part: the index of the track/disc.
     - parameter total: the total tracks/discs of the recordings.
     */
    init(_ layout: FrameLayoutIdentifier,
         part: Int?,
         total: Int?) {
        self.part = part
        self.total = total
        self.flags = PartOfTotalFrame.defaultFlags
        self.layout = layout
        self.frameKey = layout.frameKey(additionalIdentifier: nil)
    }
    
    // encode the contents of the frame to add to an ID3 tag
    func encodeContents(version: Version) throws -> Data {
        var frameData = Data()
        // append the encoding byte
        frameData.append(StringEncoding.preferred.rawValue)
        if self.total == nil { // string will contain only the "part" value
            let partOfTotalString = String(self.part ?? 0)
            frameData.append(
                partOfTotalString.encoded(withNullTermination: false))
        } else { // string will contain both values, separated by a forward slash
            let partOfTotalString = "\(self.part ?? 0)/\(self.total ?? 0)"
            frameData.append(
                partOfTotalString.encoded(withNullTermination: false))
        }
        return frameData
    }
}

// MARK: - Internal Tag extension
/* get and set functions for `PartOfTotalFrame` frame types. Each individual frame of this type will have its own get-set property that will call these fucntions */
extension Tag {
    /// add the frame contents to an ID3 `Tag`
    /// - Parameters:
    ///   - layout: the frame's layout identifer
    ///   - frameKey: the frame's unique identifier, used to ensure frame uniqueness
    ///   - part: the position of a track or disc within a set
    ///   - total: the total number of tracks or discs in the set
    internal mutating func set(_ layout: FrameLayoutIdentifier,
                      _ frameKey: FrameKey,
                      to part: Int?,
                      and total: Int?) {
        // call the frame building initializer
        let frame = PartOfTotalFrame(
            layout,
            part: part,
            total: total)
        self.frames[frameKey] = .partOfTotalFrame(frame)
    }
    
    
    /// DiscNumber(/TotalDiscs) getter-setter. ID3 Identifier: `TPA`/`TPOS`
    public var discNumber: (disc: Int?, totalDiscs: Int?) {
        get {
            var tuple: (disc: Int?, totalDiscs: Int?) = (nil, nil)
            if let frame = self.frames[.discNumber],
                case .partOfTotalFrame(let partOfTotalFrame) = frame {
                tuple.disc = partOfTotalFrame.part
                tuple.totalDiscs = partOfTotalFrame.total
            }
            return tuple
        }
        set {
            if newValue != (nil, nil) {
                set(.known(.discNumber), .discNumber,
                    to: newValue.disc, and: newValue.totalDiscs)
            } else {
                self.frames[.discNumber] = nil
            }
        }
    }
        
    /// TrackNumber(/TotalTracks) getter-setter. ID3 Identifier: `TRK`/`TRCK`
    public var trackNumber: (track: Int?, totalTracks: Int?) {
        get {
            var tuple: (track: Int?, totalTracks: Int?) = (nil, nil)
            if let frame = self.frames[.trackNumber],
                case .partOfTotalFrame(let partOfTotalFrame) = frame {
                tuple.track = partOfTotalFrame.part
                tuple.totalTracks = partOfTotalFrame.total
            }
            return tuple
        }
        set {
            if newValue != (nil, nil) {
                set(.known(.trackNumber), .trackNumber,
                    to: newValue.track, and: newValue.totalTracks)
            } else {
                self.frames[.trackNumber] = nil
            }
        }
    }
}
