//
//  CustomTopUpAmountValidator.swift
//  PhoneTopUp_Tests
//
//  Created by 188216 on 07/03/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import XCTest
@testable import PhoneTopUp

class CustomTopUpAmountValidatorTests: XCTestCase {
    
    let validator = CustomTopUpAmountValidator()

    func testValidatingFixedAmount() throws {
        let amount = TopUpAmount.fixed(TopUpValue(value: 40, bonus: 5))
        let results = validator.validate(amount: amount, minAmount: 0, maxAmount: 5, availableFunds: 100)
        switch results {
        case .valid:
            XCTAssert(true, "Fixed amounts should always be validated as valid")
        case .error:
            XCTAssert(false, "Fixed amounts should always be validated as valid")
        }
    }
    
    func testValidatingNilAmount() throws {
        let results = validator.validate(amount: nil, minAmount: 0, maxAmount: 5, availableFunds: 100)
        switch results {
        case .valid:
            XCTAssert(true, "nil amount should validate to true")
        case .error:
            XCTAssert(false)
        }
    }
    
    func testValidatingCustomAmountWithANilValue() throws {
        let amount = TopUpAmount.custom(amount: nil)
        let results = validator.validate(amount: amount, minAmount: 0, maxAmount: 5, availableFunds: 100)
        switch results {
        case .valid:
            XCTAssert(false)
        case .error(let message):
            XCTAssert(message == "", "nil amount should be invalid but no error message should be displayed")
        }
    }
    
    func testValidatingCustomAmountButOtherValuesNil() throws {
        let amount = TopUpAmount.custom(amount: 10)
        let results = validator.validate(amount: amount, minAmount: nil, maxAmount: nil, availableFunds: nil)
        switch results {
        case .valid:
            XCTAssert(false)
        case .error(let message):
            XCTAssert(message == "pl_topup_text_valid_fundsNoAvailb")
        }
    }
    
    func testValidatingCustomAmountSmallerThanMinAmount() throws {
        let amount = TopUpAmount.custom(amount: 5)
        let results = validator.validate(amount: amount, minAmount: 10, maxAmount: 100, availableFunds: 50)
        switch results {
        case .valid:
            XCTAssert(false)
        case .error(let message):
            XCTAssert(message == "pl_topup_text_valid_minFund")
        }
    }
    
    func testValidatingCustomAmountLargerThanMaxAmount() throws {
        let amount = TopUpAmount.custom(amount: 125)
        let results = validator.validate(amount: amount, minAmount: 10, maxAmount: 100, availableFunds: 150)
        switch results {
        case .valid:
            XCTAssert(false)
        case .error(let message):
            XCTAssert(message == "pl_topup_text_valid_maxFund")
        }
    }
    
    func testValidatingCustomAmountLargerThanAvailableFunds() throws {
        let amount = TopUpAmount.custom(amount: 160)
        let results = validator.validate(amount: amount, minAmount: 10, maxAmount: 200, availableFunds: 150)
        switch results {
        case .valid:
            XCTAssert(false)
        case .error(let message):
            XCTAssert(message == "pl_topup_text_valid_fundsNoAvailb")
        }
    }
    
    func testValidatingValidCustomAmount() throws {
        let amount = TopUpAmount.custom(amount: 120)
        let results = validator.validate(amount: amount, minAmount: 10, maxAmount: 200, availableFunds: 150)
        switch results {
        case .valid:
            XCTAssert(true)
        case .error:
            XCTAssert(false)
        }
    }
}
