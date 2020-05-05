//
//  PresetOptions.swift
//  SwiftTaggerID3
//
//  Created by Nolaine Crusher on 4/18/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation

enum PresetOption {
    case mediaType(MediaType)
    case genreType(GenreType)
    case fileType(FileType)
    
    init(presetName: String) {
        if let mediaType = MediaType(rawValue: presetName) {
            self = .mediaType(mediaType)
        } else if let fileType = FileType(rawValue: presetName) {
            self = .fileType(fileType)
        } else {
            self = .genreType(GenreType(rawValue: presetName) ?? .none)
        }
    }
    
    var rawValue: String {
        switch self {
            case .mediaType(let mediaType): return mediaType.rawValue
            case .genreType(let genreType): return genreType.rawValue
            case .fileType(let fileType): return fileType.rawValue
        }
    }
    
    var code: String {
        switch self {
            case .mediaType(let mediaType): return mediaType.rawValue
            case .genreType(let genreType): return String(genreType.code)
            case .fileType(let fileType): return fileType.rawValue
        }
    }
    
    static let codeToGenreTypeMapping: [Int: GenreType] = {
        var mapping: [Int: GenreType] = [:]
        for genre in GenreType.allCases {
            let id = genre.code
            mapping[id] = genre
        }
        return mapping
    }()
    
}

