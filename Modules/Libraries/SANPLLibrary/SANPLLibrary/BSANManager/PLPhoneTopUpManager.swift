//
//  File.swift
//  SANPLLibrary
//
//  Created by 188216 on 30/11/2021.
//

import Foundation
import SANLegacyLibrary

public protocol PLPhoneTopUpManagerProtocol {
    func getFormData() throws -> Result<
        TopUpFormDataDTO, NetworkProviderError>
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
    public func getFormData() throws -> Result<TopUpFormDataDTO, NetworkProviderError> {
        let accountsResult = try dataSource.getPhoneTopUpAccounts()
        let operatorsResult = try dataSource.getOperators()
        let gsmOperatorsResult = try dataSource.getGSMOperators()
        let internetContactsResults = try dataSource.getInternetContacts()
        switch (accountsResult, operatorsResult, gsmOperatorsResult, internetContactsResults) {
        case (.success(let accounts), .success(let operators), .success(let gsmOperators), .success(let contacts)):
            let plnAccounts = accounts.filter({ $0.currencyCode == CurrencyType.złoty.name })
            return .success(TopUpFormDataDTO(accounts: plnAccounts, operators: operators, gsmOperators: gsmOperators, internetContacts: contacts))
        case (.failure(let accountsFetchError), _, _, _):
            return .failure(accountsFetchError)
        case (_, .failure(let operatorsFetchError), _, _):
            return .failure(operatorsFetchError)
        case (_, _, .failure(let gsmOperatorsFetchError), _):
            return .failure(gsmOperatorsFetchError)
        case (_, _, _, .failure(let internetContactsFetchError)):
            return .failure(internetContactsFetchError)
        }
    }
}
