//
//  PLTransferManagerTest.swift
//  SANPLLibrary_Tests


import XCTest
import SANLegacyLibrary
import CoreDomain
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
    
    func test_doIBANValidation_shouldReturnIsInternalAccount() {
        self.setUpDemoUser()
        let accountNumber = "09109023980000000135424612"
        let branchId = 10902398
        let result = try? transferManager.doIBANValidation(IBANValidationParameters(accountNumber: accountNumber, branchId: "\(branchId)"))
        switch result {
        case .success(let response):
            XCTAssert(!response.isExternal)
        case .failure(let error):
            print("Error .\(error.localizedDescription)")
            XCTFail("Not validate IBAN - Failure")
        default:
            XCTFail("Not validate IBAN")
        }
    }
    
    func test_checkFinalFee_shouldReturNonEmptyFeeList() {
        self.setUpDemoUser()
        let iban = IBANDTO(countryCode: "PL", checkDigits: "12", codBban: "109010430000000142742925")
        let amount = AmountDTO(value: 12, currency: CurrencyDTO(currencyName: "PLN", currencyType: .złoty))
        let inputParameters = CheckFinalFeeInput(originAccount: iban, amount: amount, servicesAvailable: "")
        let result = try? transferManager.checkFinalFee(inputParameters)
        switch result {
        case .success(let response):
            XCTAssert(!response.isEmpty)
        case .failure(let error):
            print("Error .\(error.localizedDescription)")
            XCTFail("Not getting fee transfer - Failure")
        default:
            XCTFail("Not getting fee transfer")
        }
    }
    
    func test_confirmTransfer_shouldReturOkResonse() {
        self.setUpDemoUser()
        let parameters: GenericSendMoneyConfirmationInput = GenericSendMoneyConfirmationInput(customerAddressData: nil, debitAmountData: nil, creditAmountData: nil, debitAccountData: nil, creditAccountData: nil, signData: nil, title: nil, type: nil, transferType: nil, valueDate: nil)
        let result = try? transferManager.sendConfirmation(parameters)
        switch result {
        case .success(let response):
            XCTAssert(response.state == "ACCEPTED")
        case .failure(let error):
            print("Error .\(error.localizedDescription)")
            XCTFail("Error confirming transfer - Failure")
        default:
            XCTFail("Error confirming transfer")
        }
    }
    
    func test_checkTransactionAvailability_shouldReturNonEmptyFeeList() {
        self.setUpDemoUser()
        let iban = "PL12109010430000000142742925"
        let amount: Decimal = 200
        let parameters = CheckTransactionParameters(customerProfile: "CEKE_3", transactionAmount: amount, hasSplitPayment: false)
        let result = try? transferManager.checkTransaction(parameters: parameters, accountReceiver: iban)
        switch result {
        case .success(let response):
            XCTAssert((response.blueCashStatusCode != nil) != false)
        case .failure(let error):
            print("Error .\(error.localizedDescription)")
            XCTFail("Not getting fee transfer - Failure")
        default:
            XCTFail("Not getting fee transfer")
        }
    }
}
