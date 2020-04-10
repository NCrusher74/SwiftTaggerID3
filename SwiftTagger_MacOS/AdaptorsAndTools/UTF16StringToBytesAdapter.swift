//
//  UTF16StringToBytesAdapter.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/9/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//
//  Adapted from ID3TagEditor
//  Created by Fabrizio Duroni on 27/04/2018.
//  2018 Fabrizio Duroni.
//

import Foundation

struct UTF16StringToByteAdapter {
    
    func encoding(for version: Version) -> [UInt8] {
        return [StringEncoding.utf16WithBOM.rawValue]
    }
    
    func termination() -> [UInt8] {
        return [UInt8](repeating: 0, count: 2)
    }
    
    func adapt(stringOnly string: String) -> [UInt8] {
        return [UInt8](string.data(using: .utf16) ?? Data())
    }
}
