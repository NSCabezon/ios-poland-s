//
//  PLMonthlyBalanceUseCase.swift
//  Santander
//
//  Created by Rubén Muñoz López on 13/7/21.
//

import Foundation
import CoreFoundationLib
import SANPLLibrary
import CoreDomain

final class MonthlyBalanceUseCase: UseCase<Void, GetMonthlyBalanceUseCaseOkOutput, StringErrorOutput> {

    private let dependenciesResolver: DependenciesResolver
    lazy private var expensesChartManager: PLExpensesChartManagerProtocol = {
        return self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self).getExpensesChartManager()
    }()
    private var pfmController: PfmControllerProtocol {
        return dependenciesResolver.resolve()
    }

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<GetMonthlyBalanceUseCaseOkOutput, StringErrorOutput> {
        let result = expensesChartManager.getExpenses()
        switch result {
        case .success(let response):
            var monthlyBalance: [MonthlyBalanceRepresentable] = []
            if let entries = response.entries {
                if let month = entries.element(atIndex: 0), let entity = getMonthEntity(from: month) {
                    monthlyBalance.append(entity)
                }
                if let month = entries.element(atIndex: 1), let entity = getMonthEntity(from: month) {
                    monthlyBalance.append(entity)
                }
                if let month = entries.element(atIndex: 2), let entity = getMonthEntity(from: month) {
                    monthlyBalance.append(entity)
                }
                monthlyBalance.sort {
                    $0.date < $1.date
                }
                pfmController.monthsHistory = monthlyBalance
                return .ok(GetMonthlyBalanceUseCaseOkOutput(data: monthlyBalance))
            }
        case .failure(let error):
            return .error(StringErrorOutput(error.localizedDescription))
        }
        return .error(StringErrorOutput(""))
    }
}

private extension MonthlyBalanceUseCase {

    func getMonthEntity(from model: ExpensesChartEntryDTO) -> MonthlyBalanceRepresentable? {
        guard let date = dateFromString(input: model.month, inputFormat: .yyyyMMdd), isDateYoungerThatThreeMonths(date), let modelOutlay = model.outlay, let modelIncome = model.income else {
            return nil
        }

        return DefaultMonthlyBalance(date: date, expense: Decimal(modelOutlay), income: Decimal(modelIncome) )
    }

    func isDateYoungerThatThreeMonths(_ date: Date) -> Bool {
        return date.isSameMonth(than: Date().dateByAdding(months: 0)) || date.isSameMonth(than: Date().dateByAdding(months: -1)) || date.isSameMonth(than: Date().dateByAdding(months: -2))
    }
}

extension MonthlyBalanceUseCase: GetMonthlyBalanceUseCase {}
