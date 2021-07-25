//
//  File.swift
//  
//
//  Created by Crystal Wooley on 7/23/21.
//

import Foundation
import SwiftLanguageAndLocaleCodes

extension Tag {
    /// Import metadata from a .csv or .json file
    @available(macOS 10.12, *)
    mutating func importMetadata(location: URL) throws {
        guard let format = MetadataExportFormat(rawValue: location.pathExtension.lowercased()) else {
            print("Cannot import metadata; invalid format")
            return
        }
        
        if format == .json {
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode([String: String].self, from: try Data(contentsOf: location))
            try parseStringDictionary(jsonData)
        } else if format == .csv {
            let stringInput = try String(contentsOf: location)
            try importFromCSV(string: stringInput)
        } else {
            let stringInput = try String(contentsOf: location)
            try importFromText(string: stringInput)
        }
    }
    
    @available(macOS 10.12, *)
    private mutating func importFromText(string: String) throws {
        var lines = string.components(separatedBy: .newlines)
        lines = lines.filter({$0.hasPrefix("{")})
        
        var stringDictionary = [String: String]()
        while !lines.isEmpty {
            let line = lines.extractFirst()
            var components = line.components(separatedBy: ": ")
            guard components.count >= 2 else {
                continue
            }
            
            let keyString = components.extractFirst()
                .trimmingCharacters(in: .whitespacesAndNewlines)
            
            let valueString: String
            if components.count > 1 {
                valueString = components.joined(separator: ": ")
            } else {
                valueString = components.extractFirst()
            }
            
            stringDictionary[keyString] = valueString
        }
        try parseStringDictionary(stringDictionary)
    }
    
    @available(macOS 10.12, *)
    private mutating func importFromCSV(string: String) throws {
        let lines = string.components(separatedBy: .newlines)
        guard lines.count == 2 else {
            throw ImporterError.CSVIsEmptyOrCorrupt
        }
        
        let keyLine = lines.first!
        let valueLine = lines.last!
        
        var keys = keyLine.components(separatedBy: ",")
        let valuesRaw = valueLine.components(separatedBy: ",")
        var values = substituteCharactersOnImport(raw: valuesRaw)
        
        guard keys.count == values.count else {
            throw ImporterError.CSVDataIsCorrupted
        }
        
        var stringDictionary = [String: String]()
        while !keys.isEmpty {
            let idString = keys.extractFirst()
            var value = values.extractFirst()
            
            if idString == "TKW"
                || idString == "TKWD" {
                value = value.replacingOccurrences(of: "", with: ";")
            }
            
            stringDictionary[idString] = value
        }
        
        try parseStringDictionary(stringDictionary)
    }
    
    private func substituteCharactersOnImport(raw: [String]) -> [String] {
        return raw.map({$0
            .replacingOccurrences(of: ";", with: ",")
            .replacingOccurrences(of: "\\", with: "\n")
            .replacingOccurrences(of: "(P)", with: "\u{2117}")
            .replacingOccurrences(of: "(c)", with: "\u{00A9}")
        })
    }
    
    @available(macOS 10.12, *)
    private mutating func parseStringDictionary(_ data: [String: String]) throws {
        for (key, value) in data {
            let valueString = value
                .trimmingCharacters(in: .whitespacesAndNewlines)
            
            let frameKey = FrameKey(rawString: key)
            let id = FrameIdentifier(frameKey: frameKey)
            
            switch id.parseAs {
                case .boolean, .integer, .string, .url:
                    importStringFrame(id: id, stringValue: valueString)
                case .complex:
                    importComplexFrame(id: id, stringValue: valueString)
                case .credits:
                    importCreditsFrame(id: id, stringValue: valueString)
                case .date:
                    importDateFrame(id: id, stringValue: valueString)
                case .localized, .userDefined:
                    importLocalizedFrame(key: frameKey, stringValue: valueString)
                case .tuple:
                    importPoTFrame(id: id, stringValue: valueString)
                default: return
            }
        }
    }
    
    @available(macOS 10.12, *)
    mutating func parseMetadataFromCue(_ header: String) {
        var lines = header.components(separatedBy: .newlines)
            .map({$0.trimmingCharacters(in: .whitespaces)})
        
        let recognized = ["TITLE", "PERFORMER", "GENRE", "COMPOSER", "ISRC", "MESSAGE"]
        while !lines.isEmpty {
            let line = lines.extractFirst()
            
            if line.hasPrefix("FILE") {
                continue
            } else if line.hasPrefix("REM") {
                attemptMetadataFromRemark(line)
            } else {
                for item in recognized {
                    if line.hasPrefix(item) {
                        let trimmed = line.dropFirst(item.count)
                            .trimmingCharacters(in: .whitespacesAndNewlines)
                            .trimmingCharacters(in: CharacterSet(charactersIn: "\""))
                        
                        switch item {
                            case "TITLE":
                                self.album = trimmed
                            case "PERFORMER":
                                self.albumArtist = trimmed
                            case "COMPOSER":
                                self.composer = trimmed
                            case "ISRC":
                                self.isrc = trimmed
                            case "MESSAGE":
                                setCommentFromCue(trimmed)
                            case "GENRE":
                                importComplexFrame(id: .genre, stringValue: trimmed)
                            default: continue
                        }
                    }
                }
            }
        }
    }
        
    @available(macOS 10.12, *)
    private mutating func attemptMetadataFromRemark(_ line: String) {
        var line = line
        if let distance = line.distance(of: "\"") {
            let remark = line
                .extractFirst(distance)
                .trimmingCharacters(in: .whitespaces)
            let key = FrameKey(rawString: remark)
            let id = FrameIdentifier(frameKey: key)
            
            let valueString = line
                .trimmingCharacters(
                    in: CharacterSet(charactersIn: "\""))
                .trimmingCharacters(
                    in: .whitespacesAndNewlines)
            
            switch id.parseAs {
                case .boolean, .integer, .string, .url:
                    importStringFrame(id: id, stringValue: valueString)
                case .complex:
                    importComplexFrame(id: id, stringValue: valueString)
                case .credits:
                    importCreditsFrame(id: id, stringValue: valueString)
                case .date:
                    importDateFrame(id: id, stringValue: valueString)
                case .localized, .userDefined:
                    importLocalizedFrame(key: key, stringValue: valueString)
                case .tuple:
                    importPoTFrame(id: id, stringValue: valueString)
                default: return
            }
        }
    }
}

enum ImporterError: Error {
    case UnhandledFormat
    case CSVIsEmptyOrCorrupt
    case CSVDataIsCorrupted
    case InvalidChapterData
    case PossibleCountMismatch
    case InvalidOggChapterContent
}
