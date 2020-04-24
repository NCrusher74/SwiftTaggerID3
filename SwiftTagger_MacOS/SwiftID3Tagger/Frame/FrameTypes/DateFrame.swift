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
 A type used to represent an ID3-formatted timestamp tag. The information delivered from this type will vary depending on the tag version and formatting.
*/
struct DateFrame: FrameProtocol {

    var flags: Data
    var layout: FrameLayoutIdentifier
    var frameKey: FrameKey
    
    func encodeContents(version: Version) throws -> Data {
        <#code#>
    }
    
    var year: Int?
    var month: Int?
    var day: Int?
    var hour: Int?
    var minute: Int?
    var timeStamp: Date
    
    private init(layout: FrameLayoutIdentifier,
                 timestamp: Date) {
        self.layout = layout
        self.flags = DateFrame.defaultFlags
        
        let components = Calendar(identifier: .gregorian).dateComponents(in: TimeZone(secondsFromGMT: 0) ?? .current, from: Date())
        self.year = components.year
        self.month = components.month
        self.day = components.day
        self.hour = components.hour
        self.minute = components.minute
    }
 
    // subset of ISO 8601; valid timestamps are yyyy, yyyy-MM, yyyy-MM-dd, yyyy-MM-ddTHH, yyyy-MM-ddTHH:mm and yyyy-MM-ddTHH:mm:ss.
    init(decodingContents contents: Data.SubSequence,
         version: Version,
         layout: FrameLayoutIdentifier,
         flags: Data) throws {
        self.layout = layout
        switch layout {
            case .known(.date): self.frameKey = .date
            // (2.2-2.3) DDMM
            case .known(.encodingTime): self.frameKey = .encodingTime
            // (2.4) timestrap
            case .known(.originalReleaseTime): self.frameKey = .originalReleaseTime
            // (2.2-2.3) YYYY, (2.4) timestamp
            case .known(.recordingDate): self.frameKey = .recordingDate
            //  (2.2-2.3) "4th-7th June, 12th June" (2.4) timestamp
            case .known(.releaseTime): self.frameKey = .releaseTime
            // timestamp 2.4
            case .known(.taggingTime): self.frameKey = .taggingTime
            // timestamp 2.4
            case .known(.time): self.frameKey = .time
            // HHMM
            case .known(.year): self.frameKey = .year
            // YYYY
            default: self.frameKey = .userDefinedText(description: "")
            
            self.flags = flags
            
            
        }
    }
    

    
}
*/
