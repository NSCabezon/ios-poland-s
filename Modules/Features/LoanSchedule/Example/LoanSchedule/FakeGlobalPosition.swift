//
//  MockedGlobalPosition.swift
//  LoanSchedule_Example
//
//  Created by 187452 on 24/09/2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import Commons
import DomainCommon
import Repository
import SANPLLibrary
import SANLegacyLibrary

// TODO: Remove this mock when implementing true entry point [MOBILE-8943]
final class FakeGlobalPositionManager: PLGlobalPositionManagerProtocol {
    func getAllProducts() throws -> Result<SANPLLibrary.GlobalPositionDTO, NetworkProviderError> {
        fatalError()
    }
    
    func getAccounts() throws -> Result<SANPLLibrary.GlobalPositionDTO, NetworkProviderError> {
        fatalError()
    }
    
    func getCards() throws -> Result<SANPLLibrary.GlobalPositionDTO, NetworkProviderError> {
        fatalError()
    }
    
    func getLoans() throws -> Result<SANPLLibrary.GlobalPositionDTO, NetworkProviderError> {
        guard let mock = SANPLLibrary.GlobalPositionDTO.mock() else {
            return .failure(.other)
        }
        return .success(mock)
    }
    
    func getDeposits() throws -> Result<SANPLLibrary.GlobalPositionDTO, NetworkProviderError> {
        fatalError()
    }
    
    func getInvestmentFunds() throws -> Result<SANPLLibrary.GlobalPositionDTO, NetworkProviderError> {
        fatalError()
    }
    
    func getGlobalPosition() -> SANPLLibrary.GlobalPositionDTO? {
        fatalError()
    }
}

private extension SANPLLibrary.GlobalPositionDTO {
    static func mock() -> SANPLLibrary.GlobalPositionDTO? {
        return try? JSONDecoder().decode(GlobalPositionDTO.self, from: Data("""
    {
       "loans":[
          {
             "number":"1234"
          }
       ]
    }
    """.utf8))
    }
}
