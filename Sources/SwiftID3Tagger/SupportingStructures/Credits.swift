//
//  File.swift
//  
//
//  Created by Nolaine Crusher on 8/22/20.
//

import Foundation

struct Credits {
    var involvementList: [InvolvedPersonCredits: [String]]
    var performanceList: [MusicianAndPerformerCredits: [String]]
    var involvementStringList: [String: [String]]
    var performanceStringList: [String: [String]]
    
    init(frame: CreditsListFrame, frameKey: FrameKey) {
        let credits = frame.credits
        var involvement = [InvolvedPersonCredits: [String]]()
        var performance = [MusicianAndPerformerCredits: [String]]()
        var performanceStringList = [String: [String]]()
        var involvementStringList = [String: [String]]()
        switch frameKey {
            case .musicianCreditsList:
                performanceStringList = credits
                for (key, value) in credits {
                    if let credit = MusicianAndPerformerCredits(rawValue: key) {
                        performance[credit] = value
                    }
            }
            case .involvedPeopleList:
                involvementStringList = credits
                for (key, value) in credits {
                    if let credit = InvolvedPersonCredits(rawValue: key) {
                        involvement[credit] = value
                    }
            }
            default: break
        }
        self.involvementStringList = involvementStringList
        self.performanceStringList = performanceStringList
        self.involvementList = involvement
        self.performanceList = performance
    }
    
    init(from list: [InvolvedPersonCredits: [String]]) {
        self.involvementList = list
        var stringList = [String: [String]]()
        for (key, value) in list {
            stringList[key.rawValue] = value
        }
        self.involvementStringList = stringList
        self.performanceStringList = [:]
        self.performanceList = [:]
    }
    
    init(from list: [MusicianAndPerformerCredits: [String]]) {
        self.performanceList = list
        var stringList = [String: [String]]()
        for (key, value) in list {
            stringList[key.rawValue] = value
        }
        self.involvementStringList = [:]
        self.performanceStringList = stringList
        self.involvementList = [:]
    }
}
