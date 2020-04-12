//
//  PartOfTotalFrame.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/11/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

/**
 A type representing the track/disc index of the total tracks or discs.
 */
struct PartOfTotalFrame {
    /// The position of the track/disc.
    public var part: Int
    /// The total number of tracks/discs in recordings.
    public var total: Int?
    
    /**
     - parameter part: the index of the track/disc.
     - parameter total: the total tracks/discs of the recordings.
     */
    public init(part: Int, total: Int?) {
        self.part = part
        self.total = total
    }
}
