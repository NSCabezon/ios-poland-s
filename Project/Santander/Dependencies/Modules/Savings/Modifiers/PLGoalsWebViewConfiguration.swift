//
//  PLGoalsWebViewConfiguration.swift
//  Santander
//
//  Created by Mario Rosales Maillo on 26/4/22.
//

import Foundation
import CoreFoundationLib

struct PLGoalsWebViewConfiguration: WebViewConfiguration {
    static let urlFormat: String = "https://%@/centrum24-web/native/savings-goals#/goal/%@"
    let initialURL: String
    let httpMethod: HTTPMethodType = .get
    let bodyParameters: [String: String]? = [:]
    let closingURLs: [String] = ["app://close"]
    let webToolbarTitleKey: String? = localized("pgBasket_title_savingProducts")
    let pdfToolbarTitleKey: String? = nil
    let pdfSource: PdfSource? = nil
    let engine: WebViewConfigurationEngine = .webkit
    let isCachePdfEnabled: Bool = false
    let isFullScreenEnabled: Bool? = false
    let showBackNavigationItem: Bool = false
    var reloadSessionOnClose: Bool = false

    init(initialURL: String) {
        self.initialURL = initialURL
    }
}
