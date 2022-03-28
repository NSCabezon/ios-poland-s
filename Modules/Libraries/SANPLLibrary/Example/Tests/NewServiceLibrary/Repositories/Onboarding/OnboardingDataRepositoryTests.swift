//
//  OnboardingDataRepositoryTests.swift
//  SANPLLibrary_Tests
//
//  Created by Jose Camallonga on 15/2/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import XCTest
import OpenCombine
import UnitTestCommons
@testable import SANPLLibrary

class OnboardingDataRepositoryTests: Tests {
    func test_onboardingInfo_success() throws {
        bsanDataProvider.storeAuthCredentials(authCredentials)
        let repository = OnboardingDataRepository(customerManager: PLCustomerManagerMock(), bsanDataProvider: bsanDataProvider)
        let publisher = repository.getOnboardingInfo()
        let info = try publisher.sinkAwait()
        XCTAssertEqual(info.id, "1234")
        XCTAssertEqual(info.name, "Joe")
    }
}

private extension OnboardingDataRepositoryTests {
    var authCredentials: AuthCredentials {
        return AuthCredentials(login: nil,
                               userId: 1234,
                               userCif: nil,
                               companyContext: nil,
                               accessTokenCredentials: nil,
                               trustedDeviceTokenCredentials: nil)
    }
}
