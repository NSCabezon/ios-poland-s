//
//  PLLoanTransactionDetailUseCase.swift
//  Santander
//
//  Created by Juan Carlos López Robles on 12/31/21.
//

import Foundation
import CoreFoundationLib
import SANLegacyLibrary
import Commons
import Loans
import SANPLLibrary
import PLLegacyAdapter

final class PLLoanTransactionDetailUseCase: UseCase<LoanTransactionDetailUseCaseInput, LoanTransactionDetailUseCaseOkOutput, StringErrorOutput> {
    
    private let dependenciesResolver: DependenciesResolver
    private let localAppConfig: LocalAppConfig

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
        self.localAppConfig = dependenciesResolver.resolve(for: LocalAppConfig.self)
    }
    
    override func executeUseCase(requestValues: LoanTransactionDetailUseCaseInput) throws -> UseCaseResponse<LoanTransactionDetailUseCaseOkOutput, StringErrorOutput> {
        let loansManager = self.dependenciesResolver
            .resolve(for: PLManagersProviderAdapter.self)
            .getLoansManager()
        
        let response = try loansManager.getLoanTransactionDetail(contractDescription: requestValues.loan.contractDescription, transactionNumber: requestValues.transaction.transactionNumber)
        
        guard response.isSuccess(), let loanTransactionDetailDTO = try response.getResponseData() else {
            return .error(StringErrorOutput("transaction_label_emptyError"))
        }
        
        return .ok(LoanTransactionDetailUseCaseOkOutput(detail: LoanTransactionDetailEntity(loanTransactionDetailDTO)))
    }
}

extension PLLoanTransactionDetailUseCase: LoanTransactionDetailUseCaseProtocol {}
