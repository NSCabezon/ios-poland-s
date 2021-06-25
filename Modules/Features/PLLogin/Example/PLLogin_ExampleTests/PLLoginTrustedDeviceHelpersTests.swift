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
}
