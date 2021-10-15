//
//  RegisterPhoneNumberUseCase.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 24/08/2021.
//

import Commons
import Foundation
import DomainCommon
import SANPLLibrary

protocol RegisterPhoneNumberUseCaseProtocol: UseCase<RegisterPhoneNumberRequest, RegisterPhoneNumberResponse, StringErrorOutput> {}

final class RegisterPhoneNumberUseCase: UseCase<RegisterPhoneNumberRequest, RegisterPhoneNumberResponse, StringErrorOutput> {
    private let managersProvider: PLManagersProviderProtocol
    
    init(
        managersProvider: PLManagersProviderProtocol
    ) {
        self.managersProvider = managersProvider
    }
    
    override func executeUseCase(requestValues: RegisterPhoneNumberRequest) throws -> UseCaseResponse<RegisterPhoneNumberResponse, StringErrorOutput> {
        let request = RegisterPhoneNumberRequestDTO(
            accountNo: requestValues.accountNo,
            authCode: requestValues.authCode
        )
        let result = try managersProvider.getBLIKManager().registerPhoneNumber(request)
        switch result {
        case let .success(responseDTO):
            switch responseDTO {
            case .successfulyRegisteredPhoneNumber:
                return .ok(.successfulyRegisteredPhoneNumber)
            case .smsAuthorizationCodeSent:
                return .ok(.smsAuthorizationCodeSent)
            case let .error(error):
                return .error(.init(error.message))
            }
        case .failure(let error):
            return .error(.init(error.localizedDescription))
        }
    }
}

extension RegisterPhoneNumberUseCase: RegisterPhoneNumberUseCaseProtocol {}
