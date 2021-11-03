//
//  TrustedDeviceInfoParameters.swift
//  SANPLLibrary
//
//  Created by Mario Rosales Maillo on 14/10/21.
//

import Foundation

public struct TrustedDeviceInfoParameters: Encodable {
    let trustedDeviceAppId: String
    public init(trustedDeviceAppId: String) {
        self.trustedDeviceAppId = trustedDeviceAppId
    }
}
