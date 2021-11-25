import Commons
import Foundation
import CoreFoundationLib
import SANPLLibrary
import SANLegacyLibrary

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
        let acquirerId: Int? = {
            guard let id = requestValues.acquirerId else {
                return nil
            }
            return Int(id)
        }()
        let parameters = RegisterBlikAliasParameters(
            aliasLabel: requestValues.aliasProposal.label,
            aliasValueType: "\(requestValues.aliasProposal.type.hashValue)",
            alias: requestValues.aliasProposal.alias,
            acquirerId: acquirerId,
            merchantId: requestValues.merchantId,
            expirationDate: DateFormats.toString(date: Date().addMonth(months: 12), output: .YYYYMMDD_T_HHmmssSSS),
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
