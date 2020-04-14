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
    
    /// The image bytes as `Data`.
    public let image: Data;
    /// The ID3 type of the image (see `ImageType`).
    public let imageType: ImageType

    
    /**
     An ID attached picture frame.
     
     - parameter image: the image bytes as `Data`.
     - parameter type: the ID3 type of the attached picture. See `ImageType` for a complete list of the available.
     - parameter format: the format of the image. See `ImageFormat`.
     types.
     */
    public init(image: Data, imageType: ImageType) {
        self.image = image
        self.imageType = imageType
    }

    var flags: Data
    var identifier: FrameLayoutIdentifier
    
//    func encodeContents(version: Version) throws -> Data {
//        <#code#>
//    }

    init(decodingContents contents: Data.SubSequence, version: Version, frameIdentifier: FrameLayoutIdentifier, flags: Data) throws {
        <#code#>
    }
    

}
