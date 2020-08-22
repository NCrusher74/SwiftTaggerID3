/*

 CreditsListFrame.swift
 SwiftTaggerID3

 Copyright ©2020 Nolaine Crusher. All rights reserved.

 */

import Foundation

/**
 A type used to represent an ID3 involved peeople list or musician credits frame.
 handled as a dictionary: `[role : [array of people performing the role]]`
 */


struct CreditsListFrame: FrameProtocol, CustomStringConvertible {
    public var description: String {
        
        var credits = [(role: String, people: [String])]()
        for credit in self.credits {
            let role = credit.key
            let people = credit.value
            let entry = (role, people)
            credits.append(entry)
        }
        return """
        \(self.frameKey): \(credits)
        """
    }
    
    // // MARK: - Properties
    // inherited from FrameProtocol
    var flags: Data
    var layout: FrameLayoutIdentifier
    var frameKey: FrameKey
    
    /// The dictionary of `[role : [array of people performing the role]]`
    var credits: [ String : [String] ]
    
    // // MARK: - Frame parsing
    init(decodingContents contents: Data.SubSequence,
         version: Version,
         layout: FrameLayoutIdentifier,
         flags: Data) throws {
        self.flags = flags
        self.layout = layout
        self.frameKey = self.layout.frameKey(additionalIdentifier: nil)
        
        var parsing = contents
        let encoding = try CreditsListFrame.extractEncoding(data: &parsing, version: version)
        self.credits = CreditsListFrame.extractCreditStrings(from: &parsing, encoding: encoding)
    }
    
    private static func extractCreditStrings(
        from data: inout Data.SubSequence,
        encoding: StringEncoding
    ) -> [String: [String]] {
        var strings: [String] = []
        while !data.isEmpty,
            let next = data.extractPrefixAsStringUntilNullTermination(encoding) {
                strings.append(next)
        }
        var pairsDictionary: [ String: [String] ] = [:]
        let rolePersonPairs = strings.pairs()
        for pair in rolePersonPairs {
            let personArray = pair.1?.components(separatedBy: ",")
            pairsDictionary[pair.0] = personArray
        }
        return pairsDictionary
    }
    
    // // MARK: - Frame building
    /// Initialize a frame building instance for a given layout
    /// - Parameters:
    ///   - layout: the frame layout
    ///   - credits: the credits dictionary
    init(_ layout: FrameLayoutIdentifier,
         credits: [ String: [String] ]) {
        self.layout = layout
        self.credits = credits
        self.flags = CreditsListFrame.defaultFlags
        self.frameKey = layout.frameKey(additionalIdentifier: nil)
    }
    
    func encodeContents(version: Version) throws -> Data {
        var frameData = Data()
        // append encoding Byte
        frameData.append(StringEncoding.preferred.rawValue)
        
        // encode and append each credit
        for key in credits.keys {
            frameData.append(key.encoded(withNullTermination: true))
            let valueString = credits[key]?.joined(separator: ",") ?? ""
            frameData.append(valueString.encoded(withNullTermination: true))
        }
        return frameData
    }
}

extension Tag {
    
    /// retrieve the `[role: [person]]` dictionary from the frame
    /// - Parameter frameKey: the unique identifier for the frame
    /// - Returns: the `[String: [String]]` dictionary of `[role: [person]]` pairs
    internal func get(forCreditListFrame frameKey: FrameKey) -> Credits? {
        if let frame = self.frames[frameKey],
            case .creditsListFrame(let creditsListFrame) = frame {
            return Credits(frame: creditsListFrame, frameKey: frameKey)
        } else {
            return nil
        }
    }
    
    /// set the `[role: [person]]` dictionary for the frame
    /// - Parameters:
    ///   - layout: the frame layout
    ///   - frameKey: the frame's unique identifier
    ///   - credits: the dictionary of `[role: [person]]` pairs
    internal mutating func set(_ layout: FrameLayoutIdentifier,
                               _ frameKey: FrameKey,
                               from credits: Credits) {
        switch frameKey {
            case .involvedPeopleList:
                let stringList = credits.involvementStringList
                let frame = CreditsListFrame(layout, credits: stringList)
                self.frames[frameKey] = .creditsListFrame(frame)
            case .musicianCreditsList:
                let stringList = credits.performanceStringList
                let frame = CreditsListFrame(layout, credits: stringList)
                self.frames[frameKey] = .creditsListFrame(frame)
            default: break
        }
    }
    
    /// Getter-setter property for the dictionary of `[role: [person]]` pairs
    public var involvementCreditsList: [InvolvedPersonCredits:[String]] {
        get {
            if let credits = get(forCreditListFrame: .involvedPeopleList) {
                return credits.involvementList
            } else {
                return [:]
            }
        }
        set {
            if !newValue.isEmpty {
                let credits = Credits(from: newValue)
                set(.known(.involvedPeopleList), .involvedPeopleList, from: credits)
            } else {
                self.frames[.involvedPeopleList] = nil
            }
        }
    }
    
    /// Getter-setter property for the dictionary of `[role: [person]]` pairs
    public var performanceCreditsList: [MusicianAndPerformerCredits:[String]] {
        get {
            if let credits = get(forCreditListFrame: .musicianCreditsList) {
                return credits.performanceList
            } else {
                return [:]
            }
        }
        set {
            if !newValue.isEmpty {
                let credits = Credits(from: newValue)
                set(.known(.musicianCreditsList), .musicianCreditsList, from: credits)
            } else {
                self.frames[.musicianCreditsList] = nil
            }
        }
    }
    
    /// Add a new [role:[person]] key-value pair, or, if the `role` already exists in the dictionary, append the person to the existing value for the `role` key
    /// - Parameters:
    ///   - role: the role being performed
    ///   - person: the person performing the role
    // TODO: if version is 2.2. or 2.3, make this an `involved person` entry instead?
    public mutating func addPerformanceCredit(
        role: MusicianAndPerformerCredits, person: String) {
        
        if let existingCredit = performanceCreditsList.first(
            where: { $0.key == role && !$0.value.contains(person) }) {
            var array = existingCredit.value
            array.append(person)
            performanceCreditsList[role] = array
        } else {
            performanceCreditsList[role] = [person]
        }
    }
    
    /// Add a new [role:[person]] key-value pair, or, if the `role` already exists in the dictionary, append the person to the existing value for the `role` key
    /// - Parameters:
    ///   - role: the role being performed
    ///   - person: the person performing the role
    public mutating func addInvolvementCredit(
        role: InvolvedPersonCredits, person: String) {
        // get the list of pre-existing keys in the dictionary
        if let existingCredit = involvementCreditsList.first(
            where: { $0.key == role && !$0.value.contains(person) }) {
            var array = existingCredit.value
            array.append(person)
            involvementCreditsList[role] = array
        } else {
            involvementCreditsList[role] = [person]
        }
    }
    
    public mutating func clearPerformanceCreditList() {
        self.frames[.musicianCreditsList] = nil
    }
    
    public mutating func removePerformanceCredit(role: MusicianAndPerformerCredits) {
        self.performanceCreditsList[role] = nil
    }
    
    public mutating func clearInvolvementCreditList() {
        self.frames[.involvedPeopleList] = nil
    }
    
    public mutating func removeInvolvementCredit(role: InvolvedPersonCredits) {
        self.involvementCreditsList[role] = nil
    }
}
