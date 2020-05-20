//
//  TestMedia.swift
//  SwiftTaggerID3
//
//  Created by Nolaine Crusher on 5/19/20.
//

import Foundation
import SwiftTaggerID3

let testMediaDirectory = URL(fileURLWithPath: #file)
    .deletingLastPathComponent()
    .appendingPathComponent("TestMedia")

// v22 file
let v22File = testMediaDirectory
    .appendingPathComponent("mp3-v22-with-meta.mp3")

func mp3v22() throws -> Mp3File {
    return try Mp3File(location: v22File)
}

func tagv22() throws -> Tag {
    return try Tag(readFrom: mp3v22())
}

// v23 file
let v23File = testMediaDirectory
    .appendingPathComponent("mp3-v23-with-meta.mp3")

func mp3v23() throws -> Mp3File {
    return try Mp3File(location: v23File)
}

func tagv23() throws -> Tag {
    return try Tag(readFrom: mp3v23())
}

// v24 file
let v24File = testMediaDirectory
    .appendingPathComponent("mp3-v24-with-meta.mp3")

func mp3v24() throws -> Mp3File {
    return try Mp3File(location: v24File)
}

func tagv24() throws -> Tag {
    return try Tag(readFrom: mp3v24())
}

// noMeta file
let noMetaFile = testMediaDirectory
    .appendingPathComponent("mp3-nometa.mp3")

func mp3NoMeta() throws -> Mp3File {
    return try Mp3File(location: noMetaFile)
}

func tagNoMeta() throws -> Tag {
    return try Tag(readFrom: mp3NoMeta())
}

// corrupted file
let corruptedFile = testMediaDirectory
    .appendingPathComponent("mp3-corrupted.mp3")

func mp3Corrupted() throws -> Mp3File {
    return try Mp3File(location: corruptedFile)
}

func tagCorrupted() throws -> Tag {
    return try Tag(readFrom: mp3Corrupted())
}

// chapterized file
let chapterizedFile = testMediaDirectory
    .appendingPathComponent("mp3-chapterized.mp3")

func mp3Chapterized() throws -> Mp3File {
    return try Mp3File(location: chapterizedFile)
}

func tagChapterized() throws -> Tag {
    return try Tag(readFrom: mp3Chapterized())
}

// non-mp3 file
let nonMp3File = testMediaDirectory
    .appendingPathComponent("not-an-mp3.m4a")

let sampleCover = testMediaDirectory
    .appendingPathComponent("samplecover-green.jpg")


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
