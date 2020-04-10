//
//  Mp3File.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/7/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation
import AVFoundation

public struct Mp3File {
    
    public let location: URL
    internal var data: Data
    
    public init(location: URL) throws {
        self.location = location
        do {
            self.data = try Data(contentsOf: location)
        } catch {
            throw Mp3File.Error.CannotReadFile
        }
    }

//    public func read(from sourceAudio: Mp3File) {
//
//    }
    
//    public func write(from sourceAudio: Mp3File, to outputLocation: URL) throws {
//    }
}
