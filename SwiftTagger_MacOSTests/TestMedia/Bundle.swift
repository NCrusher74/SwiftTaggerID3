
import Foundation

@testable import SwiftTagger_MacOS

extension Bundle {

    /// A class defined in the test bundle that can be used to find it.
    private class BundleMarker {}

    /// The bundle which houses the tests.
    static let testBundle = Bundle(for: BundleMarker.self)

    /// An audio file for testing.
    static let testMp3File: Mp3File = {
        guard let locationOfTestAudioFile = Bundle.testBundle
            .url(forResource: "mp3-no-meta", withExtension: "mp3") else {
                fatalError("No audio file available for testing.")
        }
        return Mp3File(location: locationOfTestAudioFile)
    }()

//    static let mp3NoMeta: URL = {
//        guard let location = Bundle.testBundle.url(forResource: "no-meta", withExtension: "mp3") else {
//            fatalError("The mp3 file cannot be found")
//        }
//        return location
//    }()

}
