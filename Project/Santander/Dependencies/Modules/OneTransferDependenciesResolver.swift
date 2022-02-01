//
//  OneTransferDependenciesResolver.swift
//  Santander
//
//  Created by Cristobal Ramos Laina on 19/1/22.
//

import Foundation
import Transfer
import Commons
import CoreFoundationLib
import CoreDomain
import UI

extension ModuleDependencies: OneTransferHomeExternalDependenciesResolver {
    func resolve() -> FaqsRepositoryProtocol {
        legacyDependenciesResolver.resolve()
    }
    
    func resolve() -> TransfersRepository {
        legacyDependenciesResolver.resolve()
    }
    
    func resolve() -> DependenciesInjector {
        legacyDependenciesResolver.resolve()
    }
    
    func resolve() -> GetSendMoneyActionsUseCase {
        return PLGetSendMoneyActionsUseCase(candidateOfferUseCase: resolve())
    }
    
    func resolveCustomSendMoneyActionCoordinator() -> BindableCoordinator {
        return PLOneTransferHomeActionsCoordinator()
    }
}
