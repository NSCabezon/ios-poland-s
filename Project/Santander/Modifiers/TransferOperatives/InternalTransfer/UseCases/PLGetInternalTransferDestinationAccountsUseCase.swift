//
//  PLGetInternalTransferDestinationAccountsUseCase.swift
//  Santander
//
//  Created by Carlos Monfort Gómez on 21/2/22.
//

import OpenCombine
import CoreDomain
import TransferOperatives
import SANPLLibrary

struct PLGetInternalTransferDestAccountsUseCase {
    let transfersRepository: PLTransfersRepository
    let globalPositionRepository: GlobalPositionDataRepository
    
    init(dependencies: PLInternalTransferOperativeExternalDependenciesResolver) {
        self.transfersRepository = dependencies.resolve()
        self.globalPositionRepository = dependencies.resolve()
    }
}

extension PLGetInternalTransferDestAccountsUseCase: GetInternalTransferDestinationAccountsUseCase {
    
    func fetchAccounts(_ originAccount: AccountRepresentable) -> AnyPublisher<GetInternalTransferDestinationAccountsOutput, InternalTransferOperativeError> {
        let polandAccount = originAccount as? PolandAccountRepresentable
        return Publishers.Zip(
            globalPositionRepository.getMergedGlobalPosition().setFailureType(to: Error.self),
            transfersRepository.getAccountsForCreditSwitch(polandAccount?.type?.rawValue ?? "")
        )
            .mapError { _ in
                return InternalTransferOperativeError.network
            }
            .flatMap { globalPosition, creditAccounts -> AnyPublisher<GetInternalTransferDestinationAccountsOutput, InternalTransferOperativeError> in
                let notVisiblesPGAccounts = globalPosition.accounts.filter { $0.isVisible == false }
                let gpNotVisibleAccounts = notVisiblesPGAccounts.map { account in
                    return account.product
                }
                let filterAccounts = getFilteredAccounts(from: creditAccounts, originAccount: originAccount)
                if filterAccounts.isEmpty && gpNotVisibleAccounts.isEmpty {
                    return Fail(error: InternalTransferOperativeError.destinationMinimunAccounts).eraseToAnyPublisher()
                }
                return Just(destinationAccounts(accounts: filterAccounts, gpNotVisibleAccounts: gpNotVisibleAccounts))
                    .setFailureType(to: InternalTransferOperativeError.self)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}

private extension PLGetInternalTransferDestAccountsUseCase {
        func destinationAccounts(accounts: [AccountRepresentable], gpNotVisibleAccounts: [AccountRepresentable]) -> GetInternalTransferDestinationAccountsOutput {
            var destinationAccountsVisibles: [AccountRepresentable] = []
            var destinationAccountsNotVisibles: [AccountRepresentable] = []
            accounts.forEach { account in
                let polandAccount = account as? PolandAccountRepresentable
                let containsAccountNotVisible = gpNotVisibleAccounts.contains { accountNotVisibles in
                    return polandAccount?.ibanRepresentable?.codBban.contains(accountNotVisibles.ibanRepresentable?.codBban ?? "") ?? false
                }
                guard containsAccountNotVisible else {
                    destinationAccountsVisibles.append(account)
                    return
                }
                destinationAccountsNotVisibles.append(account)
            }
            return (GetInternalTransferDestinationAccountsOutput(visibleAccounts: destinationAccountsVisibles, notVisibleAccounts: destinationAccountsNotVisibles))
        }
    
    func getFilteredAccounts(from accounts: [AccountRepresentable], originAccount: AccountRepresentable) -> [PolandAccountRepresentable] {
        let accounts = accounts.filter { !$0.equalsTo(other: originAccount) }
        return accounts as? [PolandAccountRepresentable] ?? []
        
    }
}
