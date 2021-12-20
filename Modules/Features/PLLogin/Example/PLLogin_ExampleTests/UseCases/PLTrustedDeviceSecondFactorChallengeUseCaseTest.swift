//
//  PLTrustedDeviceSecondFactorChallengeUseCaseTest.swift
//  PLLogin_ExampleTests
//
//  Created by Marcos Álvarez Mesa on 17/8/21.
//

import XCTest
import Commons
import CoreFoundationLib
@testable import PLLogin

class PLTrustedDeviceSecondFactorChallengeUseCaseTests: XCTestCase {

    private let dependencies = DependenciesDefault()

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    //Generation of second factor challenge with one token (without biometry activated)
    func testSecondFactorChallengeWithOneToken() throws {

        enum ExpectedResult {
            static let challenge = "32007101"
        }

        do {
            let tokens: [TrustedDeviceSoftwareToken] = [TrustedDeviceSoftwareToken(name: "",
                                                                                   key: "",
                                                                                   type: "",
                                                                                   state: "",
                                                                                   id: 152424,
                                                                                   timestamp: 1314411585)]
            let trustedDeviceConf = TrustedDeviceConfiguration()
            trustedDeviceConf.tokens = tokens
            trustedDeviceConf.ivrOutputCode = "9556"
            let trustedDevice = TrustedDeviceConfiguration.TrustedDevice(trustedDeviceId: 4679654,
                                                                         userId: 36167469,
                                                                         trustedDeviceState: "",
                                                                         trustedDeviceTimestamp: 1313188078,
                                                                         ivrInputCode: 9556)
            trustedDeviceConf.trustedDevice = trustedDevice

            let input = PLTrustedDeviceSecondFactorChallengeInput(userId: 36167469,
                                                                  configuration: trustedDeviceConf)
            let output = try self.executeUseCase(input: input)
            XCTAssertEqual(output.challenge, ExpectedResult.challenge)
        } catch {
            XCTFail("PLTrustedDeviceSecondFactorChallengeUseCaseTests.testSecondFactorChallenge failed")
        }
    }

    //Generation of second factor challenge with two tokens (WITH biometry activated)
    func testSecondFactorChallengeWithTwoTokens() throws {

        enum ExpectedResult {
            static let challenge = "38177135"
        }

        do {
            let tokens: [TrustedDeviceSoftwareToken] =
                [TrustedDeviceSoftwareToken(name: "",
                                            key: "",
                                            type: "",
                                            state: "",
                                            id: 152427,
                                            timestamp: 1320906670),
                 TrustedDeviceSoftwareToken(name: "",
                                            key: "",
                                            type: "",
                                            state: "",
                                            id: 152428,
                                            timestamp: 1320903722)]

            let trustedDeviceConf = TrustedDeviceConfiguration()
            trustedDeviceConf.tokens = tokens
            trustedDeviceConf.ivrOutputCode = "9556"
            let trustedDevice = TrustedDeviceConfiguration.TrustedDevice(trustedDeviceId: 4679668,
                                                                         userId: 36167469,
                                                                         trustedDeviceState: "",
                                                                         trustedDeviceTimestamp: 1320809298,
                                                                         ivrInputCode: 9556)
            trustedDeviceConf.trustedDevice = trustedDevice

            let input = PLTrustedDeviceSecondFactorChallengeInput(userId: 36167469,
                                                                  configuration: trustedDeviceConf)
            let output = try self.executeUseCase(input: input)
            XCTAssertEqual(output.challenge, ExpectedResult.challenge)
        } catch {
            XCTFail("PLTrustedDeviceSecondFactorChallengeUseCaseTests.testSecondFactorChallenge failed")
        }
    }
}

private extension PLTrustedDeviceSecondFactorChallengeUseCaseTests {
    func executeUseCase(input: PLTrustedDeviceSecondFactorChallengeInput) throws -> PLTrustedDeviceSecondFactorChallengeOutput {

        let useCase = PLTrustedDeviceSecondFactorChallengeUseCase()
        let response = try useCase.executeUseCase(requestValues: input)
        return try response.getOkResult()
    }
}
