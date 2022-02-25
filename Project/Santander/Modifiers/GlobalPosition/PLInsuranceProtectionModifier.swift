//
//  PLInsuranceProtectionModifier.swift
//  Santander
//
//  Created by Ernesto Fernandez Calles on 14/2/22.
//

import GlobalPosition
import UI
import CoreFoundationLib
import PLCommons
import PLCommonOperatives
import SANLegacyLibrary
import SANPLLibrary

final class PLInsuranceProtectionModifier: InsuranceProtectionModifier {

    private let drawer: BaseMenuController

    public init(dependenciesResolver: DependenciesResolver, drawer: BaseMenuController) {
        self.drawer = drawer
        super.init(dependenciesResolver: dependenciesResolver)
    }
    
    override func didSelectInsuranceProtection(insurance: InsuranceProtectionEntity) {
        let repository = dependenciesResolver.resolve(for: PLAccountOtherOperativesInfoRepository.self)
        guard let list = repository.get()?.insuranceOptions,
              let insuranceWebConfiguration = getInsuranceProtectionWebConfiguration(list: list, identifier: "PROTECTION_INSURANCE" ),
              let url = insuranceWebConfiguration.link,
              let parameters = generateParameters(with: insurance),
              let httpMethod = insuranceWebConfiguration.httpMethod,
              let path = insurance.dto.detailsUrl  else {
                  self.showGenericErrorDialog(withDependenciesResolver: self.dependenciesResolver, action: nil, closeAction: nil)
                  return
              }
        let configuration = PLInsuranceProtectionWebConfiguration(initialURL: url.replacingOccurrences(of: "{$INSURANCE_URL}", with: path), bodyParameters: parameters, closingURLs: ["www.bancosantander.com", "app://close"], webToolbarTitleKey: nil, httpMethod: httpMethod, pdfToolbarTitleKey: nil, isFullScreenEnabled: insuranceWebConfiguration.isFullScreen)
        let linkHandler = PLWebviewCustomLinkHandler(configuration: configuration)
        let coordinator = self.dependenciesResolver.resolve(for: PLWebViewCoordinatorDelegate.self)
        coordinator.showWebView(handler: linkHandler)
    }
}

private extension PLInsuranceProtectionModifier {
    func getInsuranceProtectionWebConfiguration(list: [PLProductOperativesDTO], identifier: String) -> PLProductOperativesData? {
        var entity: PLProductOperativesData?
        for dto in list where dto.id == identifier {
            entity = PLProductOperativesData(identifier: dto.id, link: dto.url, isAvailable: dto.isAvailable, httpMethod: dto.getHTTPMethod, parameter: nil, isFullScreen: dto.isFullScreen)
        }
        return entity
    }

    func generateParameters(with insuranceEntity: InsuranceProtectionEntity) -> [String: String]? {
        guard let dataProvider = self.dependenciesResolver.resolve(for: BSANDataProviderProtocol.self) as? SANPLLibrary.BSANDataProvider, let authCredentials = try? dataProvider.getAuthCredentials(), let accessToken = authCredentials.accessTokenCredentials?.accessToken, let productId = insuranceEntity.dto.referenciaExterna else {
            return nil
        }
        var parameters = [String: String]()
        parameters["access_token"] = accessToken
        parameters["mlang"] = getLanguage()
        parameters["productId"] = productId
        return parameters
    }

    func getLanguage() -> String {
        return dependenciesResolver.resolve(forOptionalType: StringLoader.self)?.getCurrentLanguage().languageType.rawValue ?? "en"
    }
}

extension PLInsuranceProtectionModifier: GenericErrorDialogPresentationCapable {
    var associatedGenericErrorDialogView: UIViewController {
        return self.drawer.currentRootViewController as? UINavigationController ?? UIViewController()
    }
}

public struct PLInsuranceProtectionWebConfiguration: WebViewConfiguration {
    public var reloadSessionOnClose: Bool
    public var initialURL: String
    public var webToolbarTitleKey: String?
    public var pdfToolbarTitleKey: String?
    public var engine: WebViewConfigurationEngine
    public var pdfSource: PdfSource?
    public var isCachePdfEnabled: Bool
    public var isFullScreenEnabled: Bool?
    public var bodyParameters: [String: String]?
    public var httpMethod: HTTPMethodType
    public var closingURLs: [String]

    public init(initialURL: String,
                bodyParameters: [String: String]?,
                closingURLs: [String],
                webToolbarTitleKey: String?,
                httpMethod: HTTPMethodType,
                pdfToolbarTitleKey: String?,
                isFullScreenEnabled: Bool? = true) {
        self.initialURL = initialURL
        self.webToolbarTitleKey = webToolbarTitleKey
        self.pdfToolbarTitleKey = pdfToolbarTitleKey
        self.engine = .custom(engine: "uiwebview")
        self.isCachePdfEnabled = false
        self.reloadSessionOnClose = false
        self.bodyParameters = bodyParameters
        self.httpMethod = httpMethod
        self.isFullScreenEnabled = isFullScreenEnabled
        self.closingURLs = closingURLs
    }
}
