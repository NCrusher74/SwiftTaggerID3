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

/*
import Foundation
/**
 A type used to represent an ID3 recording date time frame to be used in the ID3 tag. Valid only for ID3 tag version 2.4.
 */
public struct DateFrame: FrameProtocol {
    /// The recordin date time information. This field contains date and time of the recording.
    public let date: Date
    
    /**
     - parameter recordingDateTime: a RecordingDateTime struct.
     */
    private init(layout: FrameLayoutIdentifier,
                date: Date) {
        self.date = date
        self.flags = DateFrame.defaultFlags()
        self.layout = layout
    }

    
 
    var flags: Data
    var layout: FrameLayoutIdentifier
    
    func encodeContents(version: Version) throws -> Data {
        
    }
    
    init(decodingContents contents: Data.SubSequence,
         version: Version,
         layout: FrameLayoutIdentifier,
         flags: Data) throws {
        self.flags = flags
        self.layout = layout
    }
    
    
    
}
*/
