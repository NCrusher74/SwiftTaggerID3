//
//  URLFrame.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/14/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation
/**
 A type representing an ID3 frame that holds a single string that is the URL for an external web page
 */
struct URLFrame: FrameProtocol {
    
    var urlString: String
    
    /**
     A frame with only string content, presented as a single string without `(/n)`.
     - parameter urlString: the url of a webpage.
     */
    init(layout: FrameLayoutIdentifier, urlString: String) {
        self.urlString = urlString
        self.flags = URLFrame.defaultFlags
        self.layout = layout
        switch self.layout {
            case .known(.artistWebpage):
                self.frameKey = .artistWebpage
            case .known(.audioFileWebpage):
                self.frameKey = .audioFileWebpage
            case .known(.audioSourceWebpage):
                self.frameKey = .audioSourceWebpage
            case .known(.copyrightWebpage):
                self.frameKey = .copyrightWebpage
            case .known(.paymentWebpage): self.frameKey = .paymentWebpage
            case .known(.publisherWebpage):
                self.frameKey = .publisherWebpage
            case .known(.radioStationWebpage):
                self.frameKey = .radioStationWebpage
            default: self.frameKey = .userDefinedWebpage(description: "")
        }
    }

    // encode the contents of the frame to add to an ID3 tag
    func encodeContents(version: Version) throws -> Data {
        // encode and return urlString
        return self.urlString.encoded(withNullTermination: false)
    }
    
    // MARK: Decode
    // decode incoming data and parse it into a frame
    var flags: Data
    var layout: FrameLayoutIdentifier
    var frameKey: FrameKey
    var allowMultipleFrames: Bool = false
    
    init(decodingContents contents: Data.SubSequence,
                  version: Version,
                  layout: FrameLayoutIdentifier,
                  flags: Data
    ) throws {
        self.flags = flags
        self.layout = layout
        switch self.layout {
            case .known(.artistWebpage):
                self.frameKey = .artistWebpage
            case .known(.audioFileWebpage):
                self.frameKey = .audioFileWebpage
            case .known(.audioSourceWebpage):
                self.frameKey = .audioSourceWebpage
            case .known(.copyrightWebpage):
                self.frameKey = .copyrightWebpage
            case .known(.paymentWebpage): self.frameKey = .paymentWebpage
            case .known(.publisherWebpage):
                self.frameKey = .publisherWebpage
            case .known(.radioStationWebpage):
                self.frameKey = .radioStationWebpage
            default: self.frameKey = .userDefinedWebpage(description: "")
        }
        self.urlString = try String(ascii: contents)
    }
}

// MARK: Tag Extension
public extension Tag {
    /// - ArtistWebpage getter-setter. ID3 Identifier: `WAR`/`WOAR`
    var artistWebpage: String {
        get {
            url(for: .artistWebpage) ?? ""
        }
        set {
            set(.known(.artistWebpage), .artistWebpage, to: URL(fileURLWithPath: newValue))
        }
    }
    
    /// - (Official)AudioFileWebpage getter-setter. ID3 Identifier: `WAF`/`WOAF`
    var audioFileWebpage: String {
        get {
            url(for: .audioFileWebpage) ?? ""
        }
        set {
            set(.known(.audioFileWebpage), .audioFileWebpage, to: URL(fileURLWithPath: newValue))
        }
    }
    
    /// - (Official)AudioSourceWebpage getter-setter. ID3 Identifier: `WAS`/`WOAS`
    var audioSourceWebpage: String {
        get {
            url(for: .audioSourceWebpage) ?? ""
        }
        set {
            set(.known(.audioSourceWebpage), .audioSourceWebpage, to: URL(fileURLWithPath: newValue))
        }
    }
    
    /// - Copyright/Legal Information Webpage getter-setter. ID3 Identifier: `WCP`/`WCOP`
    var copyrightWebpage: String {
        get {
            url(for: .copyrightWebpage) ?? ""
        }
        set {
            set(.known(.copyrightWebpage), .copyrightWebpage, to: URL(fileURLWithPath: newValue))
        }
    }
    
    /// - PaymentWebpage getter-setter. ID3 Identifier: `WPAY`
    /// Valid for tag versions 2.3/2.4 only
    var paymentWebpage: String {
        get {
            url(for: .paymentWebpage) ?? ""
        }
        set {
            set(.known(.paymentWebpage), .paymentWebpage, to: URL(fileURLWithPath: newValue))
        }
    }
    
    /// - PublisherWebpage getter-setter. ID3 Identifier: `WPB`/`WPUB`
    var publisherWebpage: String {
        get {
            url(for: .publisherWebpage) ?? ""
        }
        set {
            set(.known(.publisherWebpage), .publisherWebpage, to: URL(fileURLWithPath: newValue))
        }
    }
    
    /// - (Official Internet)RadioStationWebpage getter-setter. ID3 Identifier: `WRS`/`WORS`
    var radioStationWebpage: String {
        get {
            url(for: .radioStationWebpage) ?? ""
        }
        set {
            set(.known(.radioStationWebpage), .radioStationWebpage, to: URL(fileURLWithPath: newValue))
        }
    }
}
