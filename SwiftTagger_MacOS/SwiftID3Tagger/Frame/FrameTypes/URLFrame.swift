//
//  URLFrame.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/14/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

import Foundation
/**
 A type representing an ID3 frame that holds a single string, such as Artist, Title, Album, etc
 */
public struct URLFrame: FrameProtocol {
    
    private var urlString: String
    
    /**
     A frame with only string content, presented as a single string without `(/n)`.
     - parameter contentString: the content of the frame.
     */
    private init(layout: FrameLayoutIdentifier, urlString: String) {
        self.urlString = urlString
        self.flags = URLFrame.defaultFlags()
        self.layout = layout
    }

    func encodeContents(version: Version) throws -> Data {
        <#code#>
    }
    
    // MARK: Decode
    // decode incoming data and parse it into a frame
    internal var flags: Data
    internal var layout: FrameLayoutIdentifier
    
    internal init(decodingContents contents: Data.SubSequence,
                  version: Version,
                  layout: FrameLayoutIdentifier,
                  flags: Data) throws {
        self.flags = flags
        self.layout = layout
        self.urlString = contents.stringASCII ?? ""
    }
    
    init(artistWebsiteUrl: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.artistWebpage), urlString: artistWebsiteUrl)
    }

    init(officialAudioFileWebsiteUrl: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.audioFileWebpage), urlString: officialAudioFileWebsiteUrl)
    }

    init(officialAudioSourceWebsiteUrl: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.audioSourceWebpage), urlString: officialAudioSourceWebsiteUrl)
    }

    init(copyrightWebsiteUrl: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.copyrightWebpage), urlString: copyrightWebsiteUrl)
    }

    init(paymentWebsiteUrl: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.paymentWebpage), urlString: paymentWebsiteUrl)
    }
    
    init(publisherWebsiteUrl: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.publisherWebpage), urlString: publisherWebsiteUrl)
    }

    init(internetRadioStationWebsiteUrl: String) {
        self.init(layout: .known(KnownFrameLayoutIdentifier.radioStationWebpage), urlString: internetRadioStationWebsiteUrl)
    }

}
