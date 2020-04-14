//
//  BooleanFrame.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/12/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

/**
 A type representing an ID3 frame that holds a single integer
 */
internal struct BooleanFrame: FrameProtocol {
    
    let value: Bool
    
    /**
     A frame with a single-integer string, 1 or 0, presented as a boolean.
     - parameter value: the content of the frame.
     */
    init(value: Bool) {
        self.value = value
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
