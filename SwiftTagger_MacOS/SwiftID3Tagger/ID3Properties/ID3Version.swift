//
//  ID3Version.swift
//  SwiftTagger_MacOS
//
//  This code is adapted from ID3TagEditor
//  Created by Fabrizio Duroni on 27/02/2018.
//  2018 Fabrizio Duroni. https://github.com/chicio/ID3TagEditor
//
//  Created by Nolaine Crusher on 4/8/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

public enum ID3Version: Int {
    /// ID3 v2.2
    case version22 = 2
    /// ID3 v2.3
    case version23 = 3
    /// ID3 v2.4
    case version24 = 4

    internal var versionByteSize: Int {
        switch self {
            case .version22:
                return 3
            case .version23, .version24:
                return 4
        }
    }

    internal var versionFlagSize: Int {
        switch self {
            case .version22:
                return 0
            case .version23, .version24:
                return 2
        }
    }

}
