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
        if let detailsUrl = insurance.dto.detailsUrl, let url = URL(string: detailsUrl), let parameters = generateParameters(with: insurance) {
            let configuration = PLInsuranceProtectionWebConfiguration(initialURL: url.absoluteString, bodyParameters: parameters, closingURLs: [], webToolbarTitleKey: nil, httpMethod: .post, pdfToolbarTitleKey: nil, isFullScreenEnabled: false)
            let linkHandler = PLWebviewCustomLinkHandler(configuration: configuration)
            let coordinator = self.dependenciesResolver.resolve(for: PLWebViewCoordinatorDelegate.self)
            coordinator.showWebView(handler: linkHandler)
        } else {
            self.showGenericErrorDialog(withDependenciesResolver: self.dependenciesResolver, action: nil, closeAction: nil)
        }
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

    private func getLanguage() -> String {
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
