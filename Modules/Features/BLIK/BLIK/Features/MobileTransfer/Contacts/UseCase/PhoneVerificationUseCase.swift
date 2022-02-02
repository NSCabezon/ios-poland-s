import CoreFoundationLib
import Foundation
import SANPLLibrary

protocol PhoneVerificationProtocol: UseCase<PhoneVerificationUseCaseInput, PhoneVerificationUseCaseOkOutput, StringErrorOutput> {}

final class PhoneVerificationUseCase: UseCase<PhoneVerificationUseCaseInput, PhoneVerificationUseCaseOkOutput, StringErrorOutput> {
    
    private let managersProvider: PLManagersProviderProtocol
    private let formatter = MSISDNPhoneNumberFormatter()
    
    init(dependenciesResolver: DependenciesResolver) {
        self.managersProvider = dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
    }
    
    override func executeUseCase(requestValues: PhoneVerificationUseCaseInput) throws -> UseCaseResponse<PhoneVerificationUseCaseOkOutput, StringErrorOutput> {
        
        let phoneNumbers = formatNumbers(phoneNumbers: requestValues.phoneNumbers)
        let countryCodeAppenedNumbers = formatter.polishCountryCodeAppendedNumbers(formattedNumbers: phoneNumbers)
        let hashes = hashesMetadata(formattedNumbersMetadata: countryCodeAppenedNumbers)
        let result = try managersProvider
            .getBLIKManager()
            .phoneVerification(aliases: hashes.map{ $0.hash } )
        
        switch result {
        case .success(let numbers):
            let filteredNumbers = hashes.filter { numbers.aliases.contains($0.hash) }
            return .ok(PhoneVerificationUseCaseOkOutput(phoneNumbers: filteredNumbers ))
        case .failure(let error):
            return .error(.init(error.localizedDescription))
        }
    }
}

private extension PhoneVerificationUseCase {
    func formatNumbers(phoneNumbers: [String]) -> [FormattedNumberMetadata] {
        return phoneNumbers.compactMap { number -> FormattedNumberMetadata? in
            let formattedNumber = formatter.format(phoneNumber: number)
            if formattedNumber.isEmpty {
                return nil
            }
            return FormattedNumberMetadata(
                formattedNumber: formattedNumber,
                unformattedNumber: number
            )
        }
    }
    
    func hashesMetadata(formattedNumbersMetadata: [FormattedNumberMetadata]) -> [HashedNumberMetadata] {
        return formattedNumbersMetadata.map { metadata -> HashedNumberMetadata in
            let hash = metadata.formattedNumber.sha256()
            return HashedNumberMetadata(
                hash: hash,
                unformattedNumber: metadata.unformattedNumber
            )
        }
    }
}

extension PhoneVerificationUseCase: PhoneVerificationProtocol {}


struct PhoneVerificationUseCaseInput {
    let phoneNumbers: [String]
}

struct PhoneVerificationUseCaseOkOutput {
    let phoneNumbers: [HashedNumberMetadata]
}
