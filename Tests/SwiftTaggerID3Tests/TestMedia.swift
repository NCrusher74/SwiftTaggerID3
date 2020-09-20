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

func tempDirectory() throws -> URL {
    let tempDirectory = FileManager.default.temporaryDirectory
        .appendingPathComponent("SwiftTaggerTemp",
                                isDirectory: true)
    try FileManager.default.createDirectory(
        at: tempDirectory,
        withIntermediateDirectories: true)
    return tempDirectory
}

func emptyDirectory() throws {
    try FileManager.default.removeItem(at: tempDirectory())
}

func localDirectory(fileName: String, fileExtension: String) throws -> URL {
    let home = FileManager.default.homeDirectoryForCurrentUser
    let desktopPath = "Desktop/TestOutput"
    let directory = home.appendingPathComponent(
        desktopPath, isDirectory: true)
    return directory.appendingPathComponent(fileName).appendingPathExtension(fileExtension)
}
