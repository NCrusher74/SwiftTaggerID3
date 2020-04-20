//
//  MediaType.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/18/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

public enum MediaType: String, CaseIterable {
    
    case otherDigital = "Other digital media"
    case otherAnalog = "Other analogue media"
    case compactDisc = "Compact Disc"
    case laserdisc = "Laserdisc"
    case minidisc = "Minidisc"
    case dcc = "DCC"
    case dat = "DAT"
    case turntableRecord = "Turntable records"
    case dvd = "DVD"
    case television = "Television"
    case video = "Video"
    case radio = "Radio"
    case telephone = "Telephone"
    case normalCassette = "Normal Cassette"
    case reel = "Reel"
    case none = ""
    
    public var code: String {
        switch self {
            case .otherDigital: return "DIG"
            case .otherAnalog: return "ANA"
            case .compactDisc: return "CD"
            case .laserdisc: return "LD"
            case .minidisc: return "MD"
            case .dcc: return "DCC"
            case .dat: return "DAT"
            case .turntableRecord: return "TT"
            case .dvd: return "DVD"
            case .television: return "TV"
            case .video: return "VID"
            case .radio: return "RAD"
            case .telephone: return "TEL"
            case .normalCassette: return "MC"
            case .reel: return "REE"
            case .none: return ""
        }
    }
    
    public static let codeToNameMapping: [String: String] = {
        var mapping: [String: String] = [:]
        for mediaType in MediaType.allCases {
            let id = mediaType.code
            mapping[id] = mediaType.rawValue
        }
        return mapping
    }()
}

public enum MediaTypeRefinements: String, CaseIterable {
    
    case analogTransfer = "Analog transfer from media"
    case waxCylinder = "Wax cylinder"
    case eightTrack = "8-track tape cassette"
    case ddd = "DDD"
    case add = "ADD"
    case aad = "AAD"
    case thirtyThreeRPM = "33.33 rpm"
    case fortyFiveRPM = "45 rpm"
    case seventyOneRPM = "71.29 rpm"
    case seventySixRPM = "76.59 rpm"
    case seventyEightRPM = "78.26 rpm"
    case eightyRPM = "80 RPM"
    case standardDAT = "standard, 48 kHz/16 bits, linear"
    case modeTwoDAT = "mode 2, 32 kHz/16 bits, linear"
    case modeThreeDAT = "mode 3, 32 kHz/12 bits, non-linear, low speed"
    case modeFourDAT = "mode 4, 32 kHz/12 bits, 4 channels"
    case modeFiveDAT = "mode 5, 44.1 kHz/16 bits, linear"
    case modeSixDAT = "mode 6, 44.1 kHz/16 bits, 'wide track' play"
    case pal = "PAL"
    case ntsc = "NTSC"
    case secam = "SECAM"
    case vhs = "VHS"
    case svhs = "S-VHS"
    case betamax = "Betamax"
    case am = "AM"
    case fm = "FM"
    case lw = "LW"
    case mw = "MW"
    case isdn = "ISDN"
    case normalSpeed = "4.75 cm/s (normal speed for a two sided cassette)"
    case nineCMS = "9.5 cm/s"
    case nineteenCMS = "19 cm/s"
    case thirtyEightCMS = "38 cm/s"
    case seventySixCMS = "76 cm/s"
    case typeI = "Type I cassette (ferric/normal)"
    case typeII = "Type II cassette (chrome)"
    case typeIII = "Type III cassette (ferric chrome)"
    case typeIV = "Type IV cassette (metal)"
    case none = ""
    
    public var code: String {
        switch self {
            case .analogTransfer: return "/A"
            case .waxCylinder: return "/WC"
            case .eightTrack: return "/8CA"
            case .ddd: return "/DD"
            case .add: return "/AD"
            case .aad: return "/AA"
            case .thirtyThreeRPM: return "/33"
            case .fortyFiveRPM: return "/45"
            case .seventyOneRPM: return "/71"
            case .seventySixRPM: return "/76"
            case .seventyEightRPM: return "/78"
            case .eightyRPM: return "/80"
            case .standardDAT: return "/1"
            case .modeTwoDAT: return "/2"
            case .modeThreeDAT: return "/3"
            case .modeFourDAT: return "/4"
            case .modeFiveDAT: return "/5"
            case .modeSixDAT: return "/6"
            case .pal: return "/PAL"
            case .ntsc: return "/NTSC"
            case .secam: return "/SECAM"
            case .vhs: return "/VHS"
            case .svhs: return "/SVHS"
            case .betamax: return "/BETA"
            case .am: return "/AM"
            case .fm: return "/FM"
            case .lw: return "/LW"
            case .mw: return "/MW"
            case .isdn: return "/ISDN"
            case .normalSpeed: return "/4"
            case .nineCMS: return "/9"
            case .nineteenCMS: return "/19"
            case .thirtyEightCMS: return "/38"
            case .seventySixCMS: return "/76"
            case .typeI: return "/I"
            case .typeII: return "/II"
            case .typeIII: return "/III"
            case .typeIV: return "/IV"
            case .none: return ""
        }
    }
    
    public static let codeToTypeMapping: [String: String] = {
        var mapping: [String: String] = [:]
        for refinement in MediaTypeRefinements.allCases {
            let id = refinement.code
            mapping[id] = refinement.rawValue
        }
        return mapping
    }()
}
