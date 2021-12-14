//
//  LoadWalletParamsUseCase.swift
//  Account
//
//  Created by Piotr Mielcarzewicz on 16/06/2021.
//

import Commons
import Foundation
import CoreFoundationLib
import SANPLLibrary

protocol LoadWalletParamsUseCaseProtocol: UseCase<Void, LoadWalletParamsUseCaseOutput, StringErrorOutput> {}

final class LoadWalletParamsUseCase: UseCase<Void, LoadWalletParamsUseCaseOutput, StringErrorOutput> {
    private let dependenciesResolver: DependenciesResolver
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<LoadWalletParamsUseCaseOutput, StringErrorOutput> {
        let managersProvider: PLManagersProviderProtocol = dependenciesResolver.resolve(
            for: PLManagersProviderProtocol.self
        )
        let result = try managersProvider.getBLIKManager().getWalletParams()
        
        switch result {
        case let .success(dto):
            return .ok(
                LoadWalletParamsUseCaseOutput(
                    walletParams: WalletParams(
                        activeChequesLimit: dto.maxActiveCheques,
                        maxChequeAmount: Decimal(dto.maxChequeAmount)
                    )
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

struct LoadWalletParamsUseCaseOutput {
    let walletParams: WalletParams
}
