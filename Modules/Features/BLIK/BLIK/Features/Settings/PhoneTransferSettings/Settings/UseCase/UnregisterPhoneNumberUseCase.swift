//
//  UnregisterPhoneNumberUseCase.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 19/08/2021.
//

import Commons
import Foundation
import CoreFoundationLib
import SANPLLibrary

protocol UnregisterPhoneNumberUseCaseProtocol: UseCase<Void, Void, StringErrorOutput> {}

final class UnregisterPhoneNumberUseCase: UseCase<Void, Void, StringErrorOutput> {
    private let dependenciesResolver: DependenciesResolver
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<Void, StringErrorOutput> {
        let managersProvider: PLManagersProviderProtocol = dependenciesResolver.resolve(
            for: PLManagersProviderProtocol.self
        )
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

