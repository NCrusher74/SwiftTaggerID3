//
//  GenreTypes.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/11/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

public enum GenreType: Int, CaseIterable {
    case Blues = 0
    case ClassicRock = 1
    case Country = 2
    case Dance = 3
    case Disco = 4
    case Funk = 5
    case Grunge = 6
    case HipHop = 7
    case Jazz = 8
    case Metal = 9
    case NewAge = 10
    case Oldies = 11
    case Other = 12
    case Pop = 13
    case RandB = 14
    case Rap = 15
    case Reggae = 16
    case Rock = 17
    case Techno = 18
    case Industrial = 19
    case Alternative = 20
    case Ska = 21
    case DeathMetal = 22
    case Pranks = 23
    case Soundtrack = 24
    case EuroTechno = 25
    case Ambient = 26
    case TripHop = 27
    case Vocal = 28
    case JazzAndFunk = 29
    case Fusion = 30
    case Trance = 31
    case Classical = 32
    case Instrumental = 33
    case Acid = 34
    case House = 35
    case Game = 36
    case SoundClip = 37
    case Gospel = 38
    case Noise = 39
    case AltRock = 40
    case Bass = 41
    case Soul = 42
    case Punk = 43
    case Space = 44
    case Meditative = 45
    case InstrumentalPop = 46
    case InstrumentalRock = 47
    case Ethnic = 48
    case Gothic = 49
    case Darkwave = 50
    case TechnoIndustrial = 51
    case Electronic = 52
    case PopFolk = 53
    case Eurodance = 54
    case Dream = 55
    case SouthernRock = 56
    case Comedy = 57
    case Cult = 58
    case GangstaRap = 59
    case Top40 = 60
    case ChristianRap = 61
    case PopFunk = 62
    case Jungle = 63
    case NativeAmerican = 64
    case Cabaret = 65
    case NewWave = 66
    case Psychedelic = 67
    case Rave = 68
    case Showtunes = 69
    case Trailer = 70
    case LoFi = 71
    case Tribal = 72
    case AcidPunk = 73
    case AcidJazz = 74
    case Polka = 75
    case Retro = 76
    case Musical = 77
    case RockAndRoll = 78
    case HardRock = 79
    case Folk = 80
    case FolkRock = 81
    case NationalFolk = 82
    case Swing = 83
    case FastFusion = 84
    case Bebop = 85
    case Latin = 86
    case Revival = 87
    case Celtic = 88
    case Bluegrass = 89
    case Avantgarde = 90
    case GothicRock = 91
    case ProgressiveRock = 92
    case PsychedelicRock = 93
    case SymphonicRock = 94
    case SlowRock = 95
    case BigBand = 96
    case Chorus = 97
    case EasyListening = 98
    case Acoustic = 99
    case Humour = 100
    case Speech = 101
    case Chanson = 102
    case Opera = 103
    case ChamberMusic = 104
    case Sonata = 105
    case Symphony = 106
    case BootyBass = 107
    case Primus = 108
    case PornGroove = 109
    case Satire = 110
    case SlowJam = 111
    case Club = 112
    case Tango = 113
    case Samba = 114
    case Folklore = 115
    case Ballad = 116
    case PowerBallad = 117
    case RhythmicSoul = 118
    case Freestyle = 119
    case Duet = 120
    case PunkRock = 121
    case DrumSolo = 122
    case ACappella = 123
    case EuroHouse = 124
    case DanceHall = 125
    case Goa = 126
    case DrumAndBass = 127
    case ClubHouse = 128
    case Hardcore = 129
    case Terror = 130
    case Indie = 131
    case BritPop = 132
    case AfroPunk = 133
    case PolskPunk = 134
    case Beat = 135
    case ChristianGangstaRap = 136
    case HeavyMetal = 137
    case BlackMetal = 138
    case Crossover = 139
    case ContemporaryChristian = 140
    case ChristianRock = 141
    case Merengue = 142
    case Salsa = 143
    case ThrashMetal = 144
    case Anime = 145
    case JPop = 146
    case Synthpop = 147
    case Abstract = 148
    case ArtRock = 149
    case Baroque = 150
    case Bhangra = 151
    case BigBeat = 152
    case Breakbeat = 153
    case Chillout = 154
    case Downtempo = 155
    case Dub = 156
    case EBM = 157
    case Eclectic = 158
    case Electro = 159
    case Electroclash = 160
    case Emo = 161
    case Experimental = 162
    case Garage = 163
    case Global = 164
    case IDM = 165
    case Illbient = 166
    case IndustroGoth = 167
    case JamBand = 168
    case Krautrock = 169
    case Leftfield = 170
    case Lounge = 171
    case MathRock = 172
    case NewRomantic = 173
    case NuBreakz = 174
    case PostPunk = 175
    case PostRock = 176
    case Psytrance = 177
    case Shoegaze = 178
    case SpaceRock = 179
    case TropRock = 180
    case WorldMusic = 181
    case Neoclassical = 182
    case Audiobook = 183
    case AudioTheatre = 184
    case NeueDeutscheWelle = 185
    case Podcast = 186
    case IndieRock = 187
    case GFunk = 188
    case Dubstep = 189
    case GarageRock = 190
    case Psybient = 191
    case None = 255
    case Remix = 256
    case Cover = 257
    
    static var RX: GenreType { return .Remix }
    static var CR: GenreType { return .Cover }
}
