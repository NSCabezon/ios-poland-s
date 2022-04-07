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

@testable import Santander

struct PLInternalTransferExternalDependenciesResolverMock: PLInternalTransferOperativeExternalDependenciesResolver {
    private var rates: [ExchangeRateRepresentable]!

    public init(rates: [ExchangeRateRepresentable] = []) {
        self.rates = rates
    }
    
    func resolve() -> DependenciesResolver {
        fatalError()
    }
    
    func resolve() -> PLTransfersRepository {
        return PLTransfersRepositoryMock(rates: rates)
    }
    
    func resolve() -> GlobalPositionDataRepository {
        return PLGlobalPositionDataRepositoryMock()
    }
    
    func resolve() -> PLAccountOtherOperativesInfoRepository {
        fatalError()
    }
}
