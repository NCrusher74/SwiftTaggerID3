//
//  File.swift
//  
//
//  Created by Nolaine Crusher on 9/17/20.
//

import Foundation
/*
 v2.2 frame header structure - 6 characters
 Frame ID   $xx xx xx  (three characters)
 Size       $xx xx xx xx
 Flags      $xx xx

 v2.3 and 2.4 frame header structure - 10 characters
 Frame ID   $xx xx xx xx  (four characters)
 Size       $xx xx xx xx
 Flags      $xx xx
 */
class Frame {
    var identifier: FrameIdentifier
    var version: Version
    var size: Int
    var flags: Data
    
    init(identifier: FrameIdentifier,
         version: Version,
         size: Int,
         flags: Data) {
        self.identifier = identifier
        self.version = version
        self.size = size
        self.flags = flags
    }

    func frameKey() throws -> String {
        if self.identifier == .known(.attachedPicture) ||
            self.identifier == .known(.chapter) ||
            self.identifier == .known(.comments) ||
            self.identifier == .known(.unsynchronizedLyrics) ||
            self.identifier == .known(.userDefinedText) ||
            self.identifier == .known(.userDefinedWebpage) {
            fatalError("Override from frame subclass is required")
        } else {
            return try self.identifier.frameKey(additionalID: nil)
        }
    }

    @available(OSX 10.12, *)
    var contentData: Data {
        fatalError("Must be overridden from frame subclass")
    }
    
    @available(OSX 10.12, *)
    var encode: Data {
        var data = Data()
        data.append(self.identifierData)
        data.append(self.encodedFrameContentSize)
        data.append(self.version.defaultFlags)
        data.append(self.contentData)
        return data
    }
    
    /// Calculates the size of the frame for encoding purposes
    /// - Parameters:
    ///   - encodedContent: The byte-count of the content data for the frame
    ///   - version: The version of the ID3 tag
    /// - Returns:
    ///   - Version 2.2: three bytes of frame-size data.
    ///   - Versions 2.3 & 2.4: four bytes of frame-size data
    @available(OSX 10.12, *)
    private var encodedFrameContentSize: Data {
        let contentSize = contentData.count.uInt32
        switch version {
            case .v2_2:
                let contentUInt8Array = [UInt8](contentSize.beData)
                return Data(contentUInt8Array.dropFirst())
            case .v2_3: return contentSize.beData
            case .v2_4: return contentSize.encodingSynchsafe().beData
        }
    }
    
    /// Calculates and extracts the ID3 indentifier from the layout
    /// - Parameters:
    ///   - layout: the FrameLayoutIdentifier
    ///   - version: The version of the ID3 tag
    /// - Returns: The encoded identifier string
    private var identifierData: Data {
        guard let identifier = self.identifier.idString(version: self.version)?.encodedASCII else {
            switch version {
                case .v2_2: return "TXX".encodedASCII
                case .v2_3, .v2_4: return "TXXX".encodedASCII
            }
        }
        return identifier
    }
}

enum FrameError: Error {
    case UnableToDecodeStringData
    case InvalidDateString
    case InvalidIdentifierString(String)
}
