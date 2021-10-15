import Commons
import Foundation
import DomainCommon
import SANPLLibrary

protocol SaveOtherSettingsUseCaseProtocol: UseCase<String, Void, StringErrorOutput> {}

final class SaveOtherSettingsUseCase: UseCase<String, Void, StringErrorOutput> {
    private let managersProvider: PLManagersProviderProtocol
    
    init(
        managersProvider: PLManagersProviderProtocol
    ) {
        self.managersProvider = managersProvider
    }
    
    override func executeUseCase(requestValues: String) throws -> UseCaseResponse<Void, StringErrorOutput> {
        let result = try managersProvider.getBLIKManager().setChequePin(request: SetChequeBlikPinParameters(chequePin: requestValues))
        switch result {
        case .success:
            return .ok()
        case .failure(let error):
            return .error(.init(error.localizedDescription))
        }
    }
}

extension SaveOtherSettingsUseCase: SaveOtherSettingsUseCaseProtocol {}
