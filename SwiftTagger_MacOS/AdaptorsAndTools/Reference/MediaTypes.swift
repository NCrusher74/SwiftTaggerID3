//
//  MediaTypes.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/17/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

enum MediaTypes: String {
    
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
    
}



enum MediaTypeRefinements: String {
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
    // OR 76 cm/s for reel cassette
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
    /// OR 4.75 cm/s (normal speed for a two sided cassette)
    case modeFour = "/4"
    /// mode 5, 44.1 kHz/16 bits, linear
    case modeFive = "/5"
    /// mode 6, 44.1 kHz/16 bits, 'wide track' play
    case modeSix = "/6"
    // television refinements
    case PAL = "/PAL"
    case NTSC = "/NTSC"
    case SECAM = "/SECAM"
    // video refinements
    case VHS = "/VHS"
    case SVHS = "/SVHS"
    case betamax = "/BETA"
    // radio refinments
    case FM = "/FM"
    case AM = "/AM"
    case LW = "/LW"
    case MW = "/MW"
    // cassette refinements
    case doubleSpeed = "/9"
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
}
