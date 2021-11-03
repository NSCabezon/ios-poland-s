//
//  LoginViewModelProtocol.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 15/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

protocol LoginViewModelProtocol {
    func login(loginModel: LoginModel, completion: @escaping (Result<Route, Error>) -> Void)
    func save(loginModel: LoginModel)
}
