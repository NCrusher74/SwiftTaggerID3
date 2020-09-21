/*

 SwiftTaggerID3_DateFrame_Tests.swift
 SwiftTaggerID3

 Copyright ©2020 Nolaine Crusher. All rights reserved.

 */

import XCTest
import SwiftTaggerID3
@testable import SwiftTaggerID3

let calendar = Calendar(identifier: .iso8601)
let timeZone = TimeZone(secondsFromGMT: 0) ?? .current
let formatter: ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = .withInternetDateTime
    formatter.timeZone = timeZone
    return formatter
}()

// Known value of dates for files
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


class SwiftTaggerID3_DateFrame_Tests: XCTestCase {
    func testDatesV24() throws {
        XCTAssertEqual(tagV24.releaseDateTime, v24ReleaseDate)
    }
    
}
