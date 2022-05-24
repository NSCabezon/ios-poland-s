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
import SANPLLibrary

extension ModuleDependencies: TransferExternalDependenciesResolver {
    func resolve() -> FaqsRepositoryProtocol {
        return oldResolver.resolve()
    }
    
    func resolve() -> TransfersRepository {
        return oldResolver.resolve()
    }
    
    func resolve() -> GetSendMoneyActionsUseCase {
        return PLGetSendMoneyActionsUseCase(dependencies: self)
    }
    
    func resolveCustomSendMoneyActionCoordinator() -> BindableCoordinator {
        return PLOneTransferHomeActionsCoordinator(transferExternalResolver: self)
    }
    
    func transferHomeCoordinator() -> BindableCoordinator {
        return oneTransferHomeCoordinator()
    }
    
    func resolve() -> OneTransferHomeVisibilityModifier {
        return PLOneTransferHomeVisibilityModifier()
    }
}

extension ModuleDependencies: PLGetSendMoneyActionsUseCaseDependenciesResolver {
    func resolve() -> BSANDataProvider {
        return BSANDataProvider(dataRepository: oldResolver.resolve(for: DataRepository.self))
    }
}
