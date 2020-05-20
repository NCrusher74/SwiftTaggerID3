/*

 ImageTypes.swift
 SwiftTaggerID3

 Copyright ©2020 Nolaine Crusher. All rights reserved.

 */

import Foundation

/**
 An enum that describes the format of a supported attached image.
 */
enum ImageFormat: String {
    case jpg
    case png
}

/**
 An enum that describes the ID3 picture type supported.
 */
public enum ImageType: UInt8 {
    /// Other image.
    case Other = 0x00
    /// File icon image.
    case fileIcon = 0x01
    /// Other file icon image.
    case OtherFileIcon = 0x02
    /// Front cover image.
    case FrontCover = 0x03
    /// Back cover image.
    case BackCover = 0x04
    /// LeafketPage image.
    case LeafletPage = 0x05
    /// Media image.
    case Media = 0x06
    /// Lead artist image image.
    case LeadArtistLeadPerformerSoloist = 0x07
    /// Artist image image.
    case ArtistPerformer = 0x08
    /// Conductor image.
    case Conductor = 0x09
    /// Orchestra/band image.
    case BandOrchestra = 0x0A
    /// Composer image.
    case Composer = 0x0B
    /// Lyricist Text Writer image.
    case LyricistTextWriter = 0x0C
    /// Recording location image.
    case RecordingLocation = 0x0D
    /// During recording image.
    case DuringRecording = 0x0E
    /// Performance image.
    case DuringPerformance = 0x0F
    /// Movie image.
    case MovieVideoScreenCapture = 0x10
    /// ABrightColouredFish image.
    case ABrightColouredFish = 0x11
    /// Illustration image.
    case Illustration = 0x12
    /// Band logo image.
    case BandArtistLogotype = 0x13
    /// Publisher logo image.
    case PublisherStudioLogotype = 0x14

    var pictureDescription: String {
        switch self {
            case .Other: return "Other Image"
            case .fileIcon: return "File Icon"
            case .OtherFileIcon: return "Other File Icon"
            case .FrontCover: return "Front Cover"
            case .BackCover: return "Back Cover"
            case .LeafletPage: return "Leaflet Page"
            case .Media: return "Media"
            case .LeadArtistLeadPerformerSoloist: return "Lead Artist/Performer"
            case .ArtistPerformer: return "Artist/Performer"
            case .Conductor: return "Conductor"
            case .BandOrchestra: return "Band/Orchestra"
            case .Composer: return "Composer"
            case .LyricistTextWriter: return "Lyricist/Writer"
            case .RecordingLocation: return "Recording Location"
            case .DuringRecording: return "Production Still"
            case .DuringPerformance: return "Performance Still"
            case .MovieVideoScreenCapture: return "Screen Capture"
            case .ABrightColouredFish: return "A Brightly Colored Fish"
            case .Illustration: return "Illustration"
            case .BandArtistLogotype: return "Band/Artist Logo"
            case .PublisherStudioLogotype: return "Publisher/Studio Logo"
        }
    }
}
