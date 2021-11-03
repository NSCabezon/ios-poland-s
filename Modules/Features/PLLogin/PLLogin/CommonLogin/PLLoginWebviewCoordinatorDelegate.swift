//
//  PLLoginWebViewCoordinatorDelegate.swift
//  PLLogin
//
//  Created by Mario Rosales Maillo on 7/10/21.
//

import Foundation
import WebViews

public protocol PLLoginWebViewCoordinatorDelegate: AnyObject {
    func showWebView(handler: WebViewLinkHandler)
    func closedWebView(url: URL)
}
