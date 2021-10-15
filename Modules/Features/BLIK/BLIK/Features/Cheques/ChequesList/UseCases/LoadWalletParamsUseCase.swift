//
//  LoadWalletParamsUseCase.swift
//  Account
//
//  Created by Piotr Mielcarzewicz on 16/06/2021.
//

import Commons
import Foundation
import DomainCommon
import SANPLLibrary

protocol LoadWalletParamsUseCaseProtocol: UseCase<Void, WalletParams, StringErrorOutput> {}

final class LoadWalletParamsUseCase: UseCase<Void, WalletParams, StringErrorOutput> {
    private let managersProvider: PLManagersProviderProtocol
    
    init(managersProvider: PLManagersProviderProtocol) {
        self.managersProvider = managersProvider
    }
    
    override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<WalletParams, StringErrorOutput> {
        let result = try managersProvider.getBLIKManager().getWalletParams()
        
        switch result {
        case let .success(dto):
            return .ok(
                WalletParams(
                    activeChequesLimit: dto.maxActiveCheques,
                    maxChequeAmount: Decimal(dto.maxChequeAmount)
                )
            )
        case .failure(let error):
            return .error(.init(error.localizedDescription))
        }
    }
}

extension LoadWalletParamsUseCase: LoadWalletParamsUseCaseProtocol {
    enum Error: LocalizedError {
        case missingWallet
        
        var errorDescription: String? {
            switch self {
            case .missingWallet:
                return "#Brak aktywnego portfela BLIK"
            }
        }
    }
}
