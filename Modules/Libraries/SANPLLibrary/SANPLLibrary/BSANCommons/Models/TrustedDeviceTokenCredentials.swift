//
//  TrustedDeviceTokenCredentials.swift
//  SANPLLibrary
//

import Foundation

public struct TrustedDeviceTokenCredentials: Codable {
    public let trustedDeviceToken: Bool?
    public let clientId: String?
    public let expiresIn: Int?

    public init(trustedDeviceToken: Bool?, clientId: String?, expiresIn: Int?) {
        self.trustedDeviceToken = trustedDeviceToken
        self.clientId = clientId
        self.expiresIn = expiresIn
    }
}
