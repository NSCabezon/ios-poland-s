//
//  File.swift
//  SANPLLibrary
//
//  Created by 188216 on 30/11/2021.
//

import Foundation
import SANLegacyLibrary

public protocol PLPhoneTopUpManagerProtocol {
    func getFormData() throws -> Result<TopUpFormDataDTO, NetworkProviderError>
    func checkPhone(request: CheckPhoneRequestDTO) throws -> Result<CheckPhoneResponseDTO, NetworkProviderError>
    func reloadPhone(request: ReloadPhoneRequestDTO) throws -> Result<ReloadPhoneResponseDTO, NetworkProviderError>
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
        let topUpAccountResults = try dataSource.getTopUpAccount()
        switch (accountsResult, operatorsResult, gsmOperatorsResult, internetContactsResults, topUpAccountResults) {
        case (.success(let accounts), .success(let operators), .success(let gsmOperators), .success(let contacts), .success(let topUpAccount)):
            let plnAccounts = accounts.filter({ $0.currencyCode == CurrencyType.złoty.name })
            return .success(TopUpFormDataDTO(accounts: plnAccounts, operators: operators, gsmOperators: gsmOperators, internetContacts: contacts, topUpAccount: topUpAccount))
        case (.failure(let accountsFetchError), _, _, _, _):
            return .failure(accountsFetchError)
        case (_, .failure(let operatorsFetchError), _, _, _):
            return .failure(operatorsFetchError)
        case (_, _, .failure(let gsmOperatorsFetchError), _, _):
            return .failure(gsmOperatorsFetchError)
        case (_, _, _, .failure(let internetContactsFetchError), _):
            return .failure(internetContactsFetchError)
        case (_, _, _, _, .failure(let topUpAccountFetchError)):
            return .failure(topUpAccountFetchError)
        }
    }
    
    public func checkPhone(request: CheckPhoneRequestDTO) throws -> Result<CheckPhoneResponseDTO, NetworkProviderError> {
        return try dataSource.checkPhone(request: request)
    }
    
    public func reloadPhone(request: ReloadPhoneRequestDTO) throws -> Result<ReloadPhoneResponseDTO, NetworkProviderError> {
        return try dataSource.reloadPhone(request: request)
    }
}
