//
//  LoginUseCaseProtocol.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 16/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

protocol LoginUseCaseProtocol {
    func login(loginModel: LoginModel, completion: @escaping (Result<Route, Swift.Error>) -> Void)
}
