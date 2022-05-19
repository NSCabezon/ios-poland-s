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
    typealias AssociatedTaxFormType = Int
    private let irpAccountOptionId = 4
    private let getTaxAccountUseCase: GetTaxAccountsUseCaseProtocol
    private let useCaseHandler: UseCaseHandler
    private let accountTypeRecognizer: TaxAccountTypeRecognizing

    init(dependenciesResolver: DependenciesResolver) {
        self.getTaxAccountUseCase = dependenciesResolver.resolve(for: GetTaxAccountsUseCaseProtocol.self)
        self.useCaseHandler = dependenciesResolver.resolve(for: UseCaseHandler.self)
        self.accountTypeRecognizer = dependenciesResolver.resolve(for: TaxAccountTypeRecognizing.self)
    }
    
    func validateAccount(
        withNumber accountNumber: String,
        onValidResult: @escaping (AssociatedTaxFormType) -> Void,
        onInvalidResult: @escaping () -> Void,
        onError: @escaping (Error) -> Void
    ) {
        let isAccountTypeIRP = (try? accountTypeRecognizer.recognizeType(of: accountNumber) == .IRP) ?? false
        let input = GetTaxAccountsUseCaseInput(
            taxAccountNumberFilter: accountNumber,
            taxAccountNameFilter: nil,
            cityFilter: nil,
            optionId: isAccountTypeIRP ? irpAccountOptionId : nil,
            taxFormType: nil
        )
        Scenario(useCase: getTaxAccountUseCase, input: input)
            .execute(on: useCaseHandler)
            .onSuccess { output in
                let matchedTaxAccount: TaxAccount? = {
                    if isAccountTypeIRP {
                        return output.taxAccounts.first
                    }
                    return output.taxAccounts.first(where: { $0.accountNumber == accountNumber })
                }()
                guard let taxAccount = matchedTaxAccount else {
                    onInvalidResult()
                    return
                }
                
                let isAccountValid = taxAccount.isActive && taxAccount.validToDate.timeIntervalSinceNow.sign == .plus
                
                if isAccountValid {
                    onValidResult(taxAccount.taxFormType)
                } else {
                    onInvalidResult()
                }
            }
            .onError { error in
                onError(error)
            }
    }
    
    private func getAccountType(for accountNumber: String) -> Int? {
        guard
            let accountType = try? accountTypeRecognizer.recognizeType(of: accountNumber),
            accountType == .IRP
        else {
            return nil
        }
        
        return irpAccountOptionId
    }
}
