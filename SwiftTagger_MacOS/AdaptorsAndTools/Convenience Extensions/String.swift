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
    
    

}
