//
//  SynchsafeInteger.swift
//
//  This code is adapted from ID3TagEditor
//  Created by Fabrizio Duroni on 27/02/2018.
//  2018 Fabrizio Duroni. https://github.com/chicio/ID3TagEditor
//
//  Created by Nolaine Crusher on 4/8/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

/**
 Synchsafe Integer
 
 - SeeAlso https://en.wikipedia.org/wiki/Synchsafe
 */
struct SynchSafeInteger {
    
    var integer: UInt32
    
    init(integer: UInt32) {
        self.integer = integer
    }
    
    func decode() -> UInt32 {
        var decodedInteger: UInt32 = 0
        var mask: UInt32 = 0x7F000000;
        
        while (mask != 0) {
            decodedInteger = decodedInteger >> 1;
            decodedInteger = decodedInteger | self.integer & mask;
            mask >>= 8;
        }
        
        return decodedInteger;
    }

    func encode() -> UInt32 {
        var encodedInteger: UInt32 = 0
        var mask: UInt32 = 0x7F
        var partiallyEncodedInteger = self.integer
        while (mask != 0x7FFFFFFF) {
            encodedInteger = partiallyEncodedInteger & ~mask
            encodedInteger = encodedInteger << 1
            encodedInteger = encodedInteger | partiallyEncodedInteger & mask
            mask = ((mask + 1) << 8) - 1
            partiallyEncodedInteger = encodedInteger
        }
        return encodedInteger
    }

    
    
}
