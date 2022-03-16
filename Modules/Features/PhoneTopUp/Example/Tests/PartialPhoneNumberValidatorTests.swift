//
//  PartialPhoneNumberValidatorTests.swift
//  PhoneTopUp_Tests
//
//  Created by 188216 on 07/03/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import XCTest
@testable import PhoneTopUp

class PartialPhoneNumberValidatorTests: XCTestCase {
    
    let validator = PartialPhoneNumberValidator()
    let validPhoneNumbers = [
        "606887232",
        "606 338 384",
        "122 222 444",
        "222 334556",
        "000000000"
    ]
    
    let partiallyValidNumbers = [
        "",
        "1",
        "01",
        "1111",
        "606 342 23",
        "503",
        "0"
    ]
    
    let invalidNumber = [
        "606 883 5434",
        "606 733 o45",
        "abc",
        "232a45434",
        "2343242342342342354645"
    ]

    func testValidatingValidNumbers() throws {
        for validNumber in validPhoneNumbers {
            let validationResults = validator.validatePhoneNumberText(validNumber)
            switch validationResults {
            case .valid(let number):
                let numberWithoutWhitespace = validNumber.replace(" ", "")
                XCTAssert(number == numberWithoutWhitespace, "The number should be the same as the original number but without whitespace")
            default:
                XCTAssert(false, "Should correctly validate valid number: \(validNumber)")
            }
        }
    }
    
    func testValidatingPartiallyValidNumbers() throws {
        for partiallyValidNumber in partiallyValidNumbers {
            let validationResults = validator.validatePhoneNumberText(partiallyValidNumber)
            switch validationResults {
            case .partiallyValid(let number):
                let numberWithoutWhitespace = partiallyValidNumber.replace(" ", "")
                XCTAssert(number == numberWithoutWhitespace, "The number should be the same as the original number but without whitespace")
            default:
                XCTAssert(false, "Should correctly validate partially valid number \(partiallyValidNumber)")
            }
        }
    }

    func testValidatingInvalidNumbers() throws {
        for invalidNumber in invalidNumber {
            let validationResults = validator.validatePhoneNumberText(invalidNumber)
            switch validationResults {
            case .invalid:
                XCTAssert(true)
            default:
                XCTAssert(false, "Should correctly validate invalid number: \(invalidNumber)")
            }
        }
    }
}
