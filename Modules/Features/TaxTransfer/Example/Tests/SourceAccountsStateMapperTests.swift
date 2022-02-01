//
//  SourceAccountsStateMapperTests.swift
//  TaxTransfer_Tests
//
//  Created by 185167 on 26/01/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import XCTest
@testable import TaxTransfer
@testable import PLUI
@testable import PLCommons

class SourceAccountsStateMapperTests: XCTestCase {
    private var sut: SourceAccountsStateMapper?
    private var amountFormatter: NumberFormatter?
    
    override func setUp() {
        super.setUp()
        sut = SourceAccountsStateMapper()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testEmptyListState() throws {
        // given
        let sut = try XCTUnwrap(sut)
        let accounts: [AccountForDebit] = []
        
        // when
        let state = sut.map(accounts)
        
        // then
        XCTAssertEqual(state, .listIsEmpty)
    }
    
    func testDefaultAccountState() throws {
        // given
        let sut = try XCTUnwrap(sut)
        let defaultAccount = AccountForDebit.stub(id: "3", defaultForPayments: true)
        let accounts: [AccountForDebit] = [
            .stub(id: "1", defaultForPayments: false),
            .stub(id: "2", defaultForPayments: false),
            defaultAccount,
            .stub(id: "4", defaultForPayments: false)
        ]
        
        // when
        let state = sut.map(accounts)
        
        // then
        XCTAssertEqual(state, .listContainsDefaultAccount(defaultAccount))
    }
    
    func testSingleNonDefaultAccountState() throws {
        // given
        let sut = try XCTUnwrap(sut)
        let onlyAccount = AccountForDebit.stub(id: "1", defaultForPayments: false)
        
        // when
        let state = sut.map([onlyAccount])
        
        // then
        XCTAssertEqual(state, .listContainsSingleNonDefaultAccount(onlyAccount))
    }
    
    func testMultipleNonDefaultAccountsState() throws {
        // given
        let sut = try XCTUnwrap(sut)
        let accounts: [AccountForDebit] = [
            .stub(id: "1", defaultForPayments: false),
            .stub(id: "2", defaultForPayments: false),
            .stub(id: "3", defaultForPayments: false),
            .stub(id: "4", defaultForPayments: false)
        ]
        
        // when
        let state = sut.map(accounts)
        
        // then
        XCTAssertEqual(state, .listContainsMultipleNonDefaultAccounts(accounts))
    }
}
