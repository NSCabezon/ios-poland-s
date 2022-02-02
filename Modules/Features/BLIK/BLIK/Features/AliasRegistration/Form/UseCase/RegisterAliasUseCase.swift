import CoreFoundationLib
import Foundation
import SANPLLibrary
import SANLegacyLibrary
import PLCommons

protocol RegisterAliasUseCaseProtocol: UseCase<RegisterAliasInput, Void, StringErrorOutput> {}

final class RegisterAliasUseCase: UseCase<RegisterAliasInput, Void, StringErrorOutput> {
    private let dependenciesResolver: DependenciesResolver
    
    lazy private var managersProvider: PLManagersProviderProtocol = {
        return self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
    }()
    
    init(
        dependenciesResolver: DependenciesResolver
    ) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    override func executeUseCase(requestValues: RegisterAliasInput) throws -> UseCaseResponse<Void, StringErrorOutput> {
        let aliasType = requestValues.aliasProposal.type
        let parameters = RegisterBlikAliasParameters(
            aliasLabel: requestValues.aliasProposal.label,
            aliasValueType: aliasType.rawValue,
            alias: requestValues.aliasProposal.alias,
            acquirerId: aliasType == .cookie ? nil : requestValues.acquirerId,
            merchantId: aliasType == .cookie ? nil : requestValues.merchantId,
            expirationDate: Date().addMonth(months: 12).toString(format: PLTimeFormat.YYYYMMDD_HHmmssSSS.rawValue),
            aliasURL: nil,
            platform: "iOS",
            registerInPSP: true
        )
        
        let result = try managersProvider.getBLIKManager().registerAlias(parameters)
        switch result {
        case .success:
            return .ok()
        case .failure(let error):
            return .error(.init(error.localizedDescription))
        }
    }
}

extension RegisterAliasUseCase: RegisterAliasUseCaseProtocol {}
