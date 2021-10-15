//
//  LoginUseCase.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 16/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

import Foundation

final class LoginUseCase {
    enum Error: Swift.Error {
        case selfDeallocated
        case missingData
    }

    private let loginInitEndpoint: LoginInitEndpointProtocol
    private let pubKeyEndpoint: PubKeyEndpointProtocol
    private let authenticateInitEndpoint: AuthenticateInitEndpointProtocol
    private let passwordUseCase: PasswordUseCaseProtocol
    private let encryptTextUseCase: EncryptTextUseCaseProtocol

    init(
        loginInitEndpoint: LoginInitEndpointProtocol,
        pubKeyEndpoint: PubKeyEndpointProtocol,
        authenticateInitEndpoint: AuthenticateInitEndpointProtocol,
        passwordUseCase: PasswordUseCaseProtocol,
        encryptTextUseCase: EncryptTextUseCaseProtocol
    ) {
        self.loginInitEndpoint = loginInitEndpoint
        self.pubKeyEndpoint = pubKeyEndpoint
        self.authenticateInitEndpoint = authenticateInitEndpoint
        self.passwordUseCase = passwordUseCase
        self.encryptTextUseCase = encryptTextUseCase
    }
}

extension LoginUseCase: LoginUseCaseProtocol {
    func login(loginModel: LoginModel, completion: @escaping (Result<Route, Swift.Error>) -> Void) {
        var loginInfoResponse: LoginInfoResponse?
        var pubKey: PubKey?
        var loginInitError: Swift.Error?
        var pubKeyError: Swift.Error?
        let group = DispatchGroup()

        group.enter()
        loginInit(
            authHost: loginModel.authHost,
            userId: loginModel.nik
        ) { result in
            switch result {
            case let .failure(error):
                loginInitError = error
            case let .success(data):
                loginInfoResponse = data
            }
            group.leave()
        }

        group.enter()
        pubKeyEndpoint.pubKey(
            authHost: loginModel.authHost
        ) { result in

            switch result {
            case let .failure(error):
                pubKeyError = error
            case let .success(data):
                pubKey = data
            }
            group.leave()
        }

        group.notify(queue: .global()) { [weak self] in
            guard let strongSelf = self else {
                completion(.failure(Error.selfDeallocated))
                return
            }
            if let loginInitError = loginInitError {
                completion(.failure(loginInitError))
                return
            }
            if let pubKeyError = pubKeyError {
                completion(.failure(pubKeyError))
                return
            }
            guard
                let loginInfoResponse = loginInfoResponse,
                let pubKey = pubKey
            else {
                completion(.failure(Error.missingData))
                return
            }
            strongSelf.authenticateInit(
                loginModel: loginModel,
                loginInfo: loginInfoResponse,
                pubKey: pubKey,
                completion: completion
            )
        }

    }

    private func loginInit(
        authHost: URL,
        userId: Int,
        completion: @escaping (Result<LoginInfoResponse, Swift.Error>) -> Void
    ) {
        let loginInfoRequest = LoginInfoRequest(userId: userId)
        loginInitEndpoint.login(
            authHost: authHost,
            loginInfoRequest: loginInfoRequest,
            completion: completion
        )
    }

    private func authenticateInit(
        loginModel: LoginModel,
        loginInfo: LoginInfoResponse,
        pubKey: PubKey,
        completion: @escaping (Result<Route, Swift.Error>) -> Void
    ) {
        let password: String
        if
            loginInfo.passwordMaskEnabled,
            let passwordMask = loginInfo.passwordMask {
            password = passwordUseCase.mask(password: loginModel.password, with: passwordMask)
        } else {
            password = loginModel.password
        }
        let encryptedPassword: String
        do {
            encryptedPassword = try encryptTextUseCase.encrypt(text: password, using: pubKey)
        } catch {
            completion(.failure(error))
            return
        }

        let secondFactorData = AuthenticateInitRequest.SecondFactor(
            challenges: loginInfo.secondFactorData.challenges,
            defaultChallenge: loginInfo.secondFactorData.defaultChallenge
        )
        let authenticateInitRequest = AuthenticateInitRequest(
            userId: loginModel.nik,
            secondFactorData: secondFactorData
        )
        authenticateInitEndpoint.authenticateInit(
            authHost: loginModel.authHost,
            authenticateInitRequest: authenticateInitRequest
        ) { result in
            switch result {
            case let .failure(error):
                completion(.failure(error))
            case .success:
                let smsRoute = SmsRoute(
                    authHost: loginModel.authHost,
                    loginInfo: loginInfo,
                    encryptedPassword: encryptedPassword
                )
                completion(.success(smsRoute))
            }
        }
    }
}
