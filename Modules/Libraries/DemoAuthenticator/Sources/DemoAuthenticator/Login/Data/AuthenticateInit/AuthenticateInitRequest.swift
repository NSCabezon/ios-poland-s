//
//  AuthenticateInitRequest.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 17/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

struct AuthenticateInitRequest: Encodable {
    let userId: Int
    let secondFactorData: AuthenticateInitRequest.SecondFactor

    struct SecondFactor: Codable {
        let challenges: [Challenge]
        let defaultChallenge: Challenge

    }

}
