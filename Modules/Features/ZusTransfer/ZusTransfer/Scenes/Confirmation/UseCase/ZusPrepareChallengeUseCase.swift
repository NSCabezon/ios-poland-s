import CoreFoundationLib
import SANPLLibrary
import PLCommons
import CoreDomain

enum ZusPrepareChallengeErrorResult: String {
    case generalErrorMessages
    case userError = "userId not exists"
    case challengeError = "challenge not exists"
}

protocol ZusPrepareChallengeUseCaseProtocol: UseCase<ZusPrepareChallengeUseCaseInput, ZusPrepareChallengeUseCaseOutput, StringErrorOutput> {}

final class ZusPrepareChallengeUseCase: UseCase<ZusPrepareChallengeUseCaseInput, ZusPrepareChallengeUseCaseOutput, StringErrorOutput> {
    private let managersProvider: PLManagersProviderProtocol
    private let zusTransferSendMoneyInputMapper: ZusTransferSendMoneyInputMapping
    private let transferRepository: PLTransfersRepository
    
    init(dependenciesResolver: DependenciesResolver) {
        self.managersProvider = dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        self.zusTransferSendMoneyInputMapper = dependenciesResolver.resolve(for: ZusTransferSendMoneyInputMapping.self)
        self.transferRepository = dependenciesResolver.resolve(for: PLTransfersRepository.self)
    }
    
    override func executeUseCase(requestValues: ZusPrepareChallengeUseCaseInput) throws -> UseCaseResponse<ZusPrepareChallengeUseCaseOutput, StringErrorOutput> {
        guard let userId = try? managersProvider.getLoginManager().getAuthCredentials().userId else {
            return .error(.init(ZusPrepareChallengeErrorResult.userError.rawValue))
        }
        let sendMoneyConfirmationInput = zusTransferSendMoneyInputMapper.map(with: requestValues.model, userId: userId)
        
        let result = try transferRepository.getChallenge(parameters: sendMoneyConfirmationInput)
        switch result {
        case .success(let challenge):
            guard let challenge = challenge.challengeRepresentable else {
                return .error(.init(ZusPrepareChallengeErrorResult.challengeError.rawValue))
            }
            return .ok(ZusPrepareChallengeUseCaseOutput(challenge: challenge))
        case .failure(let error):
            return prepareErrorMessages(with: error)
        }
    }
    
    private func prepareErrorMessages(with error: NetworkProviderError) -> UseCaseResponse<ZusPrepareChallengeUseCaseOutput, StringErrorOutput> {
        switch error {
        case .noConnection:
            return .error(.init(AcceptZusTransactionErrorResult.noConnection.rawValue))
        default:
            let zusTransferError = ZusTransferError(with: error.getErrorBody())
            return .error(.init(zusTransferError?.errorResult.rawValue))
        }
    }
}

extension ZusPrepareChallengeUseCase: ZusPrepareChallengeUseCaseProtocol {}

struct ZusPrepareChallengeUseCaseInput {
    let model: ZusTransferModel
}

struct ZusPrepareChallengeUseCaseOutput {
    let challenge: String
}
