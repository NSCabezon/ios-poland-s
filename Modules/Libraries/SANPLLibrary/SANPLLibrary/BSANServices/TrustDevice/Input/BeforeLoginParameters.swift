//
//  BeforeLoginParameters.swift
//  SANPLLibrary
//
//  Created by Mario Rosales Maillo on 27/9/21.
//

import Foundation

public struct BeforeLoginParameters: Encodable {
    let trustedDeviceAppId: String
    let retrieveOptions: [String]
    public init(trustedDeviceAppId: String, retrieveOptions: [String]) {
        self.trustedDeviceAppId = trustedDeviceAppId
        self.retrieveOptions = retrieveOptions
    }
}
