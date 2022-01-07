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
    private let totalMonths = 3
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<MonthlyBalanceUseCaseOkOutputProtocol, StringErrorOutput> {
        // let globalPositionManager = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self).getGlobalPositionManager()
        // let result = globalPositionManager.getMonthlyBalance()
        // switch result {
        // case .success(let response):
        // return self.handleResponse(response)
        // case .failure(let error):
        // return .error(StringErrorOutput(error.localizedDescription))
        // }
        let entity1 = PFMMonthEntity(date: Date().dateByAdding(months: -2), expense: 0, income: 0)
        let entity2 = PFMMonthEntity(date: Date().dateByAdding(months: -1), expense: 0, income: 0)
        let entity3 = PFMMonthEntity(date: Date(), expense: 0, income: 0)
        let pfmMonthEntities: [PFMMonthEntity] = [entity1, entity2, entity3]
        return .ok(MonthlyBalanceUseCaseOkOutput(pfmMonthEntities: pfmMonthEntities))
    }
}
private extension MonthlyBalanceUseCase {
    func handleResponse(_ response: AccountsMonthlyBalanceDTO) -> UseCaseResponse<MonthlyBalanceUseCaseOkOutputProtocol, StringErrorOutput> {
        // guard let accountsMonthlyBalance = response.accountsMonthlyBalance else {
        // return .error(StringErrorOutput("no values"))
        // }
        // let accountsInEur = accountsMonthlyBalance.filter({​​​ $0.currencyCode == "EUR" }​​​)
        // guard !accountsInEur.isEmpty else {
        // return .error(StringErrorOutput("no values"))
        // }
        // var balances = [MonthlyBalanceDTO]()
        // accountsInEur.forEach {​​​ element in
        // element.monthlyBalance?.forEach({​​​ balance in
        // balances.append(balance)
        // }​​​)
        // }
        // var values = [(expense: Decimal, income: Decimal)](repeating: (0, 0), count: self.totalMonths)
        // for accountBalance in accountsInEur {
        // if let monthlyBalance = accountBalance.monthlyBalance, monthlyBalance.count == self.totalMonths {
        // for (index, month) in monthlyBalance.enumerated() {
        // let expense = Decimal(Double(month.expense) ?? 0)
        // let income = Decimal(Double(month.income) ?? 0)
        // values[index].expense -= expense
        // values[index].income += income
        // }
        // }
        // }
        // var pfmEntities = [PFMMonthEntity]()
        // var currentDate = Date()
        // for value in values {
        // pfmEntities.append(PFMMonthEntity(date: currentDate, expense: value.expense, income: value.income))
        // currentDate = currentDate.getDateByAdding(months: -1, ignoreHours: true)
        // }
        // return .ok(MonthlyBalanceUseCaseOkOutput(pfmMonthEntities: pfmEntities.reversed()))
        let entity1 = PFMMonthEntity(date: Date().dateByAdding(months: -2), expense: 0, income: 0)
        let entity2 = PFMMonthEntity(date: Date().dateByAdding(months: -1), expense: 0, income: 0)
        let entity3 = PFMMonthEntity(date: Date(), expense: 0, income: 0)
        let pfmMonthEntities: [PFMMonthEntity] = [entity1, entity2, entity3]
        return .ok(MonthlyBalanceUseCaseOkOutput(pfmMonthEntities: pfmMonthEntities))
    }
}

extension MonthlyBalanceUseCase: MonthlyBalanceUseCaseProtocol {}

public struct MonthlyBalanceUseCaseOkOutput: MonthlyBalanceUseCaseOkOutputProtocol {
    public let pfmMonthEntities: [PFMMonthEntity]
    
    public init(pfmMonthEntities: [PFMMonthEntity]) {
        self.pfmMonthEntities = pfmMonthEntities
    }
}
