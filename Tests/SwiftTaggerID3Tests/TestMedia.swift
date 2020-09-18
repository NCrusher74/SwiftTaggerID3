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
