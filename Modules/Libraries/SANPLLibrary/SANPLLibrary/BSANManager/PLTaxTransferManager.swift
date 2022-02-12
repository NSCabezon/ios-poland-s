//
//  PLTaxTransferManager.swift
//  SANPLLibrary
//
//  Created by 185167 on 11/01/2022.
//

import Foundation

public protocol PLTaxTransferManagerProtocol {
    func getPayers() throws -> Result<[TaxPayerDTO], NetworkProviderError>
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
}
