//
//  SmsAuthenticateResponse.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 17/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//
struct SmsAuthenticateResponse: Decodable {
    let userId: Int
    let userCif: Int
    let companyContext: Bool
    let type: String
    let access_token: String
    let expires: Int
}
