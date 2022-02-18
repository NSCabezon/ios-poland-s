//
//  TaxAccountTypeRecognizerTests.swift
//  TaxTransfer_Tests
//
//  Created by 185167 on 14/02/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import XCTest
@testable import TaxTransfer
@testable import PLUI
@testable import PLCommons

class TaxAccountTypeRecognizerTests: XCTestCase {
    private var sut: TaxAccountTypeRecognizer?
    
    override func setUp() {
        super.setUp()
        sut = TaxAccountTypeRecognizer()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testIrpAccountNumberTypeWithPesel() throws {
        // given
        let sut = try XCTUnwrap(sut)
        let accountNumber = "22101000712221123456789012"
        
        // when
        let accountType = try sut.recognizeType(of: accountNumber)
        
        // then
        XCTAssertEqual(accountType, TaxAccountType.IRP)
    }
    
    func testIrpAccountNumberTypeWithNip() throws {
        // given
        let sut = try XCTUnwrap(sut)
        let accountNumber = "22101000712222123456789012"
        
        // when
        let accountType = try sut.recognizeType(of: accountNumber)
        
        // then
        XCTAssertEqual(accountType, TaxAccountType.IRP)
    }
    
    func testIrpAccountNumberTypeWithOtherIdentifier() throws {
        // given
        let sut = try XCTUnwrap(sut)
        let accountNumber = "22101000712223123456789012"
        
        // when
        let accountType = try sut.recognizeType(of: accountNumber)
        
        // then
        XCTAssertEqual(accountType, TaxAccountType.IRP)
    }
    
    func testUSAccountNumberType() throws {
        // given
        let sut = try XCTUnwrap(sut)
        let accountNumber = "22333000712222123456789012"
        
        // when
        let accountType = try sut.recognizeType(of: accountNumber)
        
        // then
        XCTAssertEqual(accountType, TaxAccountType.US)
    }
    
    func testIllegalAccountNumberLength() throws {
        // given
        let sut = try XCTUnwrap(sut)
        let accountNumber = "123"
        
        // when
        XCTAssertThrowsError(
            try sut.recognizeType(of: accountNumber),
            "Should return invalid account number length error"
        ) { error in
            guard let recognizerError = error as? TaxAccountTypeRecognizer.Error else {
                XCTFail("Invalid error type")
                return
            }
            
            // then
            XCTAssertEqual(recognizerError, TaxAccountTypeRecognizer.Error.invalidAccountLength)
        }
    }
    
    func testIllegalAccountNumberCharacters() throws {
        // given
        let sut = try XCTUnwrap(sut)
        let accountNumber = "%&(*(^*(&%*&*(&%$*^%^awhq7"
        
        // when
        XCTAssertThrowsError(
            try sut.recognizeType(of: accountNumber),
            "Should return invalid account number illegal characters error"
        ) { error in
            guard let recognizerError = error as? TaxAccountTypeRecognizer.Error else {
                XCTFail("Invalid error type")
                return
            }
            
            // then
            XCTAssertEqual(recognizerError, TaxAccountTypeRecognizer.Error.illegalCharacters)
        }
    }
    
    func testAccountNumberSimilarToIrpTypeButWithIncorrectIdentifierType() throws {
        // given
        let sut = try XCTUnwrap(sut)
        let accountNumber = "22101000712229123456789012"
        
        // when
        let accountType = try sut.recognizeType(of: accountNumber)
        
        // then
        XCTAssertEqual(accountType, TaxAccountType.US)
    }
}
