////
////  DateFrame.swift
////  SwiftTagger_MacOS
////
////  Some of this code is adapted from ID3TagEditor
////  Created by Fabrizio Duroni on 27/02/2018.
////  2018 Fabrizio Duroni. https://github.com/chicio/ID3TagEditor
////
////  Created by Nolaine Crusher on 4/12/20.
////  Copyright © 2020 Nolaine Crusher. All rights reserved.
////
//
//import Foundation
///**
// A struct used to represent the recording date for the ID3 recording date time frame.
// */
//public struct RecordingDate: FrameProtocol {
//    
//    /// Recording day of the song.
//    public var day: Int?
//    /// Recording month of the song.
//    public var month: Int?
//    /// Recording year of the song.
//    public var year: Int?
//    
//    /**
//     - parameter day: the recording day of the song.
//     - parameter month: the recording month of the song.
//     - parameter year: the recording year of the song.
//     */
//    public init(day: Int?, month: Int?, year: Int?) {
//        self.day = day
//        self.month = month
//        self.year = year
//    }
//    
//    init(decodingContents contents: Data.SubSequence, version: Version, frameIdentifier: FrameLayoutIdentifier, flags: Data) throws {
//        <#code#>
//    }
//    
//    var flags: Data
//    var size: Int
//    var identifier: FrameLayoutIdentifier
//
//}
//
///**
// A struct used to represent the recording time for the ID3 recording date time frame.
// */
//public struct RecordingTime {
//    /// Recording hour of the song.
//    public var hour: Int?
//    /// Recording seconds of the song.
//    public var minute: Int?
//    
//    /**
//     - parameter hour: the recording hour of the song.
//     - parameter minute: the recording minute of the song.
//     */
//    public init(hour: Int?, minute: Int?) {
//        self.hour = hour
//        self.minute = minute
//    }
//    
//    init(decodingContents contents: Data.SubSequence, version: Version, frameIdentifier: FrameLayoutIdentifier, flags: Data) throws {
//        <#code#>
//    }
//    
//    var flags: Data
//    var size: Int
//    var identifier: FrameLayoutIdentifier
//    
//
//}
//
///**
// A struct used to represent the recording date and time for the ID3 recording date time frame.
// */
//public struct RecordingDateTime {
//    /// Recording date of the song.
//    public var date: RecordingDate?
//    /// Recording time of the song.
//    public var time: RecordingTime?
//    
//    /**
//     - parameter date: the recording date of the song.
//     - parameter time: the recording time of the song.
//     */
//    public init(date: RecordingDate?, time: RecordingTime?) {
//        self.date = date
//        self.time = time
//    }
//    
//    init(decodingContents contents: Data.SubSequence, version: Version, frameIdentifier: FrameLayoutIdentifier, flags: Data) throws {
//        <#code#>
//    }
//    
//    var flags: Data
//    var size: Int
//    var identifier: FrameLayoutIdentifier
//    
//}
//
///**
// A type used to represent an ID3 recording date time frame to be used in the ID3 tag. Valid only for ID3 tag version 2.4.
// */
//struct DateFrame {
//    /// The recordin date time information. This field contains date and time of the recording.
//    public let recordingDateTime: RecordingDateTime
//    
//    /**
//     - parameter recordingDateTime: a RecordingDateTime struct.
//     */
//    public init(recordingDateTime: RecordingDateTime) {
//        self.recordingDateTime = recordingDateTime
//    }
//    
//    
//    init(decodingContents contents: Data.SubSequence, version: Version, frameIdentifier: FrameLayoutIdentifier, flags: Data) throws {
//        <#code#>
//    }
//    
//    var flags: Data
//    var size: Int
//    var identifier: FrameLayoutIdentifier
//    
//
//}
