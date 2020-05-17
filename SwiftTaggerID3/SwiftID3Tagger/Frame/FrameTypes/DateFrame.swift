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
        self.frameKey = self.layout.frameKey(additionalIdentifier: nil)
        
        var parsing = contents
        // extract and interpret encoding byte
        let encoding = try DateFrame.extractEncoding(data: &parsing, version: version)
        // extract string content
        let parsedString = parsing.extractPrefixAsStringUntilNullTermination(encoding) ?? ""

        let calendar = Calendar(identifier: .iso8601)
        let timeZone = TimeZone(secondsFromGMT: 0)

        // assumes frame contents are spec-compliant, 4-characters, DDMM string
        if self.frameKey == .date {
            // split the four-character string into an array of 2-character strings
            let dayMonthArray = parsedString.components(withLength: 2)
            // make sure the array has at least two elements so we don't go out of bounds
            guard dayMonthArray.count >= 2 else {
                throw Mp3File.Error.InvalidDateString
            }
            // if parsedString is not spec-compliant, there may be more than two elements
            // so we'll use the first two, rather than .first and .last
            // because those should be day and month
            // if they're not, we'll probably get nil when we try to make a date out of them
            // the first array element is the day, make the string an Int
            let day = Int(dayMonthArray[0])
            // second element is the month, make it an Int
            let month = Int(dayMonthArray[1])
            // use day and month as components for a date
            let dateComponents = DateComponents(calendar: calendar,
                                                timeZone: timeZone,
                                                month: month,
                                                day: day)
            if let date = dateComponents.date {
                // initialize the timeStamp property
                self.timeStamp = date
            }
        // assumes frame contents are spec-compliant, 4-characters, HHmm string
        } else if self.frameKey == .time {
            // split the four-character string into an array of 2-character strings
            let hourMinuteArray = parsedString.components(withLength: 2)
            // make sure the array has at least two elements so we don't go out of bounds
            guard hourMinuteArray.count >= 2 else {
                throw Mp3File.Error.InvalidDateString
            }
            // the first array element is the hour, make the string an Int
            let hour = Int(hourMinuteArray[0])
            // the second array element is the minute, make the string an Int
            let minute = Int(hourMinuteArray[1])
            // use hour and minute as components
            let dateComponents = DateComponents(calendar: calendar,
                                                timeZone: timeZone,
                                                hour: hour,
                                                minute: minute)
            if let time = dateComponents.date {
                self.timeStamp = time
            }
        // assumes frame contents are spec-compliant, 4-characters long, yyyy string
        } else if self.frameKey == .year {
            // make the string into an Int
            let year = Int(parsedString)
            // use it as a component
            let dateComponents = DateComponents(calendar: calendar,
                                                timeZone: timeZone,
                                                year: year)
            if let year = dateComponents.date {
                self.timeStamp = year
            }
        // versions 2.2 and 2.3 should only have a year for this frame
        } else if self.frameKey == .originalReleaseTime && (version == .v2_2 || version == .v2_3) {
            // make the string into an Int
            let year = Int(parsedString)
            // use it as a component
            let dateComponents = DateComponents(calendar: calendar,
                                                timeZone: timeZone,
                                                year: year)
            if let year = dateComponents.date {
                self.timeStamp = year
            }
            // everything else should be an ISO-8601 compliant string
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
        
        guard !(version == .v2_2 || version == .v2_3) && !(self.layout == .known(.encodingTime) || self.layout == .known(.taggingTime) || self.layout == .known(.releaseTime))  else {
            throw Mp3File.Error.DateFrameNotAvailableForVersion
        }
        
        guard !(self.layout == .known(.date) || self.layout == .known(.time) || self.layout == .known(.year)) && version != .v2_4 else {
            throw Mp3File.Error.DateFrameNotAvailableForVersion
        }

        var encodedString = Data()

        if self.frameKey == .date {
            let day = String(withInt: self.timeStamp?.id3DayMonth.day ?? 01)
            let month = String(withInt: self.timeStamp?.id3DayMonth.month ?? 01)
            encodedString = "\(day)\(month)".encoded(withNullTermination: false)
        } else if self.frameKey == .time {
            let hour = String(withInt: self.timeStamp?.id3HourMinute.hour ?? 00)
            let minute = String(withInt: self.timeStamp?.id3HourMinute.minute ?? 00)
            encodedString = "\(hour)\(minute)".encoded(withNullTermination: false)
        } else if self.frameKey == .year {
            let year = self.timeStamp?.id3Year ?? 2001
            encodedString = String(year).encoded(withNullTermination: false)
        } else if self.frameKey == .originalReleaseTime && (version == .v2_2 || version == .v2_3) {
            let calendar = Calendar(identifier: .iso8601)
            let timeZone = TimeZone(secondsFromGMT: 0) ?? .current
            let components = calendar.dateComponents(in: timeZone, from: self.timeStamp ?? Date.distantPast)
            let year = String(components.year ?? 2001)
            encodedString = year.encoded(withNullTermination: false)
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
            let timeZone = TimeZone(secondsFromGMT: 0)
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
            let timeZone = TimeZone(secondsFromGMT: 0)
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
            let timeZone = TimeZone(secondsFromGMT: 0)
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
            let timeZone = TimeZone(secondsFromGMT: 0)
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
            let timeZone = TimeZone(secondsFromGMT: 0)
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
            let timeZone = TimeZone(secondsFromGMT: 0)
            let dateComponents = DateComponents(calendar: calendar,
                                                timeZone: timeZone,
                                                year: newValue)
            if let date = calendar.date(from: dateComponents) {
                set(.known(.year), .year, timeStamp: date)
            }
        }
    }
}
