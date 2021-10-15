//
//  SmsViewModelProtocol.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 17/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

protocol SmsViewModelProtocol {
    func authenticate(
        smsCode: String,
        completion: @escaping (Result<Route, Swift.Error>) -> Void
    )
}
