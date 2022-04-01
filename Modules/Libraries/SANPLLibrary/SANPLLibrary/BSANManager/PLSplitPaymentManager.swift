//
//  PLSplitPaymentManager.swift
//  SANPLLibrary
//
//  Created by 189501 on 15/03/2022.
//

import Foundation
import SANLegacyLibrary

public protocol PLSplitPaymentManagerProtocol {
    func getFormData() throws -> Result<SplitPaymentFormDataDTO, NetworkProviderError>
}

public final class PLSplitPaymentManager {
    private let dataSource: SplitPaymentDataSourceProtocol
    private let bsanDataProvider: BSANDataProvider
    
    public init(bsanDataProvider: BSANDataProvider, networkProvider: NetworkProvider) {
        self.dataSource = SplitPaymentDataSource(networkProvider: networkProvider, dataProvider: bsanDataProvider)
        self.bsanDataProvider = bsanDataProvider
    }
}

extension PLSplitPaymentManager: PLSplitPaymentManagerProtocol {
    public func getFormData() throws -> Result<SplitPaymentFormDataDTO, NetworkProviderError> {
        let accountsResult = try dataSource.getSplitPaymentsAccounts()
        
        switch (accountsResult) {
        case (.success(let accounts)):
            let plnAccounts = accounts.filter { $0.currencyCode == CurrencyType.złoty.name }
            return .success(SplitPaymentFormDataDTO(accounts: plnAccounts))
        case (.failure(let accountsFetchError)):
            return .failure(accountsFetchError)
        }
    }
}

