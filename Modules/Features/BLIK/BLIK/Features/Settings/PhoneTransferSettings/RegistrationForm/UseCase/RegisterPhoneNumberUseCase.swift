//
//  RegisterPhoneNumberUseCase.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 24/08/2021.
//

import Commons
import Foundation
import CoreFoundationLib
import SANPLLibrary

protocol RegisterPhoneNumberUseCaseProtocol: UseCase<RegisterPhoneNumberUseCaseInput, RegisterPhoneNumberUseCaseOutput, StringErrorOutput> {}

final class RegisterPhoneNumberUseCase: UseCase<RegisterPhoneNumberUseCaseInput, RegisterPhoneNumberUseCaseOutput, StringErrorOutput> {
    private let dependenciesResolver: DependenciesResolver
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    override func executeUseCase(requestValues: RegisterPhoneNumberUseCaseInput) throws -> UseCaseResponse<RegisterPhoneNumberUseCaseOutput, StringErrorOutput> {
        let managersProvider: PLManagersProviderProtocol = dependenciesResolver.resolve(
            for: PLManagersProviderProtocol.self
        )
        let request = RegisterPhoneNumberRequestDTO(
            accountNo: requestValues.registerPhoneNumberRequest.accountNo,
            authCode: requestValues.registerPhoneNumberRequest.authCode
        )
        let result = try managersProvider.getBLIKManager().registerPhoneNumber(request)
        switch result {
        case .success:
            return .ok(
                RegisterPhoneNumberUseCaseOutput(
                    registerPhoneNumberResponse: .successfulyRegisteredPhoneNumber
                ))
        case let .failure(error):
            if let blikError = BlikError(with: error.getErrorBody()),
               blikError.errorCode1 == .customerTypeDisabled,
               blikError.errorCode2 == .authCodeRequired {
                return .ok(
                    RegisterPhoneNumberUseCaseOutput(
                        registerPhoneNumberResponse: .smsAuthorizationCodeSent
                    )
                )
            } else {
                return .error(.init(error.localizedDescription))
            }
        }
    }
}

extension RegisterPhoneNumberUseCase: RegisterPhoneNumberUseCaseProtocol {}

struct RegisterPhoneNumberUseCaseInput {
    let registerPhoneNumberRequest: RegisterPhoneNumberRequest
}

struct RegisterPhoneNumberUseCaseOutput {
    let registerPhoneNumberResponse: RegisterPhoneNumberResponse
}
