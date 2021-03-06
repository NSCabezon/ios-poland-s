//
//  TransferOperativesDependenciesResolver.swift
//  Santander
//
//  Created by Cristobal Ramos Laina on 17/2/22.
//

import TransferOperatives
import CoreFoundationLib
import SANPLLibrary
import PLCommons
import Operative
import UI

extension ModuleDependencies: TransferOperativesExternalDependenciesResolver, PLInternalTransferOperativeExternalDependenciesResolver, PLGetInternalTransferDestAccountsUseCaseDependenciesResolver {
    func resolve() -> PLTransfersRepository {
        return oldResolver.resolve()
    }
    
    func resolve() -> InternalTransferConfirmationBuilder {
        return PLInternalTransferConfirmationBuilder(dependencies: self)
    }
    
    func resolve() -> InternalTransferHeaderSummaryBuilder {
        return PLInternalTransferHeaderSummaryBuilder(dependencies: self)
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
    
    func resolve() -> InternalTransferAmountModifierProtocol {
        return PLInternalTransferAmountModifier()
    }

    func resolve() -> GetInternalTransferDestinationAccountsUseCase {
        return PLGetInternalTransferDestAccountsUseCase(dependencies: self)
    }
    
    func resolve() -> CurrencyFormatterProvider {
        return PLNumberFormatter()
    }
    
    func resolve() -> GetInternalTransferAmountExchangeRateUseCase {
        PLGetInternalTransferAmountExchangeRateUseCase(dependencies: self)
    }
    
    func resolve() -> InternalTransferSummaryModifierProtocol {
        return PLInternalTransferSummaryModifier(dependencies: self)
    }

    func resolve() -> InternalTransferConfirmationModifierProtocol {
        return PLInternalTransferConfirmationModifier(dependencies: self)
    }
    
    func resolve() -> PLAccountOtherOperativesInfoRepository {
        return oldResolver.resolve()
    }
    
    func resolve() -> GetAccountsFullNameUseCase {
        return PLGetAccountsFullNameUseCase(dependencies: self)
    }
}
