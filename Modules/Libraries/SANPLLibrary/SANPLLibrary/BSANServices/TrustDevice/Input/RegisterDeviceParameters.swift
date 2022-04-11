//
//  RegisterDeviceParameters.swift
//  SANPLLibrary
//
//  Created by Juan Sánchez Marín on 21/6/21.
//

import Foundation

public struct RegisterDeviceParameters: Encodable {
    let transportKey, deviceParameters, deviceTime, certificate, appId: String
    let pushDefinition: PushDefinition
    let platform: Platform
    let applicationLanguage: String
    
    
    public init(transportKey: String,
                deviceParameters: String,
                deviceTime: String,
                certificate: String,
                appId: String,
                pushDefinition: PushDefinition,
                platform: Platform,
                applicationLanguage: String) {
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
    public init(categories: [String], status: String) {
        self.categories = categories
        self.status = status
    }
}

public struct Platform: Encodable {
    public let name, osVersion: String
    
    public init(name: String, osVersion: String) {
        self.name = name
        self.osVersion = osVersion
    }
    
}
