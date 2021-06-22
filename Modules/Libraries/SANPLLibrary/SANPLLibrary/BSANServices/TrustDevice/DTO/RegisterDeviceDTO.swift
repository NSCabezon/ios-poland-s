//
//  RegisterDeviceDTO.swift
//  SANPLLibrary
//
//  Created by Juan Sánchez Marín on 21/6/21.
//

import Foundation

public struct RegisterDeviceDTO: Codable {
    public let trustedDeviceState: String
    public let trustedDeviceId: Int
    public let userId: Int
    public let trustedDeviceTimestamp: Int
    public let ivrInputCode: Int
}
