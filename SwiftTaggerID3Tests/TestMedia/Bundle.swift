
import Foundation

@testable import SwiftTaggerID3

extension Bundle {
    
    /// A class defined in the test bundle that can be used to find it.
    private class BundleMarker {}
    
    /// The bundle which houses the tests.
    static let testBundle = Bundle(for: BundleMarker.self)

    // Mark: No Meta
    static let noMeta: URL = {
        guard let location = testBundle.url(forResource: "mp3-nometa", withExtension: "mp3") else {
            fatalError("test file does not exist.")
        }
        return location
    }()
    
    static func mp3NoMeta() throws -> Mp3File {
        let mp3File = try Mp3File(location: noMeta)
        return mp3File
    }
    
    static func dataNoMeta() throws -> Data {
        let mp3File = try Mp3File(location: noMeta)
        return mp3File.data
    }
    
    static func tagNoMeta() throws -> Tag {
        let tag = try Tag(readFrom: mp3NoMeta())
        return tag
    }
    
    // MARK: v22
    static let v22File: URL = {
        guard let location = testBundle.url(forResource: "mp3-v22-with-meta", withExtension: "mp3") else {
            fatalError("test file does not exist.")
        }
        return location
    }()
    
    static func mp3v22() throws -> Mp3File {
        let mp3File = try Mp3File(location: v22File)
        return mp3File
    }
    
    static func datav22() throws -> Data {
        let mp3File = try Mp3File(location: v22File)
        return mp3File.data
    }
    
    static func tagV22() throws -> Tag {
        let tag = try Tag(readFrom: mp3v22())
        return tag
    }

    // MARK: v23
    static let v23File: URL = {
        guard let location = testBundle.url(forResource: "mp3-v23-with-meta", withExtension: "mp3") else {
            fatalError("test file does not exist.")
        }
        return location
    }()
    
    static func mp3v23() throws -> Mp3File {
        let mp3File = try Mp3File(location: v23File)
        return mp3File
    }
    
    static func datav23() throws -> Data {
        let mp3File = try Mp3File(location: v23File)
        return mp3File.data
    }
    
    static func tagV23() throws -> Tag {
        let tag = try Tag(readFrom: mp3v23())
        return tag
    }

    // MARK: v24
    static let v24File: URL = {
        guard let location = testBundle.url(forResource: "mp3-v24-with-meta", withExtension: "mp3") else {
            fatalError("test file does not exist.")
        }
        return location
    }()
    
    static func mp3v24() throws -> Mp3File {
        let mp3File = try Mp3File(location: v24File)
        return mp3File
    }
    
    static func datav24() throws -> Data {
        let mp3File = try Mp3File(location: v24File)
        return mp3File.data
    }
    
    static func tagV24() throws -> Tag {
        let tag = try Tag(readFrom: mp3v24())
        return tag
    }
    
    // MARK: Other
    
    static let notAnMp3: URL = {
        guard let location = testBundle.url(forResource: "not-an-mp3", withExtension: "m4a") else {
            fatalError("test file does not exist.")
        }
        return location
    }()

    static let sampleCover: URL = {
        guard let location = testBundle.url(forResource: "samplecover-green", withExtension: "jpg") else {
            fatalError("test file does not exist.")
        }
        return location
    }()

    static let corruptedFile: URL = {
        guard let location = testBundle.url(forResource: "mp3-v23-corrupted", withExtension: "mp3") else {
            fatalError("test file does not exist.")
        }
        return location
    }()

    static func mp3Corrupted() throws -> Mp3File {
        let mp3File = try Mp3File(location: corruptedFile)
        return mp3File
    }
    
    static func dataCorrupted() throws -> Data {
        let mp3File = try Mp3File(location: corruptedFile)
        return mp3File.data
    }
    
    static func tagCorrupted() throws -> Tag {
        let tag = try Tag(readFrom: mp3Corrupted())
        return tag
    }
    
    static let chapterizedFile: URL = {
        guard let location = testBundle.url(forResource: "mp3chapterized", withExtension: "mp3") else {
            fatalError("test file does not exist.")
        }
        return location
    }()
    
    static func mp3Chapterized() throws -> Mp3File {
        let mp3File = try Mp3File(location: chapterizedFile)
        return mp3File
    }
    
    static func dataChapterized() throws -> Data {
        let mp3File = try Mp3File(location: chapterizedFile)
        return mp3File.data
    }
    
    static func tagChapterized() throws -> Tag {
        let tag = try Tag(readFrom: mp3Chapterized())
        return tag
    }

    static func createTempFile(fileNameWithExtension: String) throws -> URL {
        try FileManager.default.createDirectory(
            at: FileManager.default.temporaryDirectory,
            withIntermediateDirectories: true)
        return FileManager.default.temporaryDirectory.appendingPathComponent(fileNameWithExtension)
    }
    
    static func removeTempFile(at location: URL) throws {
        try FileManager.default.removeItem(at: location.parentDirectory)
    }
    
}
