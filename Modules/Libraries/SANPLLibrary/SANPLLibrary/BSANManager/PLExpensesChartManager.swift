//
//  PLExpensesChartManager.swift
//  SANPLLibrary
//

import SANLegacyLibrary

public protocol PLExpensesChartManagerProtocol {
    func getExpenses() -> Result<ExpensesChartDTO, NetworkProviderError>
}

final class PLExpensesChartManager {
    private let expensesChartDataSource: ExpensesChartDataSourceProtocol
    private let bsanDataProvider: BSANDataProvider
    private let demoInterpreter: DemoUserProtocol

    public init(bsanDataProvider: BSANDataProvider, networkProvider: NetworkProvider, demoInterpreter: DemoUserProtocol) {
        self.expensesChartDataSource = ExpensesChartDataSource(networkProvider: networkProvider, dataProvider: bsanDataProvider)
        self.bsanDataProvider = bsanDataProvider
        self.demoInterpreter = demoInterpreter
    }
}

extension PLExpensesChartManager: PLExpensesChartManagerProtocol {
    func getExpenses() -> Result<ExpensesChartDTO, NetworkProviderError> {
        return self.expensesChartDataSource.getExpenses()
    }
}
