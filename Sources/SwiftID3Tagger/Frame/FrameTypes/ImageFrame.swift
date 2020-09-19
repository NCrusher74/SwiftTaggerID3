//
//  File.swift
//  
//
//  Created by Nolaine Crusher on 9/18/20.
//

import Foundation
import Cocoa
/*
 // 2.2
 This frame contains a picture directly related to the audio file.
 Image format is preferably "PNG" [PNG] or "JPG" [JFIF]. Description
 is a short description of the picture, represented as a terminated
 textstring. The description has a maximum length of 64 characters,
 but may be empty. There may be several pictures attached to one file,
 each in their individual "PIC" frame, but only one with the same
 content descriptor. There may only be one picture with the picture
 type declared as picture type $01 and $02 respectively. There is a
 possibility to put only a link to the image file by using the 'image
 format' "-->" and having a complete URL [URL] instead of picture data.
 The use of linked files should however be used restrictively since
 there is the risk of separation of files.
 
 Attached picture   "PIC"
 Frame size         $xx xx xx
 Text encoding      $xx
 Image format       $xx xx xx
 Picture type       $xx
 Description        <textstring> $00 (00)
 Picture data       <binary data>
 
 v2.3 and 2.4:
 <Header for 'Attached picture', ID: "APIC">
 Text encoding      $xx
 MIME type          <text string> $00
 Picture type       $xx
 Description        <text string according to encoding> $00 (00)
 Picture data       <binary data>
 */

///  A type representing an ID3 frame that contains an attached image
class ImageFrame: Frame {
    
    /// The frame's image contents as data.
    ///
    /// Keeping it as data instead of converting it to NSImage enables us to preserve the format data and so forth, and makes it more portable. It can be exported as an NSImage instance when and if appropriate, or simply written to file as-is.
    var imageData: Data
    var imageType: ImageType
    var imageFormat: ImageFormat
    var description: String?
    
    // MARK: - Frame Parsing
    init(identifier: FrameIdentifier,
         version: Version,
         size: Int,
         flags: Data,
         payload: Data) throws {
        var data = payload
        
        let encoding = try data.extractEncoding()
        
        var imageFormat: ImageFormat? = nil
        switch version {
            // get MIME or format-type string to determine format
            case .v2_3, .v2_4 :
                if let formatString = data.extractNullTerminatedString(.isoLatin1) {
                    if formatString.contains("jpeg") {
                        imageFormat = .jpg
                    } else if formatString.contains("png") {
                        imageFormat = .png
                    } else {
                        imageFormat = nil
                    }
                } else {
                    imageFormat = nil
                }
            case .v2_2:
                let formatString = try String(ascii: data.extractFirst(3))
                if formatString.lowercased() == "jpg" {
                    self.imageFormat = .jpg
                } else if formatString.lowercased() == "png" {
                    self.imageFormat = .png
                } else {
                    throw FrameError.UnhandledImageFormat
                }
        }
        
        let pictureTypeByte = data.extractFirst(1)
        self.imageType = ImageType(rawValue: pictureTypeByte.uInt8BE) ?? .other
        // parse out the image description string
        // if no image description exists, use a string describing the image type
        switch version {
            case .v2_2:
                self.description = data.extractNullTerminatedString(encoding)
            case .v2_3, .v2_4:
                self.description = data.extractNullTerminatedString(encoding)
        }
        
        if let format = imageFormat {
            self.imageFormat = format
        } else {
            let range = data.startIndex ..< data.index(data.startIndex, offsetBy: 4)
            let firstFourBytes = data.subdata(in: range)
            let jpegMagicNumber: Data = Data([0xff, 0xd8, 0xff, 0xe0])
            let pngMagicNumber: Data = Data([0x89, 0x50, 0x4e, 0x47])
            if firstFourBytes == jpegMagicNumber {
                self.imageFormat = .jpg
            } else if firstFourBytes == pngMagicNumber {
                self.imageFormat = .png
            } else {
                throw FrameError.UnhandledImageFormat
            }
        }
        if NSImage(data: data) != nil {
            self.imageData = data
        } else {
            throw FrameError.InvalidImageData
        }
        super.init(identifier: identifier,
                   version: version,
                   size: size,
                   flags: flags)
    }
    
    override var frameKey: String {
        if self.imageType == .other || self.imageType == .fileIcon {
            return self.identifier.frameKey(self.imageType)
        } else {
            return self.identifier.frameKey(self.description ?? "\(self.imageType.pictureDescription)")
        }
    }

    // MARK: - Encode Contents
    override var contentData: Data {
        var data = Data()
        // append encoding byte
        let encoding = String.Encoding.isoLatin1
        data.append(encoding.encodingByte)
        // determine format based on file extension
        // encode and append a format or MIME-type string according to version requirements
        var formatString = String()
        switch version {
            case .v2_2:
                if self.imageFormat == .jpg {
                    formatString = "jpg"
                } else if self.imageFormat == .png {
                    formatString = "png"
                }
                data.append(formatString.encodedISOLatin1)
            case .v2_3, .v2_4:
                /// These versions require a MIME-type string
                if self.imageFormat == .jpg {
                    formatString = "image/jpeg"
                } else if self.imageFormat == .png {
                    formatString = "image/png"
                }
                data.append(formatString.encodeNullTerminatedString(encoding))
        }
        // append image type byte
        data.append(self.imageType.rawValue.beData)
        // encode and append image Description
        if let description = self.description {
            data.append(description.encodeNullTerminatedString(.isoLatin1))
        } else {
            data.append(self.imageType.pictureDescription.encodeNullTerminatedString(.isoLatin1))
        }
        // append image data
        data.append(self.imageData)
        return data
    }
    
    // MARK: - Frame building
    /// Initialize an ID attached picture frame.
    /// - parameter type: the ID3 type of the attached picture. See `ImageType` for a complete list of the available types.
    /// - parameter imageDescription?: an optional description of the image content.
    /// - parameter image: the image bytes as `Data`.
    init(_ identifier: FrameIdentifier,
         version: Version,
         imageType: ImageType,
         description: String?,
         imageData: Data) throws {
        self.imageType = imageType
        self.description = description
        self.imageData = imageData

        var format: ImageFormat = .jpg
        let range = imageData.startIndex ..< imageData.index(imageData.startIndex, offsetBy: 4)
        let firstFourBytes = imageData.subdata(in: range)
        let jpegMagicNumber: Data = Data([0xff, 0xd8, 0xff, 0xe0])
        let pngMagicNumber: Data = Data([0x89, 0x50, 0x4e, 0x47])
        if firstFourBytes == jpegMagicNumber {
            format = .jpg
        } else if firstFourBytes == pngMagicNumber {
            format = .png
        } else {
            throw FrameError.UnhandledImageFormat
        }
        self.imageFormat = format
        
        var size = 2 // +1 for encoding byte, +1 for pictureTypeByte
        var formatString = String()
        let encoding = String.Encoding.isoLatin1
        switch version {
            case .v2_2:
                if format == .jpg {
                    formatString = "jpg"
                } else if format == .png {
                    formatString = "png"
                }
                size += formatString.encodedISOLatin1.count
            case .v2_3, .v2_4:
                /// These versions require a MIME-type string
                if format == .jpg {
                    formatString = "image/jpeg"
                } else if format == .png {
                    formatString = "image/png"
                }
                size += formatString.encodeNullTerminatedString(encoding).count
        }
        // append image type byte
        size += self.imageType.rawValue.beData.count
        // encode and append image Description
        if let description = description {
            size += description.encodeNullTerminatedString(.isoLatin1).count
        } else {
            size += imageType.pictureDescription.encodeNullTerminatedString(.isoLatin1).count
        }
        // append image data
        size += imageData.count
        let flags = version.defaultFlags
        super.init(identifier: identifier,
                   version: version,
                   size: size,
                   flags: flags)
    }
}
