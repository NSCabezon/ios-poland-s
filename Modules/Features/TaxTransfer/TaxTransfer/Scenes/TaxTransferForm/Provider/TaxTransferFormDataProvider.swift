//
//  TaxTransferFormDataProvider.swift
//  TaxTransfer
//
//  Created by 185167 on 19/01/2022.
//

import PLCommons
import PLCommonOperatives
import CoreFoundationLib
import SANPLLibrary

enum GetTaxTransferDataUseCaseError: Error {
    case apiFailure
}

protocol TaxTransferFormDataProviding {
    func getData(completion: @escaping (Result<TaxTransferFormData, GetTaxTransferDataUseCaseError>) -> Void)
}

final class TaxTransferFormDataProvider: TaxTransferFormDataProviding {
    private let dependenciesResolver: DependenciesResolver
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    func getData(completion: @escaping (Result<TaxTransferFormData, GetTaxTransferDataUseCaseError>) -> Void) {
        var fetchedAccounts: [AccountForDebit]?
        let accountsScenario = Scenario(useCase: getAccountsUseCase)
        
        var fetchedTaxPayers: [TaxPayer]?
        let taxPayersScenario = Scenario(useCase: getTaxPayersUseCase)

        var fetchedTaxAuthorities: [TaxAuthority]?
        let taxAuthoritiesScenario = Scenario(useCase: getTaxAuthoritiesUseCase)
        
        MultiScenario(handledOn: useCaseHandler)
            .addScenario(accountsScenario) { _, accounts, _ in
                fetchedAccounts = accounts
            }
            .addScenario(taxPayersScenario) { _, output, _ in
                fetchedTaxPayers = output.taxPayers
            }
            .addScenario(taxAuthoritiesScenario) { _, output, _ in
                fetchedTaxAuthorities = output.taxAuthorities
            }
            .asScenarioHandler()
            .onSuccess { _ in
                guard
                    let fetchedAccounts = fetchedAccounts,
                    let fetchedTaxPayers = fetchedTaxPayers,
                    let fetchedTaxAuthorities = fetchedTaxAuthorities
                else {
                    completion(.failure(.apiFailure))
                    return
                }
                let data = TaxTransferFormData(
                    sourceAccounts: fetchedAccounts,
                    taxPayers: fetchedTaxPayers,
                    predefinedTaxAuthorities: fetchedTaxAuthorities
                )
                completion(.success(data))
            }
            .onError { _ in
                completion(.failure(.apiFailure))
            }
    }
}

private extension TaxTransferFormDataProvider {
    var useCaseHandler: UseCaseHandler {
        dependenciesResolver.resolve()
    }
    
    var getAccountsUseCase: GetAccountsForDebitProtocol {
        dependenciesResolver.resolve()
    }
    
    var getTaxPayersUseCase: GetTaxPayersListUseCaseProtocol {
        return dependenciesResolver.resolve()
    }

    var getTaxAuthoritiesUseCase: GetPredefinedTaxAuthoritiesUseCaseProtocol {
        dependenciesResolver.resolve()
    }
}
