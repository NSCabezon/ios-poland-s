//
//  OnboardingPermissionOptionsTests.swift
//  SantanderTests
//
//  Created by Jose Camallonga González on 15/2/22.
//

import XCTest
@testable import Santander

class OnboardingPermissionOptionsTests: XCTestCase {
    func test_onboardingOptions_success() {
        let options = OnboardingPermissionOptions()
        XCTAssertEqual(options.getOptions(), [.notifications, .location])
    }
}
