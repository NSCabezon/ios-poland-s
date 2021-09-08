//
//  PLLoginChallengeSelectionUseCase.swift
//  PLLogin
//
//  Created by Marcos Álvarez Mesa on 2/9/21.
//

import Commons
import DomainCommon
import PLCommons
import SANPLLibrary

final class PLLoginChallengeSelectionUseCase: UseCase<PLLoginChallengeSelectionUseCaseInput, PLLoginChallengeSelectionUseCaseOkOutput, PLUseCaseErrorOutput<LoginErrorType>> {
    var dependenciesResolver: DependenciesResolver

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    public override func executeUseCase(requestValues: PLLoginChallengeSelectionUseCaseInput) throws -> UseCaseResponse<PLLoginChallengeSelectionUseCaseOkOutput, PLUseCaseErrorOutput<LoginErrorType>> {
        let challengeEntity = try self.getChallenge(with: requestValues.challenges, defaultChallenge: requestValues.defaultChallenge)
        return UseCaseResponse.ok(PLLoginChallengeSelectionUseCaseOkOutput(challengeEntity: challengeEntity))
    }
}

public struct PLLoginChallengeSelectionUseCaseInput {
    public let challenges: [ChallengeEntity]?
    public let defaultChallenge: ChallengeEntity
}

public struct PLLoginChallengeSelectionUseCaseOkOutput {
    let challengeEntity: ChallengeEntity
}

private extension PLLoginChallengeSelectionUseCase {

    func getChallenge(with challenges: [ChallengeEntity]?,
                      defaultChallenge: ChallengeEntity) throws -> ChallengeEntity {
        let challenge: ChallengeEntity
        switch defaultChallenge.authorizationType {
        case .softwareToken:
            if let smsChallenge = challenges?.first(where: { $0.authorizationType == .sms }) {
                challenge = ChallengeEntity(authorizationType: smsChallenge.authorizationType,
                                            value: smsChallenge.value)
            } else if let hardwareChallenge = challenges?.first(where: { $0.authorizationType == .tokenTime || $0.authorizationType == .tokenTimeCR }) {
                challenge = ChallengeEntity(authorizationType: hardwareChallenge.authorizationType,
                                            value: hardwareChallenge.value)
            } else {
                throw BSANException("We should have .sms, .tokenTime or .tokenTimeCR in challenges")
            }
        default:
            challenge = ChallengeEntity(authorizationType: defaultChallenge.authorizationType,
                                        value: defaultChallenge.value)
        }
        return challenge
    }
}
