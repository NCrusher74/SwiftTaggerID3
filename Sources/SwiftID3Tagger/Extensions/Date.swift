//
//  File.swift
//  
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
        
        do {
            if let day = components.day {
                if let month = components.month {
                    let dateString = try String(day).leadingZeros(2) + String(month).leadingZeros(2)
                    encodedString = dateString.encodedISOLatin1
                } else {
                    encodedString = Data()
                }
            } else {
                encodedString = Data()
            }
            return encodedString
        } catch {
            fatalError("Failed to convert date to string or string to data")
        }
    }
    
    var encodeHHMMTimestamp: Data {
        let calendar = Calendar(identifier: .iso8601)
        let timeZone = TimeZone(secondsFromGMT: 0) ?? .current
        let components = calendar.dateComponents(in: timeZone, from: self)
        var encodedString = Data()
        
        do {
            if let hour = components.hour {
                if let minute = components.minute {
                    let dateString = try String(hour).leadingZeros(2) + String(minute).leadingZeros(2)
                    encodedString = dateString.encodedISOLatin1
                } else {
                    encodedString = Data()
                }
            } else {
                encodedString = Data()
            }
            return encodedString
        } catch {
            fatalError("Failed to convert date to string or string to data")
        }
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
