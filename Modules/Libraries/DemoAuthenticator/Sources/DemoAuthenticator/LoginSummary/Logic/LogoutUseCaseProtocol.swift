//
//  LogoutUseCaseProtocol.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 18/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

protocol LogoutUseCaseProtocol {
    func logout(
        completion: @escaping (Result<Void, Error>) -> Void
    )
}
