//
//  RegisterDeviceParameters.swift
//  SANPLLibrary
//
//  Created by Juan Sánchez Marín on 21/6/21.
//

import Foundation

public struct RegisterDeviceParameters: Encodable {
    public let transportKey, deviceParameters, deviceTime, certificate, appId: String
    public let pushDefinition: PushDefinition
    public let platform: Platform
    public let applicationLanguage: String
    
    public init(transportKey: String,
                deviceParameters: String,
                deviceTime: String,
                certificate: String,
                appId: String,
                pushDefinition: PushDefinition = PushDefinition(),
                platform: Platform = Platform(), applicationLanguage: String = NSLocale.preferredLanguages[0]) {
        self.transportKey = transportKey
        self.deviceParameters = deviceParameters
        self.deviceTime = deviceTime
        self.certificate = certificate
        self.appId = appId
        self.pushDefinition = pushDefinition
        self.platform = platform
        self.applicationLanguage = applicationLanguage
    }
}

public struct PushDefinition: Encodable {
    public let categories: [String]
    public let status: String
    public init(categories: [String] = ["INFORMATION", "BLIK"], status: String = "ON") {
        self.categories = categories
        self.status = status
    }
}

public struct Platform: Encodable {
    public let name, osVersion: String
    public init(name: String = "IOS", osVersion: String = UIDevice.current.systemVersion) {
        self.name = name
        self.osVersion = osVersion
    }
    
}

