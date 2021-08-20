//
//  RegisterConfirmationCodeParameters.swift
//  SANPLLibrary
//
//  Created by Mario Rosales Maillo on 12/8/21.
//

import Foundation

public struct RegisterConfirmationCodeParameters: Encodable {

    let trustedDeviceId: String
    let secondFactorSmsChallenge: String
    let language: String

    public init(trustedDeviceId: String, secondFactorSmsChallenge: String, language: String) {
        self.trustedDeviceId = trustedDeviceId
        self.secondFactorSmsChallenge = secondFactorSmsChallenge
        self.language = language
    }
}
