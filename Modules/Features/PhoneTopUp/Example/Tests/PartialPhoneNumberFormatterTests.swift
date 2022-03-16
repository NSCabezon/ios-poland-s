//
//  PartialPhoneNumberFormatterTests.swift
//  PhoneTopUp_Tests
//
//  Created by 188216 on 07/03/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import XCTest
@testable import PhoneTopUp

class PartialPhoneNumberFormatterTests: XCTestCase {
    
    let formatter = PartialPhoneNumberFormatter()
    let numbers = [
        (raw: "", formatted: ""),
        (raw: "5", formatted: "5"),
        (raw: "23", formatted: "23"),
        (raw: "504", formatted: "504"),
        (raw: "1239", formatted: "123 9"),
        (raw: "12358", formatted: "123 58"),
        (raw: "123587", formatted: "123 587"),
        (raw: "1235876", formatted: "123 587 6"),
        (raw: "12358765", formatted: "123 587 65"),
        (raw: "123587653", formatted: "123 587 653"),
        (raw: "123 587 653", formatted: "123 587 653"),
        (raw: "12 12 22456", formatted: "121 222 456"),
    ]

    func testFormattingPhoneNumbers() throws {
        for numberPair in numbers {
            let formattedNumber = formatter.formatPhoneNumberText(numberPair.raw)
            XCTAssert(formattedNumber == numberPair.formatted, "Should correctly format \(numberPair.raw) to \(numberPair.formatted)")
        }
    }
}
