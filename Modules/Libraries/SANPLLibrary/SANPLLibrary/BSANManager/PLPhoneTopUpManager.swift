//
//  File.swift
//  SANPLLibrary
//
//  Created by 188216 on 30/11/2021.
//

import Foundation

public protocol PLPhoneTopUpManagerProtocol {
    func getFormData() throws -> Result<[DebitAccountDTO], NetworkProviderError>
}

public final class PLPhoneTopUpManager {
    private let dataSource: PhoneTopUpDataSourceProtocol
    private let bsanDataProvider: BSANDataProvider
    
    public init(bsanDataProvider: BSANDataProvider, networkProvider: NetworkProvider) {
        self.dataSource = PhoneTopUpDataSource(networkProvider: networkProvider, dataProvider: bsanDataProvider)
        self.bsanDataProvider = bsanDataProvider
    }
}

extension PLPhoneTopUpManager: PLPhoneTopUpManagerProtocol {
    public func getFormData() throws -> Result<[DebitAccountDTO], NetworkProviderError> {
        return try dataSource.getPhoneTopUpAccounts()
    }
}
