//
//  PLCardsOtherOperativesWebConfiguration.swift
//  Santander
//
//  Created by Julio Nieto Santiago on 14/10/21.
//

import Commons

public struct PLCardsOtherOperativesWebConfiguration: WebViewConfiguration {
    public var initialURL: String
    public var webToolbarTitleKey: String?
    public var pdfToolbarTitleKey: String?
    public var engine: WebViewConfigurationEngine
    public var pdfSource: PdfSource?
    public var isCachePdfEnabled: Bool
    public var isFullScreenEnabled: Bool?
    public var httpMethod: HTTPMethodType
    public var bodyParameters: [String: String]?
    public var reloadSessionOnClose: Bool

    public init(initialURL: String,
                bodyParameters: [String: String]?,
                closingURLs: [String],
                webToolbarTitleKey: String?,
                pdfToolbarTitleKey: String?,
                httpMethod: HTTPMethodType,
                reloadSessionOnClose: Bool = true) {
        self.initialURL = initialURL
        self.webToolbarTitleKey = webToolbarTitleKey
        self.pdfToolbarTitleKey = pdfToolbarTitleKey
        self.engine = .custom(engine: "uiwebview")
        self.isCachePdfEnabled = false
        self.httpMethod = httpMethod
        self.bodyParameters = bodyParameters
        self.reloadSessionOnClose = reloadSessionOnClose
    }
}
