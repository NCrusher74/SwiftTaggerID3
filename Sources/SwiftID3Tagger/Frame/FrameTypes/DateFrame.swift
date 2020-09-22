//
//  File.swift
//  
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
class DateFrame: Frame {
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
    @available(OSX 10.12, *)
    init(identifier: FrameIdentifier,
         version: Version,
         size: Int,
         flags: Data,
         payload: Data
    ) throws {
        var data = payload
        let encoding = try data.extractEncoding()
        let dateString = try data.extractAndDecodeString(encoding: encoding)
        
        // assumes frame contents are spec-compliant, 4-characters, DDMM string
        if identifier == .known(.date) {
            // assumes frame contents are spec-compliant, 4-characters, HHmm string
            self.timeStamp = try dateString.dateFromDDMMString()
        } else if identifier == .known(.time) {
            self.timeStamp = try dateString.timefromHHMMString()
        } else if identifier == .known(.year) ||
                    // versions 2.2 and 2.3 should only have a year for this frame
                    (identifier == .known(.originalReleaseTime) &&
                        (version == .v2_2 || version == .v2_3)) {
            self.timeStamp = try dateString.yearFromYYYYString()
        } else {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime]
            formatter.timeZone = TimeZone(secondsFromGMT: 0) ?? .current
            self.timeStamp = formatter.date(from: dateString)
        }
        
        super.init(identifier: identifier,
                   version: version,
                   size: size,
                   flags: flags)
    }
    
    /// encode contents of the frame to add to an ID3 tag
    /// - Returns: the frame contents as data
    @available(OSX 10.12, *)
    override var contentData: Data {
        var data = Data()
        // append encoding byte
        let encoding = String.Encoding.isoLatin1
        data.append(encoding.encodingByte)
        
        if let date = timeStamp {
            var encodedString = Data()
            if self.identifier == .known(.date) {
                encodedString = date.encodeDDMMTimestamp
            } else if self.identifier == .known(.time) {
                encodedString = date.encodeHHMMTimestamp
            } else if self.identifier == .known(.year) ||
                        (self.identifier == .known(.originalReleaseTime) &&
                            (self.version == .v2_2 || self.version == .v2_3)) {
                encodedString = date.encodeYYYYTimestamp
            } else {
                let formatter = ISO8601DateFormatter()
                formatter.formatOptions = [.withInternetDateTime]
                formatter.timeZone = TimeZone(secondsFromGMT: 0) ?? .current
                let dateString = formatter.string(from: date)
                encodedString = dateString.encodedISOLatin1
            }
            data.append(encodedString)
        }
        if data != encoding.encodingByte {
            return data
        } else {
            return Data()
        }
    }
    
    // // MARK: - Frame Building
    /// Initialize a date frame for writing to file
    /// - Parameters:
    ///   - layout: the frame layout
    ///   - timeStamp: the date/time being encoded into the frame
    @available(OSX 10.12, *)
    init(_ identifier: FrameIdentifier,
         version: Version,
         timeStamp: Date) {
        self.timeStamp = timeStamp
        let flags = version.defaultFlags
        
        var size = 1 // +1 for encoding byte
        if identifier == .known(.date) {
            size += timeStamp.encodeDDMMTimestamp.count
        } else if identifier == .known(.time) {
            size += timeStamp.encodeHHMMTimestamp.count
        } else if identifier == .known(.year) ||
                    (identifier == .known(.originalReleaseTime) &&
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
extension Tag {
    @available(OSX 10.12, *)
    public var releaseDateTime: Date? {
        get {
            let identifier = FrameIdentifier.known(.releaseTime)
            switch self.version {
                case .v2_2, .v2_3:
                    return compiledDate
                case .v2_4:
                    return get(dateFrame: identifier)
            }
        }
        set {
            
        }
    }
    
    
    
    
    
    private func get(dateFrame identifier: FrameIdentifier) -> Date? {
        if let frame = self.frames[identifier.frameKey(nil)] as? DateFrame {
            let date = frame.timeStamp ?? Date.distantPast
            return date
        } else {
            return nil
        }
    }
    
    @available(OSX 10.12, *)
    private mutating func set(dateFrame identifier: FrameIdentifier,
                              timeStamp: Date) {
        let frame = DateFrame(identifier,
                              version: self.version,
                              timeStamp: timeStamp)
        self.frames[identifier.frameKey(nil)] = frame
    }
    
    /// Gathers the dates from the separate date frames used in version 2.2/2.3 and returns a single date value
    @available(OSX 10.12, *)
    private var compiledDate: Date? {
        let calendar = Calendar(identifier: .iso8601)
        let timeZone = TimeZone(secondsFromGMT: 0) ?? .current
        let year: Int?
        let month: Int?
        let day: Int?
        let hour: Int?
        let minute: Int?
        
        if let yearFrame = get(dateFrame: .known(.year)) {
            let yearComps = calendar.dateComponents(in: timeZone, from: yearFrame)
            year = yearComps.year
        } else {
            year = nil
        }
        
        if let dateFrame = get(dateFrame: .known(.date)) {
            let dateComps = calendar.dateComponents(in: timeZone, from: dateFrame)
            month = dateComps.month
            day = dateComps.day
        } else {
            month = nil
            day = nil
        }
        
        if let timeFrame = get(dateFrame: .known(.time)) {
            let timeComps = calendar.dateComponents(in: timeZone, from: timeFrame)
            hour = timeComps.hour
            minute = timeComps.minute
        } else {
            hour = nil
            minute = nil
        }
        
        let components = DateComponents(calendar: calendar, timeZone: timeZone, year: year, month: month, day: day, hour: hour, minute: minute)
        let date = calendar.date(from: components)
        return date
    }
}
