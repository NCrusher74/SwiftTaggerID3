//
//  DateFrame.swift
//  SwiftTaggerID3
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
struct DateFrame: FrameProtocol {
    
    // MARK: Properties
    var flags: Data
    var layout: FrameLayoutIdentifier
    var frameKey: FrameKey
    var allowMultipleFrames: Bool = false
    
    // needs to be in ISO-8601 format
    var timeStampString: String?
    var timeStamp: Date?
    
    // MARK: Frame parsing
    // subset of ISO 8601; valid timestamps are yyyy, yyyy-MM, yyyy-MM-dd, yyyy-MM-ddTHH, yyyy-MM-ddTHH:mm and yyyy-MM-ddTHH:mm:ss.
    init(decodingContents contents: Data.SubSequence,
         version: Version,
         layout: FrameLayoutIdentifier,
         flags: Data) throws {
        self.flags = flags
        self.layout = layout
        self.frameKey = layout.frameKey(additionalIdentifier: nil)
        
        var parsing = contents
        let encoding = try DateFrame.extractEncoding(data: &parsing, version: version)
        let parsedString = parsing.extractPrefixAsStringUntilNullTermination(encoding) ?? ""

        // assuming the timestamp is in ISO-8601 format as per the ID3 spec
        let formatter = ISO8601DateFormatter()
        guard let date = formatter.date(from: parsedString) else {
            throw Mp3File.Error.InvalidDateString
        }
        self.timeStamp = date
        self.timeStampString = formatter.string(from: date)
    }
    
    // MARK: Frame Building
    init(_ layout: FrameLayoutIdentifier,
         timeStamp: Date) {
        self.flags = DateFrame.defaultFlags
        self.layout = layout
        self.frameKey = layout.frameKey(additionalIdentifier: nil)
        
        let formatter = ISO8601DateFormatter()
        self.timeStamp = timeStamp
        self.timeStampString = formatter.string(from: timeStamp)
    }
    
    // encode contents of the frame to add to an ID3 tag
    func encodeContents(version: Version) throws -> Data {
        var frameData = Data()
        // append encoding byte
        frameData.append(StringEncoding.preferred.rawValue)
        
        frameData.append(timeStampString?.encoded(withNullTermination: false) ?? Data())

        return frameData
    }
}

// MARK: Tag extension
extension Tag {
    internal func date(for frameKey: FrameKey) -> Date? {
        if let frame = self.frames[frameKey],
            case .dateFrame(let dateFrame) = frame {
            return dateFrame.timeStamp
        } else {
            return nil
        }
    }
    
    internal mutating func set(_ layout: FrameLayoutIdentifier,
                               _ frameKey: FrameKey,
                               timeStamp: Date) {
        let frame = DateFrame(layout, timeStamp: timeStamp)
        self.frames[frameKey] = .dateFrame(frame)
    }
    
    public var releaseDateTime:
        (year: Int?, month: Int?, day: Int?, hour: Int?, minute: Int?)? {
        get {
            if let date = date(for: .releaseTime) {
                let calendar = Calendar(identifier: .iso8601)
                let timeZone = TimeZone(secondsFromGMT: 0) ?? .current
                let components = calendar.dateComponents(in: timeZone, from: date)
                return (components.year,
                        components.month,
                        components.day,
                        components.hour,
                        components.minute)
            } else {
                return nil
            }
        }
        set {
            let calendar = Calendar(identifier: .iso8601)
            let timeZone = TimeZone.init(secondsFromGMT: 0)
            if let date = DateComponents(calendar: calendar,
                                      timeZone: timeZone,
                                      year: newValue?.year,
                                      month: newValue?.month,
                                      day: newValue?.day,
                                      hour: newValue?.hour,
                                      minute: newValue?.minute).date {
                set(.known(.releaseTime), .releaseTime, timeStamp: date)
            }
        }
    }
}
