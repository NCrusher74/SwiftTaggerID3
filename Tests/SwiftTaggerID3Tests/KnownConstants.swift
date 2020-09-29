//
//  File.swift
//  
//
//  Created by Nolaine Crusher on 9/21/20.
//

import Foundation
// KNOWN value of dates for files
// MARK: - Credits List Frames
let sopranoCredit = ["Soprano Name"]
let altoCredit = ["Alto Name"]
let actorCredit = ["Actor Name"]
let actressCredit = ["Actress Name"]

// MARK: = Date Frames
let calendar = Calendar(identifier: .iso8601)
let timeZone = TimeZone(secondsFromGMT: 0) ?? .current
let formatter: ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = .withInternetDateTime
    formatter.timeZone = timeZone
    return formatter
}()

let newDate: Date = {
    guard let date = formatter.date(from: "2012-11-19T12:47:00Z") else {
        fatalError()
    }
    return date
}()

let newDateYearOnly: Date = {
    guard let date = formatter.date(from: "2012-01-01T00:00:00Z") else {
        fatalError()
    }
    return date
}()

let v22Date: Date = {
    guard let date = formatter.date(from: "0001-02-03T00:00:00Z") else {
        fatalError()
    }
    return date
}()
let v22DateComponents: DateComponents = {
    let components = calendar.dateComponents(in: timeZone, from: v22Date)
    return components
}()
let v22Time: Date = {
    guard let date = formatter.date(from: "0001-01-01T11:11:00Z") else {
        fatalError()
    }
    return date
}()
let v22TimeComponents: DateComponents = {
    let components = calendar.dateComponents(in: timeZone, from: v22Time)
    return components
}()
let v22Year: Date = {
    guard let date = formatter.date(from: "2015-01-01T00:00:00Z") else {
        fatalError()
    }
    return date
}()
let v22YearComponents: DateComponents = {
    let components = calendar.dateComponents(in: timeZone, from: v22Year)
    return components
}()

let v23Date: Date = {
    guard let date = formatter.date(from: "0001-02-03T00:00:00Z") else {
        fatalError()
    }
    return date
}()
let v23DateComponents: DateComponents = {
    let components = calendar.dateComponents(in: timeZone, from: v23Date)
    return components
}()
let v23Time: Date = {
    guard let date = formatter.date(from: "0001-01-01T11:11:00Z") else {
        fatalError()
    }
    return date
}()
let v23TimeComponents: DateComponents = {
    let components = calendar.dateComponents(in: timeZone, from: v23Time)
    return components
}()
let v23Year: Date = {
    guard let date = formatter.date(from: "2015-01-01T00:00:00Z") else {
        fatalError()
    }
    return date
}()
let v23YearComponents: DateComponents = {
    let components = calendar.dateComponents(in: timeZone, from: v23Year)
    return components
}()

let v24ReleaseDate: Date = {
    guard let date = formatter.date(from: "2015-02-03T11:11:00Z") else {
        fatalError()
    }
    return date
}()
let v24ReleaseDateComponents: DateComponents = {
    let components = calendar.dateComponents(in: timeZone, from: v24ReleaseDate)
    return components
}()

let v24EncodingDate: Date = {
    guard let date = formatter.date(from: "2016-04-05T00:00:00Z") else {
        fatalError()
    }
    return date
}()

let v24TaggingDate: Date = {
    guard let date = formatter.date(from: "2017-06-07T00:00:00Z") else {
        fatalError()
    }
    return date
}()

let v24RecordingDate: Date = {
    guard let date = formatter.date(from: "2018-10-11T00:00:00Z") else {
        fatalError()
    }
    return date
}()

let v24OriginalReleaseDate: Date = {
    guard let date = formatter.date(from: "2014-08-09T00:00:00Z") else {
        fatalError()
    }
    return date
}()
let v24OriginalReleaseDateComponents: DateComponents = {
    let components = calendar.dateComponents(in: timeZone, from: v24OriginalReleaseDate)
    return components
}()

let v23OriginalReleaseYear: Date = {
    guard let date = formatter.date(from: "2014-01-01T00:00:00Z") else {
        fatalError()
    }
    return date
}()

let testAllDate: Date = {
    guard let date = formatter.date(from: "2002-11-07T09:23:00Z") else {
        fatalError()
    }
    return date
}()
