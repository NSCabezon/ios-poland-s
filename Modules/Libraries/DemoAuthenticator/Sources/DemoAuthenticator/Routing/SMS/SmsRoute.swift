//
//  SmsRoute.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 15/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

import Foundation

struct SmsRoute: Route {
    let authHost: URL
    let loginInfo: LoginInfoResponse
    let encryptedPassword: String
}
