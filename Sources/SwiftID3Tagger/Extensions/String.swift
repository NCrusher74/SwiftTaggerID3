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
    
    /// Convert a string to data and append a null termination byte (or pair of null bytes)
    func encodeNullTerminatedString(_ encoding: String.Encoding) -> Data {
        guard var result = data(using: encoding) else {
            // This will never happen unless “preferred” is changed to something besides Unicode.
            fatalError("\(encoding) cannot encode “\(self)”.")
        }
        result.append(encoding.nullTerminator)
        return result
    }

    init(withInt int: Int, leadingZeros: Int = 2) {
        self.init(format: "%0\(leadingZeros)d", int)
    }
    
    func leadingZeros(_ zeros: Int) throws -> String {
        if let int = Int(self) {
            return String(withInt: int, leadingZeros: zeros)
        } else {
            throw FrameError.UnableToConvertIntegerToString
        }
    }
    
    func components(withLength length: Int) -> [String] {
        return stride(from: 0, to: self.count, by: length).map {
            let start = self.index(self.startIndex, offsetBy: $0)
            let end = self.index(start, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            return String(self[start ..< end])
        }
    }
        
    /// parse the parentheses out of version 2.2 and 2.3 strings (Genre and MediaType frames)
    /// for PresetOptionsFrame
    func parseParentheticalString() -> [String] {
        // separate the components into an array using the open paren as a separator
        // this will remove the open parens from parenthetical comments as well as the codes
        // so we'll have to replace those when we spot a double-paren that denotes a parenthetical freeform comment
        var stringComponents = self.components(separatedBy: "(")
        // take it one component at a time
        for (index, value) in stringComponents.enumerated() {
            // for any component except the first one, if it's empty, it means we removed a double-paren
            if index != 0 && value == "" {
                // find the previous and next components and make a range of them
                let previous = stringComponents.index(before: index)
                let next = stringComponents.index(after: index)
                let rangeToReplace = previous...next
                // replace the open paren because it's a double-paren situation
                stringComponents[next].insert("(", at: stringComponents[next].startIndex)
                // join the previous and next components
                let componentsToJoin = [stringComponents[previous], stringComponents[next]]
                let joinedComponents = [componentsToJoin.joined()]
                // replace the separate components with the joined components
                stringComponents.replaceSubrange(rangeToReplace, with: joinedComponents)
                // remove all the empty components
                stringComponents.removeAll(where: {$0 == ""})
            }
        }
        var refinedComponents: [String] = []
        for component in stringComponents {
            if !component.contains(")") {
                refinedComponents.append(component)
                // find the close parens and parse them out
            } else if component.contains(")") {
                var separatedComponents = component.components(separatedBy: ")")
                // remove the empty elements
                separatedComponents.removeAll(where: {$0 == ""})
                // find the elements where there is an unterminated open paren now
                for (index, value) in separatedComponents.enumerated() {
                    if value.contains("(") {
                        // append a close paren to the string containing the open paren
                        var valueToChange = value
                        valueToChange.append(")")
                        // replace the string containing the unterminated open paren with the new string
                        separatedComponents.remove(at: index)
                        separatedComponents.insert(valueToChange, at: index)
                    }
                }
                // append the fixed components to the array
                refinedComponents.append(contentsOf: separatedComponents)
            }
        }
        // return the array
        return refinedComponents
    }

}
