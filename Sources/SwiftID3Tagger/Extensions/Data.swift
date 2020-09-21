//
//  File.swift
//  
//
//  Created by Nolaine Crusher on 9/17/20.
//

import Foundation
extension Data {
    mutating func extractEncoding() throws -> String.Encoding {
        let encodingData = self.extractFirst(1)
        return try String.Encoding(byte: encodingData)
    }
    
    /// Interpret the most common "quasi-boolean" strings as boolean values
    /// - Parameter encoding: The `String.Encoding` type parsed out of the frame content previously
    /// - Returns: 1 or 0, if a value can be determined
    mutating func extractAndDecodeStringFromBoolean(encoding: String.Encoding) throws -> String {
        if let string = self.extractNullTerminatedString(encoding) {
            switch string.lowercased() {
                case "true", "t", "yes", "y", "1":
                    return "1"
                case "false", "f", "no", "n", "0":
                    return "0"
                default:
                    return "0"
            }
        } else {
            return ""
        }
    }
    
    mutating func extractAndDecodeString(encoding: String.Encoding) throws -> String {
        if let string = self.extractNullTerminatedString(encoding) {
            return string
        } else {
            return ""
        }
    }
    
    mutating func extractAndDecodeCreditString(encoding: String.Encoding) throws -> [String: [String]] {
        var strings = [String]()
        while !self.isEmpty {
            if let next = self.extractNullTerminatedString(encoding) {
                strings.append(next)
            }
        }
        var pairsDictionary = [ String: [String] ]()
        let rolePersonPairs = strings.pairs()
        for pair in rolePersonPairs {
            let personArray = pair.1?.components(separatedBy: ",")
            pairsDictionary[pair.0] = personArray
        }
        return pairsDictionary
    }
    
    /// Extracts and decodes description and content strings for frame types that use them.
    /// - Parameters:
    ///   - frameData: The frame's data beginning at the description string
    ///   - encoding: The `String.Encoding` type parsed out of the frame content previously
    /// - Returns: The frame's description and content strings
    /// this is used for ID3 frames with a terminated description string followed by a content string
    mutating func extractDescriptionAndContent(encoding: String.Encoding) -> (description: String?, content: String) {
        let description = self.extractNullTerminatedString(encoding)
        let content = self.extractNullTerminatedString(encoding) ?? ""
        return (description: description, content: content)
    }
    
    mutating func extractAndDecodeDDMM(_ encoding: String.Encoding) throws -> Date? {
        guard self.count >= 4 else {
            throw FrameError.InvalidDateData("Data does not have enough bytes for conversion")
        }
        let calendar = Calendar(identifier: .iso8601)
        let timeZone = TimeZone(secondsFromGMT: 0) ?? .current
        
        let day: Int
        let month: Int

        let dayBytes = self.extractFirst(2)
        let monthBytes = self.extractFirst(2)
        
        if let dayString = String(data: dayBytes, encoding: encoding) {
            if let int = Int(dayString) {
                day = int
            } else {
                throw FrameError.InvalidDateData("Data for 'day' value cannot be converted from string to integer")
            }
        } else {
            throw FrameError.InvalidDateData("Data for 'day' value cannot be converted from data to string")
        }

        if let monthString = String(data: monthBytes, encoding: encoding) {
            if let int = Int(monthString) {
                month = int
            } else {
                throw FrameError.InvalidDateData("Data for 'month' value cannot be converted from string to integer")
            }
        } else {
            throw FrameError.InvalidDateData("Data for 'month' value cannot be converted from data to string")
        }

        let dateComponents = DateComponents(calendar: calendar,
                                            timeZone: timeZone,
                                            month: month,
                                            day: day)
        return dateComponents.date
    }
    
    mutating func extractAndDecodeHHMM(_ encoding: String.Encoding) throws -> Date? {
        guard self.count >= 4 else {
            throw FrameError.InvalidDateData("Data does not have enough bytes for conversion")
        }
        let calendar = Calendar(identifier: .iso8601)
        let timeZone = TimeZone(secondsFromGMT: 0) ?? .current
        
        let hour: Int
        let minute: Int
        
        let hourBytes = self.extractFirst(2)
        let minuteBytes = self.extractFirst(2)
        
        if let hourString = String(data: hourBytes, encoding: encoding) {
            if let int = Int(hourString) {
                hour = int
            } else {
                throw FrameError.InvalidDateData("Data for 'hour' value cannot be converted from string to integer")
            }
        } else {
            throw FrameError.InvalidDateData("Data for 'hour' value cannot be converted from data to string")
        }
        
        if let minuteString = String(data: minuteBytes, encoding: encoding) {
            if let int = Int(minuteString) {
                minute = int
            } else {
                throw FrameError.InvalidDateData("Data for 'minute' value cannot be converted from string to integer")
            }
        } else {
            throw FrameError.InvalidDateData("Data for 'minute' value cannot be converted from data to string")
        }
        
        let dateComponents = DateComponents(calendar: calendar,
                                            timeZone: timeZone,
                                            hour: hour,
                                            minute: minute)
        return dateComponents.date
    }

    mutating func extractAndDecodeYYYY(_ encoding: String.Encoding) throws -> Date? {
        guard self.count == 4 else {
            throw FrameError.InvalidDateData("Data does not have enough bytes for conversion")
        }
        let calendar = Calendar(identifier: .iso8601)
        let timeZone = TimeZone(secondsFromGMT: 0) ?? .current
        
        let year: Int
        
        if let yearString = String(data: self, encoding: encoding) {
            if let int = Int(yearString) {
                year = int
            } else {
                throw FrameError.InvalidDateData("Data for 'year' value cannot be converted from string to integer")
            }
        } else {
            throw FrameError.InvalidDateData("Data for 'year' value cannot be converted from data to string")
        }
        
        let dateComponents = DateComponents(calendar: calendar,
                                            timeZone: timeZone,
                                            year: year)
        return dateComponents.date
    }

}
