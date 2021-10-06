//
//  PLTransferManagerTest.swift
//  SANPLLibrary_Tests


import XCTest
@testable import SANPLLibrary

class PLTransferManagerTest: Tests {
    
    private var transferManager: PLTransfersManager {
        return PLTransfersManager(bsanDataProvider: self.bsanDataProvider,
                              networkProvider: self.networkProvider,
                              demoInterpreter: self.demoInterpreter)
    }
    
    override func setUp() {
        super.setUp()
        self.bsanDataProvider.storeEnviroment(BSANEnvironments.environmentPre)
    }

    override func tearDown() {
        super.tearDown()
    }

    func test_getAccountForDebit_shouldReturnNonEmptyAccountList() {
        self.setUpDemoUser()
        let result = try? transferManager.getAccountsForDebit()
        switch result {
        case .success(let response):
            XCTAssert(response.count > 0)
        case .failure(let error):
            print("Error .\(error.localizedDescription)")
            XCTFail("Not getting accounts - Failure")
        default:
            XCTFail("Not getting accounts")
        }
    }
}
