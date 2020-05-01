//
//  SwiftTagger_MacOSTests.swift
//  SwiftTagger_MacOSTests
//
//  Created by Nolaine Crusher on 4/7/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import XCTest
import AVFoundation

@testable import SwiftTagger_MacOS

class SwiftTagger_MacOSTests: XCTestCase {
        
    func testPropertyMethods() throws {
        // MARK: Known Bytes
        let v22VersionBytes: [UInt8] = [0x49, 0x44, 0x33, 0x02, 0x00]
        let v23VersionBytes: [UInt8] = [0x49, 0x44, 0x33, 0x03, 0x00]
        let v24VersionBytes: [UInt8] = [0x49, 0x44, 0x33, 0x04, 0x00]

        let corruptedSizeBytes: [UInt8] = [0x00, 0x02, 0x0b, 0x33]
        let noMetaSizeBytes: [UInt8] = [0x00, 0x00, 0x0d, 0x47]
        let v22SizeBytes: [UInt8] = [0x00, 0x00, 0x18, 0x3e]
        let v23SizeBytes: [UInt8] = [0x00, 0x00, 0x1e, 0x3b]
        let v24SizeBytes: [UInt8] = [0x00, 0x00, 0x15, 0x36]

        let properties = TagProperties()

        let noMetaData = try Bundle.mp3NoMetaData()
        let corruptedData = try Bundle.mp3CorruptedData()
        let v22Data = try Bundle.mp3V22Data()
        let v23Data = try Bundle.mp3V23Data()
        let v24Data = try Bundle.mp3V24Data()

        let versionDataRange = 0 ..< properties.versionDeclarationLength
        let sizeDataRange = properties.tagSizeDeclarationOffset ..< properties.tagSizeDeclarationOffset + properties.tagSizeDeclarationLength

        let noMetaVersionTestData = noMetaData.subdata(in: versionDataRange)
        XCTAssertEqual([UInt8](noMetaVersionTestData), v23VersionBytes)
        XCTAssertEqual(try properties.version(data: noMetaVersionTestData), Version.v2_3)
        let noMetaSizeTestData = noMetaData.subdata(in: sizeDataRange)
        XCTAssertEqual([UInt8](noMetaSizeTestData), noMetaSizeBytes)

        let corruptedVersionTestData = corruptedData.subdata(in: versionDataRange)
        XCTAssertEqual([UInt8](corruptedVersionTestData), v23VersionBytes)
        XCTAssertEqual(try properties.version(data: corruptedVersionTestData), Version.v2_3)
        let corruptedSizeTestData = corruptedData.subdata(in: sizeDataRange)
        XCTAssertEqual([UInt8](corruptedSizeTestData), corruptedSizeBytes)

        let v22VersionTestData = v22Data.subdata(in: versionDataRange)
        XCTAssertEqual([UInt8](v22VersionTestData), v22VersionBytes)
        XCTAssertEqual(try properties.version(data: v22VersionTestData), Version.v2_2)
        let v22SizeTestData = v22Data.subdata(in: sizeDataRange)
        XCTAssertEqual([UInt8](v22SizeTestData), v22SizeBytes)

        let v23VersionTestData = v23Data.subdata(in: versionDataRange)
        XCTAssertEqual([UInt8](v23VersionTestData), v23VersionBytes)
        XCTAssertEqual(try properties.version(data: v23VersionTestData), Version.v2_3)
        let v23SizeTestData = v23Data.subdata(in: sizeDataRange)
        XCTAssertEqual([UInt8](v23SizeTestData), v23SizeBytes)

        let v24VersionTestData = v24Data.subdata(in: versionDataRange)
        XCTAssertEqual([UInt8](v24VersionTestData), v24VersionBytes)
        XCTAssertEqual(try properties.version(data: v24VersionTestData), Version.v2_4)
        let v24SizeTestData = v24Data.subdata(in: sizeDataRange)
        XCTAssertEqual([UInt8](v24SizeTestData), v24SizeBytes)
    }
}
