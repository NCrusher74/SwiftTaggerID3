//
//  String.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/9/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

extension String {
    
    internal init<S>(ascii: S) where S: Sequence, S.Element == UInt8 {
        assert(!ascii.contains(where: { $0 > 0x7F }), "Bytes are not ASCII: \(ascii.hexadecimal())")
        let scalars = String.UnicodeScalarView(ascii.lazy.map({ Unicode.Scalar($0) }))
        self = String(scalars)
    }
    
    var paddingRemoved: String {
        return self.trimmingCharacters(
            in: CharacterSet(charactersIn: "\0"))
    }
    
    func encoded(withNullTermination: Bool) -> Data {
        let encoding = StringEncoding.preferred
        guard var result = data(using: encoding.standardLibraryEncoding) else {
            // This will never happen unless “preferred” is changed to something besides Unicode.
            fatalError("\(encoding) cannot encode “\(self)”.")
        }
        let null = Data(repeating: 0x00, count: encoding.sizeOfTermination)
        result.append(contentsOf: null)
        return result
    }
    
    func encodedASCII() -> Data {
        // UTF‐8 is a superset of ASCII.
        return Data(utf8)
    }


}
