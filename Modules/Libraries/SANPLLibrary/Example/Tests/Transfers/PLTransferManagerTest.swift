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
    
    func test_getPayees_shouldReturNonEmptyPayeeList() {
        self.setUpDemoUser()
        let result = try? transferManager.getPayees(GetPayeesParameters(recCunt: nil))
        switch result {
        case .success(let response):
            XCTAssert(!response.isEmpty)
        case .failure(let error):
            print("Error .\(error.localizedDescription)")
            XCTFail("Not getting payees - Failure")
        default:
            XCTFail("Not getting payees")
        }
    }
    
    func test_getPayees_shouldReturn_NonEmptyPayeeList_with_AccountDetails() {
        self.setUpDemoUser(1)
        let result = try? transferManager.getPayees(GetPayeesParameters(recCunt: nil))
        switch result {
        case .success(let response):
            XCTAssert(!response.isEmpty && response.allSatisfy{ $0.account?.accountType?.details != nil })
        case .failure(let error):
            print("Error .\(error.localizedDescription)")
            XCTFail("Not getting payees - Failure")
        default:
            XCTFail("Not getting payees")
        }
    }
    
    func test_getPayees_shouldReturnEmptyPayeeList() {
        self.setUpDemoUser(2)
        let result = try? transferManager.getPayees(GetPayeesParameters(recCunt: nil))
        switch result {
        case .success(let response):
            XCTAssert(response.isEmpty)
        case .failure(let error):
            print("Error .\(error.localizedDescription)")
            XCTFail("Not getting payees - Failure")
        default:
            XCTFail("Not getting payees")
        }
    }
    
    func test_getRecentRecipients_shouldReturn_twoRecipientDataElements() throws {
        self.setUpDemoUser()
        let result = try? transferManager.getRecentRecipients()
        switch result {
        case .success(let responseDTO):
            XCTAssertTrue(responseDTO.count == 2)
        case .failure(let error):
            print("Error .\(error.localizedDescription)")
            XCTFail("Not getting payees recent recipients")
        default:
            XCTFail("Not getting recent recipients")
        }
    }
    
    func test_doIBANValidation_shouldReturnAccountOwnerData() {
        self.setUpDemoUser()
        let accountNumber = "09109023980000000135424612"
        let branchId = 10902398
        let result = try? transferManager.doIBANValidation(IBANValidationParameters(accountNumber: accountNumber, branchId: "\(branchId)"))
        switch result {
        case .success(let response):
            let plResponse = response as? PLValidateAccountTransferRepresentable
            XCTAssert(plResponse?.number == accountNumber)
        case .failure(let error):
            print("Error .\(error.localizedDescription)")
            XCTFail("Not validate IBAN - Failure")
        default:
            XCTFail("Not validate IBAN")
        }
    }
}
