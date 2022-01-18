//
//  TaxTransferFormValidatorTests.swift
//  TaxTransfer_Tests
//
//  Created by 185167 on 17/01/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import XCTest
@testable import PLUI
@testable import TaxTransfer

class TaxTransferFormValidatorTests: XCTestCase {
    private var sut: TaxTransferFormValidator?

    override func setUp() {
        super.setUp()
        let amountFormatter = NumberFormatter.PLAmountNumberFormatterWithoutCurrency
        sut = TaxTransferFormValidator(amountFormatter: amountFormatter)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testValidFormData() throws {
        // given
        let sut = try XCTUnwrap(sut)
        let formData = TaxTransferFormFieldsData(
            amount: "2000,95",
            obligationIdentifier: "example-identifier",
            date: Date()
        )
        
        // when
        let validationResult = sut.validateData(formData)
        
        // then
        let expectedValidationResult = TaxTransferFormValidity.valid
        XCTAssertEqual(validationResult, expectedValidationResult)
    }

    func testEmptyFormData() throws {
        // given
        let sut = try XCTUnwrap(sut)
        let formData = TaxTransferFormFieldsData(
            amount: "",
            obligationIdentifier: "",
            date: Date()
        )
        
        // when
        let validationResult = sut.validateData(formData)
        
        
        // then
        let expecetedMessages = TaxTransferFormValidity.InvalidFormMessages(
            amountMessage: nil,
            obligationIdentifierMessage: nil
        )
        let expectedValidationResult = TaxTransferFormValidity.invalid(expecetedMessages)
        XCTAssertEqual(validationResult, expectedValidationResult)
    }

    func testAmountLowerThanMinimum() throws {
        // given
        let sut = try XCTUnwrap(sut)
        let formData = TaxTransferFormFieldsData(
            amount: "0.0",
            obligationIdentifier: "",
            date: Date()
        )
        
        // when
        let validationResult = sut.validateData(formData)
        
        // then
        switch validationResult {
        case .valid:
            XCTFail("Unexpected valid state")
        case let .invalid(messages):
            XCTAssertFalse((messages.amountMessage ?? "").isEmpty)
            XCTAssertTrue((messages.obligationIdentifierMessage ?? "").isEmpty)
        }
    }
    
    func testIllegalCharactersInObligationIdentifier() throws {
        // given
        let sut = try XCTUnwrap(sut)
        let formData = TaxTransferFormFieldsData(
            amount: "",
            obligationIdentifier: "!@#$%^&*(",
            date: Date()
        )
        
        // when
        let validationResult = sut.validateData(formData)
        
        
        // then
        switch validationResult {
        case .valid:
            XCTFail("Unexpected valid state")
        case let .invalid(messages):
            XCTAssertTrue((messages.amountMessage ?? "").isEmpty)
            XCTAssertFalse((messages.obligationIdentifierMessage ?? "").isEmpty)
        }
    }
}
