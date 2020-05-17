//
//  Date.swift
//  SwiftTaggerID3
//
//  Created by Nolaine Crusher on 4/27/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

extension Date {
    
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
