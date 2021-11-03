//
//  Challenge.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 17/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

struct Challenge: Codable {
    let authorizationType: Challenge.AuthorizationType
    let value: String

    enum AuthorizationType: String, Codable {
        case smsCode = "SMS_CODE"
    }
}
