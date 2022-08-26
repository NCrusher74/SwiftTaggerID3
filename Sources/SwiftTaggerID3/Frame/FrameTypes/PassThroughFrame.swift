//
//  PassThroughFrame.swift
//  SwiftTaggerID3
//
//  Created by Nolaine Crusher on 9/17/20.
//

import Foundation

/// a type that passes through any unrecognized or unhandled frame content as-is
class PassThroughFrame: Frame {
    override var description: String {
        "Unhandled Frame (\(identifier.rawValue))"
    }
    
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
        self.idString = idString
        self.payload = payload

        super.init(identifier: identifier,
                   version: version,
                   size: size,
                   flags: flags)
    }
    
    override var frameKey: FrameKey {
        return self.identifier.frameKey(idString: self.idString, uuid: self.uuid)
    }
    
    override var contentData: Data {
        var data = Data()
        data.append(self.idString.encodedASCII)
        switch self.version {
            case .v2_2:
                let uInt8Array = [UInt8](self.size.uInt32.beData)
                data.append(Data(uInt8Array.dropFirst()))
            case .v2_3: data.append(self.size.uInt32.beData)
            case .v2_4: data.append(self.size.uInt32.encodingSynchsafe().beData)
        }
        data.append(self.version.defaultFlags)
        data.append(self.payload)
        return data
    }
}
