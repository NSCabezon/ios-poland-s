//
//  PLGetAccountTransactionsUseCase.swift
//  Santander
//
//  Created by Rodrigo Jurado on 10/9/21.
//

import SANLegacyLibrary
import DomainCommon
import Models
import Commons
import Account
import SANPLLibrary
import PLLegacyAdapter

final class PLGetAccountTransactionsUseCase: UseCase<GetAccountTransactionsUseCaseInput, GetAccountTransactionsUseCaseOkOutput, StringErrorOutput> {
    private let dependenciesResolver: DependenciesResolver
    private let bsanDataProvider: BSANDataProvider

    init(dependenciesResolver: DependenciesResolver, bsanDataProvider: BSANDataProvider) {
        self.dependenciesResolver = dependenciesResolver
        self.bsanDataProvider = bsanDataProvider
    }

    override func executeUseCase(requestValues: GetAccountTransactionsUseCaseInput) throws -> UseCaseResponse<GetAccountTransactionsUseCaseOkOutput, StringErrorOutput> {
        var transactionEntity: AccountTransactionListEntity?
        let transactionsDTO = try self.getAccountTransactions(requestValues)
        if transactionsDTO.isSuccess(), let data = try transactionsDTO.getResponseData() {
            transactionEntity = AccountTransactionListEntity(data)
        }
        if requestValues.filters !=  nil {
            let transactionsType = self.getTransactionsState(for: transactionEntity, requestValues: requestValues)
            return .ok(GetAccountTransactionsUseCaseOkOutput(transactionsType: transactionsType, futureBillList: nil))
        }
        if transactionEntity == nil {
            return .error(StringErrorOutput(nil))
        } else {
            let transactionsType = self.getTransactionsState(for: transactionEntity, requestValues: requestValues)
            return .ok(GetAccountTransactionsUseCaseOkOutput(transactionsType: transactionsType, futureBillList: nil))
        }
    }

    private func makeAccountTransactionsParameters(forAccountNumber accountNumber: String, fromRequestValues requestValues: GetAccountTransactionsUseCaseInput) -> AccountTransactionsParameters {
        let filters = requestValues.filters
        let description = filters?.getTransactionDescription()
        let dateInterval = filters?.getDateRange()
        let fromDate = dateInterval?.fromDate.toString(format: "yyyy-MM-dd")
        let toDate = dateInterval?.toDate.toString(format: "yyyy-MM-dd")
        let movementType = self.adaptMovementType(filters?.getMovementType())
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

    private func getAccountTransactions(_ requestValues: GetAccountTransactionsUseCaseInput) throws -> BSANResponse<AccountTransactionsListDTO> {
        guard let accountNumber = requestValues.account.getIban()?.ibanString else {
            return BSANErrorResponse(nil)
        }
        let parameters = makeAccountTransactionsParameters(forAccountNumber: accountNumber, fromRequestValues: requestValues)
        let provider = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self).getAccountsManager()
        let result = try provider.loadAccountTransactions(parameters: parameters)
        if case .success(let accountTransactionsDTO) = result {
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
            return BSANOkResponse(accountTransactionListsDTO)
        } else {
            return BSANErrorResponse(nil)
        }
    }

    private func getTransactionsState(for transactionEntity: AccountTransactionListEntity?,
                                      requestValues: GetAccountTransactionsUseCaseInput) -> GetAccountTransactionsState {

        guard let transactionEntity = transactionEntity,
            !transactionEntity.transactions.isEmpty else {
            return .noTransactions
        }
        return getAccountTransactionsState(for: transactionEntity, requestValues: requestValues)
    }

    private func getAccountTransactionsState(for transactionEntity: AccountTransactionListEntity,
                                             requestValues: GetAccountTransactionsUseCaseInput) -> GetAccountTransactionsState {
        guard let accountTransactionModifier = self.dependenciesResolver.resolve(forOptionalType: AccountTransactionsModifierProtocol.self) else {
            switch requestValues.scaState {
            case .notApply, .none:
                return .transactionsAfter90Days(transactionEntity)
            default:
                if transactionEntity.arePrior90Days() {
                    let beforeTransactions = transactionEntity.getLast90Days()
                    let afterTransactions = transactionEntity.getAfter90Days()
                    return .transactionsPrior90Days(before: beforeTransactions, after: afterTransactions)
                } else {
                    return .transactionsAfter90Days(transactionEntity)
                }
            }
        }
        let filtersIsShown = requestValues.filtersIsShown ?? true
        return accountTransactionModifier.getTransactionsState(for: transactionEntity, filtersIsShown: filtersIsShown)
    }
}

extension PLGetAccountTransactionsUseCase: GetAccountTransactionsUseCaseProtocol { }
