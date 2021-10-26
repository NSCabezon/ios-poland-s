import Foundation
import Commons
import DomainCommon
import Models
import SANPLLibrary

public protocol GetBasePLWebConfigurationUseCaseProtocol: UseCase<GetBasePLWebConfigurationUseCaseInput, GetBasePLWebConfigurationUseCaseOutput, StringErrorOutput> {}

public class GetBasePLWebConfigurationUseCase: UseCase<GetBasePLWebConfigurationUseCaseInput, GetBasePLWebConfigurationUseCaseOutput, StringErrorOutput> {
    private let dependenciesResolver: DependenciesResolver
    
    private lazy var plManagersProvider = dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
    
    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    public override func executeUseCase(requestValues: GetBasePLWebConfigurationUseCaseInput) throws -> UseCaseResponse<GetBasePLWebConfigurationUseCaseOutput, StringErrorOutput> {
        let loginManager = plManagersProvider.getLoginManager()
        
        guard let authCredentials = try? loginManager.getAuthCredentials() else {
            return .error(.init(GetYourCasesWebConfigurationError.missingAuthCredentials.rawValue))
        }
        guard let login: String = authCredentials.login else {
            return .error(.init(GetYourCasesWebConfigurationError.missingLogin.rawValue))
        }
        guard let accessToken: String = authCredentials.accessTokenCredentials?.accessToken else {
            return .error(.init(GetYourCasesWebConfigurationError.missingAccessToken.rawValue))
        }
        let language: String = getCurrentLanguage() ?? LanguageType.polish.rawValue
        
        let bodyParameters: [String: String] = [
            "clientId": login,
            "access_token": accessToken,
            "oneApp": "true",
            "mlang": language
        ]
        
        let configuration = BasePLWebConfiguration(
            initialURL: requestValues.initialURL,
            bodyParameters: bodyParameters,
            closingURLs: ["app://close"],
            webToolbarTitleKey: requestValues.webToolbarTitleKey,
            pdfToolbarTitleKey: requestValues.pdfToolbarTitleKey,
            isFullScreenEnabled: requestValues.isFullScreenEnabled
        )
        return .ok(GetBasePLWebConfigurationUseCaseOutput(configuration: configuration))
    }
    
    private func getCurrentLanguage() -> String? {
        return dependenciesResolver.resolve(forOptionalType: StringLoader.self)?.getCurrentLanguage().languageType.rawValue
    }
}

extension GetBasePLWebConfigurationUseCase: GetBasePLWebConfigurationUseCaseProtocol {}

public struct GetBasePLWebConfigurationUseCaseInput {
    let initialURL: String
    let isFullScreenEnabled: Bool
    let webToolbarTitleKey: String
    let pdfToolbarTitleKey: String
    
    public init(
        initialURL: String,
        isFullScreenEnabled: Bool = true,
        webToolbarTitleKey: String = " ",
        pdfToolbarTitleKey: String = " "
    ) {
        self.initialURL = initialURL
        self.isFullScreenEnabled = isFullScreenEnabled
        self.webToolbarTitleKey = webToolbarTitleKey
        self.pdfToolbarTitleKey = pdfToolbarTitleKey
    }
}

public struct GetBasePLWebConfigurationUseCaseOutput {
    public let configuration: WebViewConfiguration
}

public enum GetYourCasesWebConfigurationError: String {
    case missingAuthCredentials
    case missingAccessToken
    case missingLogin
}