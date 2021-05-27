//
//  PLGLobalPositionManagerTests.swift
//  SANPLLibrary_Tests
//
//  Created by Ernesto Fernandez Calles on 25/5/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
@testable import SANPLLibrary

final class PLGLobalPositionManagerTests: Tests {

    private var globalPositionManager: PLGlobalPositionManager {

        return PLGlobalPositionManager(bsanDataProvider: self.bsanDataProvider,
                              networkProvider: self.networkProvider,
                              demoInterpreter: self.demoInterpreter)
    }

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }
        
    func testGetAllProducts() throws -> Result<GlobalPositionDTO, NetworkProviderError> {
        let result = try globalPositionDataSource.getGlobalPosition()
        
        switch result {
        case .success(let globalPosition):
            XCTAssert()
        case .failure(let error):
            print("Error .\(error.localizedDescription)")
            XCTFail("Not getting global position")
        default:
            XCTFail("Not getting globalposition")
        }
    }
    
    func getAccounts() throws -> Result<GlobalPositionDTO, NetworkProviderError> {
        let result = try globalPositionDataSource.getGlobalPosition(GlobalPositionParameters(filterBy: .accounts))
        
        switch result {
        case .success(let globalPosition):
            XCTAssert()
        case .failure(let error):
            print("Error .\(error.localizedDescription)")
            XCTFail("Not getting global position")
        default:
            XCTFail("Not getting globalposition")
        }
    }
    
    func getCards() throws -> Result<GlobalPositionDTO, NetworkProviderError> {
        let result = try globalPositionDataSource.getGlobalPosition(GlobalPositionParameters(filterBy: .cards))
        
        switch result {
        case .success(let globalPosition):
            XCTAssert()
        case .failure(let error):
            print("Error .\(error.localizedDescription)")
            XCTFail("Not getting global position")
        default:
            XCTFail("Not getting globalposition")
        }
    }

    func getDeposits() throws -> Result<GlobalPositionDTO, NetworkProviderError> {
        let result = try globalPositionDataSource.getGlobalPosition(GlobalPositionParameters(filterBy: .deposits))
        
        switch result {
        case .success(let globalPosition):
            XCTAssert()
        case .failure(let error):
            print("Error .\(error.localizedDescription)")
            XCTFail("Not getting global position")
        default:
            XCTFail("Not getting globalposition")
        }
    }

    func getInvestmentFunds() throws -> Result<GlobalPositionDTO, NetworkProviderError> {
        let result = try globalPositionDataSource.getGlobalPosition(GlobalPositionParameters(filterBy: .investmentFunds))
        
        switch result {
        case .success(let globalPosition):
            XCTAssert()
        case .failure(let error):
            print("Error .\(error.localizedDescription)")
            XCTFail("Not getting global position")
        default:
            XCTFail("Not getting globalposition")
        }
    }

    func getLoans() throws -> Result<GlobalPositionDTO, NetworkProviderError> {
        let result = try globalPositionDataSource.getGlobalPosition(GlobalPositionParameters(filterBy: .loans))
        
        switch result {
        case .success(let globalPosition):
            XCTAssert()
        case .failure(let error):
            print("Error .\(error.localizedDescription)")
            XCTFail("Not getting global position")
        default:
            XCTFail("Not getting globalposition")
        }
    }
}
