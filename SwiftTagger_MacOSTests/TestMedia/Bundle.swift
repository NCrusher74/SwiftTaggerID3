
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
    static let mp3Chaptered: URL = {
        guard let location = Bundle.testBundle.url(forResource: "mp3-chaptered", withExtension: "mp3") else {
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
    
}
