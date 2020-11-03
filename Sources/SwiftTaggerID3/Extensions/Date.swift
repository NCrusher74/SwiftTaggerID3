//
//  Date.swift
//  SwiftTaggerID3
//
//  Created by Nolaine Crusher on 9/17/20.
//

import Foundation

extension Date {
    var encodeDDMMTimestamp: Data {
        let calendar = Calendar(identifier: .iso8601)
        let timeZone = TimeZone(secondsFromGMT: 0) ?? .current
        let components = calendar.dateComponents(in: timeZone, from: self)
        var encodedString = Data()

        if let day = components.day {
            if let month = components.month {
                let dateString = String(day).leadingZeros(2) + String(month).leadingZeros(2)
                encodedString = dateString.encodedISOLatin1
            } else {
                encodedString = Data()
            }
        } else {
            encodedString = Data()
        }
        return encodedString
    }

    var encodeHHMMTimestamp: Data {
        let calendar = Calendar(identifier: .iso8601)
        let timeZone = TimeZone(secondsFromGMT: 0) ?? .current
        let components = calendar.dateComponents(in: timeZone, from: self)
        var encodedString = Data()
        
        if let hour = components.hour {
            if let minute = components.minute {
                let dateString = String(hour).leadingZeros(2) + String(minute).leadingZeros(2)
                encodedString = dateString.encodedISOLatin1
            } else {
                encodedString = Data()
            }
        } else {
            encodedString = Data()
        }
        return encodedString
    }

    var encodeYYYYTimestamp: Data {
        let calendar = Calendar(identifier: .iso8601)
        let timeZone = TimeZone(secondsFromGMT: 0) ?? .current
        let components = calendar.dateComponents(in: timeZone, from: self)
        var encodedString = Data()
        
        if let year = components.year {
            let dateString = String(year)
            encodedString = dateString.encodedISOLatin1
        } else {
            encodedString = Data()
        }
        return encodedString
    }
    
}
