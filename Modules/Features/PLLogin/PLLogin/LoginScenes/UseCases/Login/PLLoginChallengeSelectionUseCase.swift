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
        switch defaultChallenge.authorizationType {
        case .softwareToken:
            guard let firstChallenge = challenges?.first,
                  (firstChallenge.authorizationType == .sms || firstChallenge.authorizationType == .tokenTime || firstChallenge.authorizationType == .tokenTimeCR) else {
                throw BSANException("We should have .sms, .tokenTime or .tokenTimeCR in challenges")
            }
            return firstChallenge
        default:
            return defaultChallenge
        }
    }
}
