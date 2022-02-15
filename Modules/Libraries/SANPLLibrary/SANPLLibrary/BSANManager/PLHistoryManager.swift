//
//  PLHistoryManager.swift
//  SANPLLibrary
//
//  Created by Ernesto Fernandez Calles on 25/1/22.
//

import Foundation
import SANLegacyLibrary

public protocol PLHistoryManagerProtocol {
    func getReceipt(receiptId: String, language: String) throws -> Result<Data, NetworkProviderError>
}

final class PLHistoryManager {
    private let historyDataSource: HistoryDataSourceProtocol
    private let bsanDataProvider: BSANDataProvider
    private let demoInterpreter: DemoUserProtocol

    public init(bsanDataProvider: BSANDataProvider, networkProvider: NetworkProvider, demoInterpreter: DemoUserProtocol) {
        self.historyDataSource = HistoryDataSource(networkProvider: networkProvider, dataProvider: bsanDataProvider)
        self.bsanDataProvider = bsanDataProvider
        self.demoInterpreter = demoInterpreter
    }
}

extension PLHistoryManager: PLHistoryManagerProtocol {
    func getReceipt(receiptId: String, language: String) throws -> Result<Data, NetworkProviderError> {
        let result = try self.historyDataSource.getReceipt(receiptId: receiptId, language: language)
        return result
    }
}
