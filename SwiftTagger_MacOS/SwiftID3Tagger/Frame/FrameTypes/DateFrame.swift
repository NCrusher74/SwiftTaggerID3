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
 A type used to represent an ID3-formatted timestamp tag. The information delivered from this type will vary depending on the tag version and formatting.
 */
public struct DateFrame: FrameProtocol {
    
    /// TDAT Date Frame
    public init(releaseDateMonth: Int?, releaseDateDay: Int?) {
        self.init(layout: .known(.date),
                  timeStampString: "\(releaseDateMonth ?? 00)-\(releaseDateDay ?? 00)")
    }
    
    /// TIM/TIME Time Frame
    public init(releaseTimeHour: Int?, releaseTimeMinute: Int?) {
        self.init(layout: .known(.time),
                  timeStampString: "\(releaseTimeHour ?? 00):\(releaseTimeMinute ?? 00)")
    }
    
    /// TYE/TYER Year Frame
    public init(releaseYear: Int?) {
        self.init(layout: .known(.year),
                  timeStampString: "\(releaseYear ?? 00)")
    }
    
    /// TDEN Encoding Time Frame
    public init(encodingTimeYear: Int?, encodingTimeMonth: Int?, encodingTimeDay: Int?, encodingTimeHour: Int?, encodingTimeMinute: Int?) {
        self.init(layout: .known(.encodingTime),
                  timeStampString: "\(encodingTimeYear ?? 0000)-\(encodingTimeMonth ?? 00)-\(encodingTimeDay ?? 00)T\(encodingTimeHour ?? 00):\(encodingTimeMinute ?? 00)")
    }
    
    /// TOR/TORY/TDOR - Original Release Date/Year Frame
    public init(originalReleaseYear: Int?, originalReleaseMonth: Int?, originalReleaseDay: Int?, originalReleaseHour: Int?, originalReleaseMinute: Int?) {
        self.init(layout: .known(.originalReleaseTime),
                  timeStampString: "\(originalReleaseYear ?? 0000)-\(originalReleaseMonth ?? 00)-\(originalReleaseDay ?? 00)T\(originalReleaseHour ?? 00):\(originalReleaseMinute ?? 00)")
    }
    
    /// TRD/TRDA/TDRC - Recording Date Frame
    public init(recordingDateYear: Int?, recordingDateMonth: Int?, recordingDateDay: Int?, recordingDateHour: Int?, recordingDateMinute: Int?) {
        self.init(layout: .known(.recordingDate),
                  timeStampString: "\(recordingDateYear ?? 0000)-\(recordingDateMonth ?? 00)-\(recordingDateDay ?? 00)T\(recordingDateHour ?? 00):\(recordingDateMinute ?? 00)")
    }
    
    /// TDRL - Release Time Frame
    public init(releaseTimeYear: Int?, releaseTimeMonth: Int?, releaseTimeDay: Int?, releaseTimeHour: Int?, releaseTimeMinute: Int?) {
        self.init(layout: .known(.releaseTime),
                  timeStampString: "\(releaseTimeYear ?? 0000)-\(releaseTimeMonth ?? 00)-\(releaseTimeDay ?? 00)T\(releaseTimeHour ?? 00):\(releaseTimeMinute ?? 00)")
    }
    
    /// TDTG - Tagging Time Frame
    public init(taggingTimeYear: Int?, taggingTimeMonth: Int?, taggingTimeDay: Int?, taggingTimeHour: Int?, taggingTimeMinute: Int?) {
        self.init(layout: .known(.taggingTime),
                  timeStampString: "\(taggingTimeYear ?? 0000)-\(taggingTimeMonth ?? 00)-\(taggingTimeDay ?? 00)T\(taggingTimeHour ?? 00):\(taggingTimeMinute ?? 00)")
    }
    
    
    
    var flags: Data
    var layout: FrameLayoutIdentifier
    var frameKey: FrameKey
    
    func encodeContents(version: Version) throws -> Data {
        return self.timeStampString.encoded(withNullTermination: false)
    }
    
    var year: Int?
    var month: Int?
    var day: Int?
    var hour: Int?
    var minute: Int?
    var timeStampString: String
    
    private init(layout: FrameLayoutIdentifier,
                 timeStampString: String) {
        self.flags = DateFrame.defaultFlags
        self.layout = layout
        switch layout {
            case .known(.date): self.frameKey = .date
            // TDAT - (2.2-2.3) DDMM
            case .known(.encodingTime): self.frameKey = .encodingTime
            // TDEN (2.4) timestamp
            case .known(.originalReleaseTime): self.frameKey = .originalReleaseTime
            // (2.2-2.3) YYYY, (2.4) timestamp
            case .known(.recordingDate): self.frameKey = .recordingDate
            //  (2.2-2.3) "4th-7th June, 12th June" (2.4) timestamp
            case .known(.releaseTime): self.frameKey = .releaseTime
            // timestamp 2.4
            case .known(.taggingTime): self.frameKey = .taggingTime
            // timestamp 2.4
            case .known(.time): self.frameKey = .time
            // HHMM (2.2-2.3)
            case .known(.year): self.frameKey = .year
            // YYYY (2.2-2.3)
            default: self.frameKey = .userDefinedText(description: "")
        }
        self.timeStampString = timeStampString
    }
    
    // subset of ISO 8601; valid timestamps are yyyy, yyyy-MM, yyyy-MM-dd, yyyy-MM-ddTHH, yyyy-MM-ddTHH:mm and yyyy-MM-ddTHH:mm:ss.
    init(decodingContents contents: Data.SubSequence,
         version: Version,
         layout: FrameLayoutIdentifier,
         flags: Data) throws {
        self.flags = flags
        self.layout = layout
        switch layout {
            case .known(.date): self.frameKey = .date
            // (2.2-2.3) DDMM
            case .known(.encodingTime): self.frameKey = .encodingTime
            // (2.4) timestamp
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
        }
        
        var parsing = contents
        let encoding = try StringFrame.extractEncoding(data: &parsing, version: version)
        self.timeStampString = parsing.extractPrefixAsStringUntilNullTermination(encoding) ?? ""
    }
}

