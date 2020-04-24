//
//  Date.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/23/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

extension Date {
    
    internal init?(id3: (year: Int?, month: Int?, day: Int?)) {
        if let date = DateComponents(
            calendar: Calendar(identifier: .gregorian),
            timeZone: TimeZone(secondsFromGMT: 0),
            year: id3.year, month: id3.month, day: id3.day
        ).date {
            self = date
        } else {
            return nil
        }
    }
    
    internal var id3: (year: Int, month: Int, day: Int) {
        let components = Calendar(identifier: .gregorian)
            .dateComponents(
                in: TimeZone(secondsFromGMT: 0)!,
                from: self)
        return (year: components.year!, month: components.month!, day: components.day!)
    }
}
