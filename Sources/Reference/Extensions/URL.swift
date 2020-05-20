//
//  URLExtension.swift
//
//  Created by Nolaine Crusher on 11/25/19.
//  Copyright © 2019 Nolaine Crusher. All rights reserved.
//

import Foundation


extension URL {
    public var parentDirectory: URL {
        get {
            let parent = self.deletingLastPathComponent()
            return parent
        }
        set {
            let newParentDirectory = newValue
            let fileNameFromBefore = self.lastPathComponent
            let fileNameInNewDirectory = newParentDirectory
                .appendingPathComponent(fileNameFromBefore)
            // Replace the URL with the new one:
            self = fileNameInNewDirectory
        }
    }
    
    public var fileName: String {
        get {
            let filename = self.deletingPathExtension().lastPathComponent
            return filename
        }
    }
    
    var fileExtension: String {
        get {
            let fileExt = self.pathExtension
            return fileExt
        }
        set {
            let newFileExtension = newValue
            let fileWithNewExtension = self.deletingPathExtension().appendingPathExtension(newFileExtension)
            self = fileWithNewExtension
        }
    }
}
