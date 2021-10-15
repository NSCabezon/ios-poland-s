//
//  LoginSummaryViewModel.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 17/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

import Foundation

final class LoginSummaryViewModel {
    let authToken: AuthToken
    private let logoutUseCase: LogoutUseCaseProtocol
    private let dateFormatter: DateFormatter

    var tokenExpirationDate: String {
        return dateFormatter.string(from: authToken.expirationDate)
    }
    var accessToken: String {
        return authToken.accessToken
    }

    init(
        authToken: AuthToken,
        logoutUseCase: LogoutUseCaseProtocol,
        dateFormatter: DateFormatter
    ) {
        self.authToken = authToken
        self.logoutUseCase = logoutUseCase
        self.dateFormatter = dateFormatter
    }

    func logout(completion: @escaping (Result<Route, Error>) -> Void) {
        logoutUseCase.logout { result in
            switch result {
            case let .failure(error):
                completion(.failure(error))
            case .success:
                completion(.success(BackToLoginPageRoute()))
            }

        }
    }
}
