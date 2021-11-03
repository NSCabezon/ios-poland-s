//
//  AccountOtherOperativesWebConfiguration.swift
//  Santander
//
//  Created by Julio Nieto Santiago on 29/9/21.
//

import Commons

public struct PLAccountOtherOperativesWebConfiguration: WebViewConfiguration {
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

    public init(initialURL: String,
                bodyParameters: [String: String]?,
                closingURLs: [String],
                webToolbarTitleKey: String?,
                httpMethod: HTTPMethodType,
                pdfToolbarTitleKey: String?) {
        self.initialURL = initialURL
        self.webToolbarTitleKey = webToolbarTitleKey
        self.pdfToolbarTitleKey = pdfToolbarTitleKey
        self.engine = .custom(engine: "uiwebview")
        self.isCachePdfEnabled = false
        self.reloadSessionOnClose = false
        self.bodyParameters = bodyParameters
        self.httpMethod = httpMethod
    }
}
