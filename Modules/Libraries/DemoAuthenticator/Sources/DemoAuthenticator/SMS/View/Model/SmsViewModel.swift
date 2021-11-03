//
//  SmsViewModel.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 17/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

final class SmsViewModel {
    private let smsAuthenticateUseCase: SmsAuthenticateUseCaseProtocol

    init(
        smsAuthenticateUseCase: SmsAuthenticateUseCaseProtocol
    ) {
        self.smsAuthenticateUseCase = smsAuthenticateUseCase
    }
}

extension SmsViewModel: SmsViewModelProtocol {
    func authenticate(
        smsCode: String,
        completion: @escaping (Result<Route, Swift.Error>) -> Void
    ) {
        smsAuthenticateUseCase.authenticate(smsCode: smsCode, completion: completion)
    }
}
