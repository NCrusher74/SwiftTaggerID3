//
//  PresetOptions.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/18/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

enum PresetOption {
    case mediaType(MediaType)
    case genreType(GenreType)
    
    init(presetName: String) {
        if let mediaType = MediaType(rawValue: presetName) {
            self = .mediaType(mediaType)
        } else {
            self = .genreType(GenreType(rawValue: presetName) ?? .none)
        }
    }
    
    var rawValue: String {
        switch self {
            case .mediaType(let mediaType): return mediaType.rawValue
            case .genreType(let genreType): return genreType.rawValue
        }
    }
    
    var code: String {
        switch self {
            case .mediaType(let mediaType): return mediaType.code
            case .genreType(let genreType): return String(genreType.code)
        }
    }
}

