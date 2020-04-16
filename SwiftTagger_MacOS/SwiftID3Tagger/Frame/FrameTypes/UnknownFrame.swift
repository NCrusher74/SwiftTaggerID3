//
//  UnknownFrame.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/16/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

public struct UnknownFrame: FrameProtocol {
//    func encodeContents(version: Version) throws -> Data {
//        <#code#>
//    }
    
    internal var flags: Data
    internal var layout: FrameLayoutIdentifier
    
    internal init(decodingContents contents: Data.SubSequence,
         version: Version,
         layout: FrameLayoutIdentifier,
         flags: Data) throws {
        self.flags = flags
        self.layout = layout
        let content = contents
    }
    
    
}
