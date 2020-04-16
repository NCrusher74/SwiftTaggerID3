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
struct ImageFrame: FrameProtocol {
    
    /// The ID3 type of the image (see `ImageType`).
    public let imageType: ImageType
    /// an optional description of the image
    public let imageDescription: String?
    /// The image bytes as `Data`.
    public let image: Data;
    
    
    /**
     An ID attached picture frame.
     
     - parameter type: the ID3 type of the attached picture. See `ImageType` for a complete list of the available types.
     - parameter imageDescription?: an optional description of the image content.
     - parameter image: the image bytes as `Data`.
     */
    public init(imageType: ImageType, imageDescription: String?, image: Data) {
        self.imageType = imageType
        self.imageDescription = imageDescription
        self.image = image
    }
    
    //    func encodeContents(version: Version) throws -> Data {
    //        
    //    }
    
    internal var flags: Data
    internal var layout: FrameLayoutIdentifier
    
    internal init(decodingContents contents: Data.SubSequence,
         version: Version,
         layout: FrameLayoutIdentifier,
         flags: Data) throws {
        self.flags = flags
        self.layout = layout
        var parsing = contents
        let encoding = ImageFrame.extractEncoding(data: &parsing, version: version)
        if version == .v2_3 || version == .v2_4 {
            let mimeString = ImageFrame.extractTerminatedString(data: &parsing, encoding: encoding)
        }
    }
    private let jpegMagicNumber: Data = Data([0xFF, 0xD8, 0xFF, 0xE0])
    private let pngMagicNumber: Data =  Data([0x89, 0x50, 0x4E, 0x47])
    
    private func extractAndInterpretMagicNumber(data: inout Data.SubSequence) -> String? {
        let magicNumberBytes = data.extractFirst(4)
        if magicNumberBytes == jpegMagicNumber { return "jpg" }
        else if magicNumberBytes == pngMagicNumber { return "png" }
        else { return nil }
    }
        
    private func extractAndInterpretPictureByte(data: inout Data.SubSequence) throws -> ImageType {
        let pictureByte = data.extractFirst(1).uint8
        guard let pictureType = ImageType(rawValue: pictureByte) else { return .Other }
        return pictureType
    }
    
}

/*
 v2.2
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
 
 Text encoding      $xx/
 Image format       $xx xx xx
 Picture type       $xx
 Description        <textstring> $00 (00)
 Picture data       <binary data>
 
 v2.3, v2.4
 This frame contains a picture directly related to the audio file.
 Image format is the MIME type and subtype [MIME] for the image. In
 the event that the MIME media type name is omitted, "image/" will be
 implied. The "image/png" [PNG] or "image/jpeg" [JFIF] picture format
 should be used when interoperability is wanted. Description is a
 short description of the picture, represented as a terminated
 textstring. The description has a maximum length of 64 characters,
 but may be empty. There may be several pictures attached to one file,
 each in their individual "APIC" frame, but only one with the same
 content descriptor. There may only be one picture with the picture
 type declared as picture type $01 and $02 respectively. There is the
 possibility to put only a link to the image file by using the 'MIME
 type' "-->" and having a complete URL [URL] instead of picture data.
 The use of linked files should however be used sparingly since there
 is the risk of separation of files.
 
 <Header for 'Attached picture', ID: "APIC">
 Text encoding      $xx/
 MIME type          <text string> $00
 Picture type       $xx
 Description        <text string according to encoding> $00 (00)
 Picture data       <binary data>
 
 */
