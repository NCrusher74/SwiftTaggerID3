//
//  UnknownFrame.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/16/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

public struct UnknownFrame: FrameProtocol {
    
    var contents: Data
    
    init(layout: FrameLayoutIdentifier, contents: Data){
        self.flags = UnknownFrame.defaultFlags()
        self.layout = layout
        self.contents = contents
    }

    func encodeContents(version: Version) throws -> Data {
        return self.contents
    }
    
    internal var flags = Data()
    internal var layout: FrameLayoutIdentifier
    
    internal init(decodingContents contents: Data.SubSequence,
         version: Version,
         layout: FrameLayoutIdentifier,
         flags: Data) throws {
        self.flags = flags
        self.layout = layout
        self.contents = contents
    }
}
