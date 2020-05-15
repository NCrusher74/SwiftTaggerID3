//
//  Date.swift
//  SwiftTaggerID3
//
//  Created by Nolaine Crusher on 4/27/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

extension Date {

    internal init?(id3TimeStamp: (year: Int?, month: Int?, day: Int?, hour: Int?, minute: Int?)) {
        if let date = DateComponents(
            calendar: Calendar(identifier: .iso8601),
            timeZone: TimeZone(secondsFromGMT: 0),
            year: id3TimeStamp.year,
            month: id3TimeStamp.month,
            day: id3TimeStamp.day,
            hour: id3TimeStamp.hour,
            minute: id3TimeStamp.minute
        ).date {
            self = date
        } else {
            return nil
        }
    }
    
    internal var id3DayMonth: (month: Int?, day: Int?) {
        let components = Calendar(identifier: .iso8601)
            .dateComponents(
                in: TimeZone(secondsFromGMT: 0)!,
                from: self)
        return (month: components.month!,
                day: components.day!)
    }

    internal var id3HourMinute: (hour: Int?, minute: Int?) {
        let components = Calendar(identifier: .iso8601)
            .dateComponents(
                in: TimeZone(secondsFromGMT: 0)!,
                from: self)
        return (hour: components.hour!,
                minute: components.minute!)
    }

    internal var id3Year: Int? {
        let components = Calendar(identifier: .iso8601)
            .dateComponents(
                in: TimeZone(secondsFromGMT: 0)!,
                from: self)
        return components.year
    }

}

extension ISO8601DateFormatter {
    // This is the format used in the ID3 "Date" frame
    static let id3DayMonth: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMM"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    // This is the format used in the ID3 "Time" frame
    static let id3HourMinute: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HHmm"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    // This is the format used in the ID3 "Year" frame
    static let id3Year: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}

