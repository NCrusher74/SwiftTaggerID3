//
//  MediaTypes.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/17/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

enum MediaType: String, CaseIterable {
    
    case otherDigitalMedia = "DIG"
    case otherAnalogMedia = "ANA"
    case compactDisc = "CD"
    case laserDisc = "LD"
    case turntableRecords = "TT"
    case miniDisc = "MD"
    case DAT = "DAT"
    case DCC = "DCC"
    case DVD = "DVD"
    case television = "TV"
    case video = "VID"
    case radio = "RAD"
    case telephone = "TEL"
    case normalCassette = "MC"
    case reel = "REE"
    case none
    
    func refinement(refinement: MediaTypeRefinement) -> MediaTypeRefinement {
        switch self {
            case .otherDigitalMedia:
                return .analogTransferFromMedia
            case .otherAnalogMedia:
                switch refinement {
                    case .waxCylinder: return .waxCylinder
                    case .eightTrackTapeCassette: return .eightTrackTapeCassette
                    default: break
            }
            case .compactDisc:
                switch refinement {
                    case .analogTransferFromMedia: return .analogTransferFromMedia
                    case .DDD: return .DDD
                    case .ADD: return .ADD
                    case .AAD: return .AAD
                    default: break
            }
            case .laserDisc:
                break
            case .turntableRecords:
                switch refinement {
                    case .thirtythreeRPM: return .thirtythreeRPM
                    case .fortyFiveRPM: return .fortyFiveRPM
                    case .seventyOneRPM: return .seventyOneRPM
                    case .seventySixRPM: return .seventySixRPM
                    case .seventyEightRPM: return .seventyEightRPM
                    case .eightyRPM: return .eightyRPM
                    default: break
            }
            case .miniDisc:
                return .analogTransferFromMedia
            case .DAT:
                switch refinement {
                    case .analogTransferFromMedia: return .analogTransferFromMedia
                    case .standard: return .standard
                    case .modeTwo: return .modeTwo
                    case .modeThree: return .modeThree
                    case .modeFour: return .modeFour
                    case .modeFive: return .modeFive
                    case .modeSix: return .modeSix
                    default: break
            }
            case .DCC:
                return .analogTransferFromMedia
            case .DVD:
                return .analogTransferFromMedia
            case .television:
                switch refinement {
                    case .PAL: return .PAL
                    case .NTSC: return .NTSC
                    case .SECAM: return .SECAM
                    default: break
            }
            case .video:
                switch refinement {
                    case .PAL: return .PAL
                    case.NTSC: return .NTSC
                    case.SECAM: return .SECAM
                    case.VHS: return .VHS
                    case.SVHS: return .SVHS
                    case.betamax: return .betamax
                    default: break
            }
            case .radio:
                switch refinement {
                    case .AM: return .AM
                    case.FM: return .FM
                    case.LW: return .LW
                    case.MW: return .MW
                    default: break
            }
            case .telephone:
                return .ISDN
            case .normalCassette:
                switch refinement {
                    case .normalSpeedCassette: return .normalSpeedCassette
                    case .doubleSpeedCassette: return .doubleSpeedCassette
                    case .typeIcassette: return .typeIcassette
                    case .typeIIcassette: return .typeIIcassette
                    case .typeIIIcassette: return .typeIIIcassette
                    case .typeIVcassette: return .typeIVcassette
                    default: break
            }
            case .reel:
                switch refinement {
                    case .nineCMs: return .nineCMs
                    case .nineteenCMs: return .nineteenCMs
                    case .thirtyEightCMs: return .thirtyEightCMs
                    case .seventySixCMs: return .seventySixCMs
                    case .typeIcassette: return .typeIcassette
                    case .typeIIcassette: return .typeIIcassette
                    case .typeIIIcassette: return .typeIIIcassette
                    case .typeIVcassette: return .typeIVcassette
                    default: break
            }
            case .none:
                break
        }; return MediaTypeRefinement.none
    }    
}



enum MediaTypeRefinement: String {
    case analogTransferFromMedia = "/A"
    // analog media refinements
    case waxCylinder = "/WAC"
    case eightTrackTapeCassette = "/8CA"
    // cd refinements
    case DDD = "/DD"
    case ADD = "/AD"
    case AAD = "/AA"
    // turntable refinements
    case thirtythreeRPM = "/33"
    case fortyFiveRPM = "/45"
    case seventyOneRPM = "/71"
    case seventySixRPM = "/76"
    case seventyEightRPM = "/78"
    case eightyRPM = "/80"
    // DAT refinements
    /// standard, 48 kHz/16 bits, linear
    case standard = "/1"
    /// mode 2, 32 kHz/16 bits, linear
    case modeTwo = "/2"
    /// mode 3, 32 kHz/12 bits, nonlinear, low speed
    case modeThree = "/3"
    /// mode 4, 32 kHz/12 bits, 4 channels
    case modeFour = "/4"
    /// mode 5, 44.1 kHz/16 bits, linear
    case modeFive = "/5"
    /// mode 6, 44.1 kHz/16 bits, 'wide track' play
    case modeSix = "/6"
    // television refinements
    case PAL = "/PAL"
    case NTSC = "/NTSC"
    case SECAM = "/SECAM"
    // video refinements (plus television refinements)
    case VHS = "/VHS"
    case SVHS = "/SVHS"
    case betamax = "/BETA"
    // radio refinments
    case FM = "/FM"
    case AM = "/AM"
    case LW = "/LW"
    case MW = "/MW"
    // cassette refinements
    /// 9 cm/s
    case doubleSpeedCassette = "/9"
    /// Type I cassette (ferric/normal)
    case typeIcassette = "/I"
    /// Type II cassette (chrome)
    case typeIIcassette = "/II"
    /// Type III cassette (ferric chrome)
    case typeIIIcassette = "/III"
    /// Type IV cassette (metal)
    case typeIVcassette = "IV"
    // reel refinements
    /// 19 cm/s
    case nineteenCMs = "/19"
    /// 38 cm/s
    case thirtyEightCMs = "/38"
    case none
    
    /// 9.5 CM/s for reel cassette
    static var nineCMs: MediaTypeRefinement {
        return MediaTypeRefinement(rawValue: "/9") ?? .none
    }
    
    /// 76 CM/s for reel cassette
    static var seventySixCMs: MediaTypeRefinement {
        return MediaTypeRefinement(rawValue: "/76") ?? .none
    }
    /// 4.75 cm/s (normal speed for a two sided cassette)
    static var normalSpeedCassette: MediaTypeRefinement {
        return MediaTypeRefinement(rawValue: "/4") ?? .none
    }
    
    static var ISDN: MediaTypeRefinement {
        return MediaTypeRefinement(rawValue: "/I") ?? .none
    }
}
