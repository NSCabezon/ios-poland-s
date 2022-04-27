//
//  PLTaxTransferManager.swift
//  SANPLLibrary
//
//  Created by 185167 on 11/01/2022.
//

import Foundation

public protocol PLTaxTransferManagerProtocol {
    func getPayers() throws -> Result<[TaxPayerDTO], NetworkProviderError>
    func getPredefinedTaxAuthorities() throws -> Result<[PayeeDTO], NetworkProviderError>
    func getTaxSymbols() throws -> Result<[TaxSymbolDTO], NetworkProviderError>
    func getTaxAccounts(requestQueries: TaxAccountsRequestQueries) throws -> Result<[TaxAccountDTO], NetworkProviderError>
    func getTaxAuthorityCities(requestQueries: TaxAuthorityCitiesRequestQueries) throws -> Result<[String], NetworkProviderError>
    func getUserTaxAccount(requestQueries: UserTaxAccountRequestQueries) throws -> Result<UserTaxAccountDTO, NetworkProviderError>
}

public final class PLTaxTransferManager {
    private let dataSource: TaxTransferDataSourceProtocol
    private let bsanDataProvider: BSANDataProvider
    
    public init(bsanDataProvider: BSANDataProvider, networkProvider: NetworkProvider) {
        self.dataSource = TaxTransferDataSource(networkProvider: networkProvider, dataProvider: bsanDataProvider)
        self.bsanDataProvider = bsanDataProvider
    }
}

extension PLTaxTransferManager: PLTaxTransferManagerProtocol {
    public func getPayers() throws -> Result<[TaxPayerDTO], NetworkProviderError> {
        try dataSource.getTaxPayers()
    }
    
    public func getPredefinedTaxAuthorities() throws -> Result<[PayeeDTO], NetworkProviderError> {
        try dataSource.getPredefinedTaxAuthorities()
    }
    
    public func getTaxSymbols() throws -> Result<[TaxSymbolDTO], NetworkProviderError> {
        try dataSource.getTaxSymbols()
    }
    
    public func getTaxAccounts(requestQueries: TaxAccountsRequestQueries) throws -> Result<[TaxAccountDTO], NetworkProviderError> {
        try dataSource.getTaxAccounts(requestQueries: requestQueries)
    }
    
    public func getTaxAuthorityCities(requestQueries: TaxAuthorityCitiesRequestQueries) throws -> Result<[String], NetworkProviderError> {
        try dataSource.getTaxAuthorityCities(requestQueries: requestQueries)
    }
    
    public func getUserTaxAccount(requestQueries: UserTaxAccountRequestQueries) throws -> Result<UserTaxAccountDTO, NetworkProviderError> {
        try dataSource.getUserTaxAccount(requestQueries: requestQueries)
    }
}
