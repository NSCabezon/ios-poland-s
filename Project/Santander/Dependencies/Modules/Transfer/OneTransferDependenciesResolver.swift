//
//  OneTransferDependenciesResolver.swift
//  Santander
//
//  Created by Cristobal Ramos Laina on 19/1/22.
//

import CoreFoundationLib
import CoreDomain
import Transfer
import UI

extension ModuleDependencies: TransferExternalDependenciesResolver {
    func resolve() -> FaqsRepositoryProtocol {
        return oldResolver.resolve()
    }
    
    func resolve() -> TransfersRepository {
        return oldResolver.resolve()
    }
    
    func resolve() -> DependenciesInjector {
        return oldResolver.resolve()
    }
    
    func resolve() -> GetSendMoneyActionsUseCase {
        return PLGetSendMoneyActionsUseCase(candidateOfferUseCase: resolve())
    }
    
    func resolveCustomSendMoneyActionCoordinator() -> BindableCoordinator {
        return PLOneTransferHomeActionsCoordinator()
    }

    func resolve() -> AccountNumberFormatterProtocol? {
        return oldResolver.resolve(forOptionalType: AccountNumberFormatterProtocol.self)
    }
}
