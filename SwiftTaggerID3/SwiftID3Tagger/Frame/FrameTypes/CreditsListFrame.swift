//
//  CreditsListFrame.swift
//  SwiftTaggerID3
//
//  Created by Nolaine Crusher on 4/11/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

/**
 A type used to represent an ID3 involved peeople list or musician credits frame.
 handled as an array of `role, person` tuples
 */
struct CreditsListFrame: FrameProtocol {
 
    /// An array of the `role, person` tuples
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
        
    // encode the contents of the frame to add to an ID3 tag
    func encodeContents(version: Version) throws -> Data {
        var frameData = Data()
        // append encoding Byte
        frameData.append(StringEncoding.preferred.rawValue.encoding(
            endianness: .bigEndian))
        
        // encod and append each entry
        for entry in self.entries {
            frameData.append(contentsOf: entry.role.encoded(withNullTermination: true))
            frameData.append(contentsOf: entry.person.encoded(withNullTermination: true))
        }
        return frameData
    }
    
    // MARK: Properties
    var flags: Data
    var layout: FrameLayoutIdentifier
    var frameKey: FrameKey
    var allowMultipleFrames: Bool = false

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

internal extension Tag {
    // get and set functions for `CreditsListFrame` frame types. Each individual frame of this type will have its own get-set property that will call these functions
    func tupleArray(for frameKey: FrameKey)
        -> [(role: String, person: String)]? {
            if let frame = self.frames[frameKey],
                case .creditsListFrame(let creditsListFrame) = frame {
                return creditsListFrame.entries
            } else {
                return nil
            }
    }
    
    // each individual CreditsListFrame type has a function that will retrieve a tuple and append append it to the credits list `entries` array
    mutating func set(_ layout: FrameLayoutIdentifier,
                      _ frameKey: FrameKey,
                      to entries: [(role: String, person: String)]?) {
        let frame = CreditsListFrame(
            layout: layout,
            entries: entries ?? [])
        self.frames[frameKey] = .creditsListFrame(frame)
    }
    

}

// MARK: Tag extension
public extension Tag {
    
    /// - MusicianCreditsList frame getter-setter. Valid only for tag version 2.4
    /// ID3 Identifier: `TMCL`
    /// the `role` parameter refers to an instrument, vocal part, or other performance-related task.
    /// the `person` parameter is the name of the person or people performing the `role`
    var musicianCreditList: [(role: MusicianAndPerformerCredits, person: String)] {
        get {
            var reconstructedEntries: [(role: MusicianAndPerformerCredits, person: String)] = []
            var role: MusicianAndPerformerCredits = .none
            var person: String = ""
            let entries = tupleArray(for: .musicianCreditsList) ?? []
            for entry in entries {
                role = MusicianAndPerformerCredits(rawValue: entry.role) ?? .none
                person = entry.person
                reconstructedEntries.append((role, person))
            }
            return reconstructedEntries
        }
    }
    
    mutating func addMusicianCredit(role: MusicianAndPerformerCredits, person: String) {
        var musicianCreditArray: [(role: String, person: String)] = []
        var roleString: String = ""
        var personString: String = ""
        
        let creditTuple = (role, person)
        roleString = creditTuple.0.rawValue
        personString = creditTuple.1
        musicianCreditArray.append((roleString, personString))
        set(.known(.musicianCreditsList),
            .musicianCreditsList,
            to: musicianCreditArray)
    }
    
    /// - InvolvedPeopleList frame getter-setter. ID3 Identifier: `IPL`/`IPLS`/`TIPL`
    /// the `role` parameter refers to a production or support-oriented task (for tag version 2.4)
    /// or to any performance or production related job (for tag versions 2.2 and 2.3)
    /// the `person` parameter is the name of the person or people performing the `role`
    var involvedPeopleList: [(role: InvolvedPersonCredits, person: String)] {
        get {
            var reconstructedEntries: [(role: InvolvedPersonCredits, person: String)] = []
            var role: InvolvedPersonCredits = .none
            var person: String = ""
            let entries = tupleArray(for: .musicianCreditsList) ?? []
            for entry in entries {
                role = InvolvedPersonCredits(rawValue: entry.role) ?? .none
                person = entry.person
                reconstructedEntries.append((role, person))
            }
            return reconstructedEntries
        }
    }
    
    mutating func addInvolvedPerson(role: InvolvedPersonCredits, person: String) {
        var involvedPersonArray: [(role: String, person: String)] = []
        var roleString: String = ""
        var personString: String = ""
        
        let creditTuple = (role, person)
        roleString = creditTuple.0.rawValue
        personString = creditTuple.1
        involvedPersonArray.append((roleString, personString))
        set(.known(.involvedPeopleList),
            .involvedPeopleList,
            to: involvedPersonArray)

    }
}
