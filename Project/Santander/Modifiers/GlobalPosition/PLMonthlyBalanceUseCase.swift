//
//  PLMonthlyBalanceUseCase.swift
//  Santander
//
//  Created by Rubén Muñoz López on 13/7/21.
//

import Foundation
import Commons
import CoreFoundationLib
import SANPLLibrary

final class MonthlyBalanceUseCase: UseCase<Void, MonthlyBalanceUseCaseOkOutputProtocol, StringErrorOutput> {

    private let dependenciesResolver: DependenciesResolver
    lazy private var expensesChartManager: PLExpensesChartManagerProtocol = {
        return self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self).getExpensesChartManager()
    }()

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<MonthlyBalanceUseCaseOkOutputProtocol, StringErrorOutput> {
        let result = expensesChartManager.getExpenses()
        switch result {
        case .success(let response):
            var pfmMonthEntities: [PFMMonthEntity] = []
            if let entries = response.entries {
                if let month = entries.element(atIndex: 0), let entity = getMonthEntity(from: month) {
                    pfmMonthEntities.append(entity)
                }
                if let month = entries.element(atIndex: 1), let entity = getMonthEntity(from: month) {
                    pfmMonthEntities.append(entity)
                }
                if let month = entries.element(atIndex: 2), let entity = getMonthEntity(from: month) {
                    pfmMonthEntities.append(entity)
                }
                pfmMonthEntities.sort {
                    $0.date < $1.date
                }
                return .ok(MonthlyBalanceUseCaseOkOutput(pfmMonthEntities: pfmMonthEntities))
            }
        case .failure(let error):
            return .error(StringErrorOutput(error.localizedDescription))
        }
        return .error(StringErrorOutput(""))
    }
}

private extension MonthlyBalanceUseCase {

    func getMonthEntity(from model: ExpensesChartEntryDTO) -> PFMMonthEntity? {
        guard let date = dateFromString(input: model.month, inputFormat: .yyyyMMdd), isDateYoungerThatThreeMonths(date), let modelOutlay = model.outlay, let modelIncome = model.income else {
            return nil
        }

        return PFMMonthEntity(date: date, expense: Decimal(modelOutlay), income: Decimal(modelIncome) )
    }

    func isDateYoungerThatThreeMonths(_ date: Date) -> Bool {
        return date.isSameMonth(than: Date().dateByAdding(months: 0)) || date.isSameMonth(than: Date().dateByAdding(months: -1)) || date.isSameMonth(than: Date().dateByAdding(months: -2))
    }
}

extension MonthlyBalanceUseCase: MonthlyBalanceUseCaseProtocol {}

public struct MonthlyBalanceUseCaseOkOutput: MonthlyBalanceUseCaseOkOutputProtocol {
    public let pfmMonthEntities: [PFMMonthEntity]
    
    public init(pfmMonthEntities: [PFMMonthEntity]) {
        self.pfmMonthEntities = pfmMonthEntities
    }
}
