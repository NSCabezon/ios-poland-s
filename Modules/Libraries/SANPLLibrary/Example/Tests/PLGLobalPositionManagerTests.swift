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
        
    func testGetAllProducts() {
        let result = try? globalPositionManager.getAllProducts()
        
        switch result {
        case .success:
            XCTAssert(true)
        case .failure(let error):
            print("Error .\(error.localizedDescription)")
            XCTFail("Not getting global position")
        default:
            XCTFail("Not getting globalposition")
        }
    }
    
    func testGetAccounts() {
        let result = try? globalPositionManager.getAccounts()
        
        switch result {
        case .success:
            XCTAssert(true)
        case .failure(let error):
            print("Error .\(error.localizedDescription)")
            XCTFail("Not getting global position")
        default:
            XCTFail("Not getting globalposition")
        }
    }
    
    func testGetCards() {
        let result = try? globalPositionManager.getCards()
        
        switch result {
        case .success:
            XCTAssert(true)
        case .failure(let error):
            print("Error .\(error.localizedDescription)")
            XCTFail("Not getting global position")
        default:
            XCTFail("Not getting globalposition")
        }
    }

    func testGetDeposits() {
        let result = try? globalPositionManager.getDeposits()
        
        switch result {
        case .success:
            XCTAssert(true)
        case .failure(let error):
            print("Error .\(error.localizedDescription)")
            XCTFail("Not getting global position")
        default:
            XCTFail("Not getting globalposition")
        }
    }

    func testGetInvestmentFunds() {
        let result = try? globalPositionManager.getInvestmentFunds()
        
        switch result {
        case .success:
            XCTAssert(true)
        case .failure(let error):
            print("Error .\(error.localizedDescription)")
            XCTFail("Not getting global position")
        default:
            XCTFail("Not getting globalposition")
        }
    }

    func testGetLoans() {
        let result = try? globalPositionManager.getLoans()
        
        switch result {
        case .success:
            XCTAssert(true)
        case .failure(let error):
            print("Error .\(error.localizedDescription)")
            XCTFail("Not getting global position")
        default:
            XCTFail("Not getting globalposition")
        }
    }
}
