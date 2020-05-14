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
    var timeStampString: String
    
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
        var dateTimeString = ""
        // assuming the timestamp is in ISO-8601 format as per the ID3 spec
        if let parsedString = parsing.extractPrefixAsStringUntilNullTermination(encoding) {
            dateTimeString = parsedString
        }
        self.timeStampString = dateTimeString
    }
    
    // MARK: Frame Building
    init(_ layout: FrameLayoutIdentifier,
         timeStamp: Date) {
        self.flags = DateFrame.defaultFlags
        self.layout = layout
        self.frameKey = layout.frameKey(additionalIdentifier: nil)
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        self.timeStampString = formatter.string(from: timeStamp)
        
    }
    
    // encode contents of the frame to add to an ID3 tag
    func encodeContents(version: Version) throws -> Data {
        var frameData = Data()
        // append encoding byte
        frameData.append(StringEncoding.preferred.rawValue)
        
        let dateString = self.timeStampString
        var dateForFrame = ""
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        if let date = formatter.date(from: dateString) {

            let calendar = Calendar(identifier: .iso8601)
            let timeZone = TimeZone(secondsFromGMT: 0) ?? .current
            let components = calendar.dateComponents(in: timeZone, from: date)

            let year = components.year ?? 2001
            let month = components.month ?? 01
            let day = components.day ?? 01
            let hour = components.hour ?? 00
            let minute = components.minute ?? 00

            // TDA/TDAT frame uses DDMM 4-character formatted string
            if self.frameKey == .date {
                dateForFrame = "\(day)\(month)"
            }
            // TIM/TIME frame uses HHmm 4 character formatted string
            if self.frameKey == .time {
                dateForFrame = "\(hour)\(minute)"
            }
            // TYE/TYER frame uses yyyy 4 character formatted string
            if self.frameKey == .year {
                dateForFrame = "\(year)"
            }
            // all other frames get a full timestamp
            if self.frameKey == .encodingTime ||
                self.frameKey == .originalReleaseTime ||
                self.frameKey == .recordingDate ||
                self.frameKey == .releaseTime ||
                self.frameKey == .taggingTime {
                dateForFrame = "\(year)-\(month)-\(day)T\(hour):\(minute)"
                frameData.append(dateForFrame.encoded(withNullTermination: false))
            }
        }
        frameData.append(dateForFrame.encoded(withNullTermination: false))
        return frameData
    }
}

// MARK: Tag extension
extension Tag {
    internal func date(for frameKey: FrameKey) -> Date? {
        if let frame = self.frames[frameKey],
            case .dateFrame(let dateFrame) = frame {
            let dateString = dateFrame.timeStampString
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime]
            return formatter.date(from: dateString) ?? Date.distantPast
        } else {
            return nil
        }
    }
    
    internal mutating func set(_ layout: FrameLayoutIdentifier,
                      _ frameKey: FrameKey,
                      year: Int?,
                      month: Int?,
                      day: Int?,
                      hour: Int?,
                      minute: Int?) {
        if let date = DateComponents(
            calendar: Calendar(identifier: .iso8601),
            year: year,
            month: month,
            day: day,
            hour: hour,
            minute: minute).date {
            let frame = DateFrame(layout, timeStamp: date)
            self.frames[frameKey] = .dateFrame(frame)
        }
    }

    /// - (Release) DateTime frame getter-setter. ID3 Identifier: `TDRL` Valid for version 2.4 only
    public var releaseDateTime: (
        year: Int?,
        month: Int?,
        day: Int?,
        hour: Int?,
        minute: Int?)? {
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
            set(.known(.releaseTime), .releaseTime,
                year: newValue?.year,
                month: newValue?.month,
                day: newValue?.day,
                hour: newValue?.hour,
                minute: newValue?.minute)
        }
    }

    /// - (Release) Date frame getter-setter. Valid for versions 2.2 and 2.3 only. Format: DDMM
    /// ID3 Identifier: `TDA`/`TDAT`
    public var date: (month: Int?, day: Int?)? {
        get {
            if let date = date(for: .date) {
                let calendar = Calendar(identifier: .iso8601)
                let timeZone = TimeZone(secondsFromGMT: 0) ?? .current
                let components = calendar.dateComponents(in: timeZone, from: date)
                return (components.month,
                        components.day)
            } else {
                return nil
            }
        }
        set {
            set(.known(.date), .date,
                year: nil,
                month: newValue?.month,
                day: newValue?.day,
                hour: nil,
                minute: nil)
        }
    }
    
    /// - (Release) Time frame getter-setter. Valid for versions 2.2 and 2.3 only.
    /// ID3 Identifier: `TIM`/`TIME`
    public var time: (hour: Int?, minute: Int?)? {
        get {
            if let date = date(for: .time) {
                let calendar = Calendar(identifier: .iso8601)
                let timeZone = TimeZone(secondsFromGMT: 0) ?? .current
                let components = calendar.dateComponents(in: timeZone, from: date)
                return (components.hour,
                        components.minute)
            } else {
                return nil
            }
        }
        set {
            set(.known(.time), .time,
                year: nil,
                month: nil,
                day: nil,
                hour: newValue?.hour,
                minute: newValue?.minute)
        }
    }
    
    /// - (Release) Year frame getter-setter. Valid for versions 2.2 and 2.3 only.
    /// ID3 Identifier: `TYE`/`TYER`
    public var year: Int? {
        get {
            if let date = date(for: .year) {
                let calendar = Calendar(identifier: .iso8601)
                let timeZone = TimeZone(secondsFromGMT: 0) ?? .current
                let components = calendar.dateComponents(in: timeZone, from: date)
                return components.year
            } else {
                return nil
            }
        }
        set {
            set(.known(.year), .year,
                year: newValue,
                month: nil,
                day: nil,
                hour: nil,
                minute: nil)
        }
    }
    
    /// - EncodingDateTime frame getter-setter. ID3 Identifier: `TDEN`. Valid for Tag Version 2.4 only
    public var encodingDateTime: (
        year: Int?,
        month: Int?,
        day: Int?,
        hour: Int?,
        minute: Int?)? {
        get {
            if let date = date(for: .encodingTime) {
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
            set(.known(.encodingTime), .encodingTime,
                year: newValue?.year,
                month: newValue?.month,
                day: newValue?.day,
                hour: newValue?.hour,
                minute: newValue?.minute)
        }
    }
    
    /// - OriginalReleaseDateTime frame getter-setter. ID3 Identifier: `TOY`/`TORY`/`TDOR`
    /// intended to be a year-only field for tag versions 2.2 and 2.3
    public var originalReleaseDate: (
        year: Int?,
        month: Int?,
        day: Int?,
        hour: Int?,
        minute: Int?)? {
        get {
            if let date = date(for: .originalReleaseTime) {
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
            set(.known(.originalReleaseTime), .originalReleaseTime,
                year: newValue?.year,
                month: newValue?.month,
                day: newValue?.day,
                hour: newValue?.hour,
                minute: newValue?.minute)
        }
    }
    
    /// - RecordingDateTime frame getter-setter. ID3 Identifier: `TRD`/`TRDA`/`TDRC`
    public var recordingDateTime: (
        year: Int?,
        month: Int?,
        day: Int?,
        hour: Int?,
        minute: Int?)? {
        get {
            if let date = date(for: .recordingDate) {
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
            set(.known(.recordingDate), .recordingDate,
                year: newValue?.year,
                month: newValue?.month,
                day: newValue?.day,
                hour: newValue?.hour,
                minute: newValue?.minute)
        }
    }
    
    /// - TaggingDateTime frame getter-setter. ID3 Identifier: `TDTG`. Valid for Tag Version 2.4 only
    public var taggingDateTime: (
        year: Int?,
        month: Int?,
        day: Int?,
        hour: Int?,
        minute: Int?)? {
        get {
            if let date = date(for: .taggingTime) {
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
            set(.known(.taggingTime), .taggingTime,
                year: newValue?.year,
                month: newValue?.month,
                day: newValue?.day,
                hour: newValue?.hour,
                minute: newValue?.minute)
        }
    }
}
