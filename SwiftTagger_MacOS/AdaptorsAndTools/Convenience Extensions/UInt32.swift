//
//  UInt32.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/9/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

//  IntsExtensions.swift
//  Created by Boris Polania on 2/19/18.

extension UInt32 {
    var data: Data {
        var int = self
        return Data(bytes: &int, count: MemoryLayout<UInt32>.size)
    }
    
    var byteArrayLittleEndian: [UInt8] {
        return [
            UInt8((self & 0xFF000000) >> 24),
            UInt8((self & 0x00FF0000) >> 16),
            UInt8((self & 0x0000FF00) >> 8),
            UInt8(self & 0x000000FF)
        ]
    }

    //  This code is adapted from ID3TagEditor
    //  Created by Fabrizio Duroni on 27/02/2018.
    //  2018 Fabrizio Duroni. https://github.com/chicio/ID3TagEditor

    var byteArrayWithUnsafePointer: [UInt8] {
        var currentUInt32 = self
        let bytes = withUnsafePointer(to: &currentUInt32) {
            $0.withMemoryRebound(to: UInt8.self, capacity: MemoryLayout<UInt32>.size) {
                Array(UnsafeBufferPointer(start: $0, count: MemoryLayout<UInt32>.size))
            }
        }
        return bytes.reversed()
    }

    //  This code is adapted from ID3TagEditor
    //  Created by Fabrizio Duroni on 27/02/2018.
    //  2018 Fabrizio Duroni. https://github.com/chicio/ID3TagEditor

    
    var synchSafeEncode: UInt32 {
        var encodedInteger: UInt32 = 0
        var mask: UInt32 = 0x7F
        var partiallyEncodedInteger = self
        while (mask != 0x7FFFFFFF) {
            encodedInteger = partiallyEncodedInteger & ~mask
            encodedInteger = encodedInteger << 1
            encodedInteger = encodedInteger | partiallyEncodedInteger & mask
            mask = ((mask + 1) << 8) - 1
            partiallyEncodedInteger = encodedInteger
        }
        return encodedInteger
    }
    
    //  This code is adapted from ID3TagEditor
    //  Created by Fabrizio Duroni on 27/02/2018.
    //  2018 Fabrizio Duroni. https://github.com/chicio/ID3TagEditor

    var synchSafeDecode: UInt32 {
        var decodedInteger: UInt32 = 0
        var mask: UInt32 = 0x7F000000;
        
        while (mask != 0) {
            decodedInteger = decodedInteger >> 1;
            decodedInteger = decodedInteger | self & mask;
            mask >>= 8;
        }
        
        return decodedInteger;
    }
}
