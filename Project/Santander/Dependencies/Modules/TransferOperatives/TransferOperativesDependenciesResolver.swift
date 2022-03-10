//
//  TransferOperativesDependenciesResolver.swift
//  Santander
//
//  Created by Cristobal Ramos Laina on 17/2/22.
//

import TransferOperatives
import CoreFoundationLib
import SANPLLibrary
import UI

extension ModuleDependencies: TransferOperativesExternalDependenciesResolver, PLInternalTransferOperativeExternalDependenciesResolver {
    func resolve() -> PLTransfersRepository {
        return oldResolver.resolve()
    }
    
    func resolve() -> InternalTransferPreSetupUseCase {
        return PLInternalTransferPreSetupUseCase(dependencies: self)
    }
    
    func resolve() -> AccountNumberFormatterProtocol? {
        return PLAccountNumberFormatter()
    }
    
    func resolve() -> InternalTransferAmountModifierProtocol? {
        return PLInternalTransferAmountModifier()
    }

    func resolve() -> GetInternalTransferDestinationAccountsUseCase {
        return PLGetInternalTransferDestAccountsUseCase()
    }

    func resolve() -> CurrencyFormatterProvider {
        return oldResolver.resolve()
    }
    
    func opinatorCoordinator() -> BindableCoordinator {
        return OpinatorWebViewCoordinator(dependencies: self)
    }
}
