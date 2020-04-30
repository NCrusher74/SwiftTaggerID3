
import Foundation

@testable import SwiftTagger_MacOS

extension Bundle {
    
    /// A class defined in the test bundle that can be used to find it.
    private class BundleMarker {}
    
    /// The bundle which houses the tests.
    static let testBundle = Bundle(for: BundleMarker.self)

    // MARK: versioned mp3 files
    static let writtenV22: URL = {
        guard let location = Bundle.testBundle.url(forResource: "mp3-v22-with-meta", withExtension: "mp3") else {
            fatalError("The audio file cannot be found")
        }
        return location
    }()

    static let writtenV23: URL = {
        guard let location = Bundle.testBundle.url(forResource: "mp3-v23-with-meta", withExtension: "mp3") else {
            fatalError("The audio file cannot be found")
        }
        return location
    }()

    static let writtenV24: URL = {
        guard let location = Bundle.testBundle.url(forResource: "mp3-v24-with-meta", withExtension: "mp3") else {
            fatalError("The audio file cannot be found")
        }
        return location
    }()

    // MARK: Other Files
    static let chapteredMp3: URL = {
        guard let location = Bundle.testBundle.url(forResource: "mp3-chapterized", withExtension: "mp3") else {
            fatalError("The mp3 file cannot be found")
        }
        return location
    }()
    
    static let corruptedV23: URL = {
        guard let location = Bundle.testBundle.url(forResource: "mp3-v23-corrupted", withExtension: "mp3") else {
            fatalError("The audio file cannot be found")
        }
        return location
    }()

    static let v23NoMeta: URL = {
        guard let location = Bundle.testBundle.url(forResource: "mp3-nometa", withExtension: "mp3") else {
            fatalError("The audio file cannot be found")
        }
        return location
    }()

    static let notMp3: URL = {
        guard let location = Bundle.testBundle.url(forResource: "not-an-mp3", withExtension: "m4a") else {
            fatalError("The audio file cannot be found")
        }
        return location
    }()
    
    // MARK: Files as MP3Files instances
    static func mp3V22() throws -> Mp3File {
        return try Mp3File(location: writtenV22)
    }

    static func mp3V23() throws -> Mp3File {
        return try Mp3File(location: writtenV23)
    }

    static func mp3V24() throws -> Mp3File {
        return try Mp3File(location: writtenV24)
    }

    static func mp3Corrupted() throws -> Mp3File {
        return try Mp3File(location: corruptedV23)
    }

    static func mp3Chaptered() throws -> Mp3File {
        return try Mp3File(location: chapteredMp3)
    }

    static func mp3NoMeta() throws -> Mp3File {
        return try Mp3File(location: v23NoMeta)
    }

    // MARK: Files as MP3File.data instances
    static func mp3V22Data() throws -> Data {
        let mp3File = try Mp3File(location: writtenV22)
        return mp3File.data
    }
    
    static func mp3V23Data() throws -> Data {
        let mp3File = try Mp3File(location: writtenV23)
        return mp3File.data
    }
    
    static func mp3V24Data() throws -> Data {
        let mp3File = try Mp3File(location: writtenV24)
        return mp3File.data
    }
    
    static func mp3CorruptedData() throws -> Data {
        let mp3File = try Mp3File(location: corruptedV23)
        return mp3File.data
    }
    
    static func mp3ChapteredData() throws -> Data {
        let mp3File = try Mp3File(location: chapteredMp3)
        return mp3File.data
    }
    
    static func mp3NoMetaData() throws -> Data {
        let mp3File = try Mp3File(location: v23NoMeta)
        return mp3File.data
    }
}
