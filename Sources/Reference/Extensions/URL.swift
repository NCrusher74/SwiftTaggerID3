/*

 URL.swift
 SwiftTaggerID3

 Copyright ©2019–2020 Nolaine Crusher. All rights reserved.

 */

import Foundation


extension URL {
    public var parentDirectory: URL {
        get {
            let parent = self.deletingLastPathComponent()
            return parent
        }
    }
}
