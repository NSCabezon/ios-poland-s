//
//  PLAddToApplePayConfirmationUseCase.swift
//  Santander
//
//  Created by 185998 on 18/02/2022.
//

import Cards
import SANLegacyLibrary
import CoreFoundationLib
import RetailLegacy
import PLLegacyAdapter
import SANPLLibrary

class PLAddToApplePayConfirmationUseCase: UseCase<PLAddToApplePayConfirmationUseCaseInput,
                                          PLAddToApplePayConfirmationUseCaseOkOutput,
                                          StringErrorOutput> {

    let bsanManagersProvider: BSANManagersProvider
    let dependenciesResolver: DependenciesResolver

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
        self.bsanManagersProvider = dependenciesResolver.resolve(for: BSANManagersProvider.self)
    }

    override func executeUseCase(requestValues: PLAddToApplePayConfirmationUseCaseInput) throws -> UseCaseResponse<PLAddToApplePayConfirmationUseCaseOkOutput, StringErrorOutput> {
        
        let managerProvider: PLManagersProviderProtocol = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        let response = try managerProvider.getCardsManager().confirmApplePay(virtualPan: requestValues.virtualPan,
                                                                             publicCertificates: requestValues.publicCertificates,
                                                                             nonce: requestValues.nonce,
                                                                             nonceSignature: requestValues.nonceSignature)

        switch response {
        case .success(let applePayConfirmation):
            return .ok(PLAddToApplePayConfirmationUseCaseOkOutput( tav: applePayConfirmation.tav,
                                                                   encryptedPassData: applePayConfirmation.encryptedPassData,
                                                                   ephemeralPublicKey: applePayConfirmation.ephemeralPublicKey)
            )
        case .failure(let error):
            return .error(StringErrorOutput(error.errorDescription))
        }
    }
}

struct PLAddToApplePayConfirmationUseCaseInput {
    let virtualPan: String
    let publicCertificates: [Data]
    let nonce: Data
    let nonceSignature: Data
}

struct PLAddToApplePayConfirmationUseCaseOkOutput: Codable {
    let tav: String
    let encryptedPassData: String
    let ephemeralPublicKey: String
}
