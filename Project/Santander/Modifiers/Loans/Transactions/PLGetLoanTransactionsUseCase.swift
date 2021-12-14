//
//  PLGetLoanTransactionsUseCase.swift
//  Santander
//
//  Created by Rodrigo Jurado on 4/10/21.
//

import SANLegacyLibrary
import CoreFoundationLib
import Models
import Commons
import Loans
import SANPLLibrary
import PLLegacyAdapter

class PLGetLoanTransactionsUseCase: UseCase<GetLoanTransactionsUseCaseInput, GetLoanTransactionsUseCaseOkOutput, StringErrorOutput> {
    private let dependenciesResolver: DependenciesResolver

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    override func executeUseCase(requestValues: GetLoanTransactionsUseCaseInput) throws -> UseCaseResponse<GetLoanTransactionsUseCaseOkOutput, StringErrorOutput> {
        guard let accountNumber = requestValues.loan.contractDescription?.replace(" ", "") else {
            return UseCaseResponse.error(StringErrorOutput(nil))
        }
        let provider = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self).getLoansManager()
        let loanTransactionsParameters = makeLoanTransactionsParameters(fromRequestValues: requestValues)
        let result = try provider.getTransactions(withAccountNumber: accountNumber, parameters: loanTransactionsParameters)
        switch result {
        case .success(let loanOperationListDTO):
            var loanTransactionsListDTO = SANLegacyLibrary.LoanTransactionsListDTO()
            let transactions = loanOperationListDTO.operationList?.compactMap({
                LoanTransactionDTOAdapter.adaptPLLoanTransactionToLoanTransaction($0)
            })
            loanTransactionsListDTO.transactionDTOs = transactions ?? [SANLegacyLibrary.LoanTransactionDTO]()
            let transactionList = LoanTransactionsListEntity(loanTransactionsListDTO)
            if transactionList.transactions.count > 0 {
                return .ok(GetLoanTransactionsUseCaseOkOutput(transactionList: transactionList))
            } else {
                return .error(StringErrorOutput(localized("generic_label_emptyListResult")))
            }
        case .failure(let error):
            return .error(StringErrorOutput(error.localizedDescription))
        }
    }

    private func makeLoanTransactionsParameters(fromRequestValues requestValues: GetLoanTransactionsUseCaseInput) -> LoanTransactionParameters {
        let filters = requestValues.filters
        let dateInterval = filters?.getDateRange()
        let fromDate = dateInterval?.fromDate.toString(format: "yyyy-MM-dd")
        let toDate = dateInterval?.toDate.toString(format: "yyyy-MM-dd")
        let parameters = LoanTransactionParameters(dateFrom: fromDate,
                                                   dateTo: toDate,
                                                   amountFrom: filters?.fromAmount,
                                                   amountTo: filters?.toAmount
        )
        return parameters
    }
}

extension PLGetLoanTransactionsUseCase: GetLoanTransactionsUseCaseProtocol {}
