//
//  ISO88591StringToBytesAdapter.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/9/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//
//  Code adapted from ID3TagEditor
//  Created by Fabrizio Duroni on 27/04/2018.
//  2018 Fabrizio Duroni.
//

import Foundation

struct ISO88591StringToByteAdapter {
    
    internal var encoding: [UInt8] {
        return [StringEncoding.isoLatin1.rawValue]
    }
    
    func termination() -> [UInt8] {
        return [UInt8](repeating: 0, count: 1)
    }
    
    func adapt(stringOnly string: String) throws -> [UInt8] {
        guard let adaptedString = string.data(
            using: .isoLatin1).map({ [UInt8]($0) })
            else { throw Mp3File.Error.InconvertibleString }
        return adaptedString
    }
}
