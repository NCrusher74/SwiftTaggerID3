//
//  File.swift
//  
//
//  Created by Nolaine Crusher on 9/18/20.
//

import Foundation
/// A type representing a frame with up to three optional strings as content, at least one of which is selected from a preset list of options. This type manages frames `genreType`, `mediaType`, and `fileType`
class ComplexTypesFrame: Frame {

    var contentArray: [String]
    
    init(identifier: FrameIdentifier,
         version: Version,
         size: Int,
         flags: Data,
         payload: Data
    ) throws {
        // standard boilerplate, it's a text frame (of sorts) so strings are encoded
        var data = payload
        let encoding = try data.extractEncoding()
        // initialize an empty array to store the parsed strings in
        var parsedArray = [String]()
        
        // versions 2.2 and 2.3 handle strings differently than version 2.4.
        // 2.2 and 2.3 relies on parentheses, while 2.4 just uses null termination
        switch version {
            // v2.2 and v2.3 use parentheses to denote codes
            case .v2_2, .v2_3:
                // extract the full string
                if let unparsedString = data.extractNullTerminatedString(encoding) {
                    // parse out the parentheses and return the array of parsed strings
                    parsedArray = unparsedString.parseParentheticalString()
                }
            case .v2_4:
                while !data.isEmpty,
                      let next = data.extractNullTerminatedString(encoding) {
                    parsedArray.append(next)
                }
        }

        if self.identifier == .known(.genre) {
            self.contentArray = parsedArray.parsedGenreStrings
        } else if self.identifier == .known(.mediaType) {
            self.contentArray = parsedArray.parsedMediaTypeStrings
        } else {
            self.contentArray = parsedArray.parsedFileTypeStrings
        }

        super.init(identifier: identifier,
                   version: version,
                   size: size,
                   flags: flags)
    }

    
    // MARK: - Frame Building
    init(_ identifier: FrameIdentifier,
         version: Version,
         contentArray: [String]) {
        self.contentArray = contentArray
        let flags = version.defaultFlags
        
        var size = 1 // +1 for encoding byte
        switch version {
            case .v2_2, .v2_3: // null termination will be false
                if identifier == .known(.genre) {
                    size += contentArray
                        .encodedGenreParentheticalStrings.count
                } else if identifier == .known(.mediaType) {
                    size += contentArray
                        .encodedMediaTypeParentheticalStrings.count
                } else if identifier == .known(.fileType) {
                    size += contentArray.encodedFileTypeStrings.count
                }
            case .v2_4: // null termination will be true
                if identifier == .known(.genre) {
                    size += contentArray
                        .encodedNonParentheticalGenreStrings.count
                } else if identifier == .known(.mediaType) {
                    size += contentArray
                        .encodedNonParentheticalMediaTypeStrings.count
                } else if identifier == .known(.fileType) {
                    size += contentArray
                        .encodedNonParentheticalFileTypeStrings.count
                }
        }
        super.init(identifier: identifier,
                   version: version,
                   size: size,
                   flags: flags)
    }
    
    override var contentData: Data {
        var data = Data()
        // append encoding byte
        let encoding = String.Encoding.isoLatin1
        data.append(encoding.encodingByte)
        switch self.version {
            case .v2_2, .v2_3: // null termination will be false
                if self.identifier == .known(.genre) {
                    data.append(
                        contentArray.encodedGenreParentheticalStrings)
                } else if self.identifier == .known(.mediaType) {
                    data.append(
                        contentArray.encodedMediaTypeParentheticalStrings)
                } else if self.identifier == .known(.fileType) {
                    data.append(contentArray.encodedFileTypeStrings)
                }
            case .v2_4: // null termination will be true
                if self.identifier == .known(.genre) {
                    data.append(
                        contentArray.encodedNonParentheticalGenreStrings)
                } else if self.identifier == .known(.mediaType) {
                    data.append(
                        contentArray.encodedNonParentheticalMediaTypeStrings)
                } else if self.identifier == .known(.fileType) {
                    data.append(
                        contentArray.encodedNonParentheticalFileTypeStrings)
                }
        }
        return data
    }
    
}
