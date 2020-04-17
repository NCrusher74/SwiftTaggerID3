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
    private var entries: [(role: String, person: String)]
    
    /**
     - parameter entries: the array of `role`:`person` tuples
     - parameter role: the role of the involved person.
     - parameter person: the name (or comma-delimited names) of the person fulfilling a given role.
     */
    private init(layout: FrameLayoutIdentifier, entries: [(role: String, person: String)]) {
        self.entries = entries
        self.flags = CreditsListFrame.defaultFlags()
        self.layout = layout
    }
    
    func encodeContents(version: Version) throws -> Data {
        var entriesAsData = Data()
        for entry in self.entries {
            entriesAsData.append(contentsOf: entry.role.encoded(withNullTermination: true))
            entriesAsData.append(contentsOf: entry.person.encoded(withNullTermination: true))
        }
        return entriesAsData
    }
    
    internal var flags: Data
    internal var layout: FrameLayoutIdentifier
    
    internal init(decodingContents contents: Data.SubSequence,
                  version: Version,
                  layout: FrameLayoutIdentifier,
                  flags: Data) throws {
        self.flags = flags
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
        from data: inout Data.SubSequence,
        encoding: StringEncoding
    ) -> [(String, String)] {
        var strings: [String] = []
        
        while !data.isEmpty,
            let next = data.extractPrefixAsStringUntilNullTermination(encoding) {
                strings.append(next)
        }
        let rolePersonArray = strings.pairs()
        return rolePersonArray as! [(String, String)]
    }
    
    init(role: String, involvedPerson: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.involvedPeopleList), entries: [(role: role, person: involvedPerson)])
    }

    init(role: InvolvedPersonCredits.RawValue, creditedPerson: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.involvedPeopleList), entries: [(role: role, person: creditedPerson)])
    }

    init(role: String, creditedMusician: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.musicianCreditsList), entries: [(role: role, person: creditedMusician)])
    }

    init(role: PerformerCredits.RawValue, creditedPerformer: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.musicianCreditsList), entries: [(role: role, person: creditedPerformer)])
    }

}
