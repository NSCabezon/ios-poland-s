//
//  TopUpFormValidatorTests.swift
//  PhoneTopUp_Tests
//
//  Created by 188216 on 07/03/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import XCTest
import PLCommons
@testable import PhoneTopUp

class TopUpFormValidatorTests: XCTestCase {
    
    let validator = TopUpFormValidator(
        customAmountValidator: CustomTopUpAmountValidator(),
        numberValidator: PartialPhoneNumberValidator()
    )
    
    func testValidationWithNilAccount() throws {
        let results = validator.areFormInputsValid(account: nil, number: .full(number: "454 456 456"), gsmOperator: mockGSMOperator(), operator: mockOperator(), topUpAmount: .custom(amount: 10), termsAcceptanceRequired: false, termsAccepted: false)
        XCTAssert(results == false, "Nil account should be validated to false")
    }
    
    func testValidationWithNilGsmOperator() throws {
        let results = validator.areFormInputsValid(account: mockAccount(), number: .full(number: "454 456 456"), gsmOperator: nil, operator: mockOperator(), topUpAmount: .custom(amount: 10), termsAcceptanceRequired: false, termsAccepted: false)
        XCTAssert(results == false, "Nil gsmOperator should be validated to false")
    }
    
    func testValidationWithNilOperator() throws {
        let results = validator.areFormInputsValid(account: mockAccount(), number: .full(number: "454 456 456"), gsmOperator: mockGSMOperator(), operator: nil, topUpAmount: .custom(amount: 10), termsAcceptanceRequired: false, termsAccepted: false)
        XCTAssert(results == false, "Nil operator should be validated to false")
    }
    
    func testValidationWithNilAmount() throws {
        let results = validator.areFormInputsValid(account: mockAccount(), number: .full(number: "454 456 456"), gsmOperator: mockGSMOperator(), operator: mockOperator(), topUpAmount: nil, termsAcceptanceRequired: false, termsAccepted: false)
        XCTAssert(results == false, "Nil amount should be validated to false")
    }
    
    func testValidationWhenTermsAcceptanceIsRequiredButTermsAreNotAccepted() throws {
        let results = validator.areFormInputsValid(account: mockAccount(), number: .full(number: "454 456 456"), gsmOperator: mockGSMOperator(), operator: mockOperator(), topUpAmount: .custom(amount: 10), termsAcceptanceRequired: true, termsAccepted: false)
        XCTAssert(results == false, "Terms should be accepted if required")
    }
    
    func testValidtionWhenPhoneNumberIsInvalid() throws {
        let results = validator.areFormInputsValid(account: mockAccount(), number: .full(number: "454 456"), gsmOperator: mockGSMOperator(), operator: mockOperator(), topUpAmount: .custom(amount: 10), termsAcceptanceRequired: true, termsAccepted: true)
        XCTAssert(results == false, "Phone number should be invalid")
    }
    
    func testValidtionWhenCustomAmountIsBelowMinAmount() throws {
        let results = validator.areFormInputsValid(account: mockAccount(), number: .full(number: "454 456 456"), gsmOperator: mockGSMOperator(), operator: mockOperator(), topUpAmount: .custom(amount: 1), termsAcceptanceRequired: true, termsAccepted: true)
        XCTAssert(results == false, "Custom amount should be too small")
    }
    
    func testValidtionWhenCustomAmountIsAboveMaxAmount() throws {
        let results = validator.areFormInputsValid(account: mockAccount(), number: .full(number: "454 456 456"), gsmOperator: mockGSMOperator(), operator: mockOperator(), topUpAmount: .custom(amount: 75), termsAcceptanceRequired: true, termsAccepted: true)
        XCTAssert(results == false, "Custom amount should be too big")
    }
    
    func testValidtionWhenCustomAmountIsAboveAvailableFunds() throws {
        let results = validator.areFormInputsValid(account: mockAccount(), number: .full(number: "454 456 456"), gsmOperator: mockGSMOperator(), operator: mockOperator(), topUpAmount: .custom(amount: 75), termsAcceptanceRequired: true, termsAccepted: true)
        XCTAssert(results == false, "Custom amount should be too big")
    }
    
    func testValidationWhenAllInputsAreValid() throws {
        let results = validator.areFormInputsValid(account: mockAccount(), number: .full(number: "454 456 456"), gsmOperator: mockGSMOperator(), operator: mockOperator(), topUpAmount: .custom(amount: 10), termsAcceptanceRequired: true, termsAccepted: true)
        XCTAssert(results == true, "All inputs should be valid")
    }
    
    private func mockGSMOperator() -> GSMOperator {
        return GSMOperator(id: 0, blueMediaId: "1", name: "Orange")
    }
    
    private func mockOperator() -> Operator {
        return Operator(id: 0, name: "Orange", topupValues: TopUpValues(type: "", min: 5, max: 100, values: [TopUpValue(value: 5, bonus: 10)]), prefixes: [])
    }
    
    private func mockAccount() -> AccountForDebit {
        return AccountForDebit(id: "0", name: "some", number: "1234", availableFunds: Money(amount: 50, currency: "PLN"), defaultForPayments: true, type: .PERSONAL, accountSequenceNumber: 0, accountType: 0)
    }
}
