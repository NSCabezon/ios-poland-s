//
//  TaxAccountValidator.swift
//  TaxTransfer
//
//  Created by 185167 on 16/03/2022.
//

import Foundation
import CoreFoundationLib
import SANPLLibrary
import PLCommons

final class TaxAccountValidator {
    private let getTaxAccountUseCase: GetTaxAccountsUseCaseProtocol
    private let useCaseHandler: UseCaseHandler

    init(dependenciesResolver: DependenciesResolver) {
        self.getTaxAccountUseCase = dependenciesResolver.resolve(for: GetTaxAccountsUseCaseProtocol.self)
        self.useCaseHandler = dependenciesResolver.resolve(for: UseCaseHandler.self)
    }
    
    func validateAccount(
        withNumber accountNumber: String,
        onValidResult: @escaping () -> Void,
        onInvalidResult: @escaping () -> Void,
        onError: @escaping (Error) -> Void
    ) {
        let input = GetTaxAccountsUseCaseInput(
            taxAccountNumberFilter: accountNumber,
            taxAccountNameFilter: nil,
            cityFilter: nil
        )
        Scenario(useCase: getTaxAccountUseCase, input: input)
            .execute(on: useCaseHandler)
            .onSuccess { output in
                let matchedTaxAccount = output.taxAccounts.first(where: { $0.accountNumber == accountNumber })
                guard let taxAccount = matchedTaxAccount else {
                    onInvalidResult()
                    return
                }
                
                let isAccountValid = taxAccount.isActive && taxAccount.validToDate.timeIntervalSinceNow.sign == .plus
                
                if isAccountValid {
                    onValidResult()
                } else {
                    onInvalidResult()
                }
            }
            .onError { error in
                onError(error)
            }
    }
}
