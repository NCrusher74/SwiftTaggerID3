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
public struct URLFrame: FrameProtocol {
    
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
    
    // MARK: Public initializers
    public init(artistWebsiteUrl: String) {
        self.init(layout: .known(.artistWebpage), urlString: artistWebsiteUrl)
    }

    public init(officialAudioFileWebsiteUrl: String) {
        self.init(layout: .known(.audioFileWebpage), urlString: officialAudioFileWebsiteUrl)
    }

    public init(officialAudioSourceWebsiteUrl: String) {
        self.init(layout: .known(.audioSourceWebpage), urlString: officialAudioSourceWebsiteUrl)
    }

    public init(copyrightWebsiteUrl: String) {
        self.init(layout: .known(.copyrightWebpage), urlString: copyrightWebsiteUrl)
    }

    public init(paymentWebsiteUrl: String) {
        self.init(layout: .known(.paymentWebpage), urlString: paymentWebsiteUrl)
    }
    
    public init(publisherWebsiteUrl: String) {
        self.init(layout: .known(.publisherWebpage), urlString: publisherWebsiteUrl)
    }

    public init(internetRadioStationWebsiteUrl: String) {
        self.init(layout: .known(.radioStationWebpage), urlString: internetRadioStationWebsiteUrl)
    }

}
