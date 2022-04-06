import Foundation
import CoreFoundationLib
import SANPLLibrary
import SANLegacyLibrary
import PLCommons

protocol GetVATAccountProtocol: UseCase<GetVATAccountUseCaseInput, GetVATAccountCaseOkOutput, StringErrorOutput> {}

final class GetVATAccountUseCase: UseCase<GetVATAccountUseCaseInput, GetVATAccountCaseOkOutput, StringErrorOutput> {
    private let managersProvider: PLManagersProviderProtocol
    private let mapper: VATAccountDetailsMapping
    
    init(dependenciesResolver: DependenciesResolver) {
        self.managersProvider = dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        self.mapper = dependenciesResolver.resolve()
    }
    
    override func executeUseCase(requestValues: GetVATAccountUseCaseInput) throws -> UseCaseResponse<GetVATAccountCaseOkOutput, StringErrorOutput> {
        
        let accountDetailsParameters = AccountDetailsParameters(includeDetails: false, includePermissions: false)
        let result = try managersProvider.getAccountsManager().getDetails(accountNumber: requestValues.accountNumber, parameters: accountDetailsParameters)
        
        switch result {
        case .success(let details):
            let vatAccountDetails = mapper.map(with: details)
            return .ok(GetVATAccountCaseOkOutput(vatAccountDetails: vatAccountDetails))
        case .failure(let error):
            return .error(.init(error.localizedDescription))
        }
    }
}

extension GetVATAccountUseCase: GetVATAccountProtocol {}

struct GetVATAccountUseCaseInput {
    let accountNumber: String
}

struct GetVATAccountCaseOkOutput {
    let vatAccountDetails: VATAccountDetails
}
