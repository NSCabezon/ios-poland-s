//
//  LoginInitEndpointProtocol.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 15/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

import Foundation

protocol LoginInitEndpointProtocol {
    func login(
        authHost: URL,
        loginInfoRequest: LoginInfoRequest,
        completion: @escaping (Result<LoginInfoResponse, Error>) -> Void
    )
}
