//
//  UnregisterPhoneNumberUseCase.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 19/08/2021.
//

import Commons
import Foundation
import DomainCommon
import SANPLLibrary

protocol UnregisterPhoneNumberUseCaseProtocol: UseCase<Void, Void, StringErrorOutput> {}

final class UnregisterPhoneNumberUseCase: UseCase<Void, Void, StringErrorOutput> {
    private let managersProvider: PLManagersProviderProtocol
    
    init(managersProvider: PLManagersProviderProtocol) {
        self.managersProvider = managersProvider
    }
    
    override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<Void, StringErrorOutput> {
        let result = try managersProvider.getBLIKManager().unregisterPhoneNumber()
        switch result {
        case .success:
            return .ok()
        case .failure(let error):
            return .error(.init(error.localizedDescription))
        }
    }
}

extension UnregisterPhoneNumberUseCase: UnregisterPhoneNumberUseCaseProtocol {}

