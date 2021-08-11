//
//  AuthenticateInitParameters.swift
//  SANPLLibrary
//
//  Created by Juan Sánchez Marín on 20/5/21.
//

import Foundation

public struct AuthenticateInitParameters: Encodable {
    let userId: String
    let secondFactorData: SecondFactorData

    public init(userId: String, secondFactorData: SecondFactorData) {
        self.userId = userId
        self.secondFactorData = secondFactorData
    }
}

public struct SecondFactorData: Encodable {
    let defaultChallenge: DefaultChallenge

    public init(defaultChallenge: DefaultChallenge) {
        self.defaultChallenge = defaultChallenge
    }
}

public struct DefaultChallenge: Encodable {
    let value: String
    let authorizationType: AuthorizationType

    public init(authorizationType: AuthorizationType, value: String) {
        self.authorizationType = authorizationType
        self.value = value
    }
}

public enum AuthorizationType: String, Codable {
    case sms = "SMS_CODE"
    case softwareToken = "SOFTWARE_TOKEN"
    case tokenTime = "TOKEN_TIME"
    case tokenTimeCR = "TOKEN_TIME_CHALLENGE_RESPONSE"
}
