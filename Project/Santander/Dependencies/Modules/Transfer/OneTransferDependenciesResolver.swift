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

extension ModuleDependencies: OneTransferHomeExternalDependenciesResolver {
    func resolve() -> FaqsRepositoryProtocol {
        oldResolver.resolve()
    }
    
    func resolve() -> TransfersRepository {
        oldResolver.resolve()
    }
    
    func resolve() -> GetSendMoneyActionsUseCase {
        return PLGetSendMoneyActionsUseCase(candidateOfferUseCase: resolve())
    }
    
    func resolveCustomSendMoneyActionCoordinator() -> BindableCoordinator {
        return PLOneTransferHomeActionsCoordinator()
    }
}
