//
//  PLLoginChallengeSelectionUseCaseTest.swift
//  PLLogin_ExampleTests
//
//  Created by Marcos Álvarez Mesa on 2/9/21.
//

import XCTest
import Commons
import DomainCommon
@testable import PLLogin

class PLLoginChallengeSelectionUseCaseTests: XCTestCase {

    private let dependencies = DependenciesDefault()

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testDefaultChallengeSMS() throws {

        do {
            let defaultChallenge = ChallengeEntity(authorizationType: .sms, value: "54583329")

            let challenges: [ChallengeEntity]? = nil

            let output = try self.executeUseCase(challenges: challenges, defaultChallenge: defaultChallenge)
            XCTAssertEqual(output.challengeEntity, defaultChallenge)
        } catch {
            XCTFail("Failed to get the correct challenge")
        }
    }

    func testDefaultChallengeWithHardwareToken() throws {

        do {
            let defaultChallenge = ChallengeEntity(authorizationType: .tokenTime, value: "54583329")

            let challenges: [ChallengeEntity]? = nil

            let output = try self.executeUseCase(challenges: challenges, defaultChallenge: defaultChallenge)
            XCTAssertEqual(output.challengeEntity, defaultChallenge)
        } catch {
            XCTFail("Failed to get the correct challenge")
        }
    }

    func testChallengeWithSoftTokenAndSMS() throws {
        do {
            let defaultChallenge = ChallengeEntity(authorizationType: .softwareToken, value: "54583329")

            let challenges = [ChallengeEntity(authorizationType: .sms, value: "54583329"),
                              ChallengeEntity(authorizationType: .softwareToken, value: "54583329")]

            let output = try self.executeUseCase(challenges: challenges, defaultChallenge: defaultChallenge)
            XCTAssertEqual(output.challengeEntity, challenges[0])
        } catch {
            XCTFail("Failed to get the correct challenge")
        }
    }

    func testChallengeWithSoftTokenAndTokenTime() throws {
        do {
            let defaultChallenge = ChallengeEntity(authorizationType: .softwareToken, value: "54583329")
            let challenges = [ChallengeEntity(authorizationType: .tokenTime, value: "54583329"),
                              ChallengeEntity(authorizationType: .softwareToken, value: "54583329")]
            let output = try self.executeUseCase(challenges: challenges, defaultChallenge: defaultChallenge)
            XCTAssertEqual(output.challengeEntity, challenges[0])
        } catch {
            XCTFail("Failed to get the correct challenge")
        }
    }

    func testChallengeWithSoftTokenAndTokenTimeCR() throws {
        do {
            let defaultChallenge = ChallengeEntity(authorizationType: .softwareToken, value: "54583329")
            let challenges = [ChallengeEntity(authorizationType: .tokenTimeCR, value: "54583329"),
                              ChallengeEntity(authorizationType: .softwareToken, value: "54583329")]

            let useCase = PLLoginChallengeSelectionUseCase(dependenciesResolver: dependencies)
            let input = PLLoginChallengeSelectionUseCaseInput(challenges: challenges,
                                                              defaultChallenge: defaultChallenge)
            let response = try useCase.executeUseCase(requestValues: input)
            XCTAssertEqual(try response.getOkResult().challengeEntity, challenges[0])
        } catch {
            XCTFail("Failed to get the correct challenge")
        }
    }

    func testChallengeWithSoftTokenAndError() throws {
        do {
            let defaultChallenge = ChallengeEntity(authorizationType: .softwareToken, value: "54583329")
            let challenges = [ChallengeEntity(authorizationType: .softwareToken, value: "54583329")]

            let _ = try self.executeUseCase(challenges: challenges, defaultChallenge: defaultChallenge)
            XCTAssertThrowsError("It should be throwing an error")
        } catch {
            XCTAssertTrue(true)
        }
    }

    func testChallengeWithSoftTokenWithEmptyChallenges() throws {
        do {
            let defaultChallenge = ChallengeEntity(authorizationType: .softwareToken, value: "54583329")
            let challenges: [ChallengeEntity]? = nil

            let _ = try self.executeUseCase(challenges: challenges, defaultChallenge: defaultChallenge)

            XCTAssertThrowsError("It should be throwing an error")
        } catch {
            XCTAssertTrue(true)
        }
    }
}

private extension PLLoginChallengeSelectionUseCaseTests {
    func executeUseCase(challenges: [ChallengeEntity]?, defaultChallenge: ChallengeEntity) throws -> PLLoginChallengeSelectionUseCaseOkOutput {

        let useCase = PLLoginChallengeSelectionUseCase(dependenciesResolver: self.dependencies)
        let input = PLLoginChallengeSelectionUseCaseInput(challenges: challenges,
                                                          defaultChallenge: defaultChallenge)
        let response = try useCase.executeUseCase(requestValues: input)
        return try response.getOkResult()
    }
}

extension ChallengeEntity: Equatable {
    public static func == (lhs: ChallengeEntity, rhs: ChallengeEntity) -> Bool {
        return lhs.authorizationType == rhs.authorizationType && lhs.value == rhs.value
    }
}
