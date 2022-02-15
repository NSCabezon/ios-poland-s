//
//  PLGetFilteredAccountTransactionsUseCase.swift
//  Santander
//
//  Created by Rodrigo Jurado on 25/8/21.
//

import SANLegacyLibrary
import CoreFoundationLib
import Account
import SANPLLibrary
import PLLegacyAdapter

final class PLGetFilteredAccountTransactionsUseCase: UseCase<GetFilteredAccountTransactionsUseCaseInput, GetFilteredAccountTransactionsUseCaseOkOutput, StringErrorOutput> {
    private let dependenciesResolver: DependenciesResolver
    private let bsanDataProvider: BSANDataProvider

    init(dependenciesResolver: DependenciesResolver, bsanDataProvider: BSANDataProvider) {
        self.dependenciesResolver = dependenciesResolver
        self.bsanDataProvider = bsanDataProvider
    }

    override func executeUseCase(requestValues: GetFilteredAccountTransactionsUseCaseInput) throws -> UseCaseResponse<GetFilteredAccountTransactionsUseCaseOkOutput, StringErrorOutput> {
        guard let accountNumber = requestValues.account.getIban()?.ibanString else {
            return UseCaseResponse.error(StringErrorOutput(nil))
        }
        let parameters = makeAccountTransactionsParameters(forAccountNumber: accountNumber, fromRequestValues: requestValues)
        let provider = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self).getAccountsManager()
        let result = try provider.loadAccountTransactions(parameters: parameters)
        switch result {
        case .success(let accountTransactionsDTO):
            var accountTransactionListsDTO = SANLegacyLibrary.AccountTransactionsListDTO()
            let customer = self.bsanDataProvider.getCustomerIndividual()
            let transactions = accountTransactionsDTO.entries?.compactMap({ (element) -> SANLegacyLibrary.AccountTransactionDTO? in
                return AccountTransactionDTOAdapter.adaptPLAccountTransactionToAccountTransaction(element, customer: customer)
            })
            accountTransactionListsDTO.transactionDTOs = transactions ?? [SANLegacyLibrary.AccountTransactionDTO]()
            if let next = accountTransactionsDTO.pagingLast {
                accountTransactionListsDTO.pagination.endList = false
                accountTransactionListsDTO.pagination.repositionXML = next
            } else {
                accountTransactionListsDTO.pagination.endList = true
            }
            let transactionList = AccountTransactionListEntity(accountTransactionListsDTO)
            if transactionList.transactions.count > 0 {
                return .ok(GetFilteredAccountTransactionsUseCaseOkOutput(transactionList: transactionList))
            } else {
                return .error(StringErrorOutput(localized("generic_label_emptyListResult")))
            }
        case .failure(let error):
            return .error(StringErrorOutput(error.localizedDescription))
        }
    }

    private func makeAccountTransactionsParameters(forAccountNumber accountNumber: String, fromRequestValues requestValues: GetFilteredAccountTransactionsUseCaseInput) -> AccountTransactionsParameters {
        let filters = requestValues.filters
        let description = filters?.getTransactionDescription()
        let dateInterval = filters?.getDateRange()
        let fromDate = dateInterval?.fromDate.toString(format: "yyyy-MM-dd")
        let toDate = dateInterval?.toDate.toString(format: "yyyy-MM-dd")
        let movementType = adaptMovementType(filters?.getMovementType())
        let parameters = AccountTransactionsParameters(accountNumbers: [accountNumber],
                                                    from: fromDate,
                                                    to: toDate,
                                                    text: description,
                                                    amountFrom: filters?.fromAmount,
                                                    amountTo: filters?.toAmount,
                                                    sortOrder: "DESCENDING",
                                                    debitFlag: movementType,
                                                    pagingLast: requestValues.pagination?.dto?.repositionXML
        )
        return parameters
    }

    private func adaptMovementType(_ movement: TransactionConceptType?) -> String? {
        switch movement {
        case .expenses:
            return "DEBIT"
        case .income:
            return "CREDIT"
        default:
            return nil
        }
    }
}

extension PLGetFilteredAccountTransactionsUseCase: GetFilteredAccountTransactionsUseCaseProtocol { }
