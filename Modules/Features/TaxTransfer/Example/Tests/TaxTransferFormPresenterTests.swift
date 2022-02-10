//
//  TaxTransferFormPresenterTests.swift
//  TaxTransfer_Tests
//
//  Created by 185167 on 17/01/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import XCTest
@testable import TaxTransfer
import CoreFoundationLib
import PLCommons

class TaxTransferFormPresenterTests: XCTestCase {
    private var sut: TaxTransferFormPresenter?
    private var dependenciesContainer: DependenciesDefault?

    override func setUp() {
        super.setUp()
        
        let dependenciesContainer = DependenciesDefault()
        self.dependenciesContainer = dependenciesContainer
        sut = TaxTransferFormPresenter(
            currency: "PLN",
            dependenciesResolver: dependenciesContainer
        )
    }
    
    override func tearDown() {
        sut = nil
        dependenciesContainer = nil
        super.tearDown()
    }
    
    func testDidTapAccountSelector() throws {
        // given
        let sut = try XCTUnwrap(sut)
        let dependenciesContainer = try XCTUnwrap(dependenciesContainer)
        let coordinatorMock = TaxTransferFormCoordinatorMock()
        dependenciesContainer.register(for: TaxTransferFormCoordinatorProtocol.self) { _ in
            return coordinatorMock
        }
        
        let showAccountSelectorExpectation = expectation(description: "Did call show account selector")
        coordinatorMock.showAccountSelectorBlock = { (receivedAccounts, receivedSelectedNumber, receivedMode) in
            showAccountSelectorExpectation.fulfill()
        }
        
        // when
        sut.didTapAccountSelector()
        
        // then
        wait(for: [showAccountSelectorExpectation], timeout: 0.1)
    }
    
    func testDidTapBack() throws {
        // given
        let sut = try XCTUnwrap(sut)
        let dependenciesContainer = try XCTUnwrap(dependenciesContainer)
        let coordinatorMock = TaxTransferFormCoordinatorMock()
        dependenciesContainer.register(for: TaxTransferFormCoordinatorProtocol.self) { _ in
            return coordinatorMock
        }
        
        let backCallExpectation = expectation(description: "Did call back method")
        coordinatorMock.backBlock = {
            backCallExpectation.fulfill()
        }
        
        // when
        sut.didTapBack()
        
        // then
        wait(for: [backCallExpectation], timeout: 0.1)
    }
    
    func testDidUpdateFieldsWithValidData() throws {
        // given
        let sut = try XCTUnwrap(sut)
        let dependenciesContainer = try XCTUnwrap(dependenciesContainer)
        let viewMock = TaxTransferFormViewMock()
        sut.view = viewMock
        let validatorMock = TaxTransferFormValidatorMock()
        dependenciesContainer.register(for: TaxTransferFormValidating.self) { _ in
            return validatorMock
        }
        let formFields = TaxTransferFormFields(
            amount: "100,00",
            obligationIdentifier: "example identifier",
            date: Date()
        )
        
        let validationExpectation = expectation(description: "Did call validator")
        validatorMock.validationBlock = { fields -> TaxTransferFormValidity in
            XCTAssertEqual(fields, formFields)
            validationExpectation.fulfill()
            return .valid
        }
        
        let enableDoneButtonExpectation = expectation(description: "Did enable done button")
        viewMock.enableDoneButtonBlock = {
            enableDoneButtonExpectation.fulfill()
        }
        
        // when
        sut.didUpdateFields(with: formFields)
        
        // then
        wait(for: [validationExpectation, enableDoneButtonExpectation], timeout: 0.1)
    }
    
    func testDidUpdateFieldsWithInvalidData() throws {
        // given
        let sut = try XCTUnwrap(sut)
        let dependenciesContainer = try XCTUnwrap(dependenciesContainer)
        let viewMock = TaxTransferFormViewMock()
        sut.view = viewMock
        let validatorMock = TaxTransferFormValidatorMock()
        dependenciesContainer.register(for: TaxTransferFormValidating.self) { _ in
            return validatorMock
        }
        let formFields = TaxTransferFormFields(
            amount: "0,0",
            obligationIdentifier: "@#$%^&*(",
            date: Date()
        )
        
        let invalidFormMessages = TaxTransferFormValidity.InvalidFormMessages(
            amountMessage: "Message 1",
            obligationIdentifierMessage: "Message 2"
        )
        let validationExpectation = expectation(description: "Did call validator")
        validatorMock.validationBlock = { fields -> TaxTransferFormValidity in
            XCTAssertEqual(fields, formFields)
            validationExpectation.fulfill()
            return .invalid(invalidFormMessages)
        }
        
        let disableDoneButtonExpectation = expectation(description: "Did disable done button")
        viewMock.disableDoneButtonBlock = { messages in
            disableDoneButtonExpectation.fulfill()
            XCTAssertEqual(messages, invalidFormMessages)
        }
        
        // when
        sut.didUpdateFields(with: formFields)
        
        // then
        wait(for: [validationExpectation, disableDoneButtonExpectation], timeout: 0.1)
    }
}
