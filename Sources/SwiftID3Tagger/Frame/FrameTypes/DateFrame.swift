//
//  File.swift
//  
//
//  Created by Nolaine Crusher on 9/17/20.
//

import Foundation


/// A type used to represent an ID3-formatted timestamp tag. The information delivered from this type will vary depending on the tag version and formatting.
class DateFrame: Frame {
    // MARK: Frame parsing
    // needs to be in ISO-8601 format
    var timeStamp: Date?
    var version: Version
    
    // subset of ISO 8601; valid timestamps are yyyy, yyyy-MM, yyyy-MM-dd, yyyy-MM-ddTHH, yyyy-MM-ddTHH:mm and yyyy-MM-ddTHH:mm:ss.
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
        self.version = version
        var data = payload
        let dateString = try data.extractAndDecodeString()
        
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
                   size: size,
                   flags: flags)
    }
    
    override func frameKey(version: Version) throws -> String {
        return try self.identifier.frameKey(additionalID: nil)
    }
    
    /// encode contents of the frame to add to an ID3 tag
    /// - fatalError: `DateFrameNotAvailableForVersion` if the frame has been deprecated in a later version or doesn't exist for an earlier version
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
        
        var encodedString = Data()
        if identifier == .known(.date) {
            encodedString = timeStamp.encodeDDMMTimestamp
        } else if identifier == .known(.time) {
            encodedString = timeStamp.encodeHHMMTimestamp
        } else if identifier == .known(.year) ||
                    (identifier == .known(.originalReleaseTime) &&
                        (self.version == .v2_2 || self.version == .v2_3)) {
            encodedString = timeStamp.encodeYYYYTimestamp
        } else {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime]
            formatter.timeZone = TimeZone(secondsFromGMT: 0) ?? .current
            let dateString = formatter.string(from: timeStamp)
            encodedString = dateString.encodedISOLatin1
        }
        let size = encodedString.count + 1
        super.init(identifier: identifier,
                   size: size,
                   flags: flags)
    }

}
