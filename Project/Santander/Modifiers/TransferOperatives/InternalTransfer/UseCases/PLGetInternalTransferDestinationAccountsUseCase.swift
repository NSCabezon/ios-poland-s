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

extension PLGetInternalTransferDestAccountsUseCase: GetInternalTransferDestinationAccountsUseCase {
    func fetchAccounts(input: GetInternalTransferDestinationAccountsInput) -> AnyPublisher<GetInternalTransferDestinationAccountsOutput, Never> {
        let visibleAccounts = getFilteredAccounts(from: input.visibleAccounts, originAccount: input.originAccount)
        let notVisibleAccounts = getFilteredAccounts(from: input.notVisibleAccounts, originAccount: input.originAccount)
        return Just(filterDestinationAccounts(visibleAccounts: visibleAccounts,
                                              notVisibleAccounts: notVisibleAccounts,
                                              originAccount: input.originAccount)
        ).eraseToAnyPublisher()
    }
}

private extension PLGetInternalTransferDestAccountsUseCase {
    func getFilteredAccounts(from accounts: [AccountRepresentable], originAccount: AccountRepresentable) -> [PolandAccountRepresentable] {
        let accounts = accounts.filter { !$0.equalsTo(other: originAccount) }
        return filterCreditCardAccounts(from: accounts)
    }
    
    func filterCreditCardAccounts(from accounts: [AccountRepresentable]) -> [PolandAccountRepresentable] {
        guard let polandAccounts: [PolandAccountRepresentable] = accounts as? [PolandAccountRepresentable] else { return [] }
        return polandAccounts.filter { $0.type != .creditCard }
    }
    
    func filterDestinationAccounts(visibleAccounts: [PolandAccountRepresentable],
                                   notVisibleAccounts: [PolandAccountRepresentable],
                                   originAccount: AccountRepresentable) -> GetInternalTransferDestinationAccountsOutput {
        guard let originAccount = originAccount as? PolandAccountRepresentable,
            originAccount.type == .creditCard else {
            return GetInternalTransferDestinationAccountsOutput(visibleAccounts: visibleAccounts,
                                                                         notVisibleAccounts: notVisibleAccounts)
        }
        let visiblesFiltered = visibleAccounts.filter { $0.currencyRepresentable?.currencyType == .złoty }
        let notVisiblesFiltered = notVisibleAccounts.filter { $0.currencyRepresentable?.currencyType == .złoty }
        return GetInternalTransferDestinationAccountsOutput(visibleAccounts: visiblesFiltered,
                                                                     notVisibleAccounts: notVisiblesFiltered)
    }
}
