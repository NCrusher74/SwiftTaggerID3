//
//  ImageFrame.swift
//  SwiftTaggerID3
//
//  Created by Nolaine Crusher on 4/11/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//


 import Foundation

/**
 A type representing an ID3 frame that contains an attached image
 */
 struct ImageFrame: FrameProtocol {
    
    /// The image bytes as `Data`.
    let image: Data;
    /// The ID3 type of the image (see `ImageType`).
    let imageType: ImageType
    /// an optional description of the image
    var imageDescription: String? = ""
    /// the format of the image (`jpg` and `png` are the only supported image formats)
    var imageFormat: ImageFormat
    
    
    /**
     An ID attached picture frame.
     
     - parameter type: the ID3 type of the attached picture. See `ImageType` for a complete list of the available types.
     - parameter imageDescription?: an optional description of the image content.
     - parameter image: the image bytes as `Data`.
     */
    init(layout: FrameLayoutIdentifier,
                 imageType: ImageType,
                 imageFormat: ImageFormat,
                 imageDescription: String?,
                 image: Data) {
        self.imageType = imageType
        self.imageFormat = imageFormat
        self.imageDescription = imageDescription
        self.image = image
        self.flags = ImageFrame.defaultFlags
        self.layout = layout
        self.frameKey = .attachedPicture(description: imageDescription ?? imageType.pictureDescription)
    }
    
    // encode the contents of the frame to add to an ID3 tag
    func encodeContents(version: Version) throws -> Data {
        var frameData = Data()
        // append encoding byte
        frameData.append(StringEncoding.preferred.rawValue.encoding(
            endianness: .bigEndian))
        // determine format based upon magic number
        // encode and append a format or MIME-type string according to version requirements
        var formatString: String = ""
        switch version {
            case .v2_2:
                if self.imageFormat == .jpg {
                    formatString = "jpg"
                } else if self.imageFormat == .png {
                    formatString = "png"
                }
                frameData.append(formatString.encoded(withNullTermination: false))
            case .v2_3, .v2_4:
                if self.imageFormat == .jpg {
                    formatString = "image/jpeg"
                } else if self.imageFormat == .png {
                    formatString = "image/png"
                }
                frameData.append(formatString.encoded(withNullTermination: true))
        }
        // append image type byte
        frameData.append(self.imageType.rawValue.encoding(
            endianness: .bigEndian))
        // encode and append image Description
        frameData.append(self.imageDescription?.encoded(
            withNullTermination: true) ?? self.imageType.pictureDescription.encoded(
                withNullTermination: true))
        // append image data
        frameData.append(self.image)
        return frameData
    }
    
    // MARK: Properties
    var flags: Data
    var layout: FrameLayoutIdentifier
    var frameKey: FrameKey
    var allowMultipleFrames: Bool = false

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
                    self.imageFormat = ImageFormat(rawValue: "jpg") ?? .jpg
                } else if formatString.lowercased() == "png" {
                    self.imageFormat = ImageFormat(rawValue: "png") ?? .png
                } else {
                    throw Mp3File.Error.UnhandledImageFormat
                }
        }; self.imageFormat = .jpg
        
        // parse out the image description string
        // if no image description exists, use a string describing the image type
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
}

public extension Tag {
    /// - AttachedPicture frame getter-setter. ID3 Identifier `PIC`/`APIC`
    subscript(attachedPicture imageDescription: String) -> Data? {
        get {
            if let frame = self.frames[.attachedPicture(description: imageDescription)],
                case .imageFrame(let imageFrame) = frame {
                return imageFrame.image
            } else {
                return nil
            }
        }
    }
    
    mutating func setAttachedPicture(imageType: ImageType?, imageDescription: String?, location: URL) throws {
        var imageFormat: ImageFormat
        if location.pathExtension.lowercased() == "jpg" || location.pathExtension.lowercased() == "jpeg" {
            imageFormat = .jpg
        } else if location.pathExtension.lowercased() == "png" {
            imageFormat = .png
        } else {
            throw Mp3File.Error.UnhandledImageFormat
        }
        let imageData = try Data(contentsOf: location)
        let key: FrameKey = .attachedPicture(description: (imageDescription ?? imageType?.pictureDescription) ?? "Other")
        self.frames[key] = Frame.imageFrame(.init(
            layout: .known(.attachedPicture),
            imageType: imageType ?? .Other,
            imageFormat: imageFormat,
            imageDescription: imageDescription,
            image: imageData))
    }
}
