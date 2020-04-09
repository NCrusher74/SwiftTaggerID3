
import Foundation

@testable import SwiftTagger_MacOS

extension Bundle {
    
    /// A class defined in the test bundle that can be used to find it.
    private class BundleMarker {}
    
    /// The bundle which houses the tests.
    static let testBundle = Bundle(for: BundleMarker.self)
    
    // MARK: Version22 file
    static let writtenV22: URL = {
        guard let location = Bundle.testBundle.url(forResource: "mp3-v22-with-meta", withExtension: "mp3") else {
            fatalError("The audio file cannot be found")
        }
        return location
    }()
    
    static let mp3v22FileWritten: Mp3File = {
        let locationOfTestAudioFile = writtenV22
        return Mp3File(location: locationOfTestAudioFile)
    }()
    
    static let validatorV22FileWritten: TagValidator = {
        return TagValidator(for: mp3v22FileWritten)
    }()

    static let propertiesV22FileWritten: TagProperties = {
        return TagProperties(for: mp3v22FileWritten)
    }()

    // MARK: Version23 file
    static let writtenV23: URL = {
        guard let location = Bundle.testBundle.url(forResource: "mp3-v23-with-meta", withExtension: "mp3") else {
            fatalError("The audio file cannot be found")
        }
        return location
    }()
    
    static let mp3v23FileWritten: Mp3File = {
        let locationOfTestAudioFile = writtenV23
        return Mp3File(location: locationOfTestAudioFile)
    }()
    
    static let validatorV23FileWritten: TagValidator = {
        return TagValidator(for: mp3v23FileWritten)
    }()
    
    static let propertiesV23FileWritten: TagProperties = {
        return TagProperties(for: mp3v23FileWritten)
    }()

    // MARK: Version24 file
    static let writtenV24: URL = {
        guard let location = Bundle.testBundle.url(forResource: "mp3-v24-with-meta", withExtension: "mp3") else {
            fatalError("The audio file cannot be found")
        }
        return location
    }()
    
    static let mp3v24FileWritten: Mp3File = {
        let locationOfTestAudioFile = writtenV24
        return Mp3File(location: locationOfTestAudioFile)
    }()
    
    static let validatorV24FileWritten: TagValidator = {
        return TagValidator(for: mp3v24FileWritten)
    }()
    
    static let propertiesV24FileWritten: TagProperties = {
        return TagProperties(for: mp3v24FileWritten)
    }()

    // MARK: No Meta (v24)
    static let mp3NoMeta: URL = {
        guard let location = Bundle.testBundle.url(forResource: "mp3-nometa", withExtension: "mp3") else {
            fatalError("The mp3 file cannot be found")
        }
        return location
    }()

    static let mp3FileNoMeta: Mp3File = {
        let locationOfTestAudioFile = mp3NoMeta
        return Mp3File(location: locationOfTestAudioFile)
    }()
    
    static let validatorNoMeta: TagValidator = {
        return TagValidator(for: mp3FileNoMeta)
    }()
    
    static let propertiesNoMeta: TagProperties = {
        return TagProperties(for: mp3FileNoMeta)
    }()
    

    
    
    // MARK: Other File
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
    
    static let notMp3: URL = {
        guard let location = Bundle.testBundle.url(forResource: "not-an-mp3", withExtension: "m4a") else {
            fatalError("The audio file cannot be found")
        }
        return location
    }()
    
}
