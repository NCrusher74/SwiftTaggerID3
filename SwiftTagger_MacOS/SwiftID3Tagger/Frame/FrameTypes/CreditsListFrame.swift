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
public struct CreditsListFrame: FrameProtocol {
 
    // public initializers
    public init(role: String, involvedPerson: String) {
        var entryArray: [(String, String)] = []
        entryArray.append((role, involvedPerson))
        self.init(layout: .known(.involvedPeopleList), entries: entryArray)
    }
    
    public init(role: InvolvedPersonCredits.RawValue, creditedPerson: String) {
        var entryArray: [(String, String)] = []
        entryArray.append((role, creditedPerson))
        self.init(layout: .known(.involvedPeopleList), entries: entryArray)
    }

    public init(role: String, creditedMusician: String) {
        var entryArray: [(String, String)] = []
        entryArray.append((role, creditedMusician))
        self.init(layout: .known(.musicianCreditsList), entries: entryArray)
    }
    
    public init(role: MusicianAndPerformerCredits.RawValue, creditedPerformer: String) {
        var entryArray: [(String, String)] = []
        entryArray.append((role, creditedPerformer))
        self.init(layout: .known(.musicianCreditsList), entries: entryArray)
    }

    /// An array of the role:person tuples
    var entries: [(role: String, person: String)]
    
    /**
     - parameter entries: the array of `role`:`person` tuples
     - parameter role: the role of the involved person.
     - parameter person: the name (or comma-delimited names) of the person fulfilling a given role.
     */
    init(layout: FrameLayoutIdentifier, entries: [(role: String, person: String)]) {
        self.entries = entries
        self.flags = CreditsListFrame.defaultFlags
        self.layout = layout
        
        switch layout {
            case .known(.involvedPeopleList) : self.frameKey = .involvedPeopleList
            case .known(.musicianCreditsList) : self.frameKey = .musicianCreditsList
            default: self.frameKey = .userDefinedText(description: "")
        }
    }
        
    func encodeContents(version: Version) throws -> Data {
        let encodingByte = StringEncoding.preferred.rawValue.encoding(endianness: .bigEndian)
        var entriesAsData = Data()
        for entry in self.entries {
            entriesAsData.append(contentsOf: entry.role.encoded(withNullTermination: true))
            entriesAsData.append(contentsOf: entry.person.encoded(withNullTermination: true))
        }
        return encodingByte + entriesAsData
    }
    
    var flags: Data
    var layout: FrameLayoutIdentifier
    var frameKey: FrameKey
    
    // MARK: Decoding
    init(decodingContents contents: Data.SubSequence,
                  version: Version,
                  layout: FrameLayoutIdentifier,
                  flags: Data
    ) throws {
        self.flags = flags
        self.layout = layout
        
        switch layout {
            case .known(.involvedPeopleList) : self.frameKey = .involvedPeopleList
            case .known(.musicianCreditsList) : self.frameKey = .musicianCreditsList
            default: self.frameKey = .userDefinedText(description: "")
        }
        
        var parsing = contents
        let encoding = try CreditsListFrame.extractEncoding(data: &parsing, version: version)
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
}
