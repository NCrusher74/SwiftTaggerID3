/*

 TestMedia.swift
 SwiftTaggerID3

 Copyright ©2020 Nolaine Crusher. All rights reserved.

 */

import Foundation
@testable import SwiftTaggerID3

let testMediaDirectory = URL(fileURLWithPath: #file)
    .deletingLastPathComponent()
    .appendingPathComponent("TestMedia")

let sample24Url = testMediaDirectory
    .appendingPathComponent("mp3-v24-with-meta")
    .appendingPathExtension("mp3")

let sample23Url = testMediaDirectory
    .appendingPathComponent("mp3-v23-with-meta")
    .appendingPathExtension("mp3")

let sample22Url = testMediaDirectory
    .appendingPathComponent("mp3-v22-with-meta")
    .appendingPathExtension("mp3")

let sampleChapterUrl = testMediaDirectory
    .appendingPathComponent("mp3-chapterized")
    .appendingPathExtension("mp3")

let sampleNoMeta = testMediaDirectory
    .appendingPathComponent("mp3-nometa")
    .appendingPathExtension("mp3")

let sampleUnknown = testMediaDirectory
    .appendingPathComponent("mp3-unknownframes")
    .appendingPathExtension("mp3")

let sampleCover = testMediaDirectory
    .appendingPathComponent("samplecover-green")
    .appendingPathExtension("jpg")

let sampleIcon = testMediaDirectory
    .appendingPathComponent("sampleicon-green")
    .appendingPathExtension("png")

let mp3V24: Mp3File = {
    do {
        let mp3 = try Mp3File(location: sample24Url)
        return mp3
    } catch {
        fatalError("Mp3File failed to initialize")
    }
}()

let mp3V23: Mp3File = {
    do {
        let mp3 = try Mp3File(location: sample23Url)
        return mp3
    } catch {
        fatalError("Mp3File failed to initialize")
    }
}()

let mp3V22: Mp3File = {
    do {
        let mp3 = try Mp3File(location: sample22Url)
        return mp3
    } catch {
        fatalError("Mp3File failed to initialize")
    }
}()

let mp3NoMeta: Mp3File = {
    do {
        let mp3 = try Mp3File(location: sampleNoMeta)
        return mp3
    } catch {
        fatalError("Mp3File failed to initialize")
    }
}()

let mp3Chaptered: Mp3File = {
    do {
        let mp3 = try Mp3File(location: sampleChapterUrl)
        return mp3
    } catch {
        fatalError("Mp3File failed to initialize")
    }
}()

let mp3Unknown: Mp3File = {
    do {
        let mp3 = try Mp3File(location: sampleUnknown)
        return mp3
    } catch {
        fatalError("Mp3File failed to initialize")
    }
}()

let tagV24: Tag = {
    do {
        let tag = try mp3V24.tag()
        return tag
    } catch {
        fatalError("Mp3File failed to initialize")
    }
}()

let tagV23: Tag = {
    do {
        let tag = try mp3V23.tag()
        return tag
    } catch {
        fatalError("Mp3File failed to initialize")
    }
}()

let tagV22: Tag = {
    do {
        let tag = try mp3V22.tag()
        return tag
    } catch {
        fatalError("Mp3File failed to initialize")
    }
}()

let tagNoMeta: Tag = {
    do {
        let tag = try mp3NoMeta.tag()
        return tag
    } catch {
        fatalError("Mp3File failed to initialize")
    }
}()

let tagChaptered: Tag = {
    do {
        let tag = try mp3Chaptered.tag()
        return tag
    } catch {
        fatalError("Mp3File failed to initialize")
    }
}()

let tagUnknown: Tag = {
    do {
        let tag = try mp3Unknown.tag()
        return tag
    } catch {
        fatalError("Mp3File failed to initialize")
    }
}()

/// Creates the test file in the temporaryDirectory `SwiftTaggerTemp`
let tempOutputDirectory: URL = {
    let tempDirectory = FileManager.default.temporaryDirectory
        .appendingPathComponent("SwiftTaggerTemp", isDirectory: true)
    do {
        try FileManager.default.createDirectory(
            at: tempDirectory,
            withIntermediateDirectories: true)
        return tempDirectory.appendingPathComponent("test.mp3")
    } catch {
        fatalError("Unable to create temporary directory")
    }
}()

func emptyDirectory() throws {
    try FileManager.default.removeItem(at: tempOutputDirectory)
}

/// Creates the test file on the desktop in the directory `TestOutput`
func localOutputDirectory(_ fileName: String) throws -> URL {
    let home = FileManager.default.homeDirectoryForCurrentUser
    let desktopPath = "Desktop/TestOutput"
    let directory = home.appendingPathComponent(
        desktopPath, isDirectory: true)
    return directory.appendingPathComponent(fileName).appendingPathExtension("mp3")
}
