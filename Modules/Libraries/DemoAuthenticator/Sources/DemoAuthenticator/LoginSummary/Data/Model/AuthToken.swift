//
//  AuthToken.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 17/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

import Foundation

public struct AuthToken {
    public let userId: Int
    public let userCif: Int
    public let tokenType: String
    public let accessToken: String
    public let expirationDate: Date
}
