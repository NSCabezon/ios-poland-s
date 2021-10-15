//
//  LogoutUseCase.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 18/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

final class LogoutUseCase {}

extension LogoutUseCase: LogoutUseCaseProtocol {
    func logout(
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        completion(.success(()))
    }
}
