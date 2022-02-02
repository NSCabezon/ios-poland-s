
import CoreFoundationLib
import Foundation
import SANPLLibrary

enum GetP2pAliasErrorResult: String {
    case aliasNotExsist
    case genericError
}

protocol P2pAliasProtocol: UseCase<P2pAliasUseCaseInput, P2pAliasUseCaseOutput, StringErrorOutput> {}

final class P2pAliasUseCase: UseCase<P2pAliasUseCaseInput, P2pAliasUseCaseOutput, StringErrorOutput> {
    
    private let managersProvider: PLManagersProviderProtocol
    private let formatter = MSISDNPhoneNumberFormatter()
    
    init(dependenciesResolver: DependenciesResolver) {
        self.managersProvider = dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
    }
    
    override func executeUseCase(requestValues: P2pAliasUseCaseInput) throws -> UseCaseResponse<P2pAliasUseCaseOutput, StringErrorOutput> {
        let phoneNumber = formatNumber(phoneNumber: requestValues.msisdn)
        let countryCodeAppenedNumber = formatter.polishCountryCodeAppendedNumber(formattedNumber: phoneNumber)
        
        let result = try managersProvider
            .getBLIKManager()
            .p2pAlias(msisdn: countryCodeAppenedNumber?.formattedNumber ?? "")
        
        switch result {
        case .success(let response):
            return .ok(.init(dstAccNo: response.dstAccNo,
                             isDstAccInternal: response.isDstAccInternal))
            
        case .failure(let error):
            let blikError = BlikError(with: error.getErrorBody())
            let p2pAliasNotExistStatus = error.getErrorCode() == 510 &&
                blikError?.errorCode1 == .customerTypeDisabled &&
                blikError?.errorCode2 == .p2pAliasNotExsist
            let errorStatus: GetP2pAliasErrorResult = p2pAliasNotExistStatus ? .aliasNotExsist : .genericError
            return .error(.init(errorStatus.rawValue))
        }
    }
    
}

private extension P2pAliasUseCase {
    func formatNumber(phoneNumber: String) -> FormattedNumberMetadata {
        let formattedNumber = formatter.format(phoneNumber: phoneNumber)
        return FormattedNumberMetadata(formattedNumber: formattedNumber,
                                       unformattedNumber: phoneNumber)
    }
}

extension P2pAliasUseCase: P2pAliasProtocol {}


struct P2pAliasUseCaseInput {
    let msisdn: String
}

struct P2pAliasUseCaseOutput {
    let dstAccNo: String
    let isDstAccInternal: Bool
}
