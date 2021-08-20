//
//  RegisterIvrParameters.swift
//  SANPLLibrary
//
//  Created by Mario Rosales Maillo on 2/8/21.
//

import Foundation

public struct RegisterIvrParameters: Encodable {

    let trustedDeviceId: String

    public init(trustedDeviceId: String) {
        self.trustedDeviceId = trustedDeviceId
    }
}
