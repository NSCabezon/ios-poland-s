//
//  TrustedDeviceHeaders.swift
//  SANPLLibrary
//
//  Created by Marcos Álvarez Mesa on 5/8/21.
//

import Foundation

public struct TrustedDeviceHeaders: Codable {
    public let parameters: String
    public let time: String
    public let appId: String

    public init(parameters: String, time: String, appId: String) {
        self.parameters = parameters
        self.time = time
        self.appId = appId
    }
}
