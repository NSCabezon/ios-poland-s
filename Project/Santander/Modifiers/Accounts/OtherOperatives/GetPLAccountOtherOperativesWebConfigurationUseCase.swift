//
//  GetPLAccountOtherOperativesWebConfigurationUseCase.swift
//  Santander
//
//  Created by Julio Nieto Santiago on 29/9/21.
//

import Foundation
import Commons
import DomainCommon
import SANLegacyLibrary

class GetPLAccountOtherOperativesWebConfigurationUseCase: UseCase<GetPLAccountOtherOperativesWebConfigurationUseCaseInput, GetPLAccountOtherOperativesWebConfigurationUseCaseOkOutput, StringErrorOutput> {
    private let dependenciesResolver: DependenciesResolver
    private let provider: BSANManagersProvider
    
    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
        self.provider = self.dependenciesResolver.resolve(for: BSANManagersProvider.self)
    }
    
    override func executeUseCase(requestValues: GetPLAccountOtherOperativesWebConfigurationUseCaseInput) throws -> UseCaseResponse<GetPLAccountOtherOperativesWebConfigurationUseCaseOkOutput, StringErrorOutput> {

        let closingUrl = "www.bancosantander.com"
        var initialURL = requestValues.type.link ?? ""
        if let parameter = requestValues.type.parameter {
            let url = initialURL.replacingOccurrences(of: StringPlaceholder.Placeholder.number.rawValue, with: parameter)
            initialURL = url
        }
        let configuration = PLAccountOtherOperativesWebConfiguration(
            initialURL: initialURL,
            bodyParameters: nil,
            closingURLs: [closingUrl],
            webToolbarTitleKey: " ",
            pdfToolbarTitleKey: " ")
        return UseCaseResponse.ok(GetPLAccountOtherOperativesWebConfigurationUseCaseOkOutput(configuration: configuration))
    }
}

struct GetPLAccountOtherOperativesWebConfigurationUseCaseInput {
    let type: PLAccountOtherOperativesData
}

struct GetPLAccountOtherOperativesWebConfigurationUseCaseOkOutput {
    let configuration: WebViewConfiguration
}
