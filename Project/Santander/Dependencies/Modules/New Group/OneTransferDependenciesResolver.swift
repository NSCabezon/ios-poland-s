//
//  OneTransferDependenciesResolver.swift
//  Santander
//
//  Created by Cristobal Ramos Laina on 19/1/22.
//

import Foundation
import Transfer
import CoreFoundationLib
import CoreDomain
import UI

extension ModuleDependencies: TransferExternalDependenciesResolver {
    func resolve() -> FaqsRepositoryProtocol {
        oldResolver.resolve()
    }
    
    func resolve() -> TransfersRepository {
        oldResolver.resolve()
    }
    
    func resolve() -> DependenciesInjector {
        oldResolver.resolve()
    }
    
    func resolve() -> GetSendMoneyActionsUseCase {
        return PLGetSendMoneyActionsUseCase(candidateOfferUseCase: resolve())
    }
    
    func resolveCustomSendMoneyActionCoordinator() -> BindableCoordinator {
        return PLOneTransferHomeActionsCoordinator()
    }
    
    func resolve() -> AppRepositoryProtocol {
        return oldResolver.resolve()
    }
    
    func resolve() -> GlobalPositionRepresentable {
        return oldResolver.resolve()
    }
}
