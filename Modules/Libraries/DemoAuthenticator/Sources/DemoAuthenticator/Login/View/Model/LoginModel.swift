//
//  LoginModel.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 15/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

import Foundation

struct LoginModel {
    let authHost: URL
    let nik: Int
    let password: String
}

extension LoginModel: LoginModelProtocol {}
