//
//  File.swift
//  
//
//  Created by Crystal Wooley on 7/22/21.
//

import Foundation

extension Tag {
    public mutating func exportMetadata(
        file savingAs: MetadataExportFormat,
        usingFullMetadataForCue: Bool = false) throws {
        
        var string = """
            """
        switch savingAs {
            case .csv:
                string = try formatAsCSV()
                try string.write(
                    to: destination(savingAs: savingAs),
                    atomically: true,
                    encoding: .utf8)
            case .json:
                let data = try formatAsJSON()
                try data.write(to: destination(savingAs: .json))
            default:
                string = formatAsText()
                try string.write(
                    to: destination(savingAs: savingAs),
                    atomically: true,
                    encoding: .utf8)
        }
    }
    
    private func destination(savingAs: MetadataExportFormat) -> URL {
        let fileName = location.fileName
        
        return location
            .deletingPathExtension()
            .deletingLastPathComponent()
            .appendingPathComponent(fileName)
            .appendingPathExtension(savingAs.rawValue)
    }

    private func getMetadataAsArray(format: MetadataExportFormat) -> [(keyString: String, valueString: String)] {
        var metadata = [(keyString: String, valueString: String)]()
        
        let frames = self.frames
            .sorted(by: {$0.key.priority < $1.key.priority })
            .filter({$0.value.identifier != .attachedPicture})
            .filter({$0.value.identifier != .chapter})
            .filter({$0.value.identifier != .tableOfContents})
           
        for (key, frame) in frames {
            let keyString = key.keyString(format: format)
            let valueString = frame.description
            metadata.append((keyString, valueString))
        }
        return metadata
    }
    
    private func getMetadataAsDictionary() throws -> [String: String] {
        var formatted = [String: String]()
        for (key, value) in getMetadataAsArray(format: .json) {
            formatted[key] = value
        }
        return formatted
    }
    
    private func formatAsJSON() throws -> Data {
        let dict = try getMetadataAsDictionary()
        let encoder = JSONEncoder()
        let data = try encoder.encode(dict)
        return data
    }
    
    private func formatAsCSV() throws -> String {
        var keyString = ""
        var valueString = ""
        
        let dict = try getMetadataAsDictionary()
        for (key, value) in dict {
            keyString.append(key + ",")
            let corrected = value
                .replacingOccurrences(of: ",", with: ";")
                .replacingOccurrences(of: "\n", with: "\\")
                .replacingOccurrences(of: "\u{2117}", with: "(P)")
                .replacingOccurrences(of: "\u{00A9}", with: "(c)")
            valueString.append(corrected + ",")
        }
        
        keyString = keyString.trimmingCharacters(in: CharacterSet(charactersIn: ","))
        valueString = valueString.trimmingCharacters(in: CharacterSet(charactersIn: ","))
        
        let string = keyString + "\n" + valueString
        return string
    }
    
    private func formatAsText() -> String {
        let metadata = getMetadataAsArray(format: .text)
        
        var string = """
            """
        
        var count = 0
        let sorted = metadata.map({$0.keyString}).sorted(by: {$0.count > $1.count})
        
        if let first = sorted.first {
            count = first.count + 6
        }
        
        for (key, value) in metadata {
            let valueString: String
            if key == "{TCMP} COMPILATION" || key == "{TCP} COMPILATION" {
                if value == "1" {
                    valueString = "True"
                } else {
                    valueString = "False"
                }
            } else {
                valueString = value
            }
            
            let difference = count - key.count
            let separator = ":".padRight(difference)
            let joined = key + separator + valueString + "\n"
            string.append(joined)
        }
        return string
    }
}

enum ExporterError: Error {
    case unableToEncodeJSON
    case unableToWriteJSON
}
