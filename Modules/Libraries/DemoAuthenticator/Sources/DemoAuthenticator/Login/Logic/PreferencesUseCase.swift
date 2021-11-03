//
//  PreferencesUseCase.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 18/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

import Foundation

final class PreferencesUseCase {
    private enum Keys: String {
        case authHost = "AUTHORIZATION_HOST"
        case nik = "NIK"
        case password = "PASSWORD"
    }

    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
}

extension PreferencesUseCase: PreferencesUseCaseProtocol {
    func save(loginModel: LoginModel) {
        userDefaults.set(loginModel.authHost, forKey: Keys.authHost.rawValue)
        userDefaults.set(loginModel.nik, forKey: Keys.nik.rawValue)
        userDefaults.set(loginModel.password, forKey: Keys.password.rawValue)
    }

    func loadLoginModel() -> LoginModel? {
        guard
            let authHost = userDefaults.url(forKey: Keys.authHost.rawValue),
            let password = userDefaults.string(forKey: Keys.password.rawValue)
        else {
            return nil
        }

        let nik = userDefaults.integer(forKey: Keys.nik.rawValue)

        let loginModel = LoginModel(
            authHost: authHost,
            nik: nik,
            password: password
        )
        return loginModel
    }
}
