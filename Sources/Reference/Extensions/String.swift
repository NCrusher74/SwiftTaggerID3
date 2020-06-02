/*

 String.swift
 SwiftTaggerID3

 Copyright ©2020 Nolaine Crusher. All rights reserved.

 */

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
    
    func encodedASCII(withNullTermination: Bool) -> Data {
        var data = Data()
        data.append(contentsOf: self.utf8)
        if withNullTermination == true {
            let null = Data(repeating: 0x00, count: StringEncoding.utf8.sizeOfTermination)
            data.append(contentsOf: null)
        }
        // UTF‐8 is a superset of ASCII.
        return data
    }
    
    init(withInt int: Int, leadingZeros: Int = 2) {
        self.init(format: "%0\(leadingZeros)d", int)
    }
    
    func components(withLength length: Int) -> [String] {
        return stride(from: 0, to: self.count, by: length).map {
            let start = self.index(self.startIndex, offsetBy: $0)
            let end = self.index(start, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            return String(self[start..<end])
        }
    }    
}
