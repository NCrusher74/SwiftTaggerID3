/*

 Sequence.swift
 SwiftTaggerID3

 Copyright ©2020 Nolaine Crusher. All rights reserved.

 */

import Foundation

public extension Sequence where Element: BinaryInteger {
    
    func hexadecimal() -> String {
        return lazy.map({ String($0, radix: 16) }).joined(separator: " ")
    }
}

/*
 let fileUrl = TestFile.v24.url
 let data = try Data(contentsOf: fileUrl)
 let range = 542 ..< 582
 let subdata = data.subdata(in: range)
 let components = subdata.hexadecimal().components(separatedBy: " ")
 var array = [String]()
 for component in components {
 let newComponent = "0x\(component)"
 array.append(newComponent)
 }
 let string = array.joined(separator: " ")
 print(string)

 */
