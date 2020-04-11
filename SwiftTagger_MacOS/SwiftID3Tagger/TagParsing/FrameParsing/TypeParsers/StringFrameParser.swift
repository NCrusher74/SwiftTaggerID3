//
//  StringFrameParser.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/10/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

/**
 A type that parses the content of a `StringFrame`
 */
//internal struct StringFrameParser: FrameParser {
//    
//    let frameLayoutIdentifier: FrameLayoutIdentifier
//
//    ///  - parameter frameData: the data of frame
//    ///  - parameter version: the ID3 version of the frame.
//    ///  - parameter frameInfo: a type containing methods of handling the content of a frame based on frame type.
//    /// returns the frame name and ????
//    func parse(frame: Data, version: Version,
//               frameInfo: FrameInformation,
//               completed: (FrameLayoutIdentifier, FrameData) throws -> ()) {
//        var parsing = frame[...]
//        extractHeader(from: &parsing, version: version, frameInfo: frameInfo)
//        
//        let encoding = try extractEncoding(from: &parsing)
//        
//        let parsed = extractContentString(from: &parsing, encoding: encoding)
//        let constructed = StringFrame(contentString: parsed)
//        completed(frameLayoutIdentifier, constructed)
//    }
//}
