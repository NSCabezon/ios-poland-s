//
//  PLDepositManager.swift
//  SANPLLibrary
//
//  Created by Alvaro Royo on 14/1/22.
//

import Foundation
import SANLegacyLibrary

public protocol PLDepositManagerProtocol {
	func changeAlias(depositDTO: SANLegacyLibrary.DepositDTO, newAlias: String) throws -> Result<DepositChangeAliasDTO, NetworkProviderError>
}

final class PLDepositManager {
	private let depositDataSource: DepositDataSourceProtocol
	private let bsanDataProvider: BSANDataProvider
	private let demoInterpreter: DemoUserProtocol
	
	public init(bsanDataProvider: BSANDataProvider, networkProvider: NetworkProvider, demoInterpreter: DemoUserProtocol) {
		self.depositDataSource = DepositDataSource(networkProvider: networkProvider, dataProvider: bsanDataProvider)
		self.bsanDataProvider = bsanDataProvider
		self.demoInterpreter = demoInterpreter
	}
}

extension PLDepositManager: PLDepositManagerProtocol {
	func changeAlias(depositDTO: SANLegacyLibrary.DepositDTO, newAlias: String) throws -> Result<DepositChangeAliasDTO, NetworkProviderError> {
		try depositDataSource.changeAlias(depositDTO: depositDTO, newAlias: newAlias)
	}
}
