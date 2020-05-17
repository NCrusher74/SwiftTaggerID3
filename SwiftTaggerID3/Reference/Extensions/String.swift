//
//  String.swift
//  SwiftTaggerID3
//
//  Created by Nolaine Crusher on 4/9/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

extension String {
    
    init<S>(ascii: S) throws where S: Sequence, S.Element == UInt8 {
        let scalars = String.UnicodeScalarView(ascii.lazy.map({ Unicode.Scalar($0) }))
        self = String(scalars)
    }
    
    func encoded(withNullTermination: Bool) -> Data {
        let encoding = StringEncoding.preferred
        guard var result = data(using: encoding.standardLibraryEncoding) else {
            // This will never happen unless “preferred” is changed to something besides Unicode.
            fatalError("\(encoding) cannot encode “\(self)”.")
        }
        if withNullTermination == true {
            let null = Data(repeating: 0x00, count: encoding.sizeOfTermination)
            result.append(contentsOf: null)
        }
        return result
    }
    
    func encodedASCII() -> Data {
        // UTF‐8 is a superset of ASCII.
        return Data(utf8)
    }
    
    init(withInt int: Int, leadingZeros: Int = 2) {
        self.init(format: "%0\(leadingZeros)d", int)
    }
    
    func leadingZeros(_ zeros: Int) -> String {
        if let int = Int(self) {
            return String(withInt: int, leadingZeros: zeros)
        }
        print("Warning: \(self) is not an Int")
        return ""
    }

    
}
