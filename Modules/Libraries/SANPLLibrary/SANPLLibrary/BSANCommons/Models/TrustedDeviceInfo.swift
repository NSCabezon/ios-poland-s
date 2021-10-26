//
//  TrustedDeviceInfo.swift
//  SANPLLibrary
//
//  Created by Mario Rosales Maillo on 14/10/21.
//

import Foundation

public struct TrustedDeviceInfo: Codable {
    public let trustedDeviceId: Int
    public let state: String
    public let trustedDeviceSoftwareTokenHeaders: [TrustedDeviceSoftwareTokenHeader]
    public let certificateTime: String
    public init(dto: TrustedDeviceInfoDTO) {
        self.trustedDeviceId = dto.trustedDevice.id
        self.state = dto.trustedDevice.state
        self.certificateTime = dto.trustedDevice.certificateTime
        self.trustedDeviceSoftwareTokenHeaders = dto.softwareTokenHeaders.map({ header in
            return TrustedDeviceSoftwareTokenHeader(dto: header)
        })
    }
}

public struct TrustedDeviceSoftwareTokenHeader: Codable {
    public let name: String
    public let state: String
    public let awaitingSoftwareTokenConfirmation: Bool
    public let type: String
    public init(dto: TrustedDeviceSoftwareTokenHeaderDTO) {
        self.name = dto.name
        self.state = dto.state
        self.awaitingSoftwareTokenConfirmation = dto.awaitingSoftwareTokenConfirmation
        self.type = dto.type
    }
}
