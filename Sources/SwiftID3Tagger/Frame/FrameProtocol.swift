/*

 FrameProtocol.swift
 SwiftTaggerID3

 Copyright ©2020 Nolaine Crusher. All rights reserved.

 */

import Foundation
import SwiftConvenienceExtensions
/**
 A type representing the properties and methods used by all frames
 */
protocol FrameProtocol {
    
    /// The frame flags property.
    ///
    /// Typically this is two bytes `[0x00, 0x00]`
    /// SwiftTagger does not support altering these flags.
    var flags: Data { get set }
    /// The layout property describes the unique structure of a given frame
    var layout: FrameLayoutIdentifier { get }
    /** The frameKey property
     
        Provides a unique identifier to permits duplication of frame types that the ID3 spec allows to be duplicated within a tag. */
    var frameKey: FrameKey { get set }
    
    /// Encodes the contents of a frame
    func encodeContents(version: Version) throws -> Data
    
    /// Initialize a frame parsing operation
    /// - Parameters:
    ///   - contents: the slice of data containing the frame
    ///   - version: the ID3 version of the tag
    ///   - layout: the frame's FrameLayoutIdentifier
    ///   - flags: (current unsupported by SwiftTagger) [0x00, 0x00]
    init(decodingContents contents: Data.SubSequence,
         version: Version,
         layout: FrameLayoutIdentifier,
         flags: Data
    ) throws
}

extension FrameProtocol {
    
    /// Encode a frame to data, including frame headers
    /// - Parameter version: The version of the ID3 tag
    /// - Throws: Caller will determine how to handle errors
    /// - Returns: `Data` containing frame header and contents
    func encode(version: Version) throws -> Data {
        let contents = try self.encodeContents(version: version)
        
        var frameData = Data()
        // encode and append header data
        frameData.append(identifierData(layout: layout, version: version))
        frameData.append(calculateFrameContentSize(encodedContent: contents, version: version))
        switch version {
            case .v2_2:
                break // Skip flags.
            case .v2_3, .v2_4:
                frameData.append(Self.defaultFlags)
        }
        // append encoded frame content data
        frameData.append(contents)
        return frameData
    }
    
    
    /// Parses the frame data
    /// - Parameters:
    ///   - data: the remaining data in the `Tag`
    ///   - version: the version of the ID3 tag
    ///   - layout: the FrameLayoutIdentifier
    /// - Throws: Caller will determine how errors are handled
    init(decodingFromStartOf data: inout Data.SubSequence,
         version: Version,
         layout: FrameLayoutIdentifier) throws {
        // parse size data first
        let frameSizeData = data.extractFirst(version.sizeDeclarationLength)
        var frameSize: Int = 0
        let raw = UInt32(parsing: frameSizeData, .bigEndian)
        switch version {
            case .v2_2, .v2_3: frameSize = Int(raw)
            case .v2_4: frameSize = Int(raw.decodingSynchsafe())
        }

        // parse flags second
        var flagsData: Data
        switch version {
            case .v2_2: flagsData = Data()
            case .v2_3, .v2_4: flagsData = data.extractFirst(version.flagsLength)
        }
        // parse content last
        let contentDataStart = data.startIndex
        let contentDataRange = contentDataStart ..< contentDataStart + frameSize
        let contentData = data.subdata(in: contentDataRange)
        try self.init(decodingContents: contentData,
                      version: version,
                      layout: layout,
                      flags: flagsData
        )
        
        data = data.dropFirst(contentData.count)
        // This line leaves the slice ready for the next frame to read from the beginning.
    }
    
    /// Calculates the size of the frame for encoding purposes
    /// - Parameters:
    ///   - encodedContent: The byte-count of the content data for the frame
    ///   - version: The version of the ID3 tag
    /// - Returns:
    ///   - Version 2.2: three bytes of frame-size data.
    ///   - Versions 2.3 & 2.4: four bytes of frame-size data
    private func calculateFrameContentSize(encodedContent: Data, version: Version) -> Data {
        let contentSize = encodedContent.count.uInt32
        switch version {
            case .v2_2:
                let contentUInt8Array = [UInt8](contentSize.beData)
                return Data(contentUInt8Array.dropFirst())
            case .v2_3: return contentSize.beData
            case .v2_4: return contentSize.encodingSynchsafe().beData
        }
    }
    
    /// Calculates and extracts the ID3 indentifier from the layout
    /// - Parameters:
    ///   - layout: the FrameLayoutIdentifier
    ///   - version: The version of the ID3 tag
    /// - Returns: The encoded identifier string
    private func identifierData(
        layout: FrameLayoutIdentifier,
        version: Version) -> Data {

        guard let identifier = layout.id3Identifier(version: version)?.encodedASCII(withNullTermination: false) else {
            switch version {
                case .v2_2: return "TXX".encodedASCII(withNullTermination: false)
                case .v2_3, .v2_4: return "TXXX".encodedASCII(withNullTermination: false)
            }
        }
        return identifier
    }
        
    /// Flags are rarely used and are unhandled by SwiftTagger
    static var defaultFlags: Data {
        let flagBytes: [UInt8] = [0x00, 0x00]
        return Data(flagBytes)
    }
    
    /** Extracts and decodes the encoding byte, leaving the remaining data ready to be parsed and returning information on the encoding of the frame's contents
    - Parameters:
      - data: The frame data beginning at the encoding byte
      - version: The ID3 version of the tag
      - Throws: Caller will determine how to handle any errors
      - Returns: A `StringEncoding` instance */
    static func extractEncoding(data: inout Data.SubSequence, version: Version) throws -> StringEncoding {
        let encodingData = data.extractFirst(1)
        let encodingByteArray = [UInt8](encodingData)
        let encodingByte = encodingByteArray.first ?? 0x00
        return StringEncoding(rawValue: encodingByte) ?? .isoLatin1
    }
    
    /// Extracts and decodes description and content strings for frame types that use them.
    /// - Parameters:
    ///   - frameData: The frame's data beginning at the description string
    ///   - encoding: The `StringEncoding` instance parsed out of the frame content previously
    /// - Throws: Caller will determine how to handle any errors
    /// - Returns: The frame's description and content strings
    /// this is used for frames with a terminated description string followed by a content string
    static func extractDescriptionAndContent(
        from frameData: inout Data.SubSequence,
        encoding: StringEncoding
    ) throws -> (description: String?, content: String) {
        let description = frameData.extractPrefixAsStringUntilNullTermination(encoding)
        let content = frameData.extractPrefixAsStringUntilNullTermination(encoding) ?? ""
        return (description: description, content: content)
    }
    
    // to be used with url frames, which do not have an encoding byte
    static func parseUrlString(data: Data, version: Version) throws -> String {
        let parsing = data
        return try String(ascii: parsing)
    }

    // to be used with basic string frames that need no special handling
    static func parseEncodedString(data: Data, version: Version) throws -> String {
        var parsing = data
        // extract and decode the encoding byte
        let encoding = try StringFrame.extractEncoding(data: &parsing, version: version)
        // extract and initialize the contentString property
        // decode the string content according to encoding as specified by encoding byte
        return parsing.extractPrefixAsStringUntilNullTermination(encoding) ?? ""
    }
        
    /// Interpret the most common "quasi-boolean" strings as boolean values
    /// - Parameter boolString: The string parsed from the frame's contents
    /// - Returns: 1 or 0, if a value can be determined
    static func parseBooleanIntFromString(version: Version, data: Data) throws -> String {
        var parsing = data
        let encoding = try extractEncoding(data: &parsing, version: version)
        let contentString = parsing.extractPrefixAsStringUntilNullTermination(encoding)
        switch contentString?.lowercased() {
            case "true", "t", "yes", "y", "1":
                return "1"
            case "false", "f", "no", "n", "0":
                return "0"
            default:
                return "0"
        }
    }
    

    // parse the parentheses out of version 2.2 and 2.3 strings (Genre and MediaType frames)
    // for PresetOptionsFrame
    static func parseParentheticalString(unparsedString: String) -> [String] {
        // separate the components into an array using the open paren as a separator
        // this will remove the open parens from parenthetical comments as well as the codes
        // so we'll have to replace those when we spot a double-paren that denotes a parenthetical freeform comment
        var stringComponents = unparsedString.components(separatedBy: "(")
        // take it one component at a time
        for (index, value) in stringComponents.enumerated() {
            // for any component except the first one, if it's empty, it means we removed a double-paren
            if index != 0 && value == "" {
                // find the previous and next components and make a range of them
                let previousIndex = index - 1
                let nextIndex = index + 1
                let rangeToReplace = previousIndex...nextIndex
                // replace the open paren because it's a double-paren situation
                stringComponents[nextIndex].insert("(", at: stringComponents[nextIndex].startIndex)
                // join the previous and next components
                let componentsToJoin = [stringComponents[previousIndex], stringComponents[nextIndex]]
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
    
    static func parseGenreStrings(parsedArray: [String]) -> [String] {
        var infoArray: [String] = []
        for component in parsedArray {
            // see if the string can be converted to an Int
            if let genreInt = Int(component) {
                // see if it matches any of the codes
                if let genreType = GenreType(code: genreInt) {
                    // if so, we know it's a genreType
                    infoArray.append(genreType.rawValue)
                }
                // if not, see if it's one of the genre type special cases
            } else if component == "RX" {
                infoArray.append(GenreType.Remix.rawValue)
            } else if component == "CR" {
                infoArray.append(GenreType.Cover.rawValue)
                // if it doesn't match a genreType, handle it as freeform description
            } else {
                infoArray.append(component)
            }
        }
        return infoArray
    }
    
    static func parseMediaTypeStrings(parsedArray: [String]) -> [String] {
        var refinedArray: [String] = []
        for component in parsedArray {
            if component.contains("/") {
                let splitString = component.components(separatedBy: "/")
                if let firstString = splitString.first {
                    refinedArray.append(firstString)
                }
                if let lastString = splitString.last {
                    // replace the slash we removed
                    let fixedString = ("/\(lastString)")
                    refinedArray.append(fixedString)
                }
            } else {
                refinedArray.append(component)
            }
        }
        var infoArray: [String] = []
        for item in refinedArray {
            if item.first == "/" {
                if let refinement = MediaTypeRefinements(code: item) {
                    infoArray.append(refinement.code)
                }
            } else if let mediaType = MediaType(rawValue: item) {
                infoArray.append(mediaType.rawValue)
            } else {
                infoArray.append(item)
            }
        }
        return infoArray
    }
    
    static func parseFileTypeStrings(parsedArray: [String]) -> [String] {
        var refinedArray: [String] = []
        for component in parsedArray {
            if component.contains("/") {
                let splitString = component.components(separatedBy: "/")
                if let firstString = splitString.first {
                    refinedArray.append(firstString)
                }
                if let lastString = splitString.last {
                    // replace the slash we removed
                    let fixedString = ("/\(lastString)")
                    refinedArray.append(fixedString)
                }
            } else {
                refinedArray.append(component)
            }
        }
        var infoArray: [String] = []
        for item in refinedArray {
            if item.first == "/" {
                if let refinement = FileTypeRefinements(rawValue: item) {
                    infoArray.append(refinement.rawValue)
                }
            } else if let fileType = FileType(rawValue: item) {
                infoArray.append(fileType.rawValue)
            } else {
                infoArray.append(item)
            }
        }
        return infoArray
    }
    
    
    

}
