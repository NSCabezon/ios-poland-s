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
        return Just(filterDestinationAccounts(visibleAccounts: filterPolandAccounts(input.visibleAccounts),
                                              notVisibleAccounts: filterPolandAccounts(input.notVisibleAccounts),
                                              originAccount: input.originAccount)
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
                                   originAccount: AccountRepresentable) -> GetInternalTransferDestinationAccountsOutput {
        guard let originAccount = originAccount as? PolandAccountRepresentable,
            originAccount.type == .creditCard else {
            return GetInternalTransferDestinationAccountsOutput(visibleAccounts: [],
                                                                         notVisibleAccounts: [])
        }
        let visiblesFiltered = visibleAccounts.filter {
            $0.currencyRepresentable?.currencyType == .złoty || $0.equalsTo(other: originAccount)
        }
        let notVisiblesFiltered = notVisibleAccounts.filter {
            $0.currencyRepresentable?.currencyType == .złoty || $0.equalsTo(other: originAccount)
        }
        return GetInternalTransferDestinationAccountsOutput(visibleAccounts: visiblesFiltered,
                                                                     notVisibleAccounts: notVisiblesFiltered)
    }
}
