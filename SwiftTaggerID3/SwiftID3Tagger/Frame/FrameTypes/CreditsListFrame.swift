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
 handled as a dictionary: `[role : [array of people performing the role]]`
 */
struct CreditsListFrame: FrameProtocol {
    // MARK: Properties
    // inherited from FrameProtocol
    var flags: Data
    var layout: FrameLayoutIdentifier
    var frameKey: FrameKey
    var allowMultipleFrames: Bool = false
    
    /// The dictionary of `[role : [array of people performing the role]]`
    var credits: [ String : [String] ]
    
    // MARK: Frame parsing
    init(decodingContents contents: Data.SubSequence,
         version: Version,
         layout: FrameLayoutIdentifier,
         flags: Data) throws {
        self.flags = flags
        self.layout = layout
        
        if layout == .known(.involvedPeopleList) {
            self.frameKey = .involvedPeopleList
        } else {
            self.frameKey = .musicianCreditsList
        }
        
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
    
    // MARK: Frame building
    /// Initialize a frame building instance for a given layout
    /// - Parameters:
    ///   - layout: the frame layout
    ///   - credits: the credits dictionary
    init(layout: FrameLayoutIdentifier,
         credits: [ String: [String] ]) {
        self.layout = layout
        self.credits = credits
        self.flags = CreditsListFrame.defaultFlags
        
        if layout == .known(.involvedPeopleList) {
            self.frameKey = .involvedPeopleList
        } else {
            self.frameKey = .musicianCreditsList
        }
    }
    
    func encodeContents(version: Version) throws -> Data {
        var frameData = Data()
        // append encoding Byte
        frameData.append(StringEncoding.preferred.rawValue.encoding(
            endianness: .bigEndian))
        
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
    internal func dictionary(for frameKey: FrameKey) -> [ String: [String] ]? {
        if let frame = self.frames[frameKey],
            case .creditsListFrame(let creditsListFrame) = frame {
            return creditsListFrame.credits
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
                               to credits: [ String: [String] ]?) {
        let frame = CreditsListFrame(layout: layout, credits: credits ?? [:])
        self.frames[frameKey] = .creditsListFrame(frame)
    }
    
    /// Add a new [role:[person]] key-value pair, or, if the `role` already exists in the dictionary, append the person to the existing value for the `role` key
    /// - Parameters:
    ///   - role: the role being performed
    ///   - person: the person performing the role
    // TODO: if version is 2.2. or 2.3, make this an `involved person` entry instead?
    public mutating func addMusicianCredit(
        role: MusicianAndPerformerCredits, person: String) {
        var creditsList = musicianCreditsList
        let keys = creditsList?.keys
        
        #warning("why does this want a bool default?")
        if keys?.contains(role) ?? true {
            var arrayValue = creditsList?[role]
            arrayValue?.append(person)
        } else {
            creditsList?[role] = [person]
        }
    }
    
    /// Getter-setter property for the dictionary of `[role: [person]]` pairs
    public var musicianCreditsList: [MusicianAndPerformerCredits:[String]]? {
        get {
            var transformedDictionary: [MusicianAndPerformerCredits:[String]] = [:]
            if let credits = dictionary(for: .musicianCreditsList) {
                for credit in credits.keys {
                    let transformedCredit = MusicianAndPerformerCredits(rawValue: credit)
                    transformedDictionary[transformedCredit ?? .none] = credits[credit]
                    return transformedDictionary
                }
            }; return nil
        }
//        set {
//            var newDictionary = [String : [String] ]()
//            for key in newValue?.keys {
//                newDictionary[key.rawValue] = newValue?[key]
//            }
//            let frame = CreditsListFrame(layout: .known(.musicianCreditsList), credits: newDictionary)
//        }
    }
    
    /// Add a new [role:[person]] key-value pair, or, if the `role` already exists in the dictionary, append the person to the existing value for the `role` key
    /// - Parameters:
    ///   - role: the role being performed
    ///   - person: the person performing the role
    public mutating func addInvolvedPersonCredit(
        role: InvolvedPersonCredits, person: String) {
        var creditsList = involvedPeopleList
        let keys = creditsList?.keys
        
        #warning("why does this want a bool default?")
        if keys?.contains(role) ?? true {
            var arrayValue = creditsList?[role]
            arrayValue?.append(person)
        } else {
            creditsList?[role] = [person]
        }
    }
    
    /// Getter-setter property for the dictionary of `[role: [person]]` pairs
    public var involvedPeopleList: [InvolvedPersonCredits:[String]]? {
        get {
            var transformedDictionary: [InvolvedPersonCredits:[String]] = [:]
            if let credits = dictionary(for: .musicianCreditsList) {
                for credit in credits.keys {
                    let transformedCredit = InvolvedPersonCredits(rawValue: credit)
                    transformedDictionary[transformedCredit ?? .none] = credits[credit]
                    return transformedDictionary
                }
            }; return nil
        }
//        set {
//            var newDictionary = [String : [String] ]()
//            for key in newValue?.keys {
//                newDictionary[key.rawValue] = newValue[key]
//            }
//            let frame = CreditsListFrame(layout: .known(.involvedPeopleList), credits: newDictionary)
//        }
    }    
}
