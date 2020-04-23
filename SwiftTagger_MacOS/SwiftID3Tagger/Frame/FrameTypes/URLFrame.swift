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
            case .known(KnownFrameLayoutIdentifier.artistWebpage):
                self.frameKey = .artistWebpage
            case .known(KnownFrameLayoutIdentifier.audioFileWebpage):
                self.frameKey = .audioFileWebpage
            case .known(KnownFrameLayoutIdentifier.audioSourceWebpage):
                self.frameKey = .audioSourceWebpage
            case .known(KnownFrameLayoutIdentifier.copyrightWebpage):
                self.frameKey = .copyrightWebpage
            case .known(KnownFrameLayoutIdentifier.paymentWebpage): self.frameKey = .paymentWebpage
            case .known(KnownFrameLayoutIdentifier.publisherWebpage):
                self.frameKey = .publisherWebpage
            case .known(KnownFrameLayoutIdentifier.radioStationWebpage):
                self.frameKey = .radioStationWebpage
            default: self.frameKey = .userDefinedWebpage(description: "")
        }
    }

    func encodeContents(version: Version) throws -> Data {
        let contents = self.urlString
        return contents.encoded(withNullTermination: false)
    }
    
    // MARK: Decode
    // decode incoming data and parse it into a frame
    var flags: Data
    var layout: FrameLayoutIdentifier
    var frameKey: FrameKey
//    var identifier: String
    
    init(decodingContents contents: Data.SubSequence,
                  version: Version,
                  layout: FrameLayoutIdentifier,
                  flags: Data
    ) throws {
        self.flags = flags
        self.layout = layout
        switch self.layout {
            case .known(KnownFrameLayoutIdentifier.artistWebpage):
                self.frameKey = .artistWebpage
            case .known(KnownFrameLayoutIdentifier.audioFileWebpage):
                self.frameKey = .audioFileWebpage
            case .known(KnownFrameLayoutIdentifier.audioSourceWebpage):
                self.frameKey = .audioSourceWebpage
            case .known(KnownFrameLayoutIdentifier.copyrightWebpage):
                self.frameKey = .copyrightWebpage
            case .known(KnownFrameLayoutIdentifier.paymentWebpage): self.frameKey = .paymentWebpage
            case .known(KnownFrameLayoutIdentifier.publisherWebpage):
                self.frameKey = .publisherWebpage
            case .known(KnownFrameLayoutIdentifier.radioStationWebpage):
                self.frameKey = .radioStationWebpage
            default: self.frameKey = .userDefinedWebpage(description: "")
        }
        self.urlString = contents.stringASCII ?? ""
    }
    
    // MARK: Public initializers
    public init(artistWebsiteUrl: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.artistWebpage), urlString: artistWebsiteUrl)
    }

    public init(officialAudioFileWebsiteUrl: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.audioFileWebpage), urlString: officialAudioFileWebsiteUrl)
    }

    public init(officialAudioSourceWebsiteUrl: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.audioSourceWebpage), urlString: officialAudioSourceWebsiteUrl)
    }

    public init(copyrightWebsiteUrl: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.copyrightWebpage), urlString: copyrightWebsiteUrl)
    }

    public init(paymentWebsiteUrl: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.paymentWebpage), urlString: paymentWebsiteUrl)
    }
    
    public init(publisherWebsiteUrl: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.publisherWebpage), urlString: publisherWebsiteUrl)
    }

    public init(internetRadioStationWebsiteUrl: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.radioStationWebpage), urlString: internetRadioStationWebsiteUrl)
    }

}
