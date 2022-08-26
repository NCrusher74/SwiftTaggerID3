//
//  CreditsFrame.swift
//  SwiftTaggerID3
//
//  Created by Nolaine Crusher on 9/18/20.
//

/*
/////  v2.2 and 2.3 /////
 Since there might be a lot of people contributing to an audio file in
 various ways, such as musicians and technicians, the 'Text
 information frames' are often insufficient to list everyone involved
 in a project. The 'Involved people list' is a frame containing the
 names of those involved, and how they were involved. The body simply
 contains a terminated string with the involvement directly followed by
 a terminated string with the involvee followed by a new involvement
 and so on. There may only be one "IPL" frame in each tag.
 
 Involved people list   "IPL"
 Frame size             $xx xx xx
 Text encoding          $xx
 People list strings    <textstrings>

 v2.4:
 TMCL
 The 'Musician credits list' is intended as a mapping between
 instruments and the musician that played it. Every odd field is an
 instrument and every even is an artist or a comma delimited list of
 artists.
 
 TIPL
 The 'Involved people list' is very similar to the musician credits
 list, but maps between functions, like producer, and names.
 */
import Foundation

/// A type used to represent an ID3 involved peeople list or musician credits frame.
///
/// Handled as a dictionary: `[role : [array of people performing the role]]`
class CreditsFrame: Frame {
    override var description: String {
        var string = String()
        let sorted = credits.sorted(by: {$0.key < $1.key})
        
        for (key, value) in sorted.dropLast() {
            let joined = key + " = " + value.joined(separator: "; ") + " // "
            string.append(joined)
        }
        
        if let last = sorted.last {
            let joined = last.key + " = " + last.value.joined(separator: "; ")
            string.append(joined)
        }
        return string
    }
    
    /// The dictionary of `[role : [array of people performing the role]]`
    var credits: [ String : [String] ]
    
    init(identifier: FrameIdentifier,
         version: Version,
         size: Int,
         flags: Data,
         payload: Data
    ) throws {
        var data = payload
        let encoding = try data.extractEncoding()
        self.credits = try data.extractAndDecodeCreditString(encoding: encoding)
        super.init(identifier: identifier,
                  version: version,
                  size: size,
                  flags: flags)
    }
    
    private static func encoding(credits: [ String : [String] ]) -> String.Encoding {
        for (key, value) in credits {
            let joined = key + value.joined()
            if String.Encoding(string: joined) != .isoLatin1 {
                return .utf16
            }
        }
        return .isoLatin1
    }
    
    override var contentData: Data {
        if credits.isEmpty {
            return Data()
        } else {
            var data = Data()
            
            // append encoding Byte
            let encoding = CreditsFrame.encoding(credits: credits)
            data.append(encoding.encodingByte)
            
            // encode and append each credit
            for (key, value) in credits {
                data.append(key.attemptTerminatedStringEncoding(encoding))
                let valueString = value.joined(separator: ",")
                data.append(valueString.attemptTerminatedStringEncoding(encoding))
            }
            return data
        }
    }
    
    // MARK: - Frame building
    /// Initialize a frame building instance for a given layout
    /// - Parameters:
    ///   - layout: the frame layout
    ///   - credits: the credits dictionary
    init(_ identifier: FrameIdentifier,
         version: Version,
         credits: [ String: [String] ]) {
        self.credits = credits
        let flags = version.defaultFlags
        
        let encoding = CreditsFrame.encoding(credits: credits)

        var size = 1 // encoding byte
        
        for (key, value) in credits {
            size += key.attemptTerminatedStringEncoding(encoding).count
            let valueString = value.joined(separator: ",")
            size += valueString.attemptTerminatedStringEncoding(encoding).count
        }
        
        super.init(identifier: identifier,
                   version: version,
                   size: size,
                   flags: flags)
    }
}

// MARK: - Tag extension
extension Tag {
    /// Getter-setter property for the dictionary of `[role: [person]]` pairs for the `involvedPeopleList` (`IPL/IPLS/TIPL`) frame
    public var involvementCreditsList: [InvolvedPersonCredits:[String]] {
        get {
            return involvementCredits
        }
        set {
            let identifier = FrameIdentifier.involvedPeopleList
            let frameKey = identifier.frameKey

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
                self.frames[frameKey] = nil
            }
        }
    }
    
    /// Getter-setter property for the dictionary of `[role: [person]]` pairs for the `musicianCreditsList` (`TMCL`) frame
    public var musicianCreditsList: [MusicianAndPerformerCredits:[String]] {
        get {
            return musicianCredits
        }
        set {
            let identifier = FrameIdentifier.musicianCreditsList
            let frameKey = identifier.frameKey

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
                set(musicianCredits: finalDictionary)
            } else {
                self.frames[frameKey] = nil
            }
        }
    }
    
    /// Add a new [role:[person]] key-value pair to the `musicianCreditsList` (`TMCL`) dictionary, or, if the `role` already exists, append the person to the existing value for the `role` key
    /// - Parameters:
    ///   - role: the role being performed
    ///   - person: the person performing the role
    // TODO: if version is 2.2. or 2.3, make this an `involved person` entry instead?
    public mutating func addMusicianCredit(
        role: MusicianAndPerformerCredits, person: String) {
        if var credit = musicianCreditsList[role], !credit.contains(person) {
            credit.append(person)
            musicianCreditsList[role] = credit
        } else {
            musicianCreditsList[role] = [person]
        }
    }
    
    /// Add a new [role:[person]] key-value pair `involvedPeopleList` (`IPL/IPLS/TIPL`) dictionary, or, if the `role` already exists, append the person to the existing value for the `role` key
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
    
    /// Removes ALL values from the `musicianCreditList` atom.
    public mutating func clearMusicianCreditList() {
        let frameKey = FrameIdentifier.musicianCreditsList.frameKey
        self.frames[frameKey] = nil
    }
    
    /// Removes the value for a specific role from the `musicianCreditList` frame
    public mutating func removeMusicianCredit(role: MusicianAndPerformerCredits) {
        self.musicianCreditsList[role] = nil
        switch role {
            case .artist: self.artist = nil
            default: break
        }
    }
    
    /// Removes ALL values from the `involvedPeopleList` atom
    public mutating func clearInvolvementCreditList() {
        let frameKey = FrameIdentifier.involvedPeopleList.frameKey
        self.frames[frameKey] = nil
    }
    
    /// Removes the value for a specific role from the `involvedPeopleList` frame
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
    
    // MARK: - Private and Internal
    /// Retrieves the `involvedPeopleList` (`IPL/IPLS/TIPL`) frame  as a `[role: [person]]` dictionary
    /// - Returns: the `[String: [String]]` dictionary of `[role: [person]]` pairs
    private var involvementCredits: [InvolvedPersonCredits: [String]] {
        let identifier = FrameIdentifier.involvedPeopleList
        let frameKey = identifier.frameKey
        
        var dictionary = [InvolvedPersonCredits: [String]]()
        if let frame = self.frames[frameKey] as? CreditsFrame {
            // convert [String: [String]] to [Enum:[String]]
            for (key, value) in frame.credits {
                if let credit = InvolvedPersonCredits(rawValue: key) {
                    dictionary[credit] = value
                }
            }
        }
        return dictionary
    }
    
    /// Retrieves the `musicianCreditsList` (`TMCL`) frame  as a `[role: [person]]` dictionary
    /// - Returns: the `[String: [String]]` dictionary of `[role: [person]]` pairs
    private var musicianCredits: [MusicianAndPerformerCredits: [String]] {
        let identifier = FrameIdentifier.musicianCreditsList
        let frameKey = identifier.frameKey
        
        var dictionary = [MusicianAndPerformerCredits: [String]]()
        if let frame = self.frames[frameKey] as? CreditsFrame {
            // convert [String: [String]] to [Enum:[String]]
            for (key, value) in frame.credits {
                if let credit = MusicianAndPerformerCredits(rawValue: key) {
                    dictionary[credit] = value
                }
            }
        }
        return dictionary
    }
    
    mutating func importCreditsFrame(id: FrameIdentifier, stringValue: String) {
        var parts = stringValue.components(separatedBy: " // ")
        
        if id == .involvedPeopleList {
            var dictionary = [InvolvedPersonCredits:[String]]()
            while !parts.isEmpty {
                var components = parts.extractFirst().components(separatedBy: " = ")
                guard components.count >= 2 else {
                    continue
                }
                
                let involvementString = components.extractFirst()
                if let involvement = InvolvedPersonCredits(rawValue: involvementString) {
                    let creditsArray = components.extractFirst().components(separatedBy: "; ")
                    dictionary[involvement] = creditsArray
                }
            }
            set(involvementCredits: dictionary)
        } else if id == .musicianCreditsList {
            var dictionary = [MusicianAndPerformerCredits:[String]]()
            while !parts.isEmpty {
                var components = parts.extractFirst().components(separatedBy: " = ")
                guard components.count >= 2 else {
                    continue
                }
                
                let involvementString = components.extractFirst()
                if let involvement = MusicianAndPerformerCredits(rawValue: involvementString) {
                    let creditsArray = components.extractFirst().components(separatedBy: "; ")
                    dictionary[involvement] = creditsArray
                }
            }
            set(musicianCredits: dictionary)
        }
    }
    
    /// set the `[role: [person]]` dictionary for the `involvedPeopleList` frame
    /// - Parameter credits: the dictionary of `[role: [person]]` pairs
    private mutating func set(involvementCredits: [InvolvedPersonCredits:[String]]) {
        let identifier = FrameIdentifier.involvedPeopleList
        let frameKey = identifier.frameKey
        
        var stringDict = [String: [String]]()
        for (key, value) in involvementCredits {
            let stringKey = key.rawValue
            stringDict[stringKey] = value
        }
        let frame = CreditsFrame(identifier,
                                     version: self.version,
                                     credits: stringDict)
        self.frames[frameKey] = frame
    }
    
    /// set the `[role: [person]]` dictionary for the `musicianCreditsList` frame
    /// - Parameter credits: the dictionary of `[role: [person]]` pairs
    private mutating func set(musicianCredits: [MusicianAndPerformerCredits:[String]]) {
        let identifier = FrameIdentifier.musicianCreditsList
        let frameKey = identifier.frameKey
        
        var stringDict = [String: [String]]()
        for (key, value) in musicianCredits {
            let stringKey = key.rawValue
            stringDict[stringKey] = value
        }
        let frame = CreditsFrame(identifier,
                                     version: self.version,
                                     credits: stringDict)
        self.frames[frameKey] =  frame
    }
}
