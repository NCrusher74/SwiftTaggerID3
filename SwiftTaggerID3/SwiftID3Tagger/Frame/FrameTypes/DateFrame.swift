//
//  DateFrame.swift
//  SwiftTaggerID3
//
//  Some of this code is adapted from ID3TagEditor
//  Created by Fabrizio Duroni on 27/02/2018.
//  2018 Fabrizio Duroni. https://github.com/chicio/ID3TagEditor
//
//  Created by Nolaine Crusher on 4/12/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//


import Foundation
/**
 A type used to represent an ID3-formatted timestamp tag. The information delivered from this type will vary depending on the tag version and formatting.
 */
struct DateFrame: FrameProtocol {
    
    /// TDAT Date Frame
    init(month: Int?, day: Int?) {
        self.init(.known(.date),
                  timeStampString: "\(month ?? 00)-\(day ?? 00)")
    }
    
    /// TIM/TIME Time Frame
    init(hour: Int?, minute: Int?) {
        self.init(.known(.time),
                  timeStampString: "\(hour ?? 00):\(minute ?? 00)")
    }
    
    /// TYE/TYER Year Frame
    init(year: Int?) {
        self.init(.known(.year),
                  timeStampString: "\(year ?? 00)")
    }
    
    /// TDEN Encoding Time Frame
    init(encodingYear: Int?, month: Int?, day: Int?, hour: Int?, minute: Int?) {
        self.init(.known(.encodingTime),
                  timeStampString: "\(encodingYear ?? 0000)-\(month ?? 00)-\(day ?? 00)T\(hour ?? 00):\(minute ?? 00)")
    }
    
    /// TOR/TORY/TDOR - Original Release Date/Year Frame
    init(originalReleaseYear: Int?, month: Int?, day: Int?, hour: Int?, minute: Int?) {
        self.init(.known(.originalReleaseTime),
                  timeStampString: "\(originalReleaseYear ?? 0000)-\(month ?? 00)-\(day ?? 00)T\(hour ?? 00):\(minute ?? 00)")
    }
    
    /// TRD/TRDA/TDRC - Recording Date Frame
    init(recordingYear: Int?, month: Int?, day: Int?, hour: Int?, minute: Int?) {
        self.init(.known(.recordingDate),
                  timeStampString: "\(recordingYear ?? 0000)-\(month ?? 00)-\(day ?? 00)T\(hour ?? 00):\(minute ?? 00)")
    }
    
    /// TDRL - Release Time Frame
    init(releaseYear: Int?, month: Int?, day: Int?, hour: Int?, minute: Int?) {
        self.init(.known(.releaseTime),
                  timeStampString: "\(releaseYear ?? 0000)-\(month ?? 00)-\(day ?? 00)T\(hour ?? 00):\(minute ?? 00)")
    }
    
    /// TDTG - Tagging Time Frame
    init(taggingYear: Int?, month: Int?, day: Int?, hour: Int?, minute: Int?) {
        self.init(.known(.taggingTime),
                  timeStampString: "\(taggingYear ?? 0000)-\(month ?? 00)-\(day ?? 00)T\(hour ?? 00):\(minute ?? 00)")
    }
    
    // MARK: Properties
    var flags: Data
    var layout: FrameLayoutIdentifier
    var frameKey: FrameKey
    var allowMultipleFrames: Bool = false

    // encode contents of the frame to add to an ID3 tag
    func encodeContents(version: Version) throws -> Data {
        var frameData = Data()
        // append encoding byte
        frameData.append(StringEncoding.preferred.rawValue.encoding(
            endianness: .bigEndian))
        // encode and append timestampstring
        frameData.append(self.timeStampString.encoded(
            withNullTermination: false))
        return frameData
    }
    
    var year: Int?
    var month: Int?
    var day: Int?
    var hour: Int?
    var minute: Int?
    var timeStampString: String
    
    init(_ layout: FrameLayoutIdentifier,
                 timeStampString: String) {
        self.flags = DateFrame.defaultFlags
        self.layout = layout
        switch layout {
            case .known(.date): self.frameKey = .date
            // TDAT - (2.2-2.3) DDMM
            case .known(.encodingTime): self.frameKey = .encodingTime
            // TDEN (2.4) timestamp
            case .known(.originalReleaseTime): self.frameKey = .originalReleaseTime
            // (2.2-2.3) YYYY, (2.4) timestamp
            case .known(.recordingDate): self.frameKey = .recordingDate
            //  (2.2-2.3) "4th-7th June, 12th June" (2.4) timestamp
            case .known(.releaseTime): self.frameKey = .releaseTime
            // timestamp 2.4
            case .known(.taggingTime): self.frameKey = .taggingTime
            // timestamp 2.4
            case .known(.time): self.frameKey = .time
            // HHMM (2.2-2.3)
            case .known(.year): self.frameKey = .year
            // YYYY (2.2-2.3)
            default: self.frameKey = .userDefinedText(description: "")
        }
        self.timeStampString = timeStampString
    }
    
    // MARK: Frame parsing
    // subset of ISO 8601; valid timestamps are yyyy, yyyy-MM, yyyy-MM-dd, yyyy-MM-ddTHH, yyyy-MM-ddTHH:mm and yyyy-MM-ddTHH:mm:ss.
    init(decodingContents contents: Data.SubSequence,
         version: Version,
         layout: FrameLayoutIdentifier,
         flags: Data) throws {
        self.flags = flags
        self.layout = layout
        switch layout {
            case .known(.date): self.frameKey = .date
            // (2.2-2.3) DDMM
            case .known(.encodingTime): self.frameKey = .encodingTime
            // (2.4) timestamp
            case .known(.originalReleaseTime): self.frameKey = .originalReleaseTime
            // (2.2-2.3) YYYY, (2.4) timestamp
            case .known(.recordingDate): self.frameKey = .recordingDate
            //  (2.2-2.3) "4th-7th June, 12th June" (2.4) timestamp
            case .known(.releaseTime): self.frameKey = .releaseTime
            // timestamp 2.4
            case .known(.taggingTime): self.frameKey = .taggingTime
            // timestamp 2.4
            case .known(.time): self.frameKey = .time
            // HHMM
            case .known(.year): self.frameKey = .year
            // YYYY
            default: self.frameKey = .userDefinedText(description: "(\(layout.id3Identifier(version: version) ?? "TXXX"))")
        }
        
        var parsing = contents
        let encoding = try StringFrame.extractEncoding(data: &parsing, version: version)
        self.timeStampString = parsing.extractPrefixAsStringUntilNullTermination(encoding) ?? ""
    }
}

public extension Tag {
    /// - (Release) Date frame getter-setter. Valid for versions 2.2 and 2.3 only.
    /// ID3 Identifier: `TDA`/`TDAT`
    var date: String? {
        get {
            if let frame = self.frames[.date],
                case .dateFrame(let dateFrame) = frame {
                return dateFrame.timeStampString
            } else {
                return nil
            }
        }
        set {
            let frame = DateFrame(.known(.date), timeStampString: newValue ?? "")
            frames[.date] = .dateFrame(frame)
        }
    }
    
    /// - (Release) Time frame getter-setter. Valid for versions 2.2 and 2.3 only.
    /// ID3 Identifier: `TIM`/`TIME`
    var time: String? {
        get {
            if let frame = self.frames[.time],
                case .dateFrame(let dateFrame) = frame {
                return dateFrame.timeStampString
            } else {
                return nil
            }
        }
        set {
            let frame = DateFrame(.known(.time), timeStampString: newValue ?? "")
            frames[.time] = .dateFrame(frame)
        }
    }
    
    /// - (Release) Year frame getter-setter. Valid for versions 2.2 and 2.3 only.
    /// ID3 Identifier: `TYE`/`TYER`
    var year: String? {
        get {
            if let frame = self.frames[.year],
                case .dateFrame(let dateFrame) = frame {
                return dateFrame.timeStampString
            } else {
                return nil
            }
        }
        set {
            let frame = DateFrame(.known(.year), timeStampString: newValue ?? "")
            frames[.year] = .dateFrame(frame)
        }
    }
    
    /// - (Release) DateTime frame getter-setter. ID3 Identifier: `TDRL` Valid for version 2.4 only
    var releaseDateTime: String? {
        get {
            if let frame = self.frames[.releaseTime],
                case .dateFrame(let dateFrame) = frame {
                return dateFrame.timeStampString
            } else {
                return nil
            }
        }
        set {
            let frame = DateFrame(.known(.releaseTime), timeStampString: newValue ?? "")
            frames[.releaseTime] = .dateFrame(frame)
        }
    }
    
    /// - EncodingDateTime frame getter-setter. ID3 Identifier: `TDEN`. Valid for Tag Version 2.4 only
    var encodingDateTime: String? {
        get {
            if let frame = self.frames[.encodingTime],
                case .dateFrame(let dateFrame) = frame {
                return dateFrame.timeStampString
            } else {
                return nil
            }
        }
        set {
            let frame = DateFrame(.known(.encodingTime), timeStampString: newValue ?? "")
            frames[.encodingTime] = .dateFrame(frame)
        }
    }
    
    /// - OriginalReleaseDateTime frame getter-setter. ID3 Identifier: `TOY`/`TORY`/`TDOR`
    /// intended to be a year-only field for tag versions 2.2 and 2.3
    var originalReleaseDate: String? {
        get {
            if let frame = self.frames[.originalReleaseTime],
                case .dateFrame(let dateFrame) = frame {
                return dateFrame.timeStampString
            } else {
                return nil
            }
        }
        set {
            let frame = DateFrame(.known(.originalReleaseTime), timeStampString: newValue ?? "")
            frames[.originalReleaseTime] = .dateFrame(frame)
        }
    }
    
    /// - RecordingDateTime frame getter-setter. ID3 Identifier: `TRD`/`TRDA`/`TDRC`
    var recordingDateTime: String? {
        get {
            if let frame = self.frames[.recordingDate],
                case .dateFrame(let dateFrame) = frame {
                return dateFrame.timeStampString
            } else {
                return nil
            }
        }
        set {
            let frame = DateFrame(.known(.recordingDate), timeStampString: newValue ?? "")
            frames[.recordingDate] = .dateFrame(frame)
        }
    }
    
    /// - TaggingDateTime frame getter-setter. ID3 Identifier: `TDTG`. Valid for Tag Version 2.4 only
    var taggingDateTime: String? {
        get {
            if let frame = self.frames[.taggingTime],
                case .dateFrame(let dateFrame) = frame {
                return dateFrame.timeStampString
            } else {
                return nil
            }
        }
        set {
            let frame = DateFrame(.known(.taggingTime), timeStampString: newValue ?? "")
            frames[.taggingTime] = .dateFrame(frame)
        }
    }
}
