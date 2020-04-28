//
//  Date.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/27/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

extension Date {
    
    internal init?(id3TimeStamp: (year: Int?, month: Int?, day: Int?, hour: Int?, minute: Int?)) {
        if let date = DateComponents(
            calendar: Calendar(identifier: .gregorian),
            timeZone: TimeZone(secondsFromGMT: 0),
            year: id3TimeStamp.year, month: id3TimeStamp.month, day: id3TimeStamp.day, hour: id3TimeStamp.hour, minute: id3TimeStamp.minute
        ).date {
            self = date
        } else {
            return nil
        }
    }
    
    internal var id3TimeStamp: (year: Int, month: Int, day: Int, hour: Int, minute: Int) {
        let components = Calendar(identifier: .gregorian)
            .dateComponents(
                in: TimeZone(secondsFromGMT: 0)!,
                from: self)
        return (year: components.year!, month: components.month!, day: components.day!, components.hour!, components.minute!)
    }
}