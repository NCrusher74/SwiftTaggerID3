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
    private func getInvolvementCredits() -> [InvolvedPersonCredits: [String]] {
        var dictionary = [InvolvedPersonCredits: [String]]()
        if let frame = self.frames[.involvedPeopleList],
            case .creditsListFrame(let creditsListFrame) = frame {
            // convert [String: [String]] to [Enum:[String]]
            for (key, value) in creditsListFrame.credits {
                if let credit = InvolvedPersonCredits(rawValue: key) {
                    dictionary[credit] = value
                }
            }
        }
        return dictionary
    }

    /// retrieve the `[role: [person]]` dictionary from the frame
    /// - Parameter frameKey: the unique identifier for the frame
    /// - Returns: the `[String: [String]]` dictionary of `[role: [person]]` pairs
    private func getPerformanceCredits() -> [MusicianAndPerformerCredits: [String]] {
        var dictionary = [MusicianAndPerformerCredits: [String]]()
        if let frame = self.frames[.musicianCreditsList],
            case .creditsListFrame(let creditsListFrame) = frame {
            // convert [String: [String]] to [Enum:[String]]
            for (key, value) in creditsListFrame.credits {
                if let credit = MusicianAndPerformerCredits(rawValue: key) {
                    dictionary[credit] = value
                }
            }
        }
        return dictionary
    }
    
    /// set the `[role: [person]]` dictionary for the frame
    /// - Parameters:
    ///   - credits: the dictionary of `[role: [person]]` pairs
    private mutating func set(involvementCredits: [InvolvedPersonCredits:[String]]) {
        var stringDict = [String: [String]]()
        for (key, value) in involvementCredits {
            let stringKey = key.rawValue
            stringDict[stringKey] = value
        }
        let frame = CreditsListFrame(.known(.involvedPeopleList),
                                     credits: stringDict)
        self.frames[.involvedPeopleList] = .creditsListFrame(frame)
    }

    /// set the `[role: [person]]` dictionary for the frame
    /// - Parameters:
    ///   - credits: the dictionary of `[role: [person]]` pairs
    private mutating func set(performanceCredits: [MusicianAndPerformerCredits:[String]]) {
        var stringDict = [String: [String]]()
        for (key, value) in performanceCredits {
            let stringKey = key.rawValue
            stringDict[stringKey] = value
        }
        let frame = CreditsListFrame(.known(.musicianCreditsList),
                                     credits: stringDict)
        self.frames[.musicianCreditsList] = .creditsListFrame(frame)
    }

    /// Getter-setter property for the dictionary of `[role: [person]]` pairs
    public var involvementCreditsList: [InvolvedPersonCredits:[String]] {
        get {
            return getInvolvementCredits()
        }
        set {
            if !newValue.isEmpty {
                var finalDictionary = [InvolvedPersonCredits:[String]]()
                for (key, value) in newValue {
                    if key == .arranger {
                        let string = value.joined(separator: "; ")
                        self.arranger = string
                    } else if key == .composer {
                        let string = value.joined(separator: "; ")
                        self.composer = string
                    } else if key == .conductor {
                        let string = value.joined(separator: "; ")
                        self.conductor = string
                    } else if key == .lyricist {
                        let string = value.joined(separator: "; ")
                        self.lyricist = string
                    } else if key == .publisher {
                        let string = value.joined(separator: "; ")
                        self.publisher = string
                    } else {
                        finalDictionary[key] = value
                    }
                }
                set(involvementCredits: finalDictionary)
            } else {
                self.frames[.involvedPeopleList] = nil
            }
        }
    }
    
    /// Getter-setter property for the dictionary of `[role: [person]]` pairs
    public var performanceCreditsList: [MusicianAndPerformerCredits:[String]] {
        get {
            return getPerformanceCredits()
        }
        set {
            if !newValue.isEmpty {
                var finalDictionary = [MusicianAndPerformerCredits:[String]]()
                for (key, value) in newValue {
                    if key == .artist {
                        let string = value.joined(separator: "; ")
                        self.artist = string
                    } else {
                        finalDictionary[key] = value
                    }
                }
                set(performanceCredits: finalDictionary)
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
        if var credit = performanceCreditsList[role], !credit.contains(person) {
            credit.append(person)
            performanceCreditsList[role] = credit
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
        if var credit = involvementCreditsList[role], !credit.contains(person) {
            credit.append(person)
            involvementCreditsList[role] = credit
        } else {
            involvementCreditsList[role] = [person]
        }
    }
    
    public mutating func clearPerformanceCreditList() {
        self.frames[.musicianCreditsList] = nil
    }
    
    public mutating func removePerformanceCredit(role: MusicianAndPerformerCredits) {
        self.performanceCreditsList[role] = nil
        switch role {
            case .artist: self.artist = nil
            default: break
        }
    }
    
    public mutating func clearInvolvementCreditList() {
        self.frames[.involvedPeopleList] = nil
    }
    
    public mutating func removeInvolvementCredit(role: InvolvedPersonCredits) {
        self.involvementCreditsList[role] = nil
        switch role {
            case .arranger: self.arranger = nil
            case .composer: self.composer = nil
            case .conductor: self.conductor = nil
            case .lyricist: self.lyricist = nil
            case .publisher: self.publisher = nil
            default: break
        }
    }
}
