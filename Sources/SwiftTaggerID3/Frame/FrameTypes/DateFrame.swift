//
//  DateFrame.swift
//  SwiftTaggerID3
//
//  Created by Nolaine Crusher on 9/17/20.
//

/*
 v2.2 and v2.3
 TYE
 The 'Year' frame is a numeric string with a year of the recording.
 This frames is always four characters long (until the year 10000).
 
 TDA
 The 'Date' frame is a numeric string in the DDMM format containing
 the date for the recording. This field is always four characters
 long.
 
 TIM
 The 'Time' frame is a numeric string in the HHMM format containing
 the time for the recording. This field is always four characters
 long.
 
 TRD
 The 'Recording dates' frame is a intended to be used as complement to
 the "TYE", "TDA" and "TIM" frames. E.g. "4th-7th June, 12th June" in
 combination with the "TYE" frame.

 TORY
 The 'Original release year' frame is intended for the year when the
 original recording, if for example the music in the file should be a
 cover of a previously released song, was released. The field is
 formatted as in the "TYER" frame.

 v2.4:
 TDEN
 The 'Encoding time' frame contains a timestamp describing when the
 audio was encoded. Timestamp format is described in the ID3v2
 structure document [ID3v2-strct].
 
 TDOR
 The 'Original release time' frame contains a timestamp describing
 when the original recording of the audio was released. Timestamp
 format is described in the ID3v2 structure document [ID3v2-strct].
 
 TDRC
 The 'Recording time' frame contains a timestamp describing when the
 audio was recorded. Timestamp format is described in the ID3v2
 structure document [ID3v2-strct].
 
 TDRL
 The 'Release time' frame contains a timestamp describing when the
 audio was first released. Timestamp format is described in the ID3v2
 structure document [ID3v2-strct].
 
 TDTG
 The 'Tagging time' frame contains a timestamp describing then the
 audio was tagged. Timestamp format is described in the ID3v2
 structure document [ID3v2-strct].
 
 The timestamp fields are based on a subset of ISO 8601. When being as
 precise as possible the format of a time string is
 yyyy-MM-ddTHH:mm:ss (year, "-", month, "-", day, "T", hour (out of
 24), ":", minutes, ":", seconds), but the precision may be reduced by
 removing as many time indicators as wanted. Hence valid timestamps
 are yyyy, yyyy-MM, yyyy-MM-dd, yyyy-MM-ddTHH, yyyy-MM-ddTHH:mm and
 yyyy-MM-ddTHH:mm:ss. All time stamps are UTC. For durations, use
 the slash character as described in 8601, and for multiple non-
 contiguous dates, use multiple strings, if allowed by the frame
 definition.
 */
import Foundation
/// A type used to represent an ID3-formatted timestamp tag. The information delivered from this type will vary depending on the tag version and formatting.

@available(OSX 10.12, iOS 12.0, *)
class DateFrame: Frame {
    override var description: String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        formatter.timeZone = TimeZone(secondsFromGMT: 0) ?? .current
        if let date = self.timeStamp {
            let string = formatter.string(from: date)
            return "\(self.identifier.rawValue): \(string)"
        } else {
            return "\(self.identifier.rawValue): Invalid Date from data \(self.contentData)"
        }
    }

    // MARK: Frame parsing
    // needs to be in ISO-8601 format
    var timeStamp: Date?

    /// Decode the contents of a date frame being read from a file
    /// - Parameters:
    ///   - contents: the frame `Data` being decoded
    ///   - version: the ID3 version of the tag being read
    ///   - layout: the layout identifier of the frame
    ///   - flags: the frame flags
    /// - Throws: `InvalidDateString` if the string SwiftTagger is attempting to parse is not spec-compliant and thus a valid date cannot be derived
    
    init(identifier: FrameIdentifier,
         version: Version,
         size: Int,
         flags: Data,
         payload: Data
    ) throws {
        var data = payload
        let encoding = try data.extractEncoding()
        let dateString = data.decodeString(encoding)
        
        // assumes frame contents are spec-compliant, 4-characters, DDMM string
        if identifier == .date {
            // assumes frame contents are spec-compliant, 4-characters, HHmm string
            self.timeStamp = try dateString.dateFromDDMMString()
        } else if identifier == .time {
            self.timeStamp = try dateString.timefromHHMMString()
        } else if identifier == .year ||
                    // versions 2.2 and 2.3 should only have a year for this frame
                    (identifier == .originalReleaseDateTime &&
                        (version == .v2_2 || version == .v2_3)) {
            self.timeStamp = try dateString.yearFromYYYYString()
        } else {
            let date = dateString.attemptDateFromString()
            self.timeStamp = date
        }
        
        super.init(identifier: identifier,
                   version: version,
                   size: size,
                   flags: flags)
    }
    
    // ["yyyy-MM-ddTHH:mm", "yyyy-MM-ddTHH", "yyyy-MM-dd", "MM-dd-yyyy", "yyyy-MM", "yyyy"]
    
    /// encode contents of the frame to add to an ID3 tag
    /// - fatalError: `DateFrameNotAvailableForVersion` if the frame has been deprecated in a later version or doesn't exist for an earlier version
    /// - Returns: the frame contents as data
    
    override var contentData: Data {
        var data = Data()
        // append encoding byte
        
        if let date = timeStamp {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime]
            formatter.timeZone = TimeZone(secondsFromGMT: 0) ?? .current
            let dateString = formatter.string(from: date)
            
            let encoding = String.Encoding(string: dateString)
            data.append(encoding.encodingByte)
            var encodedString = Data()
            
            switch self.version {
                case .v2_2, .v2_3:
                    switch self.identifier {
                        case .date: encodedString = date.encodeDDMMTimestamp
                        case .time: encodedString = date.encodeHHMMTimestamp
                        case .year, .originalReleaseDateTime:
                            encodedString = date.encodeYYYYTimestamp
                        default:
                            encodedString = dateString.attemptStringEncoding(encoding) ?? Data()
                    }
                case .v2_4:
                    switch self.identifier {
                        case .date, .time, .year:
                            encodedString = Data()
                        default:
                            encodedString = dateString.attemptStringEncoding(encoding) ?? Data()
                    }
            }
            data.append(encodedString)
        }
        return data
    }
    
    // MARK: - Frame Building
    /// Initialize a date frame for writing to file
    /// - Parameters:
    ///   - layout: the frame layout
    ///   - timeStamp: the date/time being encoded into the frame
    
    init(_ identifier: FrameIdentifier,
         version: Version,
         timeStamp: Date) {
        self.timeStamp = timeStamp

        let flags = version.defaultFlags
        
        var size = 1 // +1 for encoding byte
        if identifier == .date {
            size += timeStamp.encodeDDMMTimestamp.count
        } else if identifier == .time {
            size += timeStamp.encodeHHMMTimestamp.count
        } else if identifier == .year ||
                    (identifier == .originalReleaseDateTime &&
                        (version == .v2_2 || version == .v2_3)) {
            size += timeStamp.encodeYYYYTimestamp.count
        } else {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime]
            formatter.timeZone = TimeZone(secondsFromGMT: 0) ?? .current
            let dateString = formatter.string(from: timeStamp)
            size += dateString.encodedISOLatin1.count
        }
        super.init(identifier: identifier,
                   version: version,
                   size: size,
                   flags: flags)
    }

}

// MARK: - Tag extension
// These are convenience getter-setter properties
@available(OSX 10.12, iOS 12.0, *)
extension Tag {
    private func get(dateFrame identifier: FrameIdentifier) -> Date? {
        if let frame = self.frames[identifier.frameKey] as? DateFrame {
            let date = frame.timeStamp
            guard date != Date.distantPast else {
                return nil
            }
            return date
        } else {
            return nil
        }
    }
    
    
    private mutating func set(dateFrame identifier: FrameIdentifier,
                               timeStamp: Date?) {
        if let timeStamp = timeStamp {
            let frame = DateFrame(identifier,
                                  version: self.version,
                                  timeStamp: timeStamp)
            self.frames[identifier.frameKey] = frame
        } else {
            self.frames[identifier.frameKey] = nil
        }
    }
    
    /// v2.4: releaseDate (`TDRL`) frame.
    /// v2.2, v2.3: date (`TDA/TDAT`) frame for DDMM values, time (`TIM/TIME`) frame for HHMM values, and year (`TYE/TYER`) frame for YYYY value
    
    public var releaseDateTime: Date? {
        get {
            switch self.version {
                case .v2_2, .v2_3:
                    let calendar = Calendar(identifier: .iso8601)
                    let timeZone = TimeZone(secondsFromGMT: 0) ?? .current
                    
                    let year: Int?
                    let month: Int?
                    let day: Int?
                    let hour: Int?
                    let minute: Int?
                    
                    if let yearFrameDate = get(dateFrame: .year) {
                        let yearFrameComps = calendar.dateComponents(in: timeZone, from: yearFrameDate)
                        year = yearFrameComps.year
                    } else {
                        year = nil
                    }
                    
                    if let dateFrameDate = get(dateFrame: .date) {
                        let dateFrameComps = calendar.dateComponents(
                            in: timeZone, from: dateFrameDate)
                        day = dateFrameComps.day
                        month = dateFrameComps.month
                    } else {
                        day = nil
                        month = nil
                    }
                    
                    if let timeFrameDate = get(dateFrame: .time) {
                        let timeFrameComps = calendar.dateComponents(
                            in: timeZone, from: timeFrameDate)
                        hour = timeFrameComps.hour
                        minute = timeFrameComps.minute
                    } else {
                        hour = nil
                        minute = nil
                    }
                    
                    let date = calendar.date(from: DateComponents(
                                                calendar: calendar,
                                                timeZone: timeZone,
                                                year: year,
                                                month: month,
                                                day: day,
                                                hour: hour,
                                                minute: minute))
                    
                    let formatter = ISO8601DateFormatter()
                    formatter.timeZone = timeZone
                    formatter.formatOptions = .withInternetDateTime
                    guard date != formatter.date(from: "0001-01-01T00:00:00Z") else {
                        return nil
                    }
                    return date
                case .v2_4:
                    return get(dateFrame: .releaseDateTime)
            }
        }
        set {
            if let new = newValue {
                switch self.version {
                    case .v2_2, .v2_3:
                        let dateID = FrameIdentifier.date
                        let timeID = FrameIdentifier.time
                        let yearID = FrameIdentifier.year
                        let releaseID = FrameIdentifier.releaseDateTime
                        set(dateFrame: dateID, timeStamp: new)
                        set(dateFrame: timeID, timeStamp: new)
                        set(dateFrame: yearID, timeStamp: new)
                        set(dateFrame: releaseID, timeStamp: new)
                    case .v2_4:
                        let frameID = FrameIdentifier.releaseDateTime
                        set(dateFrame: frameID, timeStamp: new)
                }
            } else {
                switch self.version {
                    case .v2_2, .v2_3:
                        let dateID = FrameIdentifier.date
                        let timeID = FrameIdentifier.time
                        let yearID = FrameIdentifier.year
                        
                        set(dateFrame: dateID, timeStamp: nil)
                        set(dateFrame: timeID, timeStamp: nil)
                        set(dateFrame: yearID, timeStamp: nil)
                    case .v2_4:
                        let frameID = FrameIdentifier.releaseDateTime
                        set(dateFrame: frameID, timeStamp: nil)
                }
            }
        }
    }
    
    /// Version 2.4 only. Identifier `TDEN`
    
    public var encodingDateTime: Date? {
        get {
            get(dateFrame: .encodingDateTime)
        }
        set {
            let identifier = FrameIdentifier.encodingDateTime
            let frameKey = identifier.frameKey
            if let new = newValue {
                set(dateFrame: identifier,
                    timeStamp: new)
            } else {
                self.frames[frameKey] = nil
            }
        }
    }
    
    /// Version 2.4 only. Identifier `TDTG`
    
    public var taggingDateTime: Date? {
        get {
            get(dateFrame: .taggingDateTime)
        }
        set {
            let identifier = FrameIdentifier.taggingDateTime
            let frameKey = identifier.frameKey
            if let new = newValue {
                set(dateFrame: identifier,
                    timeStamp: new)
            } else {
                self.frames[frameKey] = nil
            }
        }
    }
    
    /// Identifier `TRD`/`TRDA`/`TDRC`
    
    public var recordingDateTime: Date? {
        get {
            get(dateFrame: .recordingDateTime)
        }
        set {
            let identifier = FrameIdentifier.recordingDateTime
            let frameKey = identifier.frameKey
            if let new = newValue {
                set(dateFrame: identifier,
                    timeStamp: new)
            } else {
                self.frames[frameKey] = nil
            }
        }
    }
    
    /// Full date/time for version 2.4. Identifer`TDOR`
    /// Year only for version 2.2/2.3. Identifer `TOY`/`TORY`
    
    public var originalRelease: Date? {
        get {
            get(dateFrame: .originalReleaseDateTime)
        }
        set {
            let identifier = FrameIdentifier.originalReleaseDateTime
            let frameKey = identifier.frameKey
            if let new = newValue {
                set(dateFrame: identifier,
                    timeStamp: new)
            } else {
                self.frames[frameKey] = nil
            }
        }
    }
}
