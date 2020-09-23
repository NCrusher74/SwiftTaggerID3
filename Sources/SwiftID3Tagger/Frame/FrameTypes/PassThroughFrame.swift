//
//  File.swift
//  
//
//  Created by Nolaine Crusher on 9/17/20.
//

import Foundation

/** a type that passes through any unrecognized or unhandled frame content as-is */
class PassThroughFrame: Frame {
    // MARK: - Properties
    var uuid: UUID
    var payload: Data
    var idString: String
    
    init(identifier: FrameIdentifier,
         version: Version,
         size: Int,
         flags: Data,
         payload: Data,
         idString: String
    ) {
        self.uuid = UUID()
        self.payload = payload
        self.idString = idString
        super.init(identifier: identifier,
                   version: version,
                   size: size,
                   flags: flags)
    }
    
    override var frameKey: String {
        return self.identifier.frameKey(self.uuid)
    }
    
    override var contentData: Data {
        return self.payload
    }
}
