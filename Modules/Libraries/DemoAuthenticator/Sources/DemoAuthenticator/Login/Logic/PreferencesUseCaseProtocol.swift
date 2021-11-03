//
//  PreferencesUseCaseProtocol.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 18/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

protocol PreferencesUseCaseProtocol {
    func save(loginModel: LoginModel)
    func loadLoginModel() -> LoginModel?
}
