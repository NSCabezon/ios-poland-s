//
//  PLLoginHelpersTests.swift
//  PLLogin_ExampleTests
//
//  Created by Marcos Álvarez Mesa on 15/6/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
@testable import PLLogin

class PLLoginTrustedDeviceHelpersTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testLength16Password() {

        // password lenght < 16
        XCTAssertEqual(PLLoginTrustedDeviceHelpers.length16Password("1234"), "1234123412341234")
        XCTAssertEqual(PLLoginTrustedDeviceHelpers.length16Password("348x!z"), "348x!z348x!z348x")

        // password length = 16
        XCTAssertEqual(PLLoginTrustedDeviceHelpers.length16Password("1234567890123456"), "1234567890123456")

        // password length > 16
        XCTAssertEqual(PLLoginTrustedDeviceHelpers.length16Password("1234567890123456789"), "1234567890123456")

        // password length = 0
        XCTAssertEqual(PLLoginTrustedDeviceHelpers.length16Password(""), nil)
    }

    func testStringMultipleOf16() {

        // string lenght < 16
        let string1 = PLLoginTrustedDeviceHelpers.stringMultipleOf16("Test")
        XCTAssertEqual(string1, "Test            ")
        XCTAssertEqual(string1.count, 16)

        // string lenght = 16
        let string2 = PLLoginTrustedDeviceHelpers.stringMultipleOf16("TestTestTestTest")
        XCTAssertEqual(string2, "TestTestTestTest")
        XCTAssertEqual(string2.count, 16)

        // string lenght = 15
        let string3 = PLLoginTrustedDeviceHelpers.stringMultipleOf16("TestTestTestTes")
        XCTAssertEqual(string3, "TestTestTestTes ")
        XCTAssertEqual(string3.count, 16)

        // string lenght = 17
        let string4 = PLLoginTrustedDeviceHelpers.stringMultipleOf16("TestTestTestTestT")
        XCTAssertEqual(string4, "TestTestTestTestT               ")
        XCTAssertEqual(string4.count, 32)

        // string lenght = 34
        let string5 = PLLoginTrustedDeviceHelpers.stringMultipleOf16("TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT")
        XCTAssertEqual(string5.count, 48)
    }
}
