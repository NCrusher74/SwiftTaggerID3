////
////  ImageFrame.swift
////  SwiftTagger_MacOS
////
////  Some of this code is adapted from ID3TagEditor
////  Created by Fabrizio Duroni on 27/02/2018.
////  2018 Fabrizio Duroni. https://github.com/chicio/ID3TagEditor
////
////  Created by Nolaine Crusher on 4/11/20.
////  Copyright © 2020 Nolaine Crusher. All rights reserved.
////
//
//
//import Foundation
//
///**
// A type representing an ID3 frame that contains an attached image
// */
//public struct ImageFrame: FrameProtocol {
//    
//    /// The ID3 type of the image (see `ImageType`).
//    public let imageType: ImageType
//    /// an optional description of the image
//    public let imageDescription: String?
//    /// The image bytes as `Data`.
//    public let image: Data;
//    
//    
//    /**
//     An ID attached picture frame.
//     
//     - parameter type: the ID3 type of the attached picture. See `ImageType` for a complete list of the available types.
//     - parameter imageDescription?: an optional description of the image content.
//     - parameter image: the image bytes as `Data`.
//     */
//    private init(layout: FrameLayoutIdentifier,
//                 imageType: ImageType,
//                 imageDescription: String?,
//                 image: Data) {
//        self.imageType = imageType
//        self.imageDescription = imageDescription
//        self.image = image
//        self.flags = ImageFrame.defaultFlags
//        self.layout = layout
//    }
//    
//    func encodeContents(version: Version) throws -> Data {
//        
//    }
//    
//    var flags: Data
//    var layout: FrameLayoutIdentifier
//    var frameKey: FrameKey
//    
//    init(decodingContents contents: Data.SubSequence,
//                  version: Version,
//                  layout: FrameLayoutIdentifier,
//                  flags: Data) throws {
//        self.flags = flags
//        self.layout = layout
//        
//        var parsing = contents
//        let encoding = try ImageFrame.extractEncoding(data: &parsing, version: version)
//        
//        var mimeTypeString: String = ""
//        if version == .v2_3 || version == .v2_4 {
//            mimeTypeString = parsing.extractPrefixAsStringUntilNullTermination(encoding) ?? "image/"
//        }
//        
//        
//        
//    }
//
//
//    
//    
//    
//    
//    
//    
//    init(imageType: ImageType,
//         imageDescription: String?,
//         image: Data){
//        self.init(layout: .known(.attachedPicture),
//                  imageType: imageType,
//                  imageDescription: imageDescription,
//                  image: image)
//    }
//}
//
