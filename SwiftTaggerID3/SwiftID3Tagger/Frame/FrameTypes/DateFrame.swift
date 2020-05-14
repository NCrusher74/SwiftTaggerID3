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
//            let formatter = ISO8601DateFormatter()
//            formatter.formatOptions = [.withInternetDateTime]
//
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
            let components = Calendar(identifier: .iso8601).dateComponents([.year,.month,.day,.hour,.minute], from: date)
            // TDA/TDAT frame uses DDMM 4-character formatted string
            if self.frameKey == .date {
                dateForFrame = "\(components.day ?? 00)\(components.month ?? 00)"
            }
            // TIM/TIME frame uses HHmm 4 character formatted string
            if self.frameKey == .time {
                dateForFrame = "\(components.hour ?? 00)\(components.minute ?? 00)"
            }
            // TYE/TYER frame uses yyyy 4 character formatted string
            if self.frameKey == .year {
                dateForFrame = "\(components.year ?? 0000)"
            }
            // all other frames get a full timestamp
            if self.frameKey == .encodingTime ||
                self.frameKey == .originalReleaseTime ||
                self.frameKey == .recordingDate ||
                self.frameKey == .releaseTime ||
                self.frameKey == .taggingTime {
                dateForFrame = "\(components.year ?? 0000)-\(components.month ?? 00)-\(components.day ?? 00)T\(components.hour ?? 00):\(components.minute ?? 00)"
                frameData.append(dateForFrame.encoded(withNullTermination: false))
            }
        }
        frameData.append(dateForFrame.encoded(withNullTermination: false))
        return frameData
    }
}

extension Tag {
    /// - (Release) Date frame getter-setter. Valid for versions 2.2 and 2.3 only.
    /// ID3 Identifier: `TDA`/`TDAT`
    public var date: (month: Int?, day: Int?)? {
        get {
            if let frame = self.frames[.date],
                case .dateFrame(let dateFrame) = frame {
                let dateString = dateFrame.timeStampString
                let formatter = ISO8601DateFormatter()
                formatter.formatOptions = [.withInternetDateTime]
                if let date = formatter.date(from: dateString) {
                    let components = Calendar(identifier: .iso8601).dateComponents([.day,.month], from: date)
                    return (components.month, components.day)
                } else {
                    return nil
                }
            } else {
                return nil
            }
        }
        set {
            if let date = DateComponents(
                calendar: Calendar(identifier: .iso8601),
                month: newValue?.month,
                day: newValue?.day).date {
            let frame = DateFrame(.known(.date), timeStamp: date)
            frames[.date] = .dateFrame(frame)
            }
        }
    }
    
    /// - (Release) Time frame getter-setter. Valid for versions 2.2 and 2.3 only.
    /// ID3 Identifier: `TIM`/`TIME`
    public var time: (hour: Int?, minute: Int?)? {
        get {
            if let frame = self.frames[.time],
                case .dateFrame(let dateFrame) = frame {
                let dateString = dateFrame.timeStampString
                let formatter = ISO8601DateFormatter()
                formatter.formatOptions = [.withInternetDateTime]
                if let date = formatter.date(from: dateString) {
                    let components = Calendar(identifier: .iso8601).dateComponents([.hour,.minute], from: date)
                    return (components.hour, components.minute)
                } else {
                    return nil
                }
            } else {
                return nil
            }
        }
        set {
            if let date = DateComponents(
                calendar: Calendar(identifier: .iso8601),
                hour: newValue?.hour,
                minute: newValue?.minute).date {
                let frame = DateFrame(.known(.time), timeStamp: date)
                frames[.time] = .dateFrame(frame)
            }
        }
    }
    
    /// - (Release) Year frame getter-setter. Valid for versions 2.2 and 2.3 only.
    /// ID3 Identifier: `TYE`/`TYER`
    public var year: Int? {
        get {
            if let frame = self.frames[.year],
                case .dateFrame(let dateFrame) = frame {
                let dateString = dateFrame.timeStampString
                let formatter = ISO8601DateFormatter()
                formatter.formatOptions = [.withInternetDateTime]
                if let date = formatter.date(from: dateString) {
                    let components = Calendar(identifier: .iso8601).dateComponents([.year], from: date)
                    return components.year
                } else {
                    return nil
                }
            } else {
                return nil
            }
        }
        set {
            if let date = DateComponents(
                calendar: Calendar(identifier: .iso8601),
                year: newValue).date {
                let frame = DateFrame(.known(.year), timeStamp: date)
                frames[.year] = .dateFrame(frame)
            }
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
            if let frame = self.frames[.releaseTime],
                case .dateFrame(let dateFrame) = frame {
                let dateString = dateFrame.timeStampString
                let formatter = ISO8601DateFormatter()
                formatter.formatOptions = [.withInternetDateTime]
                if let date = formatter.date(from: dateString) {
                    let components = Calendar(identifier: .iso8601).dateComponents([.year,.month,.day,.hour,.minute], from: date)
                    return (components.year,
                            components.month,
                            components.day,
                            components.hour,
                            components.minute)
                } else {
                    return nil
                }
            } else {
                return nil
            }
        }
        set {
            if let date = DateComponents(
                calendar: Calendar(identifier: .iso8601),
                year: newValue?.year,
                month: newValue?.month,
                day: newValue?.day,
                hour: newValue?.hour,
                minute: newValue?.minute).date {
                let frame = DateFrame(.known(.releaseTime), timeStamp: date)
                frames[.releaseTime] = .dateFrame(frame)
            }
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
            if let frame = self.frames[.encodingTime],
                case .dateFrame(let dateFrame) = frame {
                let dateString = dateFrame.timeStampString
                let formatter = ISO8601DateFormatter()
                formatter.formatOptions = [.withInternetDateTime]
                if let date = formatter.date(from: dateString) {
                    let components = Calendar(identifier: .iso8601).dateComponents([.year,.month,.day,.hour,.minute], from: date)
                    return (components.year,
                            components.month,
                            components.day,
                            components.hour,
                            components.minute)
                } else {
                    return nil
                }
            } else {
                return nil
            }
        }
        set {
            if let date = DateComponents(
                calendar: Calendar(identifier: .iso8601),
                year: newValue?.year,
                month: newValue?.month,
                day: newValue?.day,
                hour: newValue?.hour,
                minute: newValue?.minute).date {
                let frame = DateFrame(.known(.encodingTime), timeStamp: date)
                frames[.encodingTime] = .dateFrame(frame)
            }
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
            if let frame = self.frames[.originalReleaseTime],
                case .dateFrame(let dateFrame) = frame {
                let dateString = dateFrame.timeStampString
                let formatter = ISO8601DateFormatter()
                formatter.formatOptions = [.withInternetDateTime]
                if let date = formatter.date(from: dateString) {
                    let components = Calendar(identifier: .iso8601).dateComponents([.year,.month,.day,.hour,.minute], from: date)
                    return (components.year,
                            components.month,
                            components.day,
                            components.hour,
                            components.minute)
                } else {
                    return nil
                }
            } else {
                return nil
            }
        }
        set {
            if let date = DateComponents(
                calendar: Calendar(identifier: .iso8601),
                year: newValue?.year,
                month: newValue?.month,
                day: newValue?.day,
                hour: newValue?.hour,
                minute: newValue?.minute).date {
                let frame = DateFrame(.known(.originalReleaseTime), timeStamp: date)
                frames[.originalReleaseTime] = .dateFrame(frame)
            }
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
            if let frame = self.frames[.recordingDate],
                case .dateFrame(let dateFrame) = frame {
                let dateString = dateFrame.timeStampString
                let formatter = ISO8601DateFormatter()
                formatter.formatOptions = [.withInternetDateTime]
                if let date = formatter.date(from: dateString) {
                    let components = Calendar(identifier: .iso8601).dateComponents([.year,.month,.day,.hour,.minute], from: date)
                    return (components.year,
                            components.month,
                            components.day,
                            components.hour,
                            components.minute)
                } else {
                    return nil
                }
            } else {
                return nil
            }
        }
        set {
            if let date = DateComponents(
                calendar: Calendar(identifier: .iso8601),
                year: newValue?.year,
                month: newValue?.month,
                day: newValue?.day,
                hour: newValue?.hour,
                minute: newValue?.minute).date {
                let frame = DateFrame(.known(.recordingDate), timeStamp: date)
                frames[.recordingDate] = .dateFrame(frame)
            }
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
            if let frame = self.frames[.taggingTime],
                case .dateFrame(let dateFrame) = frame {
                let dateString = dateFrame.timeStampString
                let formatter = ISO8601DateFormatter()
                formatter.formatOptions = [.withInternetDateTime]
                if let date = formatter.date(from: dateString) {
                    let components = Calendar(identifier: .iso8601).dateComponents([.year,.month,.day,.hour,.minute], from: date)
                    return (components.year,
                            components.month,
                            components.day,
                            components.hour,
                            components.minute)
                } else {
                    return nil
                }
            } else {
                return nil
            }
        }
        set {
            if let date = DateComponents(
                calendar: Calendar(identifier: .iso8601),
                year: newValue?.year,
                month: newValue?.month,
                day: newValue?.day,
                hour: newValue?.hour,
                minute: newValue?.minute).date {
                let frame = DateFrame(.known(.taggingTime), timeStamp: date)
                frames[.taggingTime] = .dateFrame(frame)
            }
        }
    }
}
