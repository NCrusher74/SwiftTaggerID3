//
//  File.swift
//  
//
//  Created by Nolaine Crusher on 9/18/20.
//

/*
/////  v2.2 and 2.3 /////
 Since there might be a lot of people contributing to an audio file in
 various ways, such as musicians and technicians, the 'Text
 information frames' are often insufficient to list everyone involved
 in a project. The 'Involved people list' is a frame containing the
 names of those involved, and how they were involved. The body simply
 contains a terminated string with the involvement directly followed by
 a terminated string with the involvee followed by a new involvement
 and so on. There may only be one "IPL" frame in each tag.
 
 Involved people list   "IPL"
 Frame size             $xx xx xx
 Text encoding          $xx
 People list strings    <textstrings>

 v2.4:
 TMCL
 The 'Musician credits list' is intended as a mapping between
 instruments and the musician that played it. Every odd field is an
 instrument and every even is an artist or a comma delimited list of
 artists.
 
 TIPL
 The 'Involved people list' is very similar to the musician credits
 list, but maps between functions, like producer, and names.
 */
import Foundation

/**
 A type used to represent an ID3 involved peeople list or musician credits frame.
 handled as a dictionary: `[role : [array of people performing the role]]`
 */
class CreditsListFrame: Frame {
    /// The dictionary of `[role : [array of people performing the role]]`
    var credits: [ String : [String] ]
    
    init(identifier: FrameIdentifier,
         version: Version,
         size: Int,
         flags: Data,
         payload: Data
    ) throws {
        var data = payload
        let encoding = try data.extractEncoding()
        self.credits = try data.extractAndDecodeCreditString(encoding: encoding)
        super.init(identifier: identifier,
                  version: version,
                  size: size,
                  flags: flags)
    }
    
    override var contentData: Data {
        var data = Data()
        // append encoding Byte
        let encoding = String.Encoding.isoLatin1
        data.append(encoding.encodingByte)

        // encode and append each credit
        for key in credits.keys {
            data.append(key.encodeNullTerminatedString(encoding))
            let valueString = credits[key]?.joined(separator: ",") ?? ""
            data.append(valueString.encodeNullTerminatedString(encoding))
        }
        return data
    }
    
    // MARK: - Frame building
    /// Initialize a frame building instance for a given layout
    /// - Parameters:
    ///   - layout: the frame layout
    ///   - credits: the credits dictionary
    init(_ identifier: FrameIdentifier,
         version: Version,
         credits: [ String: [String] ]) {
        self.credits = credits
        let flags = version.defaultFlags
        
        var size = 1 // +1 for encoding byte
        let encoding = String.Encoding.isoLatin1
        for key in credits.keys {
            size += key.encodeNullTerminatedString(encoding).count
            let valueString = credits[key]?.joined(separator: ",") ?? ""
            size += valueString.encodeNullTerminatedString(encoding).count
        }
        super.init(identifier: identifier,
                   version: version,
                   size: size,
                   flags: flags)
    }
    
}

