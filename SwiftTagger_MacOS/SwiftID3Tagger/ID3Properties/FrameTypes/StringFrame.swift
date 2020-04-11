//
//  StringFrame.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/11/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

/**
 A type representing an ID3 frame that holds a single string, such as Artist, Title, Album, etc
 */
struct StringFrame {
    
    let contentString: String
    
    /**
     A frame with only string content, presented as a single string without `(/n)`.     
     - parameter contentString: the content of the frame.
     */
    init(contentString: String) {
        self.contentString = contentString
    }
}
