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
        // assumes frame contents are 4-characters, DDMM string
        if self.frameKey == .date {
            let formatter = DateFormatter()
            formatter.dateFormat = "DDMM"
            if let date = formatter.date(from: parsedString) {
                self.timeStamp = date
            }
        // assumes frame contents are 4-characters long, HHmm string
        } else if self.frameKey == .time {
            let formatter = DateFormatter()
            formatter.dateFormat = "HHmm"
            if let time = formatter.date(from: parsedString) {
                self.timeStamp = time
            }
        // assumes frame contents are 4-characters long, yyyy string
        } else if self.frameKey == .year {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy"
            if let year = formatter.date(from: parsedString) {
                self.timeStamp = year
            }
        } else {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime]
            if let date = formatter.date(from: parsedString) {
                self.timeStamp = date
            }
        }
    }
    
    // MARK: Frame Building
    init(_ layout: FrameLayoutIdentifier,
         timeStamp: Date) {
        self.flags = DateFrame.defaultFlags
        self.layout = layout
        self.frameKey = layout.frameKey(additionalIdentifier: nil)
        self.timeStamp = timeStamp
    }
    
    // encode contents of the frame to add to an ID3 tag
    func encodeContents(version: Version) throws -> Data {
        var frameData = Data()
        // append encoding byte
        frameData.append(StringEncoding.preferred.rawValue)
        
        var encodedString = Data()
        if self.frameKey == .date {
            let day = self.timeStamp?.id3DayMonth.day ?? 01
            let month = self.timeStamp?.id3DayMonth.month ?? 01
            encodedString = "\(day)\(month)".encoded(withNullTermination: false)
        } else if self.frameKey == .time {
            let hour = self.timeStamp?.id3HourMinute.hour ?? 00
            let minute = self.timeStamp?.id3HourMinute.minute ?? 00
            encodedString = "\(hour)\(minute)".encoded(withNullTermination: false)
        } else if self.frameKey == .year {
            let year = self.timeStamp?.id3Year ?? 2001
            encodedString = String(year).encoded(withNullTermination: false)
        } else {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime]
            let dateString = formatter.string(from: timeStamp ?? Date.distantPast )
            encodedString = dateString.encoded(withNullTermination: false)
        }
        frameData.append(encodedString)
        return frameData
    }
}

// MARK: Tag extension
// These are convenience getter-setter properties
extension Tag {
    internal func date(for frameKey: FrameKey)
        -> (year: Int?, month: Int?, day: Int?, hour: Int?, minute: Int?)? {
            if let frame = self.frames[frameKey],
                case .dateFrame(let dateFrame) = frame {
                let date = dateFrame.timeStamp ?? Date.distantPast
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
    
    internal mutating func set(_ layout: FrameLayoutIdentifier,
                               _ frameKey: FrameKey,
                               timeStamp: Date) {
        let frame = DateFrame(layout, timeStamp: timeStamp)
        self.frames[frameKey] = .dateFrame(frame)
    }
    
    /// Version 2.4 only. Identifier: `TDRL`
    public var releaseDateTime:
        (year: Int?, month: Int?, day: Int?, hour: Int?, minute: Int?)? {
        get {
            date(for: .releaseTime)
        }
        set {
            let calendar = Calendar(identifier: .iso8601)
            let timeZone = TimeZone.init(secondsFromGMT: 0)
            let dateComponents = DateComponents(calendar: calendar,
                                                timeZone: timeZone,
                                                year: newValue?.year,
                                                month: newValue?.month,
                                                day: newValue?.day,
                                                hour: newValue?.hour,
                                                minute: newValue?.minute)
            if let date = calendar.date(from: dateComponents) {
                set(.known(.releaseTime), .releaseTime, timeStamp: date)
            }
        }
    }
    
    /// Version 2.4 only. Identifier `TDEN`
    public var encodingDateTime:
        (year: Int?, month: Int?, day: Int?, hour: Int?, minute: Int?)? {
        get {
            date(for: .encodingTime)
        }
        set {
            let calendar = Calendar(identifier: .iso8601)
            let timeZone = TimeZone.init(secondsFromGMT: 0)
            let dateComponents = DateComponents(calendar: calendar,
                                                timeZone: timeZone,
                                                year: newValue?.year,
                                                month: newValue?.month,
                                                day: newValue?.day,
                                                hour: newValue?.hour,
                                                minute: newValue?.minute)
            if let date = calendar.date(from: dateComponents) {
                set(.known(.encodingTime), .encodingTime, timeStamp: date)
            }
        }
    }
    
    /// Version 2.4 only. Identifier `TDTG`
    public var taggingDateTime:
        (year: Int?, month: Int?, day: Int?, hour: Int?, minute: Int?)? {
        get {
            date(for: .taggingTime)
        }
        set {
            let calendar = Calendar(identifier: .iso8601)
            let timeZone = TimeZone.init(secondsFromGMT: 0)
            let dateComponents = DateComponents(calendar: calendar,
                                                timeZone: timeZone,
                                                year: newValue?.year,
                                                month: newValue?.month,
                                                day: newValue?.day,
                                                hour: newValue?.hour,
                                                minute: newValue?.minute)
            if let date = calendar.date(from: dateComponents) {
                set(.known(.taggingTime), .taggingTime, timeStamp: date)
            }
        }
    }
    
    /// Identifier `TRD`/`TRDA`/`TDRC`
    public var recordingDateTime:
        (year: Int?, month: Int?, day: Int?, hour: Int?, minute: Int?)? {
        get {
            date(for: .recordingDate)
        }
        set {
            let calendar = Calendar(identifier: .iso8601)
            let timeZone = TimeZone.init(secondsFromGMT: 0)
            let dateComponents = DateComponents(calendar: calendar,
                                                timeZone: timeZone,
                                                year: newValue?.year,
                                                month: newValue?.month,
                                                day: newValue?.day,
                                                hour: newValue?.hour,
                                                minute: newValue?.minute)
            if let date = calendar.date(from: dateComponents) {
                set(.known(.recordingDate), .recordingDate, timeStamp: date)
            }
        }
    }
    
    /// Full date/time for version 2.4. Year-only for versions 2.2 and 2.3. Identifer `TOY`/`TORY`/`TDOR`
    public var originalReleaseDateTime:
        (year: Int?, month: Int?, day: Int?, hour: Int?, minute: Int?)? {
        get {
            date(for: .originalReleaseTime)
        }
        set {
            let calendar = Calendar(identifier: .iso8601)
            let timeZone = TimeZone.init(secondsFromGMT: 0)
            let dateComponents = DateComponents(calendar: calendar,
                                                timeZone: timeZone,
                                                year: newValue?.year,
                                                month: newValue?.month,
                                                day: newValue?.day,
                                                hour: newValue?.hour,
                                                minute: newValue?.minute)
            if let date = calendar.date(from: dateComponents) {
                set(.known(.originalReleaseTime), .originalReleaseTime, timeStamp: date)
            }
        }
    }
    
    /// version 2.2/2.3 only Identifier `TDA`/`TDAT`
    public var date: (month: Int?, day: Int?)? {
        get {
            if let date = date(for: .date) {
                return (date.month, date.day)
            } else {
                return nil
            }
        }
        set {
            let calendar = Calendar(identifier: .iso8601)
            let timeZone = TimeZone(secondsFromGMT: 0)
            let dateComponents = DateComponents(calendar: calendar,
                                                timeZone: timeZone,
                                                month: newValue?.month,
                                                day: newValue?.day)
            if let date = calendar.date(from: dateComponents) {
                set(.known(.date), .date, timeStamp: date)
            }
        }
    }
    
    /// version 2.2/2.3. Identifier `TIM`/`TIME`
    public var time: (hour: Int?, minute: Int?)? {
        get {
            if let date = date(for: .time) {
                return (date.hour, date.minute)
            } else {
                return nil
            }
        }
        set {
            let calendar = Calendar(identifier: .iso8601)
            let timeZone = TimeZone(secondsFromGMT: 0)
            let dateComponents = DateComponents(calendar: calendar,
                                                timeZone: timeZone,
                                                hour: newValue?.hour,
                                                minute: newValue?.minute)
            if let date = calendar.date(from: dateComponents) {
                set(.known(.time), .time, timeStamp: date)
            }
        }
    }
    
    /// version 2.2/2.3 Identifier `TYE`/`TYER`
    public var year: Int? {
        get {
            if let date = date(for: .year) {
                return date.year
            } else {
                return nil
            }
        }
        set {
            let calendar = Calendar(identifier: .iso8601)
            let timeZone = TimeZone.init(secondsFromGMT: 0)
            let dateComponents = DateComponents(calendar: calendar,
                                                timeZone: timeZone,
                                                year: newValue)
            if let date = calendar.date(from: dateComponents) {
                set(.known(.year), .year, timeStamp: date)
            }
        }
    }
}
