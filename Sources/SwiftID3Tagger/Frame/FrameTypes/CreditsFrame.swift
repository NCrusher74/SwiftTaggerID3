//
//  File.swift
//  
//
//  Created by Nolaine Crusher on 9/18/20.
//

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

