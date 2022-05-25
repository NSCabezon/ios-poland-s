//
//  PLInternalTransferExternalDependenciesResolverMock.swift
//  SantanderTests
//
//  Created by Mario Rosales Maillo on 10/3/22.
//

import Foundation
import SANPLLibrary
import CoreDomain
import CoreFoundationLib
import CoreTestData
@testable import Santander

struct PLInternalTransferExternalDependenciesResolverMock: PLInternalTransferOperativeExternalDependenciesResolver {
    private var rates: [ExchangeRateRepresentable]!
    private var accounts: [AccountRepresentable]
    private var mockDataInjector: MockDataInjector

    public init(rates: [ExchangeRateRepresentable] = [], accounts: [AccountRepresentable] = [], mockDataInjector: MockDataInjector = MockDataInjector()) {
        self.rates = rates
        self.accounts = accounts
        self.mockDataInjector = mockDataInjector
    }
    
    func resolve() -> DependenciesResolver {
        fatalError()
    }
    
    func resolve() -> PLTransfersRepository {
        return PLTransfersRepositoryMock(rates: rates, accounts: accounts)
    }
    
    func resolve() -> GlobalPositionDataRepository {
        return MockGlobalPositionDataRepository(mockDataInjector.mockDataProvider.gpData.getGlobalPositionMock)
    }
    
    func resolve() -> PLAccountOtherOperativesInfoRepository {
        fatalError()
    }
}
