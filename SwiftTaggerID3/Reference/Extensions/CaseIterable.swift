 //
//  CaseIterable.swift
//  SwiftTaggerID3
//
//  Created by Nolaine Crusher on 4/18/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//
import Foundation

extension CaseIterable where Self: RawRepresentable {
    
    static var rawValues: [RawValue] {
        return allCases.map { $0.rawValue }
    }
}
