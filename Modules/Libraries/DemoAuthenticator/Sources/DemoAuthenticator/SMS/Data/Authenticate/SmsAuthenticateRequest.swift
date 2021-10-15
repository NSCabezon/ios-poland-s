//
//  SmsAuthenticateRequest.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 17/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

struct SmsAuthenticateRequest: Encodable {
    let userId: Int
    let encryptedPassword: String
    let secondFactorData: SmsAuthenticateRequest.SmsSecondFactor

    struct SmsSecondFactor: Encodable {
        let response: SmsAuthenticateRequest.SmsSecondFactor.Response

        struct Response: Encodable {
            let challenge: Challenge
            let value: String

        }
    }
}
