//
//  SmsAuthenticationEndpointProtocol.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 17/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

import Foundation

protocol SmsAuthenticationEndpointProtocol {
    func authenticate(
        authHost: URL,
        smsAuthenticateRequest: SmsAuthenticateRequest,
        completion: @escaping (Result<SmsAuthenticateResponse, Error>) -> Void
    )
}
