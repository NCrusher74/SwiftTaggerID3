//
//  GlobalProperties.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/28/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

var incrementalChapterID: String {
    var chapterNumber: Int = 1
    return "ch\(chapterNumber += 1)"
}

var incrementalTocID: String {
    var tocNumber: Int = 1
    return "toc\(tocNumber += 1)"
}
