//
//  RegisterDeviceParameters.swift
//  SANPLLibrary
//
//  Created by Juan Sánchez Marín on 21/6/21.
//

import Foundation

public struct RegisterDeviceParameters: Encodable {

    let transportKey, deviceParameters, deviceTime, certificate, appId: String

    public init(transportKey: String, deviceParameters: String, deviceTime: String, certificate: String, appId: String) {
        self.transportKey = transportKey
        self.deviceParameters = deviceParameters
        self.deviceTime = deviceTime
        self.certificate = certificate
        self.appId = appId
    }
}
