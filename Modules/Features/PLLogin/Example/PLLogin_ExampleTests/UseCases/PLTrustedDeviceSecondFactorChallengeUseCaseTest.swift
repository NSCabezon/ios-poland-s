//
//  PLTrustedDeviceSecondFactorChallengeUseCaseTest.swift
//  PLLogin_ExampleTests
//
//  Created by Marcos Álvarez Mesa on 17/8/21.
//

import XCTest
import Commons
import DomainCommon
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
            let tokens = [PLTrustedDeviceSecondFactorChallengeInput.PLTrustedDeviceSecondFactorChallengeToken(id: 152424,
                                                                                                              timestamp: 1314411585)]
            let input = PLTrustedDeviceSecondFactorChallengeInput(ivrCode: 9556,
                                                                  trustedDeviceId: 4679654,
                                                                  deviceTimestamp: 1313188078,
                                                                  userId: 36167469,
                                                                  tokens: tokens)
            let useCase = PLTrustedDeviceSecondFactorChallengeUseCase()
            let response = try useCase.executeUseCase(requestValues: input)
            let output = try? response.getOkResult()
            XCTAssertEqual(output?.challenge, ExpectedResult.challenge)
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
            let tokens = [PLTrustedDeviceSecondFactorChallengeInput.PLTrustedDeviceSecondFactorChallengeToken(id: 152427,
                                                                                                              timestamp: 1320906670),
                          PLTrustedDeviceSecondFactorChallengeInput.PLTrustedDeviceSecondFactorChallengeToken(id: 152428,
                                                                                                              timestamp: 1320903722)]
            let input = PLTrustedDeviceSecondFactorChallengeInput(ivrCode: 9556,
                                                                  trustedDeviceId: 4679668,
                                                                  deviceTimestamp: 1320809298,
                                                                  userId: 36167469,
                                                                  tokens: tokens)
            let useCase = PLTrustedDeviceSecondFactorChallengeUseCase()
            let response = try useCase.executeUseCase(requestValues: input)
            let output = try? response.getOkResult()
            XCTAssertEqual(output?.challenge, ExpectedResult.challenge)
        } catch {
            XCTFail("PLTrustedDeviceSecondFactorChallengeUseCaseTests.testSecondFactorChallenge failed")
        }
    }
}

