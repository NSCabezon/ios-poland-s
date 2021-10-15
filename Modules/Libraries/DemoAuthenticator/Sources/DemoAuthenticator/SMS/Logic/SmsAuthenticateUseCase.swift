//
//  SmsAuthenticateUseCase.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 17/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

import Foundation

final class SmsAuthenticateUseCase {
    private let smsAuthenticationEndpoint: SmsAuthenticationEndpointProtocol
    private let authHost: URL
    private let loginInfo: LoginInfoResponse
    private let encryptedPassword: String

    init(
        smsAuthenticationEndpoint: SmsAuthenticationEndpointProtocol,
        authHost: URL,
        loginInfo: LoginInfoResponse,
        encryptedPassword: String
    ) {
        self.smsAuthenticationEndpoint = smsAuthenticationEndpoint
        self.authHost = authHost
        self.loginInfo = loginInfo
        self.encryptedPassword = encryptedPassword
    }
}

extension SmsAuthenticateUseCase: SmsAuthenticateUseCaseProtocol {
    func authenticate(smsCode: String, completion: @escaping (Result<Route, Swift.Error>) -> Void) {
        let code = smsCode
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "-", with: "")
        let challenge = Challenge(
            authorizationType: loginInfo.secondFactorData.defaultChallenge.authorizationType,
            value: loginInfo.secondFactorData.defaultChallenge.value
        )
        let secondFactorData = SmsAuthenticateRequest.SmsSecondFactor(
            response: SmsAuthenticateRequest.SmsSecondFactor.Response(
                challenge: challenge,
                value: code
            )
        )
        let smsAuthenticateRequest = SmsAuthenticateRequest(
            userId: loginInfo.userId,
            encryptedPassword: encryptedPassword,
            secondFactorData: secondFactorData
        )
        smsAuthenticationEndpoint.authenticate(
            authHost: authHost,
            smsAuthenticateRequest: smsAuthenticateRequest
        ) { result in
            switch result {
            case let .failure(error):
                completion(.failure(error))
            case let .success(token):
                let authToken = AuthToken(
                    userId: token.userId,
                    userCif: token.userCif,
                    tokenType: token.type,
                    accessToken: token.access_token,
                    expirationDate: Date(timeIntervalSince1970: Double(token.expires))
                )
                let route = SuccessfulLoginRoute(
                    authToken: authToken
                )
                completion(.success(route))
            }
        }
    }
}
