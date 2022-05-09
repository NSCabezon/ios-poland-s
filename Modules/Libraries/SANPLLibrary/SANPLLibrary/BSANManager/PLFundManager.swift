//
//  PLFundManager.swift
//  SANPLLibrary
//
//  Created by Alvaro Royo on 15/1/22.
//

import Foundation
import SANLegacyLibrary

public protocol PLFundManagerProtocol {
    func getFundDetails(registerId: String) -> Result<FundDetailsDTO, NetworkProviderError>
    func getFundTransactions(registerId: String, language: String) -> Result<FundTransactionListDTO, NetworkProviderError>
    func getFundTransactionsFiltered(registerId: String, language: String, parameters: FundTransactionsParameters) -> Result<FundTransactionListDTO, NetworkProviderError>
    func changeAlias(fundDTO: SANLegacyLibrary.FundDTO, newAlias: String) throws -> Result<FundChangeAliasDTO, NetworkProviderError>
}

final class PLFundManager {
	private let fundDataSource: FundDataSourceProtocol
	private let bsanDataProvider: BSANDataProvider
	private let demoInterpreter: DemoUserProtocol
	
	public init(bsanDataProvider: BSANDataProvider, networkProvider: NetworkProvider, demoInterpreter: DemoUserProtocol) {
		self.fundDataSource = FundDataSource(networkProvider: networkProvider, dataProvider: bsanDataProvider)
		self.bsanDataProvider = bsanDataProvider
		self.demoInterpreter = demoInterpreter
	}
}

extension PLFundManager: PLFundManagerProtocol {

    func getFundDetails(registerId: String) -> Result<FundDetailsDTO, NetworkProviderError> {
        fundDataSource.getFundDetails(registerId: registerId)
    }

    func getFundTransactions(registerId: String, language: String) -> Result<FundTransactionListDTO, NetworkProviderError> {
        fundDataSource.getFundTransactions(registerId: registerId, language: language)
    }

    func getFundTransactionsFiltered(registerId: String, language: String, parameters: FundTransactionsParameters) -> Result<FundTransactionListDTO, NetworkProviderError> {
        fundDataSource.getFundTransactionsFiltered(registerId: registerId, language: language, parameters: parameters)
    }

	func changeAlias(fundDTO: SANLegacyLibrary.FundDTO, newAlias: String) throws -> Result<FundChangeAliasDTO, NetworkProviderError> {
		try fundDataSource.changeAlias(fundDTO: fundDTO, newAlias: newAlias)
	}
}
