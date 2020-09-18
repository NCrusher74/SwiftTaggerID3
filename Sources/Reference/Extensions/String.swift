/*

 String.swift
 SwiftTaggerID3

 Copyright ©2020 Nolaine Crusher. All rights reserved.

 */

import Foundation

extension String {
    
    init<S>(ascii: S) throws where S: Sequence, S.Element == UInt8 {
        let scalars = String.UnicodeScalarView(ascii.lazy.map({ Unicode.Scalar($0) }))
        self = String(scalars)
    }
    
    func nullTerminatedData(encoding: String.Encoding) -> Data {
        guard var result = data(using: encoding) else {
            // This will never happen unless “preferred” is changed to something besides Unicode.
            fatalError("\(encoding) cannot encode “\(self)”.")
        }
        result.append(encoding.nullTerminator)
        return result
    }

    init(withInt int: Int, leadingZeros: Int = 2) {
        self.init(format: "%0\(leadingZeros)d", int)
    }
    
    func components(withLength length: Int) -> [String] {
        return stride(from: 0, to: self.count, by: length).map {
            let start = self.index(self.startIndex, offsetBy: $0)
            let end = self.index(start, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            return String(self[start..<end])
        }
    }
    
    func dateFromDDMMString() throws -> Date? {
        let calendar = Calendar(identifier: .iso8601)
        let timeZone = TimeZone(secondsFromGMT: 0) ?? .current

        // split the four-character string into an array of 2-character strings
        let dayMonthArray = self.components(withLength: 2)
        // make sure the array has at least two elements so we don't go out of bounds
        guard dayMonthArray.count >= 2 else {
            throw FrameError.InvalidDateString
        }
        // If parsed dateString is not spec-compliant, there may be more than two elements. We'll use the first two, rather than .first and .last because those should be day and month. If they're not, we'll probably get nil when we try to make a date out of them.
        // The first array element is the day, make the string an Int
        let day = Int(dayMonthArray[0])
        // second element is the month, make it an Int
        let month = Int(dayMonthArray[1])
        // use day and month as components for a date
        let dateComponents = DateComponents(calendar: calendar,
                                            timeZone: timeZone,
                                            month: month,
                                            day: day)
        return dateComponents.date
    }
    
    func timefromHHMMString() throws -> Date? {
        let calendar = Calendar(identifier: .iso8601)
        let timeZone = TimeZone(secondsFromGMT: 0) ?? .current

        // split the four-character string into an array of 2-character strings
        let hourMinuteArray = self.components(withLength: 2)
        // make sure the array has at least two elements so we don't go out of bounds
        guard hourMinuteArray.count >= 2 else {
            throw FrameError.InvalidDateString
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
        return dateComponents.date
    }
    
    func yearFromYYYYString() throws -> Date? {
        let calendar = Calendar(identifier: .iso8601)
        let timeZone = TimeZone(secondsFromGMT: 0) ?? .current
        // make the string into an Int
        let year = Int(self)
        // use it as a component
        let dateComponents = DateComponents(calendar: calendar,
                                            timeZone: timeZone,
                                            year: year)
        return dateComponents.date
    }
}
