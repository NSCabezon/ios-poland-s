//
//  PLInternalTransferOperativeExternalDependenciesResolverTest.swift
//  SantanderTests
//
//  Created by Cristobal Ramos Laina on 16/3/22.
//

import Foundation
import XCTest
import SANPLLibrary
import CoreDomain
import OpenCombine
import UnitTestCommons
import TransferOperatives
import CoreFoundationLib

@testable import Santander
struct PLInternalTransferOperativeExternalDependenciesResolverTest: PLInternalTransferOperativeExternalDependenciesResolver {
    func resolve() -> PLTransfersRepository {
        return PLTransfersRepositoryMock(rates: [])
    }
    
    func resolve() -> GlobalPositionDataRepository {
        return PLGlobalPositionDataRepositoryMock()
    }
    
    func resolve() -> DependenciesResolver {
        fatalError()
    }
}
