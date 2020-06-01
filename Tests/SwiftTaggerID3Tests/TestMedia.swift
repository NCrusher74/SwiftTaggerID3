/*

 TestMedia.swift
 SwiftTaggerID3

 Copyright ©2020 Nolaine Crusher. All rights reserved.

 */

import Foundation
import SwiftTaggerID3

let testMediaDirectory = URL(fileURLWithPath: #file)
    .deletingLastPathComponent()
    .appendingPathComponent("TestMedia")

enum TestFile {
    case noMeta
    case v22
    case v23
    case v24
    case chapterized
    case nonMP3
    case sampleCover
    case sampleIcon
    case unknown
    
    var url: URL {
        switch self {
            case .v22:
                return testMediaDirectory
                    .appendingPathComponent("mp3-v22-with-meta.mp3")
            case .v23:
                return testMediaDirectory
                    .appendingPathComponent("mp3-v23-with-meta.mp3")
            case .v24:
                return testMediaDirectory
                    .appendingPathComponent("mp3-v24-with-meta.mp3")
            case .noMeta:
                return testMediaDirectory
                    .appendingPathComponent("mp3-nometa.mp3")
            case .chapterized:
                return testMediaDirectory
                    .appendingPathComponent("mp3-chapterized.mp3")
            case .nonMP3:
                return testMediaDirectory
                    .appendingPathComponent("not-an-mp3.m4a")
            case .sampleCover:
                return testMediaDirectory
                    .appendingPathComponent("samplecover-green.jpg")
            case .sampleIcon:
                return testMediaDirectory
                    .appendingPathComponent("sampleicon-green.png")
            case .unknown:
                return testMediaDirectory
                    .appendingPathComponent("mp3-unknownframes.mp3")
        }
    }
    
    func mp3File() throws -> Mp3File? {
        switch self {
            case .v22, .v23, .v24, .noMeta, .chapterized, .unknown: return try Mp3File(location: self.url)
            default: return nil
        }
    }
    
    func tag() throws -> Tag? {
        switch self {
            case .v22, .v23, .v24, .noMeta, .chapterized, .unknown:
                return try Tag(readFrom: self.mp3File() ?? Mp3File(location: self.url))
            default: return nil
        }
    }
    
    func data() throws -> Data? {
        switch self {
            case .v22, .v23, .v24, .noMeta, .chapterized, .unknown: return try Mp3File(location: self.url).data
            default: return nil
        }
    }

}

@available(OSX 10.12, *)
func tempDirectory() throws -> URL {
    let tempDirectory = FileManager.default.temporaryDirectory
        .appendingPathComponent("SwiftTaggerTemp",
                                isDirectory: true)
    try FileManager.default.createDirectory(
        at: tempDirectory,
        withIntermediateDirectories: true)
    return tempDirectory
}

@available(OSX 10.12, *)
func emptyDirectory() throws {
    try FileManager.default.removeItem(at: tempDirectory())
}

@available(OSX 10.12, *)
func localDirectory(fileName: String, fileExtension: String) throws -> URL {
    let home = FileManager.default.homeDirectoryForCurrentUser
    let desktopPath = "Desktop/TestOutput"
    let directory = home.appendingPathComponent(
        desktopPath, isDirectory: true)
    return directory.appendingPathComponent(fileName).appendingPathExtension(fileExtension)
}
