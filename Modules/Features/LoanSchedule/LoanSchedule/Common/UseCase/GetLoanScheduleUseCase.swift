//
//  GetLoanScheduleUseCase.swift
//  LoanSchedule
//
//  Created by 186490 on 31/08/2021.
//

import Commons
import DomainCommon
import Foundation
import Models // for AmountEntity
import SANLegacyLibrary // for currencyType
import SANPLLibrary

protocol GetLoanScheduleUseCaseProtocol: UseCase<GetLoanScheduleUseCaseInput, GetLoanScheduleUseCaseOkOutput, StringErrorOutput> {}

final class GetLoanScheduleUseCase: UseCase<GetLoanScheduleUseCaseInput, GetLoanScheduleUseCaseOkOutput, StringErrorOutput> {
    private let dependenciesResolver: DependenciesResolver

    private lazy var plManagersProvider = dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    override func executeUseCase(requestValues: GetLoanScheduleUseCaseInput) throws -> UseCaseResponse<GetLoanScheduleUseCaseOkOutput, StringErrorOutput> {
        let manager = plManagersProvider.getLoanScheduleManager()
        
        // TODO: < REMOVE WHEN ENTRY POINT WILL BE READY AND ACCOUNT NUMBER WILL BE AVAILABLE [MOBILE-8943]
         let globalPositionManager = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self).getGlobalPositionManager()
        guard case let .success(result) = try globalPositionManager.getLoans() else { return .error(StringErrorOutput(localized("generic_alert_notAvailableOperation"))) }
        let loanAccountId = result.loans?.first?.number ?? "1234"
        let requestValues = GetLoanScheduleUseCaseInput(accountNumber: loanAccountId)
        // TODO: Also remove FakeGlobalPositionManager />
        
        guard !requestValues.accountNumber.isEmpty else {
            return .error(.init("Account number can't be empty"))
        }
        let params = LoanScheduleParameters(
            accountNumber: requestValues.accountNumber
        )
        switch try manager.getLoanSchedule(params) {
        case let .success(schedules):
            var items: [LoanSchedule.ItemEntity] = []
            if let currencyType = CurrencyType(rawValue: schedules.paymentSchedule?.currency?.currencyCode ?? "") {
                items = schedules.paymentSchedule?.scheduleItems?.compactMap { item in
                    guard let date = dependenciesResolver.resolve(for: TimeManager.self).fromString(input: item.date, inputFormat: .yyyyMMdd),
                          let amount = item.amount,
                          let principalAmount = item.principalAmount,
                          let interestAmount = item.interestAmount,
                          let balanceAfterPayment = item.balanceAfterPayment
                    else { return nil }
                    return LoanSchedule.ItemEntity(
                        date: date,
                        amount: AmountEntity(value: amount, currency: currencyType),
                        principalAmount: AmountEntity(value: principalAmount, currency: currencyType),
                        interestAmount: AmountEntity(value: interestAmount, currency: currencyType),
                        balanceAfterPayment: AmountEntity(value: balanceAfterPayment, currency: currencyType)
                    )
                } ?? []
            }
            return .ok(GetLoanScheduleUseCaseOkOutput(schedules: LoanSchedule.ScheduleEntity(items: items)))
        case let .failure(error):
            return .error(.init(error.localizedDescription))
        }
    }
}

extension GetLoanScheduleUseCase: GetLoanScheduleUseCaseProtocol {}

struct GetLoanScheduleUseCaseInput {
    let accountNumber: String
}

struct GetLoanScheduleUseCaseOkOutput {
    let schedules: LoanSchedule.ScheduleEntity
}