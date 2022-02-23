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

struct PLGetInternalTransferDestAccountsUseCase {}

struct PLGetInternalTransferDestinationAccountsUseCaseOutput: GetInternalTransferDestinationAccountsUseCaseOutput {
    let visibleAccounts: [AccountRepresentable]
    let notVisibleAccounts: [AccountRepresentable]
}

extension PLGetInternalTransferDestAccountsUseCase: GetInternalTransferDestinationAccountsUseCase {
    func fetchAccounts(visibleAccounts: [AccountRepresentable],
                       notVisibleAccounts: [AccountRepresentable],
                       originAccount: AccountRepresentable) -> AnyPublisher<GetInternalTransferDestinationAccountsUseCaseOutput, Never> {
        return Just(filterDestinationAccounts(visibleAccounts: filterPolandAccounts(visibleAccounts),
                                              notVisibleAccounts: filterPolandAccounts(notVisibleAccounts),
                                              originAccount: originAccount)
        ).eraseToAnyPublisher()
    }
}

private extension PLGetInternalTransferDestAccountsUseCase {
    func filterPolandAccounts(_ accounts: [AccountRepresentable]) -> [PolandAccountRepresentable] {
        guard let polandAccounts: [PolandAccountRepresentable] = accounts as? [PolandAccountRepresentable] else { return [] }
        return polandAccounts.filter { $0.type != .creditCard }
    }
    
    func filterDestinationAccounts(visibleAccounts: [PolandAccountRepresentable],
                                   notVisibleAccounts: [PolandAccountRepresentable],
                                   originAccount: AccountRepresentable) -> GetInternalTransferDestinationAccountsUseCaseOutput {
        guard let originAccount = originAccount as? PolandAccountRepresentable else {
            return PLGetInternalTransferDestinationAccountsUseCaseOutput(visibleAccounts: [],
                                                                         notVisibleAccounts: [])
        }
        guard originAccount.type == .creditCard else {
            return PLGetInternalTransferDestinationAccountsUseCaseOutput(visibleAccounts: visibleAccounts,
                                                                         notVisibleAccounts: notVisibleAccounts)
        }
        let visiblesFiltered = visibleAccounts.filter {
            $0.currencyRepresentable?.currencyType == .złoty || $0.equalsTo(other: originAccount)
        }
        let notVisiblesFiltered = notVisibleAccounts.filter {
            $0.currencyRepresentable?.currencyType == .złoty || $0.equalsTo(other: originAccount)
        }
        return PLGetInternalTransferDestinationAccountsUseCaseOutput(visibleAccounts: visiblesFiltered,
                                                                     notVisibleAccounts: notVisiblesFiltered)
    }
}
