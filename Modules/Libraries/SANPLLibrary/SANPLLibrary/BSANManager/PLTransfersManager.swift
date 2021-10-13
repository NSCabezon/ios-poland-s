//
//  PolandTransfersRepository.swift
//  SANPLLibrary
//
//  Created by Luis Escámez Sánchez on 27/9/21.
//

import CoreDomain

public protocol PLTransfersManagerProtocol {
    func getAccountsForDebit() throws -> Result<[AccountRepresentable], NetworkProviderError>
}

final class PLTransfersManager {
    
    private let transferDataSource: TransfersDataSourceProtocol
    private let bsanDataProvider: BSANDataProvider
    private let demoInterpreter: DemoUserProtocol
    
    public init(bsanDataProvider: BSANDataProvider, networkProvider: NetworkProvider, demoInterpreter: DemoUserProtocol) {
        self.transferDataSource = TransfersDataSource(networkProvider: networkProvider, dataProvider: bsanDataProvider)
        self.bsanDataProvider = bsanDataProvider
        self.demoInterpreter = demoInterpreter
    }
}
    
extension PLTransfersManager: PLTransfersManagerProtocol {
    
    func getAccountsForDebit() throws -> Result<[AccountRepresentable], NetworkProviderError> {
        let result = try self.transferDataSource.getAccountsForDebit()
        switch result {
        case .success(let accountForDebitDTO):
            return .success(accountForDebitDTO)
        case .failure(let error):
            return .failure(error)
        }
    }
}
