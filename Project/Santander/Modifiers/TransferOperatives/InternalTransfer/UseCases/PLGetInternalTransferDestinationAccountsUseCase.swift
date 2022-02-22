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
        let originAccount = originAccount as? PolandAccountRepresentable
        var visibles: [PolandAccountRepresentable] = visibleAccounts.filter { $0.type != .creditCard }
        var notVisibles: [PolandAccountRepresentable] = []
//        if originAccount.type == .creditCard {
//
//        }
    }
}
