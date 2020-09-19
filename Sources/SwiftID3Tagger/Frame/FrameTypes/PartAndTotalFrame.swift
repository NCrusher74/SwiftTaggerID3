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
