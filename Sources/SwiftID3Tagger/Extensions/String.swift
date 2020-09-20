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
    
    /// Convert a string to data and append a null termination byte (or pair of null bytes)
    func encodeNullTerminatedString(_ encoding: String.Encoding) -> Data {
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
    
    /// Convert 4-character numeric string representing a day/month value to a ISO-8601 compliant date
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
    
    /// Convert 4-character numeric string representing a hour/minute value to a ISO-8601 compliant date
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
    
    /// Convert 4-character numeric string representing a year value to a ISO-8601 compliant date
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
    
    /// parse the parentheses out of version 2.2 and 2.3 strings (Genre and MediaType frames)
    /// for PresetOptionsFrame
    func parseParentheticalString() -> [String] {
        // separate the components into an array using the open paren as a separator
        // this will remove the open parens from parenthetical comments as well as the codes
        // so we'll have to replace those when we spot a double-paren that denotes a parenthetical freeform comment
        var stringComponents = self.components(separatedBy: "(")
        // take it one component at a time
        for (index, value) in stringComponents.enumerated() {
            // for any component except the first one, if it's empty, it means we removed a double-paren
            if index != 0 && value == "" {
                // find the previous and next components and make a range of them
                let previous = stringComponents.index(before: index)
                let next = stringComponents.index(after: index)
                let rangeToReplace = previous...next
                // replace the open paren because it's a double-paren situation
                stringComponents[next].insert("(", at: stringComponents[next].startIndex)
                // join the previous and next components
                let componentsToJoin = [stringComponents[previous], stringComponents[next]]
                let joinedComponents = [componentsToJoin.joined()]
                // replace the separate components with the joined components
                stringComponents.replaceSubrange(rangeToReplace, with: joinedComponents)
                // remove all the empty components
                stringComponents.removeAll(where: {$0 == ""})
            }
        }
        var refinedComponents: [String] = []
        for component in stringComponents {
            if !component.contains(")") {
                refinedComponents.append(component)
                // find the close parens and parse them out
            } else if component.contains(")") {
                var separatedComponents = component.components(separatedBy: ")")
                // remove the empty elements
                separatedComponents.removeAll(where: {$0 == ""})
                // find the elements where there is an unterminated open paren now
                for (index, value) in separatedComponents.enumerated() {
                    if value.contains("(") {
                        // append a close paren to the string containing the open paren
                        var valueToChange = value
                        valueToChange.append(")")
                        // replace the string containing the unterminated open paren with the new string
                        separatedComponents.remove(at: index)
                        separatedComponents.insert(valueToChange, at: index)
                    }
                }
                // append the fixed components to the array
                refinedComponents.append(contentsOf: separatedComponents)
            }
        }
        // return the array
        return refinedComponents
    }

}
