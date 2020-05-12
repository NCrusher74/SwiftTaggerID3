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

    var year: Int?
    var month: Int?
    var day: Int?
    var hour: Int?
    var minute: Int?
    var timeStamp: Date
    var timeStampString: String?

    // MARK: Frame parsing
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
            default: self.frameKey = .userDefinedText(description: "(\(layout.id3Identifier(version: version) ?? "TXXX"))")
        }
        
        var parsing = contents
        let encoding = try DateFrame.extractEncoding(data: &parsing, version: version)

        // assuming the timestamp is in ISO-8601 format as per the ID3 spec
        self.timeStampString = parsing.extractPrefixAsStringUntilNullTermination(encoding) ?? ""
        let formatter = DateFormatter()
        let formattedTimeStamp = formatter.date(from: timeStampString ?? "")?.id3TimeStamp ?? (year: 0000, month: 00, day: 00, hour: 00, minute: 00)
        self.timeStamp = Date(id3TimeStamp: formattedTimeStamp) ?? Date()
        
        self.year = timeStamp.id3TimeStamp.year
        self.month = timeStamp.id3TimeStamp.month
        self.day = timeStamp.id3TimeStamp.day
        self.hour = timeStamp.id3TimeStamp.hour
        self.minute = timeStamp.id3TimeStamp.minute
    }
    
    // MARK: Frame Building
    init(_ layout: FrameLayoutIdentifier,
         timeStamp: Date) {
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
        self.timeStamp = timeStamp
    }

    // encode contents of the frame to add to an ID3 tag
    func encodeContents(version: Version) throws -> Data {
        var frameData = Data()
        // append encoding byte
        frameData.append(StringEncoding.preferred.rawValue)
        let formatter = DateFormatter()
        // format, encode and append a string value for the date as required by the frame
        if layout == .known(.date) {
            let dateString = "\(self.day ?? 00)-\(self.month ?? 00)"
            frameData.append(dateString.encoded(withNullTermination: false))
        } else if layout == .known(.time) {
            let timeString = "\(self.hour ?? 00):\(self.minute ?? 00)"
            frameData.append(timeString.encoded(withNullTermination: false))
        } else if layout == .known(.year) {
            let yearString = "\(self.year ?? 0000)"
            frameData.append(yearString.encoded(withNullTermination: false))
        } else if layout == .known(.recordingDate) {
            switch version {
                case .v2_2, .v2_3 :
                    let freeformTimeString = self.timeStampString ?? ""
                    frameData.append(freeformTimeString.encoded(withNullTermination: false))
                case .v2_4 :
                    let timeStampString = formatter.string(from: timeStamp)
                    frameData.append(timeStampString.encoded(withNullTermination: false))
            }
        } else {
            let timeStampString = formatter.string(from: timeStamp)
            frameData.append(timeStampString.encoded(withNullTermination: false))
        }
        return frameData
    }
}

extension Tag {
    /// - (Release) Date frame getter-setter. Valid for versions 2.2 and 2.3 only.
    /// ID3 Identifier: `TDA`/`TDAT`
    public var date: (day: Int?, month: Int?)? {
        get {
            if let frame = self.frames[.date],
                case .dateFrame(let dateFrame) = frame {
                return (dateFrame.day, dateFrame.month)
            } else {
                return nil
            }
        }
        set {
            let date = Date(id3TimeStamp: (year: nil, month: newValue?.month, day: newValue?.day, hour: nil, minute: nil)) ?? Date()
            let frame = DateFrame(.known(.date), timeStamp: date)
            frames[.date] = .dateFrame(frame)
        }
    }
    
    /// - (Release) Time frame getter-setter. Valid for versions 2.2 and 2.3 only.
    /// ID3 Identifier: `TIM`/`TIME`
    public var time: (hour: Int?, minute: Int?)? {
        get {
            if let frame = self.frames[.date],
                case .dateFrame(let dateFrame) = frame {
                return (dateFrame.hour, dateFrame.minute)
            } else {
                return nil
            }
        }
        set {
            let date = Date(id3TimeStamp: (year: nil, month: nil, day: nil, hour: newValue?.hour, minute: newValue?.minute)) ?? Date()
            let frame = DateFrame(.known(.date), timeStamp: date)
            frames[.date] = .dateFrame(frame)
        }
    }
    
    /// - (Release) Year frame getter-setter. Valid for versions 2.2 and 2.3 only.
    /// ID3 Identifier: `TYE`/`TYER`
    public var year: Int? {
        get {
            if let frame = self.frames[.date],
                case .dateFrame(let dateFrame) = frame {
                return dateFrame.year
            } else {
                return nil
            }
        }
        set {
            let date = Date(id3TimeStamp: (year: newValue, month: nil, day: nil, hour: nil, minute: nil)) ?? Date()
            let frame = DateFrame(.known(.date), timeStamp: date)
            frames[.date] = .dateFrame(frame)
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
                return (dateFrame.year,
                        dateFrame.month,
                        dateFrame.day,
                        dateFrame.hour,
                        dateFrame.minute)
            } else {
                return nil
            }
        }
        set {
            let frame = DateFrame(.known(.releaseTime),
                                  timeStamp: Date(
                                    id3TimeStamp: (
                                        newValue?.year,
                                        newValue?.month,
                                        newValue?.day,
                                        newValue?.hour,
                                        newValue?.minute)) ?? Date())
            frames[.releaseTime] = .dateFrame(frame)
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
                return (dateFrame.year,
                        dateFrame.month,
                        dateFrame.day,
                        dateFrame.hour,
                        dateFrame.minute)
            } else {
                return nil
            }
        }
        set {
            let frame = DateFrame(.known(.encodingTime),
                                  timeStamp: Date(
                                    id3TimeStamp: (
                                        newValue?.year,
                                        newValue?.month,
                                        newValue?.day,
                                        newValue?.hour,
                                        newValue?.minute)) ?? Date())
            frames[.encodingTime] = .dateFrame(frame)
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
                return (dateFrame.year,
                        dateFrame.month,
                        dateFrame.day,
                        dateFrame.hour,
                        dateFrame.minute)
            } else {
                return nil
            }
        }
        set {
            let frame = DateFrame(.known(.originalReleaseTime),
                                  timeStamp: Date(
                                    id3TimeStamp: (
                                        newValue?.year,
                                        newValue?.month,
                                        newValue?.day,
                                        newValue?.hour,
                                        newValue?.minute)) ?? Date())
            frames[.originalReleaseTime] = .dateFrame(frame)
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
                return (dateFrame.year,
                        dateFrame.month,
                        dateFrame.day,
                        dateFrame.hour,
                        dateFrame.minute)
            } else {
                return nil
            }
        }
        set {
            let frame = DateFrame(.known(.recordingDate),
                                  timeStamp: Date(
                                    id3TimeStamp: (
                                        newValue?.year,
                                        newValue?.month,
                                        newValue?.day,
                                        newValue?.hour,
                                        newValue?.minute)) ?? Date())
            frames[.recordingDate] = .dateFrame(frame)
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
                return (dateFrame.year,
                        dateFrame.month,
                        dateFrame.day,
                        dateFrame.hour,
                        dateFrame.minute)
            } else {
                return nil
            }
        }
        set {
            let frame = DateFrame(.known(.taggingTime),
                                  timeStamp: Date(
                                    id3TimeStamp: (
                                        newValue?.year,
                                        newValue?.month,
                                        newValue?.day,
                                        newValue?.hour,
                                        newValue?.minute)) ?? Date())
            frames[.taggingTime] = .dateFrame(frame)
        }
    }
}
