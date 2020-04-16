//
//  CreditsListFrame.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/11/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

/**
 A type used to represent an ID3 involved peeople list or musician credits frame.
 */
struct CreditsListFrame: FrameProtocol {
    
    /// An array of the role:person tuples
    public var entries: [(role: String, person: String)]
    
    /**
     - parameter entries: the array of `role`:`person` tuples
     - parameter role: the role of the involved person.
     - parameter person: the name (or comma-delimited names) of the person fulfilling a given role.
     */
    public init(entries: [(role: String, person: String)]) {
        self.entries = entries
    }
    
    //    func encodeContents(version: Version) throws -> Data {
    //
    //    }
    
    var flags: Data
    var layout: FrameLayoutIdentifier
    
    init(decodingContents contents: Data.SubSequence,
         version: Version,
         layout: FrameLayoutIdentifier,
         flags: Data) throws {
        self.flags = CreditsListFrame.defaultFlags(version: version)
        self.layout = layout
        var parsing = contents
        let encoding = CreditsListFrame.extractEncoding(data: &parsing, version: version)
        let parsed = CreditsListFrame.extractCreditStrings(from: &parsing, encoding: encoding)
        var entries: [(role: String, person: String)] = []
        for pair in parsed {
            entries.append((role: pair.0, person: pair.1))
        }
        self.entries = entries
    }
    
    private static func extractCreditStrings(
        from frameData: inout Data.SubSequence,
        encoding: StringEncoding
    ) -> [(String, String)] {
        var strings: [String] = []
        
        while !frameData.isEmpty,
            let next = frameData.extractPrefixAsStringUntilNullTermination(encoding) {
                strings.append(next)
        }
        let rolePersonArray = strings.pairs()
        return rolePersonArray as! [(String, String)]
    }

    
}
