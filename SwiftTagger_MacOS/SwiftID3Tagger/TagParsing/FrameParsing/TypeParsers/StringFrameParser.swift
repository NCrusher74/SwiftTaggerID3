//
//  StringFrameParser.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/10/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

internal struct StringFrameParser: FrameParser {
    
    let frameName: FrameName
    
    func parse(frame: Data, version: Version,
               frameInfo: FrameInformation,
               completed: (FrameName, FrameData) throws -> ()) {
        var parsing = frame[...]
        extractHeader(from: &parsing, version: version, frameInfo: frameInfo)
        
        let encoding = try extractEncoding(from: &parsing)
        
        let parsed = extractContentString(from: &parsing, encoding: encoding)
        let constructed = StringFrame(contentString: parsed)
        completed(frameName, constructed)
    }
}
