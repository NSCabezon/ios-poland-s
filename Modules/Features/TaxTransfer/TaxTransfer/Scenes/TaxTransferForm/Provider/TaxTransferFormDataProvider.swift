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
        
        MultiScenario(handledOn: useCaseHandler)
            .addScenario(accountsScenario) { _, accounts, _ in
                fetchedAccounts = accounts
            }
            .addScenario(taxPayersScenario) { _, output, _ in
                fetchedTaxPayers = output.taxPayers
            }
            .asScenarioHandler()
            .finally {
                guard let fetchedAccounts = fetchedAccounts,
                      let fetchedTaxPayers = fetchedTaxPayers else {
                    completion(.failure(.apiFailure))
                    return
                }
                let data = TaxTransferFormData(
                    sourceAccounts: fetchedAccounts,
                    taxPayers: fetchedTaxPayers
                )
                completion(.success(data))
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
}
