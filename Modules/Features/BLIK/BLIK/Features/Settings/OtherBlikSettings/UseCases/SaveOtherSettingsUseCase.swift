import Commons
import Foundation
import DomainCommon
import SANPLLibrary

protocol SaveOtherSettingsUseCaseProtocol: UseCase<SaveOtherSettingsUseCaseInput, Void, StringErrorOutput> {}

final class SaveOtherSettingsUseCase: UseCase<SaveOtherSettingsUseCaseInput, Void, StringErrorOutput> {
    private let dependenciesResolver: DependenciesResolver
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    override func executeUseCase(requestValues: SaveOtherSettingsUseCaseInput) throws -> UseCaseResponse<Void, StringErrorOutput> {
        let managersProvider: PLManagersProviderProtocol = dependenciesResolver.resolve(
            for: PLManagersProviderProtocol.self
        )
        let result = try managersProvider.getBLIKManager().setChequePin(
            request: SetChequeBlikPinParameters(
                chequePin: requestValues.chequePin
            )
        )
        switch result {
        case .success:
            return .ok()
        case .failure(let error):
            return .error(.init(error.localizedDescription))
        }
    }
}

extension SaveOtherSettingsUseCase: SaveOtherSettingsUseCaseProtocol {}

struct SaveOtherSettingsUseCaseInput {
    let chequePin: String
}
