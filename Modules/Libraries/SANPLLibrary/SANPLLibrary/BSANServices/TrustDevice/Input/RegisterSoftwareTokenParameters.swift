//
//  RegisterSoftwareTokenParameters.swift
//  SANPLLibrary
//
//  Created by Juan Sánchez Marín on 22/6/21.
//

import Foundation

public struct RegisterSoftwareTokenParameters: Encodable {
    let createBiometricsToken: Bool
    let trustedDeviceAuth: TrustedDeviceAuthData

    public init(createBiometricsToken: Bool, trustedDeviceAuth: TrustedDeviceAuthData) {
        self.createBiometricsToken = createBiometricsToken
        self.trustedDeviceAuth = trustedDeviceAuth
    }
}

public struct TrustedDeviceAuthData: Encodable {
    let appId: String
    let parameters: String
    let deviceTime: String

    public init(appId: String, parameters: String, deviceTime: String) {
        self.appId = appId
        self.parameters = parameters
        self.deviceTime = deviceTime
    }
}
