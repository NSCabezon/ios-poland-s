//
//  InternalTransferPreSetupUseCase.swift
//  TransferOperatives
//
//  Created by Cristobal Ramos Laina on 15/2/22.
//

import Foundation
import OpenCombine
import CoreDomain
import SANLegacyLibrary
import CoreFoundationLib
import TransferOperatives
import SANPLLibrary

protocol PLInternalTransferOperativeExternalDependenciesResolver {
    func resolve() -> PLTransfersRepository
    func resolve() -> PLAccountOtherOperativesInfoRepository
    func resolve() -> GlobalPositionDataRepository
    func resolve() -> DependenciesResolver
}

struct PLInternalTransferPreSetupUseCase {
    let transfersRepository: PLTransfersRepository
    let globalPositionRepository: GlobalPositionDataRepository
    
    init(dependencies: PLInternalTransferOperativeExternalDependenciesResolver) {
        self.transfersRepository = dependencies.resolve()
        self.globalPositionRepository = dependencies.resolve()
    }
}

extension PLInternalTransferPreSetupUseCase: InternalTransferPreSetupUseCase {
    func fetchPreSetup() -> AnyPublisher<PreSetupData, InternalTransferOperativeError> {
        Publishers.Zip(
            globalPositionRepository.getMergedGlobalPosition().setFailureType(to: Error.self),
            transfersRepository.getAccountsForDebitSwitch()
        )
            .mapError { _ in
                return InternalTransferOperativeError.network
            }
            .flatMap { globalPosition, debitAccounts -> AnyPublisher<PreSetupData, InternalTransferOperativeError> in
                let notVisiblesPGAccounts = globalPosition.accounts.filter { $0.isVisible == false }
                let gpNotVisibleAccounts = notVisiblesPGAccounts.map { account in
                    return account.product
                }
                let (originAccountsVisibles, originAccountsNotVisibles) = originAccounts(accounts: debitAccounts, gpNotVisibleAccounts: gpNotVisibleAccounts)
                if isMinimunAccounts(accounts: originAccountsVisibles + originAccountsNotVisibles) == false {
                    return Fail(error: InternalTransferOperativeError.originMinimunAccounts).eraseToAnyPublisher()
                }
                let data = PreSetupData(originAccountsVisibles: originAccountsVisibles,
                                    originAccountsNotVisibles: originAccountsNotVisibles,
                                    destinationAccountsVisibles: nil,
                                    destinationAccountsNotVisibles: nil)
                return Just(data).setFailureType(to: InternalTransferOperativeError.self).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func isMinimunAccounts(accounts: [AccountRepresentable]) -> Bool {
        if accounts.count > 1 {
            return true
        } else {
            return false
        }
    }
    
    func originAccounts(accounts: [AccountRepresentable], gpNotVisibleAccounts: [AccountRepresentable]) -> ([AccountRepresentable], [AccountRepresentable]) {
        var originAccountsVisibles: [AccountRepresentable] = []
        var originAccountsNotVisibles: [AccountRepresentable] = []
        accounts.forEach { account in
            let polandAccount = account as? PolandAccountRepresentable
            let containsAccountNotVisible = gpNotVisibleAccounts.contains { accountNotVisibles in
                return polandAccount?.ibanRepresentable?.codBban.contains(accountNotVisibles.ibanRepresentable?.codBban ?? "") ?? false
            }
            guard containsAccountNotVisible else {
                originAccountsVisibles.append(account)
                return
            }
            originAccountsNotVisibles.append(account)
        }
        return (originAccountsVisibles, originAccountsNotVisibles)
    }
}
