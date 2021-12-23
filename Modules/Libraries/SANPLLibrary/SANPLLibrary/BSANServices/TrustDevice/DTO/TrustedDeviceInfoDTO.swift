//
//  TrustedDeviceInfoDTO.swift
//  SANPLLibrary
//
//  Created by Mario Rosales Maillo on 14/10/21.
//

import Foundation

public struct TrustedDeviceInfoDTO: Codable {
    public let trustedDevice: TrustedDeviceDTO
    public let applicationLanguage: String
    public let timestamp: Int
}

public struct TrustedDeviceDTO: Codable {
    public let id: Int
    public let name: String
    public let state: String
    public let certificateTime: String
    public let platform: TrustedDevicePlatformDTO
}

public struct TrustedDevicePlatformDTO: Codable {
    public let name: String
    public let osVersion: String
}

public struct TrustedDeviceSoftwareTokenHeaderDTO: Codable {
    public let name: String
    public let state: String
    public let awaitingSoftwareTokenConfirmation: Bool
    public let type: String
}
