//
//  File.swift
//  
//
//  Created by Nolaine Crusher on 4/21/21.
//

import Foundation
/// An enum that describes the format of a supported attached image.
public enum ImageFormat: String, CaseIterable {
    case jpg
    case png
    case bmp
    case gif
    case tiff
    
    private static var jpgExtensions: [String] {
        ["jpg", "jpeg", "jpe,", "jif", "jfif", "jfi"]
    }
    
    private static var tifExtensions: [String] {
        ["tiff", "tif"]
    }
    
    private static var bmpExtensions: [String] {
        ["bmp", "dib"]
    }
    
    init?(_ fileExtension: String?, _ mimeString: String?, version: Version) {
        if let fileExtension = fileExtension?.lowercased() {
            if ImageFormat.jpgExtensions.contains(fileExtension) {
                self = .jpg
            } else if fileExtension == "png" {
                self = .png
            } else if ImageFormat.bmpExtensions.contains(fileExtension) {
                self = .bmp
            } else if fileExtension == "gif" {
                self = .gif
            } else if ImageFormat.tifExtensions.contains(fileExtension) {
                self = .tiff
            } else {
                return nil
            }
        } else if let mimeString = mimeString?.lowercased() {
            switch version {
                case .v2_2:
                    if mimeString == "jpg" {
                        self = .jpg
                    } else if mimeString == "png" {
                        self = .png
                    } else if mimeString == "gif" {
                        self = .gif
                    } else if mimeString == "bmp" {
                        self = .bmp
                    } else if mimeString == "tif" {
                        self = .tiff
                    } else {
                        return nil
                    }
                default:
                    if mimeString.contains("jpeg") {
                        self = .jpg
                    } else if mimeString.contains("png") {
                        self = .png
                    } else if mimeString.contains("bmp") {
                        self = .bmp
                    } else if mimeString.contains("gif") {
                        self = .gif
                    } else if mimeString.contains("tiff") {
                        self = .tiff
                    } else {
                        return nil
                    }
            }
        } else {
            return nil
        }
    }
    
    private static var jpgMagicNumbers: [Data] {
        [Data([0xFF, 0xD8, 0xFF, 0xE0]),
         Data([0xFF, 0xD8, 0xFF, 0xE1]),
         Data([0xFF, 0xD8, 0xFF, 0xE2]),
         Data([0xFF, 0xD8, 0xFF, 0xE8])]
    }
    
    
    init?(_ magicNumberData: Data) {
        if magicNumberData == Data([0x89, 0x50, 0x4E, 0x47]) {
            self = .png
        } else if magicNumberData == Data([0x47, 0x49, 0x46, 0x38]) {
            self = .gif
        } else if magicNumberData[0..<2] == Data([0x42, 0x4D]) {
            self = .bmp
        } else if magicNumberData[0..<3] == Data([0x49, 0x20, 0x49]) {
            self = .tiff
        } else if ImageFormat.jpgMagicNumbers.contains(magicNumberData) {
            self = .jpg
        } else {
            return nil
        }
    }
}
