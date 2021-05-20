//
//  AuthenticateParameters.swift
//  SANPLLibrary
//
//  Created by Juan Sánchez Marín on 20/5/21.
//

import Foundation

public struct AuthenticateParameters: Encodable {
    let encryptedPassword, userId: String?
    let secondFactorData: SecondFactorData

    public init(encryptedPassword: String, userId: String, secondFactorData: SecondFactorData) {
        self.encryptedPassword = encryptedPassword
        self.userId = userId
        self.secondFactorData = secondFactorData
    }
}

public struct SecondFactorData: Encodable {
    let response: Response

    public init(response: Response) {
        self.response = response
    }
}

public struct Response: Encodable {
    let challenge: Challenge
    let value: String

    public init(challenge: Challenge, value: String) {
        self.challenge = challenge
        self.value = value
    }
}

public struct Challenge: Encodable {
    let authorizationType, value: String

    public init(authorizationType: String, value: String) {
        self.authorizationType = authorizationType
        self.value = value
    }
}
