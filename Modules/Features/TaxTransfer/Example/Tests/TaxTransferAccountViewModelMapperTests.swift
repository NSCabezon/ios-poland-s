//
//  TaxTransferAccountViewModelMapperTests.swift
//  TaxTransfer_Tests
//
//  Created by 185167 on 17/01/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import XCTest
@testable import TaxTransfer
@testable import PLUI
@testable import PLCommons

class TaxTransferAccountViewModelMapperTests: XCTestCase {
    private var sut: TaxTransferAccountViewModelMapper?
    private var amountFormatter: NumberFormatter?
    
    override func setUp() {
        super.setUp()
        let amountFormatter = NumberFormatter.PLAmountNumberFormatter
        self.amountFormatter = amountFormatter
        sut = TaxTransferAccountViewModelMapper(amountFormatter: amountFormatter)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testMapping() throws {
        // given
        let sut = try XCTUnwrap(sut)
        let amountFormatter = try XCTUnwrap(amountFormatter)
        let account = AccountForDebit(
            id: "123",
            name: "Example Account Name",
            number: "12 0001 2030 2003 5910 0100",
            availableFunds: Money(amount: 10000.00, currency: "PLN"),
            defaultForPayments: true,
            type: .PERSONAL,
            accountSequenceNumber: 10,
            accountType: 15
        )
        let maskedAccount = "*" + account.number.suffix(4)
        amountFormatter.currencySymbol = account.availableFunds.currency
        let amountNumber = account.availableFunds.amount as NSNumber
        let accountBalance = amountFormatter.string(from: amountNumber)
        let isEditButtonEnabled = true
        
        // when
        let viewModel = sut.map(
            account,
            isEditButtonEnabled: isEditButtonEnabled
        )
        
        // then
        XCTAssertEqual(viewModel.id, account.id)
        XCTAssertEqual(viewModel.accountName, account.name)
        XCTAssertEqual(viewModel.maskedAccountNumber, maskedAccount)
        XCTAssertEqual(viewModel.unformattedAccountNumber, account.number)
        XCTAssertEqual(viewModel.accountBalance, accountBalance)
        XCTAssertEqual(viewModel.isEditButtonEnabled, isEditButtonEnabled)
    }
}
