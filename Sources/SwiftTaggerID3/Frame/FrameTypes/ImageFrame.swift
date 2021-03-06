//
//  ImageFrame.swift
//  SwiftTaggerID3
//
//  Created by Nolaine Crusher on 9/18/20.
//

import Foundation
import SwiftConvenienceExtensions
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
    
    /// The frame's image contents
    var imageData: Data
    var imageType: ImageType
    var imageFormat: ImageFormat
    var descriptionString: String?
    
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
                if let formatString = data.extractNullTerminatedString(encoding) {
                    imageFormat = ImageFormat(nil, formatString, version: version)
                }
            case .v2_2:
                if let formatString = String(bytes: data.extractFirst(3), encoding: encoding) {
                    if let format = ImageFormat(nil, formatString, version: version) {
                        imageFormat = format
                    } else {
                        throw FrameError.UnhandledImageFormat
                    }
                }
        }
        
        let pictureTypeByte = data.extractFirst(1)
        self.imageType = ImageType(rawValue: pictureTypeByte.uInt8BE) ?? .other
        // parse out the image description string
        // if no image description exists, use a string describing the image type
        switch version {
            case .v2_2:
                self.descriptionString = data.extractNullTerminatedString(encoding)
            case .v2_3, .v2_4:
                self.descriptionString = data.extractNullTerminatedString(encoding)
        }
        
        if let format = imageFormat {
            self.imageFormat = format
        } else {
            let range = data.startIndex ..< data.index(data.startIndex, offsetBy: 4)
            let firstFourBytes = data[range]
            if let format = ImageFormat(firstFourBytes) {
                self.imageFormat = format
            } else {
                throw FrameError.UnhandledImageFormat
            }
        }
        
        self.imageData = data

        super.init(identifier: identifier,
                   version: version,
                   size: size,
                   flags: flags)
    }
    
    override var frameKey: FrameKey {
        return self.identifier.frameKey(imageType: self.imageType)
    }
    
    // MARK: - Encode Contents
    override var contentData: Data {
        if imageData == Data() {
            return Data()
        } else {
            var data = Data()
            
            // append encoding byte
            let encoding: String.Encoding
            if let descriptionString = descriptionString {
                encoding = String.Encoding(string: descriptionString)
            } else {
                encoding = .isoLatin1
            }
            
            data.append(encoding.encodingByte)
            // determine format based on file extension
            // encode and append a format or MIME-type string according to version requirements
            do {
                let formatString: String
                switch version {
                    case .v2_2:
                        if self.imageFormat == .jpg {
                            formatString = "jpg"
                        } else if self.imageFormat == .png {
                            formatString = "png"
                        } else if self.imageFormat == .bmp {
                            formatString = "bmp"
                        } else if self.imageFormat == .gif {
                            formatString = "gif"
                        } else if self.imageFormat == .tiff {
                            formatString = "tif"
                        } else {
                            throw FrameError.UnhandledImageFormat
                        }
                        data.append(formatString.attemptStringEncoding(encoding))
                    case .v2_3, .v2_4:
                        /// These versions require a MIME-type string
                        if self.imageFormat == .jpg {
                            formatString = "image/jpeg"
                        } else if self.imageFormat == .png {
                            formatString = "image/png"
                        } else if self.imageFormat == .bmp {
                            formatString = "image/bmp"
                        } else if self.imageFormat == .gif {
                            formatString = "image/gif"
                        } else if self.imageFormat == .tiff {
                            formatString = "image/tiff"
                        } else {
                            throw FrameError.UnhandledImageFormat
                        }
                        data.append(formatString.attemptTerminatedStringEncoding(encoding))
                }
            } catch {
                print("Image frame \(descriptionString ?? imageType.pictureDescription) contains invalid image format. Images must be jpg or png. Aborting encoding of this frame")
                return Data()
            }
            
            // append image type byte
            data.append(self.imageType.rawValue.beData)
            
            // encode and append image Description
            if let description = self.descriptionString {
                data.append(description.attemptTerminatedStringEncoding(encoding))
            } else {
                data.append(self.imageType.pictureDescription.attemptTerminatedStringEncoding(encoding))
            }
            
            data.append(self.imageData)
            
            return data
        }
    }
    
    // MARK: - Frame building
    /// Initialize an ID attached picture frame.
    /// - parameter type: the ID3 type of the attached picture. See `ImageType` for a complete list of the available types.
    /// - parameter imageDescription?: an optional description of the image content.
    /// - parameter image: the image bytes as `Data`.
    init(_ identifier: FrameIdentifier,
         version: Version,
         imageType: ImageType,
         imageFormat: ImageFormat,
         description: String?,
         imageData: Data) throws {
        self.imageType = imageType
        self.imageFormat = imageFormat
        self.descriptionString = description
        self.imageData = imageData

        let encoding = String.Encoding(string: description ?? imageType.pictureDescription)
        var size = 2 // +1 for encoding byte, +1 for pictureTypeByte
        switch version {
            case .v2_2:
                size += 3
            case .v2_3, .v2_4:
                let formatString: String
                /// These versions require a MIME-type string
                if imageFormat == .jpg {
                    formatString = "image/jpeg"
                } else if imageFormat == .png {
                    formatString = "image/png"
                } else if imageFormat == .bmp {
                    formatString = "image/bmp"
                } else if imageFormat == .gif {
                    formatString = "image/gif"
                } else if imageFormat == .tiff {
                    formatString = "image/tiff"
                } else {
                    throw FrameError.UnhandledImageFormat
                }
                size += formatString.attemptTerminatedStringEncoding(encoding).count
        }
        
        // append image type byte
        size += self.imageType.rawValue.beData.count
        // encode and append image Description
        if let description = description {
            size += description.attemptTerminatedStringEncoding(encoding).count
        } else {
            size += imageType.pictureDescription.attemptTerminatedStringEncoding(encoding).count
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

extension Tag {
    public subscript(attachedPicture type: ImageType) -> NativeImage? {
        let identifier = FrameIdentifier.attachedPicture
        let frameKey = identifier.frameKey(imageType: type)
        if let frame = self.frames[frameKey] as? ImageFrame {
            if let image = NativeImage(data: frame.imageData) {
                return image
            } else {
                return nil
            }
        } else {
            return nil
        }
    }

    public mutating func set(attachedPicture type: ImageType,
                             imageLocation: URL,
                             description: String?) throws {
        let identifier = FrameIdentifier.attachedPicture
        let frameKey = identifier.frameKey(imageType: type)
        let data = try Data(contentsOf: imageLocation)
        
        let imageFormat: ImageFormat
        let range = data.startIndex ..< data.index(data.startIndex, offsetBy: 4)
        // magic numbers are more reliable than extension
        let firstFourBytes = data[range]
        if let format = ImageFormat(firstFourBytes) {
            imageFormat = format
        } else {
            throw FrameError.UnhandledImageFormat
        }

        let description = description ?? type.pictureDescription
        
        let frame = try ImageFrame(identifier,
                                   version: self.version,
                                   imageType: type,
                                   imageFormat: imageFormat,
                                   description: description,
                                   imageData: data)
        self.frames[frameKey] = frame
    }
    
    public mutating func removeImage(type: ImageType) {
        let identifier = FrameIdentifier.attachedPicture
        let frameKey = identifier.frameKey(imageType: type)
        self.frames[frameKey] = nil
    }
}
