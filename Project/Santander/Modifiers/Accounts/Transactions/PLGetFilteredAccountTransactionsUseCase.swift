//
//  PLGetFilteredAccountTransactionsUseCase.swift
//  Santander
//
//  Created by Rodrigo Jurado on 25/8/21.
//

import SANLegacyLibrary
import DomainCommon
import Models
import Commons
import Account
import SANPLLibrary
import PLLegacyAdapter

final class PLGetFilteredAccountTransactionsUseCase: UseCase<GetFilteredAccountTransactionsUseCaseInput, GetFilteredAccountTransactionsUseCaseOkOutput, StringErrorOutput> {
    private let dependenciesResolver: DependenciesResolver

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
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
            let transactions = accountTransactionsDTO.entries?.compactMap({ (element) -> SANLegacyLibrary.AccountTransactionDTO? in
                return AccountTransactionDTOAdapter.adaptPLAccountTransactionToAccountTransaction(element)
            })
            accountTransactionListsDTO.transactionDTOs = transactions ?? [SANLegacyLibrary.AccountTransactionDTO]()
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
        let description = requestValues.tagDescription
        let date = Date().getDateByAdding(days: -89, ignoreHours: true)
        let fromDate = requestValues.starDate > date ? requestValues.starDate : date
        let toDate = requestValues.endDate ?? fromDate
        let parameters = AccountTransactionsParameters(accountNumbers: [accountNumber],
                                                    from: fromDate.toString(format: "yyyy-MM-dd"),
                                                    to: toDate.toString(format: "yyyy-MM-dd"),
                                                    text: description,
                                                    sortOrder: "DESCENDING"
        )
        return parameters
    }
}

extension PLGetFilteredAccountTransactionsUseCase: GetFilteredAccountTransactionsUseCaseProtocol { }
