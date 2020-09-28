//
//  Array.swift
//  SwiftTaggerID3
//
//  Created by Nolaine Crusher on 9/18/20.
//

import Foundation
extension Array where Element == String {
    var parsedGenreStrings: [String] {
        var infoArray: [String] = []
        for component in self {
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
    
    var parsedMediaTypeStrings: [String] {
        var refinedArray: [String] = []
        for component in self {
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
    
    var parsedFileTypeStrings: [String] {
        var refinedArray: [String] = []
        for component in self {
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
    
    // NOTE: This will produce a numeric code wrapped in parentheses, which is in keeping with the spec, but a lot of metadata reading apps won't extrapolate from the numeric code to a genre type
    var encodedGenreParentheticalStrings: Data {
        var newArray: [String] = []
        for item in self {
            // get rid of the empty strings
            if item != "" {
                // see if the item represents a genreType
                if let genreType = GenreType(rawValue: item) {
                    // if it does, append the code in parens to the return array
                    if genreType == .Remix {
                        newArray.append("(RX)")
                    } else if genreType == .Cover {
                        newArray.append("(CR)")
                    } else {
                        newArray.append(String(genreType.code))
                    }
                } else {
                    // otherwise just append the string to the array
                    newArray.append(item)
                }
            }
        }
        var data = Data()
        for item in newArray {
            data.append(item.encodedISOLatin1)
        }
        return data
    }
    
    var encodedNonParentheticalGenreStrings: Data {
        var data = Data()
        // convert the raw value to the numerical code, if necessary
        for item in self {
            if item != "" {
                if let genreType = GenreType(rawValue: item) {
                    var itemCode: String = ""
                    if genreType == .Remix {
                        itemCode = "RX"
                    } else if genreType == .Cover {
                        itemCode = "CR"
                    } else {
                        itemCode = String(genreType.code)
                    }
                    data.append(itemCode.encodeNullTerminatedString(.isoLatin1))
                } else {
                    data.append(item.encodeNullTerminatedString(.isoLatin1))
                }
            }
        }
        return data
    }
    
    var encodedMediaTypeParentheticalStrings: Data {
        var newArray: [String] = []
        for (index, item) in self.enumerated() {
            // make sure the item isn't an empty string
            if item != "" {
                // check if it's a valid media type
                if let mediaType = MediaType(rawValue: item) {
                    if self.index(after: index) != self.endIndex {
                        
                        let nextItem = self[self.index(after: index)]
                        if nextItem.first == "/" {
                            if let refinement = MediaTypeRefinements(
                                code: nextItem) {
                                // if it is, merge them into a single string
                                let mergedItems = "(\(mediaType.rawValue)\(refinement.code))"
                                // add them to the new array
                                newArray.append(mergedItems)
                            }
                        } else {
                            // if there's not a refinement after it, but it is a media type raw value
                            // wrap it in parens and call it a day
                            let wrappedItem = "(\(mediaType.rawValue))"
                            newArray.append(wrappedItem)
                        }
                        // if it's not a media type or refinement, add it to the array as is
                    }
                } else if item.first != "/" {
                    newArray.append(item)
                }
            }
        }
        var data = Data()
        for item in newArray {
            data.append(item.encodedISOLatin1)
        }
        return data
    }
    
    var encodedNonParentheticalMediaTypeStrings: Data {
        var data = Data()
        for (index, item) in self.enumerated() {
            // make sure the string isn't empty
            if item != "" {
                // if the string represents a valid media type
                if let mediaType = MediaType(rawValue: item) {
                    // see if the next one is a valid refinement
                    if self.index(after: index) != self.endIndex {
                        let nextItem = self[self.index(after: index)]
                        if nextItem.first == "/" {
                            if let refinement = MediaTypeRefinements(code: nextItem) {
                                // if it is, merge them into one string
                                let mergedItems = "\(mediaType.rawValue)\(refinement.code)"
                                // and encode them together
                                data.append(mergedItems.encodeNullTerminatedString(.isoLatin1))
                            }
                            // if it isn't, encode the media type raw value by itself
                        } else {
                            data.append(mediaType.rawValue.encodeNullTerminatedString(.isoLatin1))
                        }
                    }
                    // if the item isn't a media type or a refinement, encode it as is
                } else if item.first != "/" {
                    data.append(item.encodeNullTerminatedString(.isoLatin1))
                }
            }
        }
        return data
    }
    
    // According to the letter of the specs, fileType isn't supposed to have parentheses
    // however, it's easier to parse the codes from the freeform string this way
    var encodedFileTypeStrings: Data {
        var newArray: [String] = []
        for (index, item) in self.enumerated() {
            // make sure the item isn't an empty string
            if item != "" {
                // check if it's a valid file type
                if let fileType = FileType(rawValue: item) {
                    if self.index(after: index) != self.endIndex {
                        let nextItem = self[self.index(after: index)]
                        if nextItem.first == "/" {
                            if let refinement = FileTypeRefinements(
                                rawValue: nextItem) {
                                // if it is, merge them into a single string, no parens
                                let mergedItems = "(\(fileType.rawValue)\(refinement.rawValue))"
                                // add them to the new array
                                newArray.append(mergedItems)
                            }
                        }
                    } else {
                        // if there's not a refinement after it, but it is a file type raw value
                        // add it to the array
                        let fileTypeItem = "(\(fileType.rawValue))"
                        newArray.append(fileTypeItem)
                    }
                    // if it's not a media type or refinement, add it to the array as is
                } else if item.first != "/" {
                    newArray.append(item)
                }
            }
        }
        var data = Data()
        for item in newArray {
            data.append(item.encodedISOLatin1)
        }
        return data
    }
    
    var encodedNonParentheticalFileTypeStrings: Data {
        var data = Data()
        for (index, item) in self.enumerated() {
            if item != "" {
                if let fileType = FileType(rawValue: item) {
                    if self.index(after: index) != self.endIndex {
                        let nextItem = self[self.index(after: index)]
                        if nextItem.first == "/" {
                            if let refinement = FileTypeRefinements(rawValue: nextItem) {
                                let mergedItems = "\(fileType.rawValue)\(refinement.rawValue)"
                                data.append(
                                    mergedItems.encodeNullTerminatedString(.isoLatin1))
                            }
                        }
                    } else {
                        data.append(fileType.rawValue.encodeNullTerminatedString(.isoLatin1))
                    }
                } else if item.first != "/" {
                    data.append(item.encodeNullTerminatedString(.isoLatin1))
                }
            }
        }
        return data
    }
}
