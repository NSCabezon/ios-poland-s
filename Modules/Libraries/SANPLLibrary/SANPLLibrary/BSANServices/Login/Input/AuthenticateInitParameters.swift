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
    let authorizationType, value: String

    public init(authorizationType: String, value: String) {
        self.authorizationType = authorizationType
        self.value = value
    }
}
