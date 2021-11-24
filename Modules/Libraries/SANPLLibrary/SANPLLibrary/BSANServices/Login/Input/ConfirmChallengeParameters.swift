//
//  ConfirmChallengeParameters.swift
//  SANPLLibrary
//
//  Created by Juan Sánchez Marín on 5/10/21.
//

import Foundation

public struct ConfirmChallengeParameters: Encodable {
    let userId: String?
    let trustedDeviceId: Int
    let softwareTokenType: String
    let trustedDeviceCertificate: String
    let authorizationData: String

    public init(userId: String?, trustedDeviceId: Int, softwareTokenType: String, trustedDeviceCertificate: String, authorizationData: String) {
        self.userId = userId
        self.trustedDeviceId = trustedDeviceId
        self.softwareTokenType = softwareTokenType
        self.trustedDeviceCertificate = trustedDeviceCertificate
        self.authorizationData = authorizationData
    }
}
