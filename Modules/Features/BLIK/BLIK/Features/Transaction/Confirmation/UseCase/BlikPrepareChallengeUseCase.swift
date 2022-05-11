//
//  BlikPrepareChallengeUseCase.swift
//  BLIK
//
//  Created by 187830 on 26/04/2022.
//


import CoreFoundationLib
import SANPLLibrary
import PLCommons
import CoreDomain

enum BlikPrepareChallengeErrorResult: String {
    case generalErrorMessages
    case userError = "userId not exists"
    case challengeError = "challenge not exists"
}

protocol BlikPrepareChallengeUseCaseProtocol: UseCase<BlikPrepareChallengeUseCaseInput, BlikPrepareChallengeUseCaseOutput, StringErrorOutput> {}

final class BlikPrepareChallengeUseCase: UseCase<BlikPrepareChallengeUseCaseInput, BlikPrepareChallengeUseCaseOutput, StringErrorOutput> {
    private let managersProvider: PLManagersProviderProtocol
    private let transferRepository: PLTransfersRepository
    
    init(dependenciesResolver: DependenciesResolver) {
        self.managersProvider = dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        self.transferRepository = dependenciesResolver.resolve(for: PLTransfersRepository.self)
    }
    
    override func executeUseCase(requestValues: BlikPrepareChallengeUseCaseInput) throws -> UseCaseResponse<BlikPrepareChallengeUseCaseOutput, StringErrorOutput> {
        
        let result = try managersProvider
            .getBLIKManager()
            .getChallenge(
                BlikChallengeParameters(
                    merchantId: requestValues.model.transactionRawValue.merchant?.merchantId ?? "",
                    time: requestValues.model.transactionRawValue.time,
                    amount: requestValues.model.transactionRawValue.amount.amount
                )
            )
        switch result {
        case .success(let challenge):
            guard let challenge = challenge.challengeRepresentable else {
                return .error(.init(BlikPrepareChallengeErrorResult.challengeError.rawValue))
            }
            return .ok(BlikPrepareChallengeUseCaseOutput(challenge: challenge))
        case .failure(let error):
            let blikError = BlikError(with: error.getErrorBody())
            guard let blikError = blikError,
                  blikError.errorCode1 == .customerTypeDisabled else {
                return .error(.init(error.localizedDescription))
            }
            return .error(.init(blikError.errorKey + "." + "\(blikError.errorCode2.rawValue)"))
        }
    }
}

extension BlikPrepareChallengeUseCase: BlikPrepareChallengeUseCaseProtocol {}

struct BlikPrepareChallengeUseCaseInput {
    let model: Transaction
}

struct BlikPrepareChallengeUseCaseOutput {
    let challenge: String
}
