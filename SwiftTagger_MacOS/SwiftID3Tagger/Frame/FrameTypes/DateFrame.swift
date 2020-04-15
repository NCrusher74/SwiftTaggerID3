//
//  DateFrame.swift
//  SwiftTagger_MacOS
//
//  Some of this code is adapted from ID3TagEditor
//  Created by Fabrizio Duroni on 27/02/2018.
//  2018 Fabrizio Duroni. https://github.com/chicio/ID3TagEditor
//
//  Created by Nolaine Crusher on 4/12/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation
/**
 A type used to represent an ID3 recording date time frame to be used in the ID3 tag. Valid only for ID3 tag version 2.4.
 */
struct DateFrame: FrameProtocol {
    /// The recordin date time information. This field contains date and time of the recording.
    public let dateTime: Date
    
    /**
     - parameter recordingDateTime: a RecordingDateTime struct.
     */
    public init(dateTime: Date) {
        self.dateTime = dateTime
    }

    
 
    var flags: Data
    var layout: KnownFrameLayoutIdentifier
    
//    func encodeContents(version: Version) throws -> Data {
//        
//    }
    
    init(decodingContents contents: Data.SubSequence,
         version: Version,
         layout: KnownFrameLayoutIdentifier,
         flags: Data) throws {
        //
    }
    
}
