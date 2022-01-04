//
//  PLBeforeLoginUseCaseTest.swift
//  PLLogin_ExampleTests
//
//  Created by Mario Rosales Maillo on 29/11/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
import Commons
import SANPLLibrary
@testable import PLLogin

class PLBeforeLoginUseCaseTest: PLLoginServiceUseCaseTest {
    
    override func setUpWithError() throws {
        self.useLocalFiles = true
        try super.setUpWithError()
        self.setDependencies()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
    
    func testBeforeLoginUntrustedDevice() throws {
        do {
            self.managerProvider.getTrustedDeviceManager().deleteTrustedDeviceHeaders()
            let output = try self.executeUseCase()
            XCTAssertEqual(output.isTrustedDevice, false)
        } catch {
            XCTFail("testBeforeLoginUntrustedDevice: Failed to get the correct file")
        }
    }
    
    func testBeforeLoginTrustedDevice() throws {
        do {
            let headers = TrustedDeviceHeaders(parameters: "", time: "", appId: "test_app_id")
            self.managerProvider.getTrustedDeviceManager().storeTrustedDeviceHeaders(headers)
            let output = try self.executeUseCase()
            XCTAssertEqual(output.isTrustedDevice, true)
        } catch {
            XCTFail("testBeforeLoginTrustedDevice: Failed to get the correct file")
        }
    }
    
    func testBeforeLoginExpiredHeadersError() throws {
        do {
            let headers = TrustedDeviceHeaders(parameters: "", time: "", appId: "test_app_id")
            self.managerProvider.getTrustedDeviceManager().storeTrustedDeviceHeaders(headers)
            self.setTestFile("before-login-error") //this responds with an 422 error (UnprocessableEntity)
            let output = try self.executeUseCase()
            let header = self.managerProvider.getTrustedDeviceManager().getTrustedDeviceHeaders()
            XCTAssertEqual(output.isTrustedDevice, false)
            XCTAssertNil(header)
        } catch {
            XCTFail("testBeforeLoginExpiredHeadersError: Failed to get the correct file")
        }
    }
}

private extension PLBeforeLoginUseCaseTest {
    func setDependencies() {
        self.dependencies.register(for: PLBeforeLoginUseCase.self) { resolver in
            return PLBeforeLoginUseCase(dependenciesResolver: self.dependencies)
        }
    }
}

private extension PLBeforeLoginUseCaseTest {
    func executeUseCase() throws -> PLBeforeLoginUseCaseOutput {
        let beforeLoginUseCase = self.dependencies.resolve(for: PLBeforeLoginUseCase.self)
        let response = try beforeLoginUseCase.executeUseCase(requestValues: ())
        return try response.getOkResult()
    }
}
