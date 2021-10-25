import Commons
import Foundation
import DomainCommon
import SANPLLibrary
import SANLegacyLibrary

protocol AliasTransactionRegisterAliasUseCaseProtocol: UseCase<RegisterBlikAliasInput, Void, StringErrorOutput> {}

final class AliasTransactionRegisterAliasUseCase: UseCase<RegisterBlikAliasInput, Void, StringErrorOutput> {
    private let dependenciesResolver: DependenciesResolver
    
    lazy private var managersProvider: PLManagersProviderProtocol = {
        return self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
    }()
    
    init(
        dependenciesResolver: DependenciesResolver
    ) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    override func executeUseCase(requestValues: RegisterBlikAliasInput) throws -> UseCaseResponse<Void, StringErrorOutput> {
        let parameters = RegisterBlikAliasParameters(
            aliasLabel: "", //TODO: Update after business decision https://godzilla.centrala.bzwbk:9998/browse/TAP-1898
            aliasValueType: "",
            alias: requestValues.alias,
            acquirerId: requestValues.acquirerId,
            merchantId: requestValues.merchantId,
            expirationDate: DateFormats.toString(date: Date().addMonth(months: 12), output: .YYYYMMDD_T_HHmmssSSS),
            aliasURL: "",
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

extension AliasTransactionRegisterAliasUseCase: AliasTransactionRegisterAliasUseCaseProtocol {}
