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
    public init(month: Int?, day: Int?) {
        self.init(layout: .known(.date),
                  timeStampString: "\(month ?? 00)-\(day ?? 00)")
    }
    
    /// TIM/TIME Time Frame
    public init(hour: Int?, minute: Int?) {
        self.init(layout: .known(.time),
                  timeStampString: "\(hour ?? 00):\(minute ?? 00)")
    }
    
    /// TYE/TYER Year Frame
    public init(year: Int?) {
        self.init(layout: .known(.year),
                  timeStampString: "\(year ?? 00)")
    }
    
    /// TDEN Encoding Time Frame
    public init(encodingYear: Int?, month: Int?, day: Int?, hour: Int?, minute: Int?) {
        self.init(layout: .known(.encodingTime),
                  timeStampString: "\(encodingYear ?? 0000)-\(month ?? 00)-\(day ?? 00)T\(hour ?? 00):\(minute ?? 00)")
    }
    
    /// TOR/TORY/TDOR - Original Release Date/Year Frame
    public init(originalReleaseYear: Int?, month: Int?, day: Int?, hour: Int?, minute: Int?) {
        self.init(layout: .known(.originalReleaseTime),
                  timeStampString: "\(originalReleaseYear ?? 0000)-\(month ?? 00)-\(day ?? 00)T\(hour ?? 00):\(minute ?? 00)")
    }
    
    /// TRD/TRDA/TDRC - Recording Date Frame
    public init(recordingYear: Int?, month: Int?, day: Int?, hour: Int?, minute: Int?) {
        self.init(layout: .known(.recordingDate),
                  timeStampString: "\(recordingYear ?? 0000)-\(month ?? 00)-\(day ?? 00)T\(hour ?? 00):\(minute ?? 00)")
    }
    
    /// TDRL - Release Time Frame
    public init(releaseYear: Int?, month: Int?, day: Int?, hour: Int?, minute: Int?) {
        self.init(layout: .known(.releaseTime),
                  timeStampString: "\(releaseYear ?? 0000)-\(month ?? 00)-\(day ?? 00)T\(hour ?? 00):\(minute ?? 00)")
    }
    
    /// TDTG - Tagging Time Frame
    public init(taggingYear: Int?, month: Int?, day: Int?, hour: Int?, minute: Int?) {
        self.init(layout: .known(.taggingTime),
                  timeStampString: "\(taggingYear ?? 0000)-\(month ?? 00)-\(day ?? 00)T\(hour ?? 00):\(minute ?? 00)")
    }
    
    var flags: Data
    var layout: FrameLayoutIdentifier
    var frameKey: FrameKey
    
    // encode contents of the frame to add to an ID3 tag
    func encodeContents(version: Version) throws -> Data {
        let encodingByte = StringEncoding.preferred.rawValue.encoding(endianness: .bigEndian)
        return encodingByte + self.timeStampString.encoded(withNullTermination: false)
    }
    
    var year: Int?
    var month: Int?
    var day: Int?
    var hour: Int?
    var minute: Int?
    var timeStampString: String
    
    init(layout: FrameLayoutIdentifier,
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
    // decode contents of a frame from an ID3 tag
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

