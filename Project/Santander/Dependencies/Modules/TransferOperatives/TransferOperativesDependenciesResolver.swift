//
//  TransferOperativesDependenciesResolver.swift
//  Santander
//
//  Created by Cristobal Ramos Laina on 17/2/22.
//

import TransferOperatives
import SANPLLibrary
import CoreFoundationLib

extension ModuleDependencies: TransferOperativesExternalDependenciesResolver, PLInternalTransferOperativeExternalDependenciesResolver {
    func resolve() -> PLTransfersRepository {
        return oldResolver.resolve()
    }
    
    func resolve() -> InternalTransferPreSetupUseCase {
        return PLInternalTransferPreSetupUseCase(dependencies: self)
    }
    
    func resolve() -> InternalTransferConfirmationUseCase {
        return PLInternalTransferConfirmationUseCase(dependencies: self)
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
}
