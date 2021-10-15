//
//  AuthenticateInitEndpointProtocol.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 17/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

import Foundation

protocol AuthenticateInitEndpointProtocol {
    func authenticateInit(
        authHost: URL,
        authenticateInitRequest: AuthenticateInitRequest,
        completion: @escaping (Result<Void, Error>) -> Void
    )
}
