import CoreFoundationLib
import Foundation
import CoreFoundationLib
import SANPLLibrary

protocol SaveChequePinUseCaseProtocol: UseCase<SaveChequePinUseCaseInput, Void, StringErrorOutput> {}

final class SaveChequePinUseCase: UseCase<SaveChequePinUseCaseInput, Void, StringErrorOutput> {
    private let dependenciesResolver: DependenciesResolver
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    override func executeUseCase(requestValues: SaveChequePinUseCaseInput) throws -> UseCaseResponse<Void, StringErrorOutput> {
        let managersProvider: PLManagersProviderProtocol = dependenciesResolver.resolve(
            for: PLManagersProviderProtocol.self
        )
        let result = try managersProvider.getBLIKManager().setChequePin(
            request: SetChequeBlikPinParameters(
                chequePin: requestValues.encryptedPin
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

extension SaveChequePinUseCase: SaveChequePinUseCaseProtocol {}

struct SaveChequePinUseCaseInput {
    let encryptedPin: String
}
