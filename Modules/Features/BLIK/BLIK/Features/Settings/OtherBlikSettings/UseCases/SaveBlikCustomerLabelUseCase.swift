import CoreFoundationLib
import Foundation
import SANPLLibrary

protocol SaveBlikCustomerLabelUseCaseProtocol: UseCase<SaveBlikCustomerLabelInput, Void, StringErrorOutput> {}

final class SaveBlikCustomerLabelUseCase: UseCase<SaveBlikCustomerLabelInput, Void, StringErrorOutput> {
    private let dependenciesResolver: DependenciesResolver
    private var managersProvider: PLManagersProviderProtocol {
        dependenciesResolver.resolve()
    }
    
    private var requestMapper: RegisterAliasParametersMapping {
        dependenciesResolver.resolve()
    }

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    override func executeUseCase(requestValues: SaveBlikCustomerLabelInput) throws -> UseCaseResponse<Void, StringErrorOutput> {
        let parameters = SetPSPAliasLabelParameters(label: requestValues.chequePin)
        let result = try managersProvider.getBLIKManager().setPSPAliasLabel(parameters)
        switch result {
        case .success:
            return .ok()
        case .failure(let error):
            return .error(.init(error.localizedDescription))
        }
    }
}

struct SaveBlikCustomerLabelInput {
    let chequePin: String
}

extension SaveBlikCustomerLabelUseCase: SaveBlikCustomerLabelUseCaseProtocol {}
