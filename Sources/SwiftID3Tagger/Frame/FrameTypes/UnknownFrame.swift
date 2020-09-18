//
//  File.swift
//  
//
//  Created by Nolaine Crusher on 9/17/20.
//

import Foundation

/** a type that passes through any unrecognized or unhandled frame content as-is */
class UnknownFrame: Frame {
    // MARK: - Properties
    var uuid: UUID
    var payload: Data
    
    init(identifier: FrameIdentifier,
         version: Version,
         size: Int,
         flags: Data,
         payload: Data
    ) {
        self.uuid = UUID()
        self.payload = payload
        super.init(identifier: identifier,
                   version: version,
                   size: size,
                   flags: flags)
    }
    
    override func frameKey() throws -> String {
        return try self.identifier.frameKey(additionalID: self.uuid)
    }
    
    override var contentData: Data {
        return self.payload
    }
}
