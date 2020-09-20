//
//  File.swift
//  
//
//  Created by Nolaine Crusher on 9/18/20.
//

/*
 TRCK
 The 'Track number/Position in set' frame is a numeric string
 containing the order number of the audio-file on its original
 recording. This MAY be extended with a "/" character and a numeric
 string containing the total number of tracks/elements on the original
 recording. E.g. "4/9".
 
 TPOS
 The 'Part of a set' frame is a numeric string that describes which
 part of a set the audio came from. This frame is used if the source
 described in the "TALB" frame is divided into several mediums, e.g. a
 double CD. The value MAY be extended with a "/" character and a
 numeric string containing the total number of parts in the set. E.g.
 "1/2".
 */
import Foundation
class PartAndTotalFrame: Frame {
    /// The index of the track or disc in the set
    var part: Int
    /// The total number of tracks/discs in the set
    var total: Int?
    
    // MARK: - Frame Parsing
    init(identifier: FrameIdentifier,
         version: Version,
         size: Int,
         flags: Data,
         payload: Data) throws {
        var data = payload
        
        // extract and interpret encoding byte
        let encoding = try data.extractEncoding()        
        // extract and decode content as a string
        let string = data.extractNullTerminatedString(encoding) ?? ""
        // parse the string into an array
        let components = string.components(separatedBy: "/")
        
        // parse the integer values out of the array
        self.part = Int(components[0]) ?? 0
        if components.count > 1 {
            self.total = Int(components[1])
        }
        super.init(identifier: identifier,
                   version: version,
                   size: size,
                   flags: flags)
    }
    
    // MARK: - Frame building
    ///
    /// Initialize a frame building instance
    /// - parameter part: the index of the track/disc.
    /// - parameter total: the total tracks/discs of the recordings.
    init(_ identifier: FrameIdentifier,
         version: Version,
         part: Int,
         total: Int?) {
        self.part = part
        self.total = total
        
        var size = 1 // +1 for encoding byte
        if let total = total {
            size += "\(part)/\(total)".encodedISOLatin1.count
        } else {
            size += String(part).encodedISOLatin1.count
        }

        let flags = version.defaultFlags
        super.init(identifier: identifier,
                   version: version,
                   size: size,
                   flags: flags)
    }

    override var contentData: Data {
        var contentString = String()
        if let total = self.total {
            contentString = "\(self.part)/\(total)"
        } else {
            contentString = String(self.part)
        }
        let encoding = String.Encoding.isoLatin1
        
        var data = Data()
        data.append(encoding.encodingByte)
        data.append(contentString.encodedISOLatin1)
        return data
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
    internal mutating func set(partTotalFrame identifier: FrameIdentifier,
                               part: Int,
                               total: Int?) {
        let frameKey = identifier.frameKey(nil)
        // call the frame building initializer
        let frame = PartAndTotalFrame(identifier,
                                      version: self.version,
                                      part: part,
                                      total: total)
        self.frames[frameKey] = frame
    }
    
    
    /// DiscNumber(/TotalDiscs) getter-setter. ID3 Identifier: `TPA`/`TPOS`
    public var discNumber: (disc: Int, totalDiscs: Int?) {
        get {
            let identifier = FrameIdentifier.known(.discNumber)
            let frameKey = identifier.frameKey(nil)
            var tuple: (disc: Int, totalDiscs: Int?) = (0, nil)
            if let frame = self.frames[frameKey] as? PartAndTotalFrame {
                tuple.disc = frame.part
                tuple.totalDiscs = frame.total
            }
            return tuple
        }
        set {
            let identifier = FrameIdentifier.known(.discNumber)
            let frameKey = identifier.frameKey(nil)
            if newValue != (0, nil) {
                set(partTotalFrame: identifier,
                    part: newValue.disc,
                    total: newValue.totalDiscs)
            } else {
                self.frames[frameKey] = nil
            }
        }
    }
    
    /// TrackNumber(/TotalTracks) getter-setter. ID3 Identifier: `TRK`/`TRCK`
    public var trackNumber: (track: Int, totalTracks: Int?) {
        get {
            let identifier = FrameIdentifier.known(.trackNumber)
            let frameKey = identifier.frameKey(nil)
            var tuple: (track: Int, totalTracks: Int?) = (0, nil)
            if let frame = self.frames[frameKey] as? PartAndTotalFrame {
                tuple.track = frame.part
                tuple.totalTracks = frame.total
            }
            return tuple
        }
        set {
            let identifier = FrameIdentifier.known(.trackNumber)
            let frameKey = identifier.frameKey(nil)
            if newValue != (0, nil) {
                set(partTotalFrame: identifier,
                    part: newValue.track,
                    total: newValue.totalTracks)
            } else {
                self.frames[frameKey] = nil
            }
        }
    }
}
