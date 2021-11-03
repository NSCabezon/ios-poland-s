//
//  LoginViewModel.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 15/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

final class LoginViewModel {
    private let loginUseCase: LoginUseCaseProtocol
    private let preferencesUseCase: PreferencesUseCaseProtocol

    init(
        loginUseCase: LoginUseCaseProtocol,
        preferencesUseCase: PreferencesUseCaseProtocol
    ) {
        self.loginUseCase = loginUseCase
        self.preferencesUseCase = preferencesUseCase
    }
}

extension LoginViewModel: LoginViewModelProtocol {
    func login(loginModel: LoginModel, completion: @escaping (Result<Route, Swift.Error>) -> Void) {
        loginUseCase.login(loginModel: loginModel, completion: completion)
    }

    func save(loginModel: LoginModel) {
        preferencesUseCase.save(loginModel: loginModel)
    }

    func loadLoginModel() -> LoginModel? {
        return preferencesUseCase.loadLoginModel()
    }
}
