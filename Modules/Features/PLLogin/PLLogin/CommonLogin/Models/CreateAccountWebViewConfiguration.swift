//
//  CreateAccountWebViewConfiguration.swift
//  PLLogin
//
//  Created by Mario Rosales Maillo on 8/10/21.
//

import Foundation
import Commons

struct CreateAccountWebViewConfiguration: WebViewConfiguration {
    let initialURL: String
    let httpMethod: HTTPMethodType = .get
    let bodyParameters: [String: String]? = [:]
    let closingURLs: [String] = ["app://close"]
    let webToolbarTitleKey: String? = localized("pl_onboarding_button_openAccount")
    let pdfToolbarTitleKey: String? = nil
    let pdfSource: PdfSource? = nil
    let engine: WebViewConfigurationEngine = .webkit
    let isCachePdfEnabled: Bool = false
    let isFullScreenEnabled: Bool? = false
    let showBackNavigationItem: Bool = false

    init(initialURL: String) {
        self.initialURL = initialURL
    }
}
