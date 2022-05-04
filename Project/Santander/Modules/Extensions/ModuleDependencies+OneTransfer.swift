//
//  ModuleDependencies.swift
//  Santander
//
//  Created by Carlos Monfort Gómez on 24/12/21.
//

import Foundation
import Transfer
import Commons
import CoreFoundationLib
import CoreDomain
import UI

extension ModuleDependencies: OneTransferHomeExternalDependenciesResolver, OneFavouritesListExternalDependenciesResolver {
    func resolve() -> TransfersRepository {
        legacyDependenciesResolver.resolve()
    }
    
    func resolve() -> DependenciesInjector {
        legacyDependenciesResolver.resolve()
    }
    
    func resolve() -> GetSendMoneyActionsUseCase {
        return PLGetSendMoneyActionsUseCase()
    }
    
    func resolveCustomSendMoneyActionCoordinator() -> BindableCoordinator {
        return PLOneTransferHomeActionsCoordinator()
    }
}
