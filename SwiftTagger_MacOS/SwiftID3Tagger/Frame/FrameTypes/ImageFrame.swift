//
//  ImageFrame.swift
//  SwiftTagger_MacOS
//
//  Some of this code is adapted from ID3TagEditor
//  Created by Fabrizio Duroni on 27/02/2018.
//  2018 Fabrizio Duroni. https://github.com/chicio/ID3TagEditor
//
//  Created by Nolaine Crusher on 4/11/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//


 import Foundation

/**
 A type representing an ID3 frame that contains an attached image
 */
 public struct ImageFrame: FrameProtocol {
    
    /// The image bytes as `Data`.
    public let image: Data;
    /// The ID3 type of the image (see `ImageType`).
    public let imageType: ImageType
    /// an optional description of the image
    public var imageDescription: String? = ""
    
    
    /**
     An ID attached picture frame.
     
     - parameter type: the ID3 type of the attached picture. See `ImageType` for a complete list of the available types.
     - parameter imageDescription?: an optional description of the image content.
     - parameter image: the image bytes as `Data`.
     */
    private init(layout: FrameLayoutIdentifier,
                 imageType: ImageType,
                 imageDescription: String?,
                 image: Data) {
        self.imageType = imageType
        self.imageDescription = imageDescription
        self.image = image
        self.flags = ImageFrame.defaultFlags
        self.layout = layout
        self.frameKey = .attachedPicture(description: imageDescription ?? imageType.pictureDescription)
    }
    
    // encode the contents of the frame to add to an ID3 tag
    func encodeContents(version: Version) throws -> Data {
        let encodingByte = StringEncoding.preferred.rawValue.encoding(endianness: .bigEndian)
        
        var formatOrMIMETypeString: String = ""
        var encodedFormatOrMIMETypeString = Data()
        let magicNumberRange = 0 ..< 4
        
        switch version {
            case .v2_2:
                if self.image.subdata(in: magicNumberRange) == jpgMagicNumber {
                    formatOrMIMETypeString = "jpg"
                } else if self.image.subdata(in: magicNumberRange) == pngMagicNumber {
                    formatOrMIMETypeString = "png"
                }
                encodedFormatOrMIMETypeString.append(formatOrMIMETypeString.encoded(withNullTermination: false))
            case .v2_3, .v2_4:
                if self.image.subdata(in: magicNumberRange) == jpgMagicNumber {
                    formatOrMIMETypeString = "image/jpeg"
                } else if self.image.subdata(in: magicNumberRange) == pngMagicNumber {
                    formatOrMIMETypeString = "image/png"
                }
                encodedFormatOrMIMETypeString.append(formatOrMIMETypeString.encoded(withNullTermination: true))
        }
        
        let encodedImageTypeByte = self.imageType.rawValue.encoding(endianness: .bigEndian)
        
        let encodedImageDescription = self.imageDescription?.encoded(withNullTermination: true) ?? self.imageType.pictureDescription.encoded(withNullTermination: true)
        
        return encodingByte + encodedFormatOrMIMETypeString + encodedImageTypeByte + encodedImageDescription
    }
    
    // the first four bytes of an image file contain a "magic number" that identifies the image format
    private var jpgMagicNumber: Data {
        return Data([0xFF, 0xD8, 0xFF, 0xE0])
    }
    
    private var pngMagicNumber: Data {
        return Data([0x89, 0x50, 0x4E, 0x47])
    }
    
    var flags: Data
    var layout: FrameLayoutIdentifier
    var frameKey: FrameKey
    var allowMultipleFrames: Bool = true
    
    // decode the contents of an image frame from an ID3 tag
    init(decodingContents contents: Data.SubSequence,
         version: Version,
         layout: FrameLayoutIdentifier,
         flags: Data) throws {
        self.flags = flags
        self.layout = layout
        
        var parsing = contents
        let encoding = try ImageFrame.extractEncoding(data: &parsing, version: version)
        
        switch version {
            // get MIME type string, unused
            case .v2_3, .v2_4 :
                let formatString = parsing.extractPrefixAsStringUntilNullTermination(encoding) ?? "image/"
                if formatString.contains("jpeg") {
                    _ = ImageFormat(rawValue: "jpg")
                } else if formatString.contains("png") {
                    _ = ImageFormat(rawValue: "png")
                } else {
                    throw Mp3File.Error.UnhandledImageFormat
            }
            case .v2_2:
                let formatString = try String(ascii: parsing.extractFirst(3))
                if formatString.lowercased() == "jpg" {
                    _ = ImageFormat(rawValue: "jpg")
                } else if formatString.lowercased() == "png" {
                    _ = ImageFormat(rawValue: "png")
                } else {
                    throw Mp3File.Error.UnhandledImageFormat
            }
        }
        
        var imageDescription: String = ""
        let pictureTypeByte = parsing.extractFirst(1)
        let imageType = ImageType(rawValue: pictureTypeByte.uint8) ?? .Other
        self.imageType = imageType
        switch version {
            case .v2_2:
                imageDescription = parsing.extractPrefixAsStringUntilNullTermination(.isoLatin1) ?? imageType.pictureDescription
            case .v2_3, .v2_4:
                imageDescription = parsing.extractPrefixAsStringUntilNullTermination(encoding) ?? imageType.pictureDescription
        }
        self.imageDescription = imageDescription
        self.frameKey = .attachedPicture(description: imageDescription)
        self.image = parsing
    }
    
    
    /// add an image to an ID3 tag using the `URL` of the image file
    public init(imageLocation: URL,
                imageType: ImageType,
                imageDescription: String?) throws {
        let imageData = try Data(contentsOf: imageLocation)
        
        self.init(layout: .known(.attachedPicture),
                  imageType: imageType,
                  imageDescription: imageDescription,
                  image: imageData)
    }
}

