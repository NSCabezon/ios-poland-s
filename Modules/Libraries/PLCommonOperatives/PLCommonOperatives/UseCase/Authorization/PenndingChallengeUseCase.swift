import CoreFoundationLib
import SANPLLibrary
import PLCommons
import CoreDomain

public enum PenndingChallengeErrorResult: String {
    case generalErrorMessages
}

public protocol PenndingChallengeUseCaseProtocol: UseCase<Void, PenndingChallengeUseCaseOutput, StringErrorOutput> {}

public final class PenndingChallengeUseCase: UseCase<Void, PenndingChallengeUseCaseOutput, StringErrorOutput> {
    private let managersProvider: PLManagersProviderProtocol
    
    public init(dependenciesResolver: DependenciesResolver) {
        self.managersProvider = dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
    }
    
    public override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<PenndingChallengeUseCaseOutput, StringErrorOutput> {
        let result = try managersProvider.getAuthorizationProcessorManager().getPendingChallenge()
        switch result {
        case .success(let pennding):
            return .ok(PenndingChallengeUseCaseOutput(penndingChallenge: pennding))
        case .failure(_):
            return .error(.init(PenndingChallengeErrorResult.generalErrorMessages.rawValue))
        }
    }
}

extension PenndingChallengeUseCase: PenndingChallengeUseCaseProtocol {}

public struct PenndingChallengeUseCaseOutput {
    public let penndingChallenge: ChallengeRepresentable
    
    public init(penndingChallenge: ChallengeRepresentable) {
        self.penndingChallenge = penndingChallenge
    }
}
