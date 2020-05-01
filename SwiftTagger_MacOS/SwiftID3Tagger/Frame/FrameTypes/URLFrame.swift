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
    private init(layout: FrameLayoutIdentifier, urlString: String) {
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
        let contents = self.urlString
        return contents.encoded(withNullTermination: false)
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
    
    // MARK: Initializers
    init(artistWebsiteUrl: String) {
        self.init(layout: .known(.artistWebpage), urlString: artistWebsiteUrl)
    }

    init(officialAudioFileWebsiteUrl: String) {
        self.init(layout: .known(.audioFileWebpage), urlString: officialAudioFileWebsiteUrl)
    }

    init(officialAudioSourceWebsiteUrl: String) {
        self.init(layout: .known(.audioSourceWebpage), urlString: officialAudioSourceWebsiteUrl)
    }

    init(copyrightWebsiteUrl: String) {
        self.init(layout: .known(.copyrightWebpage), urlString: copyrightWebsiteUrl)
    }

    init(paymentWebsiteUrl: String) {
        self.init(layout: .known(.paymentWebpage), urlString: paymentWebsiteUrl)
    }
    
    init(publisherWebsiteUrl: String) {
        self.init(layout: .known(.publisherWebpage), urlString: publisherWebsiteUrl)
    }

    init(internetRadioStationWebsiteUrl: String) {
        self.init(layout: .known(.radioStationWebpage), urlString: internetRadioStationWebsiteUrl)
    }

}

// MARK: Tag Extension
public extension Tag {
    /// - ArtistWebpage getter-setter. ID3 Identifier: `WAR`/`WOAR`
    var artistWebpage: String? {
        get {
            if let frame = self.frames[.artistWebpage],
                case .urlFrame(let urlFrame) = frame {
                return urlFrame.urlString
            } else {
                return nil
            }
        }
        set {
            let frame = URLFrame(artistWebsiteUrl: newValue ?? "")
            frames[.artistWebpage] = .urlFrame(frame)
        }
    }
    
    /// - (Official)AudioFileWebpage getter-setter. ID3 Identifier: `WAF`/`WOAF`
    var audioFileWebpage: String? {
        get {
            if let frame = self.frames[.audioFileWebpage],
                case .urlFrame(let urlFrame) = frame {
                return urlFrame.urlString
            } else {
                return nil
            }
        }
        set {
            let frame = URLFrame(officialAudioFileWebsiteUrl: newValue ?? "")
            frames[.audioFileWebpage] = .urlFrame(frame)
        }
    }
    
    /// - (Official)AudioSourceWebpage getter-setter. ID3 Identifier: `WAS`/`WOAS`
    var audioSourceWebpage: String? {
        get {
            if let frame = self.frames[.audioSourceWebpage],
                case .urlFrame(let urlFrame) = frame {
                return urlFrame.urlString
            } else {
                return nil
            }
        }
        set {
            let frame = URLFrame(officialAudioSourceWebsiteUrl: newValue ?? "")
            frames[.audioSourceWebpage] = .urlFrame(frame)
        }
    }
    
    /// - Copyright/Legal Information Webpage getter-setter. ID3 Identifier: `WCP`/`WCOP`
    var copyrightWebpage: String? {
        get {
            if let frame = self.frames[.copyrightWebpage],
                case .urlFrame(let urlFrame) = frame {
                return urlFrame.urlString
            } else {
                return nil
            }
        }
        set {
            let frame = URLFrame(copyrightWebsiteUrl: newValue ?? "")
            frames[.copyrightWebpage] = .urlFrame(frame)
        }
    }
    
    /// - PaymentWebpage getter-setter. ID3 Identifier: `WPAY`
    /// Valid for tag versions 2.3/2.4 only
    var paymentWebpage: String? {
        get {
            if let frame = self.frames[.paymentWebpage],
                case .urlFrame(let urlFrame) = frame {
                return urlFrame.urlString
            } else {
                return nil
            }
        }
        set {
            let frame = URLFrame(paymentWebsiteUrl: newValue ?? "")
            frames[.paymentWebpage] = .urlFrame(frame)
        }
    }
    
    /// - PublisherWebpage getter-setter. ID3 Identifier: `WPB`/`WPUB`
    var publisherWebpage: String? {
        get {
            if let frame = self.frames[.publisherWebpage],
                case .urlFrame(let urlFrame) = frame {
                return urlFrame.urlString
            } else {
                return nil
            }
        }
        set {
            let frame = URLFrame(publisherWebsiteUrl: newValue ?? "")
            frames[.publisherWebpage] = .urlFrame(frame)
        }
    }
    
    /// - (Official Internet)RadioStationWebpage getter-setter. ID3 Identifier: `WRS`/`WORS`
    var radioStationWebpage: String? {
        get {
            if let frame = self.frames[.radioStationWebpage],
                case .urlFrame(let urlFrame) = frame {
                return urlFrame.urlString
            } else {
                return nil
            }
        }
        set {
            let frame = URLFrame(internetRadioStationWebsiteUrl: newValue ?? "")
            frames[.radioStationWebpage] = .urlFrame(frame)
        }
    }
}
