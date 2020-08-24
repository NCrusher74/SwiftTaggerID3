/*

 ImageFrame.swift
 SwiftTaggerID3

 Copyright ©2020 Nolaine Crusher. All rights reserved.

 */

import Foundation
import Cocoa
/**
 A type representing an ID3 frame that contains an attached image
 */
struct ImageFrame: FrameProtocol, CustomStringConvertible {
    public var description: String {
        if let description = self.imageDescription {
            return """
            \(self.frameKey):
            \(self.imageType.rawValue) - \(description)
            """
        } else {
            return """
            \(self.frameKey):
            \(self.imageType.rawValue)
            """
        }
    }

    // MARK: - Properties
    var flags: Data
    var layout: FrameLayoutIdentifier
    var frameKey: FrameKey
    
    /// The image bytes as `Data`.
    let image: Data
    /// The ID3 type of the image (see `ImageType`).
    let imageType: ImageType
    /// an optional description of the image
    var imageDescription: String? = ""
    /// the format of the image (`jpg` and `png` are the only supported image formats)
    var imageFormat: ImageFormat
    
    
    // MARK: - Frame parsing
    init(decodingContents contents: Data.SubSequence,
         version: Version,
         layout: FrameLayoutIdentifier,
         flags: Data) throws {
        self.flags = flags
        self.layout = layout
        
        var parsing = contents
        let encoding = try ImageFrame.extractEncoding(data: &parsing, version: version)
        
        switch version {
            // get MIME or format-type string to determine format
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
        
        let pictureTypeByte = parsing.extractFirst(1)
        let imageType = ImageType(rawValue: pictureTypeByte.uint8) ?? .Other
        self.imageType = imageType
        // parse out the image description string
        // if no image description exists, use a string describing the image type
        var imageDescription: String = imageType.pictureDescription
        switch version {
            case .v2_2:
                imageDescription = parsing.extractPrefixAsStringUntilNullTermination(.isoLatin1) ?? imageType.pictureDescription
            case .v2_3, .v2_4:
                imageDescription = parsing.extractPrefixAsStringUntilNullTermination(encoding) ?? imageType.pictureDescription
        }
        self.imageDescription = imageDescription
        self.frameKey = .attachedPicture(imageType: imageType)
        self.image = parsing

        if let description = self.imageDescription {
            let entry = (self.frameKey, description, self.imageType)
            Tag.metadataWithDifferentiatingElement.removeAll(where: {$0.frameKey == self.frameKey && $0.differentiatingElement == description})
            Tag.metadataWithDifferentiatingElement.append(entry)
        } else {
            let entry = (self.frameKey, "", self.imageType)
            Tag.metadataWithDifferentiatingElement.removeAll(where: {$0.frameKey == self.frameKey && $0.differentiatingElement == ""})
            Tag.metadataWithDifferentiatingElement.append(entry)
        }
    }

    // MARK: - Frame building
    /**
     Initialize an ID attached picture frame.
     - parameter type: the ID3 type of the attached picture. See `ImageType` for a complete list of the available types.
     - parameter imageDescription?: an optional description of the image content.
     - parameter image: the image bytes as `Data`.
     */
    init(_ layout: FrameLayoutIdentifier,
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

        if let description = self.imageDescription {
            let entry = (self.frameKey, description, self.imageType)
            Tag.metadataWithDifferentiatingElement.removeAll(where: {$0.frameKey == frameKey})
            Tag.metadataWithDifferentiatingElement.append(entry)
        } else {
            let entry = (self.frameKey, "", self.imageType)
            Tag.metadataWithDifferentiatingElement.removeAll(where: {$0.frameKey == frameKey})
            Tag.metadataWithDifferentiatingElement.append(entry)
        }
    }
    
    // encode the contents of the frame to add to an ID3 tag
    func encodeContents(version: Version) throws -> Data {
        var frameData = Data()
        // append encoding byte
        frameData.append(StringEncoding.preferred.rawValue)
        // determine format based on file extension
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
}

extension Tag {
    /// AttachedPicture frame getter-setter. ID3 Identifier `PIC`/`APIC`
    public subscript(attachedPicture imageDescription: String) -> Data? {
        get {
            if let frame = self.frames[.attachedPicture(description: imageDescription)],
                case .imageFrame(let imageFrame) = frame {
                return imageFrame.image
            } else {
                return nil
            }
        }
    }
        
    public mutating func set(imageType: ImageType?, imageDescription: String?, location: URL?) throws {
        var imageFormat: ImageFormat
        if location?.pathExtension.lowercased() == "jpg" || location?.pathExtension.lowercased() == "jpeg" {
            imageFormat = .jpg
        } else if location?.pathExtension.lowercased() == "png" {
            imageFormat = .png
        } else {
            throw Mp3File.Error.UnhandledImageFormat
        }
        let imageData = try Data(contentsOf: location ?? URL(fileURLWithPath: ""))
        let key: FrameKey = .attachedPicture(description: (imageDescription ?? imageType?.pictureDescription) ?? "Other")
        self.frames[key] = Frame.imageFrame(.init(
            .known(.attachedPicture),
            imageType: imageType ?? .Other,
            imageFormat: imageFormat,
            imageDescription: imageDescription,
            image: imageData))
    }
    
    public mutating func removeAttachedPicture(withDescription: String?) {
        self.frames[.attachedPicture(description: withDescription ?? "")] = nil
    }
    
    public var coverArt: NSImage? {
        get {
            if let frame = self.frames[.attachedPicture(
                imageType: .FrontCover)],
                case .imageFrame(let imageFrame) = frame {
                return NSImage(data: imageFrame.image)
            } else if let frame = self.frames[.attachedPicture(
                imageType: .Other)],
                case .imageFrame(let imageFrame) = frame {
                return NSImage(data: imageFrame.image)
            } else {
                return nil
            }
        }
        set {
            if let new = newValue {
                var format = ImageFormat.png
                var imageData = Data()
                if let data = new.tiffRepresentation(using: .jpeg, factor: 1) {
                    format = .jpg
                    imageData = data
                } else if let data =  new.tiffRepresentation {
                    let magicBytes = data[0 ..< 4]
                    if magicBytes.hexadecimal().lowercased() == "ff d8 ff e0" {
                        format = .jpg
                        imageData = data
                    } else {
                        imageData = data
                        format = .png
                    }
                } else {
                    return
                }
                self.frames[.attachedPicture(imageType: .FrontCover)] = Frame.imageFrame(.init(
                    .known(.attachedPicture),
                    imageType: .FrontCover,
                    imageFormat: format,
                    imageDescription: ImageType.FrontCover.pictureDescription,
                    image: imageData))
            } else {
                self.frames[.attachedPicture(imageType: .FrontCover)] = nil
                self.frames[.attachedPicture(imageType: .Other)] = nil
            }
        }
    }
}
